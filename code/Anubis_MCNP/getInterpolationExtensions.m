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

function output = getInterpolationExtensions(caseDef,Temp)
interpTemps = [293.6,600,900,1200,2500];

if caseDef.crossSections.evaluation == "70s"
interpExts = [".70c",".71c",".72c",".73c",".74c"];
end

if caseDef.crossSections.evaluation == "80s"
interpExts = [".80c",".81c",".82c",".83c",".84c"];  
end

index = 0;
for i=1:1:size(interpTemps,2)
    if interpTemps(i) > Temp
    index = i;
    break;
    end
end

if Temp >= interpTemps(1) && Temp <= interpTemps(end)
output.lower = interpExts(index-1);
output.higher = interpExts(index);
end

if Temp < interpTemps(1)
output.lower = interpExts(1);
output.higher = interpExts(2);
end

if Temp > interpTemps(end)
output.lower = interpExts(end-1);
output.higher = interpExts(end);
end

end
