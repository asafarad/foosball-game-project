clear;

%{
  ____  _   _  ____ _     __     ___   _ ____  _       _____           _ 
 |  _ \| \ | |/ ___| |_ __\ \   / / | | |  _ \| |     |_   _|__   ___ | |
 | |_) |  \| | |  _| __/ _ \ \ / /| |_| | | | | |       | |/ _ \ / _ \| |
 |  __/| |\  | |_| | || (_) \ V / |  _  | |_| | |___    | | (_) | (_) | |
 |_|   |_| \_|\____|\__\___/ \_/  |_| |_|____/|_____|   |_|\___/ \___/|_|

                    awesome lab graphics made easy
%}                                               
% ################### HOW DO I USE THING ? ######################

% ########## 1. ADD YOUR PNG TO THIS FILE's FOLDER ##############
% ######## 2. CHANGE NAME OF fileToConvert TO YOUR PNG ##########
% ################### 3. PRESS RUN ##############################

                fileToConvert = 'player.png';
               
% ###############################################################


fileName = fileToConvert(1:find(fileToConvert == '.', 1, 'last')-1);
fileType = fileToConvert(find(fileToConvert == '.', 1, 'last'):end);
isIndexedImage = false;

%read the image

 try
    [I,map,alpha] = imread(strcat(fileName,fileType));
    catch e
        fprintf('\n@@@@@@@@ LOOKS LIKE WE HAD AN ERROR :( @@@@@@@@\n');
        fprintf(1,'The identifier was:\n\t%s\n\n',e.identifier);
        fprintf(1,'There was an error! The message was:\n\t%s\n',e.message);

        fprintf('Are you sure that is a PNG file?\n');
        msgbox('Had a problem opening the file, are you sure thats a PNG?', 'Oh no :(','error');
        error('could not open file...');

 end


if (~isempty(map))
    I = ind2rgb(I, map);
    isIndexedImage = true;
end

% imshow(I);

r = I(:, :, 1); r = floor(double(r)/32);   % convert to 3-bit RRR
g = I(:, :, 2); g = floor(double(g)/32);   % convert to 3-bit GGG
b = I(:, :, 3); b = floor(double(b)/64);   % convert to 2-bit BB


for row = 1:size(I,1)
    for col = 1:size(I,2)
        COLOR(row,col) = bin2dec([dec2bin(r(row, col), 3), dec2bin(g(row, col), 3), dec2bin(b(row, col), 2)]);
    end
end
%save variable COLOR to a file in HEX format for the chip to read
fileID = fopen (strcat(fileName,'_object.vhd'), 'w');

% the madness begings - adding the code 
fprintf (fileID, 'library IEEE;\nuse IEEE.STD_LOGIC_1164.all;\n\n');
fprintf (fileID, 'entity %s_object is\n',fileName);
fprintf (fileID, 'port 	(\n	   	CLK  		: in std_logic;\n		RESETn		: in std_logic;\n		oCoord_X	: in integer;\n		oCoord_Y	: in integer;\n		ObjectStartX	: in integer;\n		ObjectStartY 	: in integer;\n		drawing_request	: out std_logic ;\n		mVGA_RGB 	: out std_logic_vector(7 downto 0) \n	);\n');
fprintf (fileID, 'end %s_object;\n\n',fileName);
fprintf (fileID, 'architecture behav of %s_object is\n\n',fileName); 
fprintf (fileID, 'constant object_X_size : integer := %i;\n',size(COLOR,2)); 
fprintf (fileID, 'constant object_Y_size : integer := %i;\n',size(COLOR,1)); 
fprintf (fileID, '\ntype ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  \n');
fprintf (fileID, '\n-- 8 bit - color definition : "RRRGGGBB"  \nconstant object_colors: ram_array := ( \n');





% print out the first array
fprintf (fileID, '(');
for j = 1:size(COLOR,1)
    for i = 1:size(COLOR,2)
        decValue = COLOR(j,i);
        if (decValue == 0 )
            fprintf (fileID, 'x"00"');
        elseif (decValue<16)
            fprintf (fileID, 'x"0%X"',decValue);
        else
            fprintf (fileID, 'x"%X"',decValue);
        end
        if (i~=size(COLOR,2))
            fprintf (fileID, ', ');
        end
    end
    if (j~= size(COLOR,1)) 
        fprintf (fileID, '),\n(');
    else
        fprintf (fileID, ')\n');
    end

end

% bit more code
fprintf (fileID, ');\n\n-- one bit mask  0 - off 1 dispaly \ntype object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;\nconstant object : object_form := (');

% print mask
if isempty(alpha) 
    maskTarget = COLOR;
else
   maskTarget = alpha; 
end
fprintf (fileID, '\n("');

for j = 1:size(maskTarget,1)
    for i = 1:size(maskTarget,2)
        decValue = maskTarget(j,i);
        if (decValue == 0 )
            fprintf (fileID, '0');
        else
            fprintf (fileID, '1');
        end

    end
    if (j ~= size(maskTarget,1))
        fprintf (fileID, '"),\n("');
    else 
        fprintf (fileID, '")\n);\n');
    end
end

% add end of code
fprintf (fileID, '\nsignal bCoord_X : integer := 0;-- offset from start position \nsignal bCoord_Y : integer := 0;\n\nsignal drawing_X : std_logic := ''0'';\nsignal drawing_Y : std_logic := ''0'';\n\nsignal objectEndX : integer;\nsignal objectEndY : integer;\n\nbegin\n\n-- Calculate object end boundaries\nobjectEndX	<= object_X_size+ObjectStartX;\nobjectEndY	<= object_Y_size+ObjectStartY;\n\n-- Signals drawing_X[Y] are active when obects coordinates are being crossed\n\n-- test if ooCoord is in the rectangle defined by Start and End \n	drawing_X	<= ''1'' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectEndX) else ''0'';\n    drawing_Y	<= ''1'' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else ''0'';\n\n-- calculate offset from start corner \n	bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = ''1'' and  drawing_Y = ''1''  ) else 0 ; \n	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = ''1'' and  drawing_Y = ''1''  ) else 0 ; \n\n\nprocess ( RESETn, CLK)\n   begin\n	if RESETn = ''0'' then\n	    mVGA_RGB	<=  (others => ''0'') ; 	\n		drawing_request	<=  ''0'' ;\n\n		elsif rising_edge(CLK) then\n			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	--get from colors table \n			drawing_request	<= object(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ; -- get from mask table if inside rectangle  \n	end if;\n  end process;\nend behav;		\n\n--generated with PNGtoVHDL tool by Ben Wellingstein\n');
fclose (fileID);

msgbox(sprintf('The file is saved as %s',strcat(fileName,'_object.vhd')),'Done!'); 
