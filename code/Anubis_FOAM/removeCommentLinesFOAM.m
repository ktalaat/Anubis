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

function output = removeCommentLinesFOAM(fileLines)
comment = 0;
commentlines = [];
for i=1:1:size(fileLines,1)
    if (strfind(fileLines{i},'/*') > 0)
        comment = 1;
    end
    singleLineCommentMarkers = strfind(fileLines{i},'//');
    if comment == 1 || ~isempty(singleLineCommentMarkers)
       commentlines = [commentlines; i]; 
    end
    if strfind(fileLines{i},'*/') > 0
        comment = 0;
    end
end

for i=1:1:size(fileLines,1)
   fileLines{i,2} = ismember(i,commentlines);
end
fileLines(cell2mat(fileLines(:,2)),:) = [];
fileLines(:,2) = [];
fileLines = fileLines(~cellfun('isempty',fileLines));
output = fileLines;
end
