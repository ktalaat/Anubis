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

function jobID = submitPBSToHost(caseDef,iteration,activeApp)
cd(sprintf('%s',caseDef.outputDir));
iterationDirName = strcat(activeApp,"/",num2str(iteration));
disp('Connecting to host')
s = sftp(caseDef.setup.(char(activeApp)).hostname,caseDef.setup.(char(activeApp)).username,"Password",caseDef.setup.(char(activeApp)).password);
disp('Transferring PBS script to host..')
PD = cd(s);
remoteIterationDir = strcat(caseDef.setup.(char(activeApp)).remoteDir,"/",iterationDirName);
cd(s,sprintf('%s',remoteIterationDir));
mput(s,strcat('AnubisRun',activeApp,'.pbs'))
disp('Transfer successful. Now setting up job.')
cd(s,sprintf('%s',PD));
close(s)
handle = strcat('ssh -t -t',{' '},caseDef.setup.(char(activeApp)).username,'@',caseDef.setup.(char(activeApp)).hostname,{' '},'qsub',{' '},strcat(remoteIterationDir,'/','AnubisRun',activeApp,'.pbs'));
[status,cmdout] = system(sprintf('%s',char(handle)))
jobID = strtok(cmdout,'.');
disp(strcat('Job submitted to queue. Job ID is',{' '},jobID))
end
