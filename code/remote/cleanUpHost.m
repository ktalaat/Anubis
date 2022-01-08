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

function cleanUpHost(caseDef,iteration,activeApp)
pause(10)
if caseDef.setup.(char(activeApp)).cleanup == "yes" && ~strcmpi(activeApp,'OpenFOAM')
    iterationDirName = strcat(activeApp,"/",num2str(iteration));
    disp('Connecting to host')
    s = sftp(caseDef.setup.(char(activeApp)).hostname,caseDef.setup.(char(activeApp)).username,"Password",caseDef.setup.(char(activeApp)).password);
    disp('Cleaning up..')
    PD = cd(s);
    cd(s,caseDef.setup.(char(activeApp)).remoteDir)
    fileList = dir(s,iterationDirName);
    for i=1:size(fileList,1)
        delete(s,strcat(iterationDirName,'/',fileList(i).name))
    end
    rmdir(s,iterationDirName)
    disp('Clean up successful..')
    cd(s,sprintf('%s',PD));
    close(s)
end
if strcmpi(activeApp,'OpenFOAM')
disp('Remote clean up is not supported for OpenFOAM');
end
end
