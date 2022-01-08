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

function output = readResultFOAM(caseDef,geomCoupling,parameterofInterest)
global slash
controlDict = readControlDictFOAM(caseDef);
timeSteps = getTimeStepsFOAM(caseDef);
lastStepFolder = timeSteps.last;
lastStepDir = strcat(caseDef.simCase.OpenFOAM,slash,lastStepFolder);

if controlDict.application ~= "chtMultiRegionFoam" && controlDict.application ~= "chtMultiRegionSimpleFoam"
error('Unsupported solver. You must use a multiregion solver.');
end

if controlDict.application == "chtMultiRegionFoam" || controlDict.application == "chtMultiRegionSimpleFoam"
%regionNames = getFolderNames(lastStepDir);
regionNames = fields(geomCoupling.regions);
    for i=1:1:size(regionNames,1)
        fileAddress = char(strcat(lastStepDir,slash,regionNames(i),slash,parameterofInterest));
        result.mean.(char(regionNames(i)))= getTempFieldAverageFoam(fileAddress);
        result.max.(char(regionNames(i)))= getTempFieldMaxFoam(fileAddress);
    end
output = result;
end
end
