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

function output = cloneCaseCCM(caseDef,iteration)
global slash
[~,CCMFileName,CCMFileExt] = fileparts(caseDef.initialCases.StarCCM);
StarCCMFile = strcat(CCMFileName,CCMFileExt);
cd(sprintf('%s',caseDef.outputDir));
iterationDirName = strcat("StarCCM",slash,num2str(iteration));
mkdir(sprintf('%s',iterationDirName));
cd(sprintf('%s',iterationDirName));
if strcmpi(caseDef.setup.StarCCM.mapFieldsBetweenIterations,'no')
copyfile(caseDef.initialCases.StarCCM);
elseif strcmpi(caseDef.setup.StarCCM.mapFieldsBetweenIterations,'yes')
    if iteration > 1
        copyfile(char(strcat(caseDef.outputDir,slash,"StarCCM",slash,num2str(iteration-1),slash,StarCCMFile)));
    elseif iteration == 1
        copyfile(caseDef.initialCases.StarCCM);
    end
end
output = char(strcat(caseDef.outputDir,slash,"StarCCM",slash,num2str(iteration),slash,StarCCMFile));
end
