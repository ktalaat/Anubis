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

function output = executeFOAM(caseDef)
global slash
controlDict = readControlDictFOAM(caseDef);
openFOAMBinaries = caseDef.installDirs.OpenFOAM;    
solverEXE = strcat(controlDict.application,'.exe');

try
if str2num(caseDef.setup.OpenFOAM.cores) == 1
if ispc
handle = strcat(openFOAMBinaries,slash,solverEXE,{' '},'-case',{' '},caseDef.simCase.OpenFOAM);
elseif isunix
handle = strcat(controlDict.application,{' '},'-case',{' '},caseDef.simCase.OpenFOAM);
else
    disp('Fatal: Your operating system is not supported. You may need to modify this source code.');
    return;
end
output = system(sprintf('%s',char(handle)));
end

if str2num(caseDef.setup.OpenFOAM.cores) > 1
    if ispc
    handle1 = strcat(openFOAMBinaries,slash,'decomposePar.exe',{' '},'-case',{' '},caseDef.simCase.OpenFOAM,{' '},'-allRegions');   
    handle2 = strcat('mpiexec.exe',{' '},'-n',{' '},caseDef.setup.OpenFOAM.cores,{' '},'-genv',{' '},'MPI_BUFFER_SIZE',{' '},'200000000',{' '},openFOAMBinaries,slash,solverEXE,{' '},'-case',{' '},caseDef.simCase.OpenFOAM,{' '},'-parallel');
    handle3 = strcat(openFOAMBinaries,slash,'reconstructPar.exe',{' '},'-case',{' '},caseDef.simCase.OpenFOAM,{' '},'-allRegions');
    elseif isunix
    handle1 = strcat('decomposePar',{' '},'-case',{' '},caseDef.simCase.OpenFOAM,{' '},'-allRegions');   
    handle2 = strcat('mpiexec',{' '},'-n',{' '},caseDef.setup.OpenFOAM.cores,{' '},controlDict.application,{' '},'-case',{' '},caseDef.simCase.OpenFOAM,{' '},'-parallel');
    handle3 = strcat('reconstructPar',{' '},'-case',{' '},caseDef.simCase.OpenFOAM,{' '},'-allRegions');    
    else
    disp('Fatal: Your operating system is not supported. You may need to modify this source code.');
    return;
    end

output = system(sprintf('%s',char(handle1)));
cd(sprintf('%s',getenv('MSMPI_BIN')));
output = system(sprintf('%s',char(handle2)));
output = system(sprintf('%s',char(handle3)));
end

catch
    if ispc
    handle = strcat(openFOAMBinaries,slash,solverEXE,{' '},'-case',{' '},caseDef.simCase.OpenFOAM);
    elseif isunix
    handle = strcat(controlDict.application,{' '},'-case',{' '},caseDef.simCase.OpenFOAM);
    else
        disp('Fatal: Your operating system is not supported. You may need to modify this source code.');
        return;
    end
    output = system(sprintf('%s',char(handle)));
end

end
