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

function updateSurfaceCardsMCNP(caseDef,surfaces,iteration)
mcnpFile = regexp(fileread(caseDef.simCase.MCNP),getLineDelimiterMCNP(caseDef,"input"),'split');
mcnpFile = mcnpFile.';
surfaceList = fields(surfaces);
for i=1:1:length(surfaceList)
 for j=1:1:length(surfaces.(char(surfaceList{i})).params)
      splitline = strsplit(mcnpFile{surfaces.(char(surfaceList{i})).startLine},' ');
      splitline{surfaces.(char(surfaceList{i})).index.params{1}+j} = strrep(splitline{surfaces.(char(surfaceList{i})).index.params{1}+j},surfaces.(char(surfaceList{i})).originalParams{j},surfaces.(char(surfaceList{i})).params{j});
      mcnpFile{surfaces.(char(surfaceList{i})).startLine} = strjoin(splitline,' ');
 end
end
 
[fp1,fp2,fp3] = fileparts(caseDef.simCase.MCNP);
cd(sprintf('%s',fp1));
cd ..
mkdir(num2str(iteration));
cd(sprintf('%s',num2str(iteration)));
fid = fopen(strcat(fp2,fp3),'w');
formatspec = strcat('%s',getLineDelimiterMCNP(caseDef,"input"));
[nrows,~] = size(mcnpFile);
for row = 1:nrows
    if row == nrows
        formatspec = '%s';
    end
    fprintf(fid,formatspec,mcnpFile{row,:});
end
fclose(fid);
 
end
 