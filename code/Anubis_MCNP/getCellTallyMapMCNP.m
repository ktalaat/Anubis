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

function output = getCellTallyMapMCNP(cellTallyData)
cellTallyData(3:3:end,:) = [];
oddRows = {};
evenRows = {};
for i=1:1:length(cellTallyData)
    if mod(i,2) ~= 0
        cellTallyData{i,1}{1,1} = {};
        cellTallyData{i,1}{1,2} = {};
        oddRows{end+1,1} = cellTallyData(i);
    end
    if mod(i,2) == 0
        evenRows{end+1,1} = cellTallyData(i);
    end
end
for i=1:1:length(oddRows)
  output{i,1} = strcat('c',oddRows{i,1}{1,1}{1,3});
  output{i,2} = evenRows{i,1}{1,1}{1,2};
  output{i,3} = evenRows{i,1}{1,1}{1,3};
end

end
