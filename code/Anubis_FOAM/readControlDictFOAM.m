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

function output = readControlDictFOAM(caseDef)
global slash
controldictfile = strcat(caseDef.simCase.OpenFOAM,slash,'system',slash,'controlDict');
if exist(controldictfile, 'file') ~= 2
    disp("Fatal Error: please make sure that the control dictionary is defined in the system folder.");
    output = NaN;
    return;
end
fileLines = regexp(fileread(controldictfile),'\t|\n','split');
fileLines = fileLines.';
fileLines = removeCommentLinesFOAM(fileLines);

controlDictParams = {};
for i=1:1:size(fileLines,1)
    line{i} = strtok(fileLines{i},'{');
    line{i} = strtok(line{i},';');
    line{i} = strsplit(line{i},' ');
    line{i}(strcmp('',line{i})) = [];
    if length(line{i}) == 2
        controlDictParams = [controlDictParams; line{i}];
    end
end

output = cell2struct(controlDictParams(:,2),controlDictParams(:,1),1);
end
