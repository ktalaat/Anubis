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

function updateCellCardsMCNP(caseDef,cells,iteration)
mcnpFile = regexp(fileread(caseDef.simCase.MCNP),getLineDelimiterMCNP(caseDef,"input"),'split');
mcnpFile = mcnpFile.';
cellList = fields(cells);
for i=1:1:length(cellList)
splitline = strsplit(mcnpFile{cells.(char(cellList{i})).startLine},' ');
disp('Replacing the original cell density of:')
disp(splitline{3})
disp('With:')
disp(num2str(cells.(char(cellList{i})).newDensity))
splitline{3} = strrep(splitline{3},cells.(char(cellList{i})).density,num2str(cells.(char(cellList{i})).newDensity));
mcnpFile{cells.(char(cellList{i})).startLine} = strjoin(splitline,' ');

try
splitline = strsplit(mcnpFile{cells.(char(cellList{i})).startLine},{' ','='});
splitline{cells.(char(cellList{i})).index.inpVol{1} + 1} = strrep(splitline{cells.(char(cellList{i})).index.inpVol{1} + 1},cells.(char(cellList{i})).inpVol{1},num2str(cells.(char(cellList{i})).newInpVol)); 
splitline{cells.(char(cellList{i})).index.inpVol{1}} = strjoin({splitline{cells.(char(cellList{i})).index.inpVol{1}},splitline{cells.(char(cellList{i})).index.inpVol{1} + 1}},'=');
splitline(cells.(char(cellList{i})).index.inpVol{1} + 1) = [];
mcnpFile{cells.(char(cellList{i})).startLine} = strjoin(splitline,' ');

catch
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
