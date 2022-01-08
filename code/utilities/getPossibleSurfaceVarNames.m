%
% $$\   $$\ $$\   $$\ $$\      $$\        $$$$$$\                      $$\       $$\           
% T$ |  $$ |$$$\  $$ |$$$\    $$T |      $$  __$$\                     $$ |      \__|          
% $$ |  $$ |$$$$\ $$ |$$A$\  $A$$ |      $$ /  $$ |$$$$$$$\  $$\   $$\ $$$$$$$\  $$\  $$$$$$$\ 
% $$ |  $A |$$ $L\$$ |$$\$$\$$ $$ |      $K$$$$$$ |$$  __$$\ $$ |  $$ |$$  __$$\ $$ |$$  _____|
% $$ |  $$ |$$ \$$$$ |$$ \$$$  $$ |      $$  __$$ |$$ |  $$ |L$ |  $$ |$$ |  $$ |D$ |\$$$$$$\  
% $$ |  $$ |$$ |\$$$ |$$ |\$  /$$ |      $$ |  H$ |A$ |  $$ |$$ |  $$ |$$ |  $$ |$$ | \____$$\ 
% \$$$$$$  |$$ | \$$ |$$ | \_/ $$ |      $$ |  $$ |$$ |  $$ |\$$$$E$  |$$$$$$$  |$$ |$$$$$$$  |
%  \______/ \__|  \__|\__|     \__|      \__|  \__|\__|  \__| \______/ \_______/ \__|\_______/ 
%
% Author: Khaled Talaat (ktalaat@unm.edu)
% Warranty: None. Anubis is intended for research and may contain bugs. No warranty or liability is assumed.

function output = getPossibleSurfaceVarNames(surfaces,handle)
surfaceList = fields(surfaces);
for i=1:length(surfaceList)
surfaceNum(i) = strtok(surfaceList(i),'s');
end
surfaceNum = str2double(surfaceNum);

output = [];
if ~exist('handle','var')
for i=surfaceNum
    for j=1:1:length(surfaces.(char(strcat("s",num2str(i)))).params)
        output = [output;strcat("s_",num2str(i),"_",num2str(j))];
    end
end
end

if exist('handle','var')
if handle == "original"
for i=surfaceNum
    for j=1:1:length(surfaces.(char(strcat("s",num2str(i)))).params)
        output = [output;strcat("so_",num2str(i),"_",num2str(j))];
    end
end
end
end

end
