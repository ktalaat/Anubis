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

function output = getLineDelimiterMCNP(caseDef,fileType)
if fileType == "input"
fileLines = regexp(fileread(caseDef.initialCases.MCNP),'\r\n','split');
if length(fileLines) > 1
   output = '\r\n'; 
end
if length(fileLines) == 1
  fileLines = regexp(fileread(caseDef.initialCases.MCNP),'\n','split');
  if length(fileLines) > 1
     output = '\n'; 
  end
end
end

if fileType == "output"
fileLines = regexp(fileread(caseDef.simCase.outputMCNP),'\r\n','split');
if length(fileLines) > 1
   output = '\r\n'; 
end
if length(fileLines) == 1
  fileLines = regexp(fileread(caseDef.simCase.outputMCNP),'\n','split');
  if length(fileLines) > 1
     output = '\n'; 
  end
end    
end
end
