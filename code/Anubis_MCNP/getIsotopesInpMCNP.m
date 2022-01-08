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

function output = getIsotopesInpMCNP(caseDef)
filelines_notdelimited = regexp(fileread(caseDef.simCase.MCNP),getLineDelimiterMCNP(caseDef,"input"),'split');
filelines_notdelimited = filelines_notdelimited.';
lines = {};
emptylines = [];
for i=1:1:size(filelines_notdelimited,1)
   lines{i} = strsplit(strtok(filelines_notdelimited{i},'$'),{' ','\t'});
   if size(lines{i},2) == 1 && lines{i}{1} == ""
       emptylines = [emptylines; i];
   end
end

datacards = {};
materialcards = {};
matlineindices = {};
cleanmaterialcards = {};
materialmarkers = [];
matIDs = [];
zaidsonly = {};
for i=emptylines(2)+1:1:emptylines(3)-1
    clim = (size(lines{i},2).*(size(lines{i},2)<=5)+5.*(size(lines{i},2)>5));
    if ~max(ismember("C",lines{i}(1:clim))) && ~max(ismember("c",lines{i}(1:clim)))
    datacards{end+1} = lines{i};
    matches = strfind(lines{i},'.');
    tf1 = any(vertcat(matches{:}));
    matches = strfind(lines{i},'c');
    matches2 = strfind(lines{i},'t');
    tf21 = any(vertcat(matches{:})); 
    tf22 = any(vertcat(matches2{:}));
    tf2 = tf21 || tf22;
    negativeKeywords = ['a';'b';'d';'e';'f';'g';'h';'i';'j';'k';'l';'n';'o';'p';'q';'r';'s';'u';'v';'w';'x';'y';'z'];
    tfneg = [];
    for p=1:1:size(negativeKeywords,1)
        negmatches = strfind(lines{i},negativeKeywords(p));
        tfneg = [tfneg;any(vertcat(negmatches{:}))];
    end
    tf3 = ~max(tfneg);
    if tf1 && tf2 && tf3
    materialcards{end+1} = lines{i};
    cleanmaterialcards{end+1} = lines{i};
    matlineindices{end+1} = i;
    matches = strfind(lines{i},'m');
    tf4 = any(vertcat(matches{:}));
    if tf4
        materialmarkers = [materialmarkers; size(materialcards,2)];
        for k=1:1:size(materialcards(end),2)
           matches = strfind(materialcards{end}(k),'m');
           tf5 = any(vertcat(matches{:}));
           if tf5
               matIDcol = k;
           end
        end
        matIDs = [matIDs; materialcards{end}(matIDcol)];
        cleanmaterialcards{end}(matIDcol)=[];
    end
    %remove empty cells
    b = size(cleanmaterialcards{end},2);
    for k=0:1:b-1
           if isempty(cleanmaterialcards{end}{b-k})
               cleanmaterialcards{end}(b-k)= [];
           end
    end
    %ZAIDs only
    zaidsonly{end+1} = cleanmaterialcards{end};
    b = size(zaidsonly{end},2);
    for k=0:1:b-1
            isDensity = 0;
            if ~isempty(str2num(char(zaidsonly{end}(b-k))))
                isDensity = 1;
            end   
           if isDensity == 1
               zaidsonly{end}(b-k)= [];
           end
    end
        
    end   
    end
end

for i=1:1:size(zaidsonly,2)
   zaidsonly{i}{1} = strtok(char(zaidsonly{i}{1}),'.'); 
end
zaidsonly = [zaidsonly{:}]';

for i=1:1:size(materialmarkers,1)
    if i ~= size(materialmarkers,1)
        for j=materialmarkers(i):1:materialmarkers(i+1)-1
        Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).xs0 = cleanmaterialcards{1,j}{1};
        [~,Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).ext0] = strtok(cleanmaterialcards{1,j}{1},'.');
        Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).fraction0 = cleanmaterialcards{1,j}{2};
        Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).zaid = zaidsonly{j};
        Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).line = matlineindices{j};
        end
    end
    if i == size(materialmarkers,1)
        for j=materialmarkers(i):1:length(cleanmaterialcards)
        Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).xs0 = cleanmaterialcards{1,j}{1};
        [~,Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).ext0] = strtok(cleanmaterialcards{1,j}{1},'.');
        Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).fraction0 = cleanmaterialcards{1,j}{2};
        Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).zaid = zaidsonly{j};
        Isotopes.(char(matIDs(i))).(strcat('z',zaidsonly{j})).line = matlineindices{j};
        end
    end    
end

output = Isotopes;

end
