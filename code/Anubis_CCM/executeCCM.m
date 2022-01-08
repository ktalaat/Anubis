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

function output = executeCCM(caseDef,iteration)
global slash
ccmBinaries = caseDef.installDirs.StarCCM;    
solverEXE = 'starccm+.exe';
try
if str2num(caseDef.setup.StarCCM.cores) >= 1
if ispc
handle = strcat(ccmBinaries,slash,solverEXE,{' '},'-np',{' '},caseDef.setup.StarCCM.cores,{' '},'-batch',{' '},char(strcat(caseDef.outputDir,slash,"StarCCM",slash,num2str(iteration))),slash,'anubis.java',{' '},caseDef.simCase.StarCCM,{' '},'-licpath',{' '},caseDef.setup.StarCCM.licensePath);
elseif isunix
handle = strcat('sshpass',{' '},'-p',{' '},caseDef.setup.StarCCM.sshpass,{' '},'starccm+',{' '},'-np',{' '},caseDef.setup.StarCCM.cores,{' '},'-batch',{' '},char(strcat(caseDef.outputDir,slash,"StarCCM",slash,num2str(iteration))),slash,'anubis.java',{' '},caseDef.simCase.StarCCM,{' '},'-licpath',{' '},caseDef.setup.StarCCM.licensePath);
else
    disp('Fatal: Your operating system is not supported. You may need to modify this source code.');
    return;
end
output = system(sprintf('%s',char(handle)));
end

catch
    disp('Parallel run failed. Attempting to run in serial..');
    if ispc
    handle = strcat(ccmBinaries,slash,solverEXE,{' '},'-batch',{' '},char(strcat(caseDef.outputDir,slash,"StarCCM",slash,num2str(iteration))),slash,'anubis.java',{' '},caseDef.simCase.StarCCM,{' '},'-licpath',{' '},caseDef.setup.StarCCM.licensePath);
    elseif isunix
    handle = strcat('starccm+',{' '},'-batch',{' '},char(strcat(caseDef.outputDir,slash,"StarCCM",slash,num2str(iteration))),slash,'anubis.java',{' '},caseDef.simCase.StarCCM,{' '},'-licpath',{' '},caseDef.setup.StarCCM.licensePath);
    else
        disp('Fatal: Your operating system is not supported. You may need to modify this source code.');
        return;
    end
    output = system(sprintf('%s',char(handle)));
end
end
