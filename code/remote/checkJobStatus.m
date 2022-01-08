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

function checkJobStatus(caseDef,jobID,activeApp)
threshold = 3;
pause(threshold)
disp('Connecting to host to check job status')
handle = strcat('ssh -t -t',{' '},caseDef.setup.(char(activeApp)).username,'@',caseDef.setup.(char(activeApp)).hostname,{' '},'qstat -f',{' '},jobID);
[status,cmdout] = system(sprintf('%s',char(handle)));
disp(cmdout)

if contains(cmdout,'Unknown Job Id Error')
    jobStatus = -1;
    error('Submission either crashed or is not recognized.')
end

jobStatus = 0;
while jobStatus == 0
    if ~contains(cmdout,'job_state = Q')
        jobStatus = 1;
    end
    if contains(cmdout,'job_state = Q')
        disp(strcat('Job',{' '},jobID,{' '},'is still in the queue. Anubis will check again in',{' '},caseDef.setup.(char(activeApp)).checktimequeue,{' '},'seconds.'))
        pause(str2num(caseDef.setup.(char(activeApp)).checktimequeue));
        handle = strcat('ssh -t -t',{' '},caseDef.setup.(char(activeApp)).username,'@',caseDef.setup.(char(activeApp)).hostname,{' '},'qstat -f',{' '},jobID);
        [status,cmdout] = system(sprintf('%s',char(handle)));
        disp(cmdout)
    end
end

while jobStatus == 1
    if ~contains(cmdout,'job_state = R')
        jobStatus = 2;
        disp('Run is done')
        pause(30)
    end    
    if contains(cmdout,'job_state = R')
        disp(strcat('Job',{' '},jobID,{' '},'is actively running on server. Anubis will check again in',{' '},caseDef.setup.(char(activeApp)).checktimeactive,{' '},'seconds.'))
        pause(str2num(caseDef.setup.(char(activeApp)).checktimeactive));
        handle = strcat('ssh -t -t',{' '},caseDef.setup.(char(activeApp)).username,'@',caseDef.setup.(char(activeApp)).hostname,{' '},'qstat -f',{' '},jobID);
        [status,cmdout] = system(sprintf('%s',char(handle)));
        disp(cmdout)
    end
end

end
