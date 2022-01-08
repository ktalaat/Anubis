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

function cells = updateCellsObject(cells,mapTempField,caseDef)
cellList = fields(cells);
for i=1:1:size(mapTempField,1)
   cells.(char(strcat('c',mapTempField(i,1)))).newDensity = str2num(cells.(char(strcat('c',mapTempField(i,1)))).density);
   cells.(char(strcat('c',mapTempField(i,1)))).temp = mapTempField{i,3};
   cells.(char(strcat('c',mapTempField(i,1)))).CFDRegion = mapTempField{i,8};
   try
   if caseDef.densities.updateDensities == "yes"
   cells.(char(strcat('c',mapTempField(i,1)))).newDensity = str2num(cells.(char(strcat('c',mapTempField(i,1)))).density) * mapTempField{i,7};

   try
       cells.(char(strcat('c',mapTempField(i,1)))).newInpVol = str2num(cells.(char(strcat('c',mapTempField(i,1)))).inpVol{1})/mapTempField{i,7};
   catch
   end

   end
   catch
   end
end

end
