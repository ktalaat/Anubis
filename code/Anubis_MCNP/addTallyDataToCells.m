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

function output = addTallyDataToCells(caseDef,cells,surfaces)
tallies = readTallies(caseDef);
cellList = fields(cells);
for i=1:1:length(cellList)
%  cells.(char(cellList(i))).tallyVolume = 0;
  cells.(char(cellList(i))).tallyMass = 0;
  cells.(char(cellList(i))).power = 0;
end

if caseDef.tallies.volumes ~= "MCNP"
volumesFile = caseDef.tallies.volumes;
filelines = regexp(fileread(volumesFile),'\t|\n','split');
filelines = filelines.';
filetext = sprintf('%s',filelines{:});
cellVolumes = jsondecode(filetext); 
end
denominatorUnnormalization = 0;
for i=1:1:size(tallies.(caseDef.tallies.tallyType).cellMassMap,1)
if cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).newDensity > 0 && caseDef.tallies.volumes ~= "MCNP"
    disp("Fatal error: You should not use tally surface functions with number density inputs. Either change the condition or provide physical densities.");
    return;
end

if caseDef.tallies.volumes == "MCNP"
cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyMass = str2num(tallies.(caseDef.tallies.tallyType).cellMassMap{i,2});
end

if caseDef.tallies.volumes ~= "MCNP"
    statement = cellVolumes.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1});
    %Now need to resolve surface var names
    validSurfaceVars.names = getPossibleSurfaceVarNames(surfaces);
    for j=1:1:length(validSurfaceVars.names)
    b = getParamsFromSurfaceName(char(validSurfaceVars.names(j)));
    validSurfaceVars.values{j} = surfaces.(char(b.surfaceID)).params{b.paramNum};
    statement = strrep(statement,validSurfaceVars.names(j),num2str(validSurfaceVars.values{j}));
    end    
    validSurfaceVars.names = getPossibleSurfaceVarNames(surfaces,"original");
    for j=1:1:length(validSurfaceVars.names)
    b = getParamsFromSurfaceName(char(validSurfaceVars.names(j)));
    validSurfaceVars.values{j} = surfaces.(char(b.surfaceID)).originalParams{b.paramNum};
    statement = strrep(statement,validSurfaceVars.names(j),num2str(validSurfaceVars.values{j}));
    end   
    cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyVolume = str2num(char(statement));
    cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyMass = -1*cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyVolume * cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).newDensity;
end

cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyNormalized = str2num(tallies.(caseDef.tallies.tallyType).cellTallyMap{i,2});
cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyRelError = str2num(tallies.(caseDef.tallies.tallyType).cellTallyMap{i,3});

denominatorUnnormalization = denominatorUnnormalization + (cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyMass * cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyNormalized * 1.60205E-16);
end

for i=1:1:size(tallies.(caseDef.tallies.tallyType).cellMassMap,1)
sourceParticlesPerSecond = (str2num(caseDef.tallies.totalPowerWatts)/1000)/denominatorUnnormalization;
cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).power = cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyNormalized*sourceParticlesPerSecond*cells.(tallies.(caseDef.tallies.tallyType).cellMassMap{i,1}).tallyMass * 1.60205E-13;
end

output = cells;

end
