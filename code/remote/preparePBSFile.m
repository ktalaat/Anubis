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

function preparePBSFile(caseDef,iteration,activeApp)
global slash
[~,FileName,FileExt] = fileparts(caseDef.initialCases.(char(activeApp)));
inputFile = strcat(FileName,FileExt);
fid  = fopen(caseDef.setup.(char(activeApp)).PBStemplate,'r');
template=fread(fid,'*char')';
fclose(fid);
PBS = strrep(template,'*NODECOUNT*',caseDef.setup.(char(activeApp)).nodes);
PBS = strrep(PBS,'*CORECOUNT*',caseDef.setup.(char(activeApp)).cores);
PBS = strrep(PBS,'*JOBTITLE*',caseDef.setup.(char(activeApp)).jobtitle);
PBS = strrep(PBS,'*WALLTIME*',caseDef.setup.(char(activeApp)).walltime);
PBS = strrep(PBS,'*MODULENAME*',caseDef.setup.(char(activeApp)).module);

if activeApp == "StarCCM"
    PBS = strrep(PBS,'*CCMFILE*',strcat(caseDef.setup.(char(activeApp)).remoteDir,'/StarCCM/',num2str(iteration),'/',inputFile));
    PBS = strrep(PBS,'*ANUBISJAVAPATH*',strcat(caseDef.setup.(char(activeApp)).remoteDir,'/StarCCM/',num2str(iteration),'/','anubis.java'));
    PBS = strrep(PBS,'*LICENSEPATH*',caseDef.setup.(char(activeApp)).licensePath);
elseif activeApp == "MCNP"
    PBS = strrep(PBS,'*MCNPINFILE*',strcat(caseDef.setup.(char(activeApp)).remoteDir,'/MCNP/',num2str(iteration),'/',inputFile));
    PBS = strrep(PBS,'*MCNPOUTFILE*',strcat(caseDef.setup.(char(activeApp)).remoteDir,'/MCNP/',num2str(iteration),'/',FileName,'.out'));
elseif activeApp == "OpenFOAM"
    PBS = strrep(PBS,'*FOAMCASE*',strcat(caseDef.setup.(char(activeApp)).remoteDir,'/OpenFOAM/',num2str(iteration)));
    controlDict = readControlDictFOAM(caseDef);
    PBS = strrep(PBS,'*FOAMSOLVER*',sprintf('%s',controlDict.application));
end

fid  = fopen(strcat(caseDef.outputDir,slash,'AnubisRun',activeApp,'.pbs'),'w');
fprintf(fid,'%s',PBS);
fclose(fid);
end
