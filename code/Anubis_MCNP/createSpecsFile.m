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

function output = createSpecsFile(caseDef,Isotopes)
randomNumber = randi([100000, 999999]);
randomNumber = num2str(randomNumber);
[iterationdirectory,~,~] = fileparts(caseDef.simCase.MCNP);
cd (sprintf('%s',iterationdirectory));
zaidlimit = 250;
terminator = 0;
k = 0;
i = 0;
j = 0;
flag = 0;
fileNames.specs = [];
fileNames.xsdir = [];
fileNames.libraries = [];
while terminator ~= 1
k = k + 1;
specsFileName = strcat("specs.",num2str(k));
fileNames.specs = [fileNames.specs;specsFileName];
xsdirFileName = strcat("xsdir_anubis_",randomNumber,"_",num2str(k));
fileNames.xsdir = [fileNames.xsdir;xsdirFileName];
libraryFileName = strcat("library_anubis_",randomNumber,"_",num2str(k));
fileNames.libraries = [fileNames.libraries;libraryFileName];
header_xsdir = sprintf('xsdirOriginalAnubis\t%s',xsdirFileName);
header_library = sprintf('%s\t1',libraryFileName);
emptyLine = sprintf('\r\n');
fid = fopen(specsFileName,'w');
fprintf(fid,'%s\r\n',header_xsdir);
fprintf(fid,'%s\r\n',header_library);
fprintf(fid,'%s',emptyLine);
materials = fields(Isotopes);

newfile = 0;
if flag == 1
    newfile = 1;
end
flag = 0;
counter = 0;
v = i + 1;
try
if j < size(zzaids,1)
v = i;
end
catch
end

for i=v:size(materials,1)
    p = 1;
    if newfile == 1
        try
        if j < size(zzaids,1)
        p = j + 1;
        end
        catch
        end
        newfile = 0;
    end
    zzaids = fields(Isotopes.(char(materials{i})));
    for j=p:1:size(zzaids,1)
        try
        if Isotopes.(char(materials{i})).(char(zzaids{j})).status ~= 0
        fprintf(fid,'%s %f %s %s\r\n',Isotopes.(char(materials{i})).(char(zzaids{j})).xs,Isotopes.(char(materials{i})).(char(zzaids{j})).T,Isotopes.(char(materials{i})).(char(zzaids{j})).interpxs1,Isotopes.(char(materials{i})).(char(zzaids{j})).interpxs2);
        counter = counter + 1;
        end
        catch
        end
        if counter == zaidlimit
            flag = 1;
            fclose(fid);
            break;
        end
    end
    if flag == 1
        break;
    end
end
terminator = ((i>=size(materials,1)) && (j>=size(zzaids,1)));
end
output = fileNames;
end
