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

function updateHeatSourcesFOAM(caseDef,geomCoupling,cells)
global slash
cd(sprintf('%s',caseDef.simCase.OpenFOAM,slash,"constant"));
regionsList = fields(geomCoupling.regions);
for i=1:1:length(regionsList)
    try
    cd(sprintf('%s',regionsList{i}));
    filelines.notDelimited = regexp(fileread('fvOptions'),'\r\n','split');
    filelines.notDelimited = filelines.notDelimited.';
    filelines.notDelimitedNoComments = strtok(filelines.notDelimited,'//');
    if length(filelines.notDelimited) == 1
    filelines.notDelimited = regexp(fileread('fvOptions'),'\n','split');
    filelines.notDelimited = filelines.notDelimited.';
    filelines.notDelimitedNoComments = strtok(filelines.notDelimited,'//');
    end

        for j=1:1:length(filelines.notDelimited)
            matches = strfind(filelines.notDelimited(j),'h(');
            tf1 = any(vertcat(matches{:}));
            matches = strfind(filelines.notDelimited(j),'h (');
            tf2 = any(vertcat(matches{:}));
            searchOutcome = tf1 || tf2;
            if searchOutcome
            line = strsplit(filelines.notDelimited{j},{' ','(',')','\t'});
            for f = 1:1:length(line)
                if line{f} == 'h'
                    originalPower = line(f+1);
                   break; 
                end
            end
            
            try
                siblingCount = length(strsplit(geomCoupling.regions.(char(regionsList(i))).siblings,{' ',','}));
            catch
                siblingCount = 0;
            end
            numberOfParts = 1 + siblingCount;
            newPower = num2str(getPowerFromCells(cells,regionsList{i},geomCoupling)/numberOfParts);
            filelines.notDelimited(j) = strrep(filelines.notDelimitedNoComments{j},originalPower,newPower);
            end
        end

        fid = fopen('fvOptions','w');
        formatspec = strcat('%s','\r\n');
        [nrows,~] = size(filelines.notDelimited);
        for row = 1:nrows
            if row == nrows
                formatspec = '%s';
            end
            fprintf(fid,formatspec,filelines.notDelimited{row,:});
        end
        fclose(fid);
        %Now update sibling regions - we updated main region in previous step
        try
            siblings = strsplit(geomCoupling.regions.(char(regionsList(i))).siblings,{' ',','});
            for m=1:1:length(siblings)
                cd ..
                cd(sprintf('%s',siblings{m}));
                filelines.notDelimited = regexp(fileread('fvOptions'),'\r\n','split');
                filelines.notDelimited = filelines.notDelimited.';
                filelines.notDelimitedNoComments = strtok(filelines.notDelimited,'//');
                if length(filelines.notDelimited) == 1
                filelines.notDelimited = regexp(fileread('fvOptions'),'\n','split');
                filelines.notDelimited = filelines.notDelimited.';
                filelines.notDelimitedNoComments = strtok(filelines.notDelimited,'//');
                end

                for j=1:1:length(filelines.notDelimited)
                    matches = strfind(filelines.notDelimited(j),'h(');
                    tf1 = any(vertcat(matches{:}));
                    matches = strfind(filelines.notDelimited(j),'h (');
                    tf2 = any(vertcat(matches{:}));
                    searchOutcome = tf1 || tf2;
                    if searchOutcome
                    line = strsplit(filelines.notDelimited{j},{' ','(',')','\t'});
                    for f = 1:1:length(line)
                        if line{f} == 'h'
                            originalPower = line(f+1);
                           break; 
                        end
                    end
                    filelines.notDelimited(j) = strrep(filelines.notDelimitedNoComments{j},originalPower,newPower);
                    end
                end

                fid = fopen('fvOptions','w');
                formatspec = strcat('%s','\r\n');
                [nrows,~] = size(filelines.notDelimited);
                for row = 1:nrows
                    if row == nrows
                        formatspec = '%s';
                    end
                    fprintf(fid,formatspec,filelines.notDelimited{row,:});
                end
                fclose(fid);

            end
        catch
        end
    
   catch
        disp('catch')
   end
 cd ..   
end
cd ..
end
