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

function output = getCellMassMapMCNP(cellMassData)
output = {};
oddRows = {};
evenRows = {};
for i=1:1:length(cellMassData)
    if mod(i,2) ~= 0
        cellMassData{i,1}{1,1} = {};
        cellMassData{i,1}{1,2} = {};
        cellMassData{i,1} = cellMassData{i,1}.';
        oddRows{end+1,1} = cellMassData(i);
        oddRows{end,1}{1,1} = oddRows{end,1}{1,1}(~cellfun('isempty',oddRows{end,1}{1,1}));
    end
    if mod(i,2) == 0
        cellMassData{i,1}{1,1} = {};
        cellMassData{i,1} = cellMassData{i,1}.';
        evenRows{end+1,1} = cellMassData(i);
        evenRows{end,1}{1,1} = evenRows{end,1}{1,1}(~cellfun('isempty',evenRows{end,1}{1,1}));
    end
end
for i=1:1:length(oddRows)
    for j=1:1:length(oddRows{i,1}{1,1})
     output{end+1,1} = strcat('c',oddRows{i,1}{1,1}{j,1});
     output{end,2} = evenRows{i,1}{1,1}{j,1};
    end
end

end
