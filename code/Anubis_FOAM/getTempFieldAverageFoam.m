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

function output = getTempFieldAverageFoam(fileAddress)
filelines.notDelimited = regexp(fileread(fileAddress),'\t|\n','split');
filelines.notDelimited = filelines.notDelimited.';

endLoop = 0;
endLine = 0;
totalCells = 0;
temperatureSum = 0;
while endLoop == 0
try  
    startLine = getStartLineInternalFieldFoam(filelines.notDelimited,endLine);
    numberOfCells = str2num(filelines.notDelimited{startLine});
    totalCells = totalCells + numberOfCells;
    endLine = numberOfCells + startLine + 1;
    for i=startLine+2:1:endLine
    temperatureSum = temperatureSum + str2double(filelines.notDelimited{i});
    end
catch
    endLoop = 1;
end
end

output = temperatureSum/totalCells;
end
