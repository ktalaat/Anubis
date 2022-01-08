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

function output = getStartLineInternalFieldFoam(fileLines,lastStop)
stopLoop = 0;
i = lastStop;
while stopLoop == 0
  i = i + 1;
   try 
   stopLoop = ~isempty(str2num(fileLines{i}));
   if stopLoop && i > 2
       oneLineUp = strsplit(fileLines{i-1},{' ','(',')','\t'});
       oneLineUp = oneLineUp(~cellfun('isempty',oneLineUp));
       twoLinesUp = strsplit(fileLines{i-2},{' ','(',')','\t'});
       twoLinesUp = twoLinesUp(~cellfun('isempty',twoLinesUp));
       if strcmpi(char(oneLineUp{1}),'valueFraction') && strcmpi(char(twoLinesUp{1}),'refGradient')
           stopLoop = 0;
           i = i + str2num(fileLines{i}) + 3;
       end
   end
   catch
   stopLoop = 1;
   i = -1;
   end
end
output = i;
end
