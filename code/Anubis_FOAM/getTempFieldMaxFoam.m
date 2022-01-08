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

function output = getTempFieldMaxFoam(fileAddress)
filelines.notDelimited = regexp(fileread(fileAddress),'\t|\n','split');
filelines.notDelimited = filelines.notDelimited.';

endLoop = 0;
endLine = 0;
maxTemp = 0;
while endLoop == 0
try  
    startLine = getStartLineInternalFieldFoam(filelines.notDelimited,endLine);
    numberOfCells = str2num(filelines.notDelimited{startLine});
    endLine = numberOfCells + startLine + 1;
    for i=startLine+2:1:endLine
        if str2double(filelines.notDelimited{i}) > maxTemp
        maxTemp = str2double(filelines.notDelimited{i});
        end
    end
catch
    endLoop = 1;
end
end

output = maxTemp;
end
