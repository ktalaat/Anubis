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

function output = resolveSurfaceExpVars(statement,surfExp,surfaces,mapTempField)
try
validDefinedVars.names = fields(surfExp.variables);
for i=1:1:length(validDefinedVars.names)
varValue = surfExp.variables.(char(validDefinedVars.names(length(validDefinedVars.names)+1-i)));
statement = strrep(statement,validDefinedVars.names(length(validDefinedVars.names)+1-i),strcat('(',varValue,')'));
end
statement = strcat('(',char(statement),')');
catch
end
column = 1;
newstr = {};
i = 1;
done = 0;
while done == 0    
   if statement(i) == "#" && statement(i+1) == "!"
       j = i+2;
       terminate = 0;
       row = 1;
       while terminate == 0
       newstr{row,column} = statement(j);
       j = j + 1;
       row = row + 1;
           if statement(j) == "!" && statement(j+1) == "#"
               originalVarName = strcat('#!',sprintf('%s',newstr{:,column}),'!#');
               [handle,cellID] = strtok(sprintf('%s',newstr{:,column}),'(');
               cellID = strtok(strtok(sprintf('%s',cellID),'('),')');
               statement = strrep(statement,originalVarName,num2str(getCellValue(handle,cellID,mapTempField)));
               terminate = 1;
               column = column + 1;
               
           end
       end
   end
i = i + 1;
if i == length(statement)-1
    done = 1;
end
end

validSurfaceVars.names = getPossibleSurfaceVarNames(surfaces);
for i=1:1:length(validSurfaceVars.names)
b = getParamsFromSurfaceName(char(validSurfaceVars.names(i)));
validSurfaceVars.values{i} = surfaces.(char(b.surfaceID)).params{b.paramNum};
statement = strrep(statement,validSurfaceVars.names(i),num2str(validSurfaceVars.values{i}));
end

validSurfaceVars.names = getPossibleSurfaceVarNames(surfaces,"original");
for i=1:1:length(validSurfaceVars.names)
b = getParamsFromSurfaceName(char(validSurfaceVars.names(i)));
validSurfaceVars.values{i} = surfaces.(char(b.surfaceID)).originalParams{b.paramNum};
statement = strrep(statement,validSurfaceVars.names(i),num2str(validSurfaceVars.values{i}));
end

output = num2str(str2num(char(statement)),12);
end
