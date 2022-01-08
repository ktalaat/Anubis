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

function output = readTallies(caseDef)
filelines.notDelimited = regexp(fileread(caseDef.simCase.outputMCNP),getLineDelimiterMCNP(caseDef,"output"),'split');
filelines.notDelimited = filelines.notDelimited.';
tallyIndicatorLines = [];
tallyTerminationLines = [];
cellMasses = {};
cellID={};
for i=1:1:size(filelines.notDelimited,1)
   filelines.notDelimited{i,1} = strtok(filelines.notDelimited{i},'$');
   filelines.delimited{i,1} = strsplit(strtok(filelines.notDelimited{i},'$'),{' ','(',')','=','\t'}); 
   
   matches = strfind(filelines.notDelimited(i,1),'tally type');
   tallyIndicatorCheck = any(vertcat(matches{:}));
   if tallyIndicatorCheck
       tallyIndicatorLines = [tallyIndicatorLines; i];
   end
   matches = strfind(filelines.notDelimited(i,1),'the nps-dependent');
   tallyTerminationCheck = any(vertcat(matches{:}));
   if tallyTerminationCheck
       tallyTerminationLines = [tallyTerminationLines; i];
   end
end

massStartLines = [];
massTerminationLines = [];
cellTallyStartLines = [];
cellTallyTerminationLines = [];
tallyStartLine = 0;
tallyEndLine = 0;
tallyType = {};
for i=1:1:size(filelines.notDelimited,1)

   for j=1:1:length(tallyIndicatorLines)
   if i >= tallyIndicatorLines(j) && i <= tallyTerminationLines(j)
       tallyStartLine = tallyIndicatorLines(j);
       tallyEndLine = tallyTerminationLines(j);
       break;
   end
   end
   
   if i == tallyStartLine
     for j=1:1:length(filelines.delimited{i,1})
       if strcmpi(filelines.delimited{i,1}{1,j},'type')
           tallyType{end+1,1} = strcat('F',filelines.delimited{i,1}{1,j+1});
       end
     end
     counter = 0;
   end
   
   if i >= tallyStartLine && i <= tallyEndLine
       
       matches = strfind(filelines.notDelimited(i,1),'masses');
       massDataCheck = any(vertcat(matches{:}));
       if massDataCheck
           massStartLines = [massStartLines; i+1];           
       end
       matches = strfind(filelines.notDelimited(i,1),'cell ');
       massDataCheck = any(vertcat(matches{:}));
       if massDataCheck && counter == 0
           massTerminationLines = [massTerminationLines; i-2];
           cellTallyStartLines = [cellTallyStartLines; i];
           cellTallyTerminationLines = [cellTallyTerminationLines; tallyEndLine-3];
           counter = counter + 1;          
       end
   end  
end

for i=1:1:length(tallyType)
    tallies.(char(tallyType(i))).rawData.cellMass = filelines.delimited(massStartLines(i):massTerminationLines(i));
    tallies.(char(tallyType(i))).cellMassMap = getCellMassMapMCNP(tallies.(char(tallyType(i))).rawData.cellMass);
    tallies.(char(tallyType(i))).rawData.cellTally = filelines.delimited(cellTallyStartLines(i):cellTallyTerminationLines(i));
    tallies.(char(tallyType(i))).cellTallyMap = getCellTallyMapMCNP(tallies.(char(tallyType(i))).rawData.cellTally);
end
output = tallies;

end
