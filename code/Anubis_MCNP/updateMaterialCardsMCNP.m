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

function updateMaterialCardsMCNP(caseDef,Isotopes,iteration)
mcnpFile = regexp(fileread(caseDef.simCase.MCNP),getLineDelimiterMCNP(caseDef,"input"),'split');
mcnpFile = mcnpFile.';
materials = fields(Isotopes);
for i=1:1:length(materials)
    zzaids = fields(Isotopes.(char(materials{i})));
    for j=1:1:length(zzaids)
        try
        if Isotopes.(char(materials{i})).(char(zzaids{j})).status == 1
        xs0 = Isotopes.(char(materials{i})).(char(zzaids{j})).xs0;
        xs = Isotopes.(char(materials{i})).(char(zzaids{j})).xs;
        mcnpFile{Isotopes.(char(materials{i})).(char(zzaids{j})).line} = strrep(mcnpFile{Isotopes.(char(materials{i})).(char(zzaids{j})).line},xs0,xs);
        end
        if Isotopes.(char(materials{i})).(char(zzaids{j})).status == 0
        mcnpFile{Isotopes.(char(materials{i})).(char(zzaids{j})).line} = strcat("c",{' '},mcnpFile{Isotopes.(char(materials{i})).(char(zzaids{j})).line});
        end
        catch
        end
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
