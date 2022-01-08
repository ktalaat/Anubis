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

function updateXSdirMCNP(xsFileNames,caseDef)
cd(sprintf('%s',getenv('DATAPATH')));
keyword = "directory";

for i=1:1:length(xsFileNames.xsdir)
xsdir.original = regexp(fileread(sprintf('%s',caseDef.crossSections.xsdirIndex)),'\n','split');
xsdir.original = xsdir.original.';
Index.original = strfind(xsdir.original, keyword);
Index.original = find(not(cellfun('isempty', Index.original)));

xsdir.gen.(char(xsFileNames.xsdir(i))) = regexp(fileread(char(xsFileNames.xsdir(i))),'\n','split');
xsdir.gen.(char(xsFileNames.xsdir(i))) = xsdir.gen.(char(xsFileNames.xsdir(i))).';
Index.gen.(char(xsFileNames.xsdir(i))) = strfind(xsdir.gen.(char(xsFileNames.xsdir(i))), keyword);
Index.gen.(char(xsFileNames.xsdir(i))) = find(not(cellfun('isempty', Index.gen.(char(xsFileNames.xsdir(i))))));
delIndices = (1:1:Index.gen.(char(xsFileNames.xsdir(i))));
xsdir.gen.(char(xsFileNames.xsdir(i)))(delIndices) = [];
if isempty(xsdir.gen.(char(xsFileNames.xsdir(i))){end})
    xsdir.gen.(char(xsFileNames.xsdir(i)))(end) = [];
end
xsdir.new = [xsdir.original(1:1:Index.original);xsdir.gen.(char(xsFileNames.xsdir(i)));xsdir.original(Index.original+1:1:length(xsdir.original))];

fid = fopen(sprintf('%s',caseDef.crossSections.xsdirIndex),'w');
formatspec = '%s\n';
[nrows,~] = size(xsdir.new);
for row = 1:nrows
    if row == nrows
        formatspec = '%s';
    end
    fprintf(fid,formatspec,xsdir.new{row,:});
end
fclose(fid);
end

end
