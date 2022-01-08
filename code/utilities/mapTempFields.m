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

function output = mapTempFields(caseDef,geomCoupling,iteration)
if strcmpi(caseDef.couplingFlow.applicationCFD,'OpenFOAM')
    T = readResultFOAM(caseDef,geomCoupling,'T');
elseif strcmpi(caseDef.couplingFlow.applicationCFD,'StarCCM')
    T = readTempCCM(caseDef,geomCoupling,iteration);
else
    disp('You did not specify what CFD package to couple MCNP with in the case.json file.');
    return;
end

cells = getCellsMCNP(caseDef);
matDB = readMaterialsDB(caseDef);
regionList = fields(T.mean);
output = {};
for i=1:1:size(regionList,1)
    MCNPCellID = geomCoupling.regions.(char(regionList(i))).MCNPCellID;
    MCNPMatID = strcat('m',cells.(strcat('c',MCNPCellID)).m);
    try
    materialsDBID = geomCoupling.regions.(char(regionList(i))).materialsDBID;
    catch
    materialsDBID = '0';
    end
    try
    MCNPInitialTemp = str2num(geomCoupling.regions.(char(regionList(i))).MCNPInitialTemp);
    catch
        try
            MCNPInitialTemp = str2num(caseDef.densities.defaultInitialTemp);
        catch
            MCNPInitialTemp = 300;
        end
    end
    
    if MCNPMatID ~= "m0"
    Temp = T.mean.(char(regionList(i)));
    maxTemp = T.max.(char(regionList(i)));
    alpha = getThermalExpCoeff(materialsDBID,Temp,matDB);
	alphaMax = getThermalExpCoeff(materialsDBID,maxTemp,matDB);
	if strcmpi(caseDef.densities.densityCorrectionEquation,'default')
		densityCorrection = 1/(1+(3*alpha*(Temp-MCNPInitialTemp)*10^-6));
	elseif ~strcmpi(caseDef.densities.densityCorrectionEquation,'default')
		densityCorrection = eval(caseDef.densities.densityCorrectionEquation);
	end
    output = [output; cellstr(MCNPCellID) cellstr(MCNPMatID) Temp cellstr(materialsDBID) MCNPInitialTemp alpha densityCorrection char(regionList(i)) maxTemp];
    end
end
end
