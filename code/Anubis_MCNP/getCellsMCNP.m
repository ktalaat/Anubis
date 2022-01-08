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

function cells = getCellsMCNP(caseDef)
filelines.notDelimited = regexp(fileread(caseDef.simCase.MCNP),getLineDelimiterMCNP(caseDef,"input"),'split');
filelines.notDelimited = filelines.notDelimited.';
emptylines = [];
for i=1:1:size(filelines.notDelimited,1)
   filelines.notDelimited{i,1} = strtok(filelines.notDelimited{i},'$');
   filelines.colonDelimited{i,1} = strsplit(strtok(filelines.notDelimited{i},'$'),{' ',':','(',')','\t'});
   filelines.delimited{i,1} = strsplit(strtok(filelines.notDelimited{i},'$'),{' ','(',')','=','\t'}); 
   
   if isNewCardMCNP(filelines.notDelimited{i,1},filelines.delimited{i-1.*(i~=1),1}) 
       filelines.isNewCard(i,1) = 1;
   end
   if ~isNewCardMCNP(filelines.notDelimited{i,1},filelines.delimited{i-1.*(i~=1),1}) 
       filelines.isNewCard(i,1) = 0;
   end
 
   if size(filelines.delimited{i,1},2) == 1 && filelines.delimited{i,1}{1} == ""
       emptylines = [emptylines; i];
   end
end

cellcards = {};
concatenatedcellcards = {};
cellMatMap = {};
for i=2:1:emptylines(1)-1
    clim = (size(filelines.delimited{i,1},2).*(size(filelines.delimited{i,1},2)<=5)+5.*(size(filelines.delimited{i,1},2)>5));
    if ~max(ismember("C",filelines.delimited{i,1}(1:clim))) && ~max(ismember("c",filelines.delimited{i,1}(1:clim)))
        cellcards{end+1,1} = filelines.delimited{i,1};
        if filelines.isNewCard(i,1) == 1
            cellMatMap{end+1,1} = filelines.delimited{i,1}{1};
            cellMatMap{end,2} = filelines.delimited{i,1}{2};
            try
            cellMatMap{end,3} = filelines.delimited{i,1}{3};
            catch
            cellMatMap{end,3} = '0';
            end
           
            if cellMatMap{end,2} == '0'
                cellMatMap{end,3} = '0';
            end
            cellMatMap{end,4} = num2str(i);
            cellMatMap{end,5} = num2str(i);
            concatenatedcellcards{end+1,1} = filelines.delimited{i,1};
        end
        if filelines.isNewCard(i,1) ~= 1
            cellMatMap{end,5} = num2str(i);
            concatenatedcellcards{end,1}(1,end+1:end+size(filelines.delimited{i,1},2)) = filelines.delimited{i,1};  
        end
       concatenatedcellcards{end,1} = concatenatedcellcards{end,1}(~cellfun('isempty',concatenatedcellcards{end,1}));
    end   
end

for i=1:1:size(cellMatMap,1)
   cells.(char(strcat('c',cellMatMap(i,1)))).startLine = str2num(char(cellMatMap(i,4)));
   cells.(char(strcat('c',cellMatMap(i,1)))).endLine = str2num(char(cellMatMap(i,5)));
   cells.(char(strcat('c',cellMatMap(i,1)))).m = cellMatMap(i,2);
   cells.(char(strcat('c',cellMatMap(i,1)))).density = char(cellMatMap(i,3));
   cells.(char(strcat('c',cellMatMap(i,1)))).newDensity = str2num(char(cellMatMap(i,3)));
   if cells.(char(strcat('c',cellMatMap(i,1)))).m == "0"
       cells.(char(strcat('c',cellMatMap(i,1)))).newDensity = 0;
   end
   cells.(char(strcat('c',cellMatMap(i,1)))).universe = getParamFromCard(concatenatedcellcards{i,1},"u");
   cells.(char(strcat('c',cellMatMap(i,1)))).nimp = getParamFromCard(concatenatedcellcards{i,1},"imp:n");
   cells.(char(strcat('c',cellMatMap(i,1)))).like = getParamFromCard(concatenatedcellcards{i,1},"like");
   cells.(char(strcat('c',cellMatMap(i,1)))).but = getParamFromCard(concatenatedcellcards{i,1},"but");
   cells.(char(strcat('c',cellMatMap(i,1)))).lat = getParamFromCard(concatenatedcellcards{i,1},"lat"); 
   cells.(char(strcat('c',cellMatMap(i,1)))).fill = getParamFromCard(concatenatedcellcards{i,1},"fill");
   cells.(char(strcat('c',cellMatMap(i,1)))).fillList = getParamFromCard(concatenatedcellcards{i,1},"fill",3);
   cells.(char(strcat('c',cellMatMap(i,1)))).trcl = getParamFromCard(concatenatedcellcards{i,1},"trcl");
   [cells.(char(strcat('c',cellMatMap(i,1)))).inpVol,cells.(char(strcat('c',cellMatMap(i,1)))).index.inpVol] = getParamFromCard(concatenatedcellcards{i,1},"vol");
end

end
