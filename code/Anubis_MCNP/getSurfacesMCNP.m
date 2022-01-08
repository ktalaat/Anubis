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

function surfaces = getSurfacesMCNP(caseDef)
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

surfaceCards = {};
concatenatedSurfaceCards = {};
surfaceProperties = {};
for i=emptylines(1)+1:1:emptylines(2)-1
    clim = (size(filelines.delimited{i,1},2).*(size(filelines.delimited{i,1},2)<=5)+5.*(size(filelines.delimited{i,1},2)>5));
    if ~max(ismember("C",filelines.delimited{i,1}(1:clim))) && ~max(ismember("c",filelines.delimited{i,1}(1:clim)))
        surfaceCards{end+1,1} = filelines.delimited{i,1};
        if filelines.isNewCard(i,1) == 1
            surfaceProperties{end+1,1} = strtok(filelines.delimited{i,1}{1},{'*','+'});
            surfaceProperties{end,2} = num2str(i);
            surfaceProperties{end,3} = num2str(i);
            for k=2:1:length(filelines.delimited{i,1})
                if issurfacemnemonic(filelines.delimited{i,1}{k})
                    surfaceProperties{end,4} = filelines.delimited{i,1}{k};
                    break;
                end
            end
            concatenatedSurfaceCards{end+1,1} = filelines.delimited{i,1};
        end
        if filelines.isNewCard(i,1) ~= 1
            surfaceProperties{end,3} = num2str(i);
            concatenatedSurfaceCards{end,1}(1,end+1:end+size(filelines.delimited{i,1},2)) = filelines.delimited{i,1};  
        end
       concatenatedSurfaceCards{end,1} = concatenatedSurfaceCards{end,1}(~cellfun('isempty',concatenatedSurfaceCards{end,1}));
    end   
end

for i=1:1:size(surfaceProperties,1)
   surfaces.(char(strcat('s',surfaceProperties(i,1)))).startLine = str2num(char(surfaceProperties(i,2)));
   surfaces.(char(strcat('s',surfaceProperties(i,1)))).endLine = str2num(char(surfaceProperties(i,3)));
   surfaces.(char(strcat('s',surfaceProperties(i,1)))).mnemonic = surfaceProperties(i,4);
   [surfaces.(char(strcat('s',surfaceProperties(i,1)))).params,surfaces.(char(strcat('s',surfaceProperties(i,1)))).index.params] = getParamFromCard(concatenatedSurfaceCards{i,1},surfaces.(char(strcat('s',surfaceProperties(i,1)))).mnemonic);
   surfaces.(char(strcat('s',surfaceProperties(i,1)))).originalParams = surfaces.(char(strcat('s',surfaceProperties(i,1)))).params;
end

end
