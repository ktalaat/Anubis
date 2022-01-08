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

function uploadXSToHostMCNP(caseDef,xsFileNames)
global slash
PLD = pwd;
cd(sprintf('%s',getenv('DATAPATH')));
disp('Connecting to host')
s = sftp(caseDef.setup.MCNP.hostname,caseDef.setup.MCNP.username,"Password",caseDef.setup.MCNP.password);
disp('Transferring cross-section data to host..')
PD = cd(s);
cd(s,sprintf('%s',caseDef.setup.MCNP.xsdatadirectory))
mput(s,sprintf('%s',caseDef.crossSections.xsdirIndex))
for i=1:size(xsFileNames.specs,1)
mput(s,sprintf('%s',xsFileNames.libraries(i)))
end
disp('Transfer successful')
cd(s,sprintf('%s',PD));
close(s)
cd(sprintf('%s',PLD));
end

