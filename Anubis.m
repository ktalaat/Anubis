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
% Important: Program directory and sub-directories must be added to path before running this program.

function Anubis(directory)
global slash
if ispc
    slash = '\';
elseif isunix
    slash = '/';
end
cd(sprintf('%s',directory));
caseDef = readCaseDef();
iteration = str2num(caseDef.couplingFlow.iteration);
resumeExistingRun = 0;
if caseDef.couplingFlow.resumeExistingRun == "yes"
   resumeExistingRun = 1; 
end
if strcmpi(caseDef.couplingFlow.applicationCFD,'OpenFOAM')
    FOAM_MCNP_Iterator(directory,iteration,resumeExistingRun);
elseif strcmpi(caseDef.couplingFlow.applicationCFD,'StarCCM')
    CCM_MCNP_Iterator(directory,iteration,resumeExistingRun);
end
end


