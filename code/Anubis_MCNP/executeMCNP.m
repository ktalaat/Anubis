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

function output = executeMCNP(caseDef)
global slash
[outdir,outfilename,~] = fileparts(caseDef.simCase.MCNP);
outfilename = strcat(outdir,slash,outfilename);
if caseDef.setup.MCNP.cores == 1
    if ispc
    handle = strcat(caseDef.installDirs.MCNP,slash,"mcnp6.exe",{' '},'inp=',caseDef.simCase.MCNP,{' '},"outp=",outfilename,".out",{' '});
    elseif isunix
    handle = strcat("mcnp6",{' '},'inp=',caseDef.simCase.MCNP,{' '},"outp=",outfilename,".out",{' '});
    else
        disp('Your operating system is not supported. You may need to modify the source code to support it.');
        return;
    end
        
output = system(sprintf('%s',char(handle)));
end

if caseDef.setup.MCNP.cores > 1
    if ispc    
    handle = strcat(caseDef.installDirs.MCNP,slash,"mcnp6.exe",{' '},'inp=',caseDef.simCase.MCNP,{' '},"outp=",outfilename,".out",{' '},"tasks",{' '},caseDef.setup.MCNP.cores);
    elseif isunix
    handle = strcat("mcnp6",{' '},'inp=',caseDef.simCase.MCNP,{' '},"outp=",outfilename,".out",{' '},"tasks",{' '},caseDef.setup.MCNP.cores);
    else
    disp('Your operating system is not supported. You may need to modify the source code to support it.');
    return;
    end
output = system(sprintf('%s',char(handle)));
end
end
