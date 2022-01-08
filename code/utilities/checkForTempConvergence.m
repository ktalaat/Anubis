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

function output = checkForTempConvergence(caseDef,iteration)
output = 1;
cd(sprintf('%s',caseDef.outputDir));
cd saves
if iteration >= str2num(caseDef.couplingFlow.minIterations)
tempFields = [];
for i=iteration-str2num(caseDef.couplingFlow.numberOfIterationsToCompareWith):1:iteration
regionTemps = load(sprintf('%s',strcat('iteration',num2str(i))),'mapTempField');
tempFields = [tempFields cell2mat(regionTemps.mapTempField(:,3))];
end

if strcmpi(caseDef.couplingFlow.convergenceCriterion,'percentChange')
for i=1:1:size(tempFields,1)
    for j=1:1:size(tempFields,2)-1
        if (100*abs(tempFields(i,end)-tempFields(i,j))/tempFields(i,j)) > str2num(caseDef.couplingFlow.convergenceTolerance)
            output = 0;
            break;
        end
    end    
end
end

if strcmpi(caseDef.couplingFlow.convergenceCriterion,'absoluteChange')
for i=1:1:size(tempFields,1)
    for j=1:1:size(tempFields,2)-1
        if (abs(tempFields(i,end)-tempFields(i,j))) > str2num(caseDef.couplingFlow.convergenceTolerance)
            output = 0;
            break;
        end
    end    
end
end
end

if iteration < str2num(caseDef.couplingFlow.minIterations)
        output = 0;
end

cd ..
end
