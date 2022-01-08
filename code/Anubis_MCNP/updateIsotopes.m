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

function output = updateIsotopes(Isotopes,mapTempField,caseDef)
for i=1:1:size(mapTempField,1)
    ZAIDS = fields(Isotopes.(char(mapTempField{i,2})));
    for j=1:1:size(ZAIDS,1)
    Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).T = str2num(sprintf('%s',mapTempField{i,3}));
    Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).ext = getExtMCNP(Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).T);
    Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).xs = strcat(Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).zaid,Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).ext);
    interpExts = getInterpolationExtensions(caseDef,Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).T);
    Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).interpxs1 = strcat(Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).zaid,interpExts.lower);
    Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).interpxs2 = strcat(Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).zaid,interpExts.higher);
    interpxs1 = checkXSMCNP(Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).interpxs1,caseDef);
    interpxs2 = checkXSMCNP(Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).interpxs2,caseDef);
    Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).status = interpxs1.status && interpxs2.status;
    Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).interpxs1 = interpxs1.alt;
    Isotopes.(char(mapTempField{i,2})).(char(ZAIDS{j})).interpxs2 = interpxs2.alt;       
    end
end
output = Isotopes;
end
