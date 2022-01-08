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

function output = runMakxsf(caseDef,xsFileNames)
global slash
cd(sprintf('%s',getenv('DATAPATH')));
try
   sigFile = fopen('Coupler.signature','r');
   testVar = fread(sigFile);
catch
    copyfile(sprintf('%s',caseDef.crossSections.xsdirIndex),'xsdirOriginalAnubis')
    fwrite(fopen('Coupler.signature','w'),'This is a tracking file associated with Anubis. Please do not delete.');   
end

mkdir xsdirBackups
copyfile('xsdir',char(strcat("xsdirBackups",slash,"xsdir_wo_",xsFileNames.libraries(1))));

cd(sprintf('%s',caseDef.installDirs.MCNP));
[iterationdirectory,~,~] = fileparts(caseDef.simCase.MCNP);
for i=1:1:size(xsFileNames.specs,1)
copyfile(char(strcat(iterationdirectory,slash,xsFileNames.specs(i))),'specs');
output = system('makxsf');
movefile(char(strcat(caseDef.installDirs.MCNP,slash,xsFileNames.libraries(i))),getenv('DATAPATH'));
movefile(char(strcat(caseDef.installDirs.MCNP,slash,xsFileNames.xsdir(i))),getenv('DATAPATH'));
end
end
