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

function runMapFieldsFOAM(caseDef,iteration)
global slash
if iteration > 1 && caseDef.setup.OpenFOAM.mapFieldsBetweenIterations == "yes"
regionNames = getFolderNames(strcat(caseDef.simCase.OpenFOAM,slash,'0'));
prevIteration = iteration - 1;
prevIterationDir = char(strcat(caseDef.outputDir,slash,"OpenFOAM",slash,num2str(prevIteration)));
openFOAMBinaries = caseDef.installDirs.OpenFOAM; 

for i=1:1:length(regionNames)
if ispc
handle = strcat(openFOAMBinaries,slash,'mapFields.exe',{' '},prevIterationDir,{' '},'-case',{' '},caseDef.simCase.OpenFOAM,{' '},'-sourceRegion',{' '},regionNames{i},{' '},'-targetRegion',{' '},regionNames{i},{' '},'-consistent',{' '},'-sourceTime',{' '},'latestTime');
elseif isunix
handle = strcat('mapFields',{' '},prevIterationDir,{' '},'-case',{' '},caseDef.simCase.OpenFOAM,{' '},'-sourceRegion',{' '},regionNames{i},{' '},'-targetRegion',{' '},regionNames{i},{' '},'-consistent',{' '},'-sourceTime',{' '},'latestTime');
else
    disp('Fatal: Your operating system is not supported. You may need to modify this source code.');
    return;
end
output = system(sprintf('%s',char(handle)));
end

end
end
