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

function output = checkXSMCNP(xs,caseDef)
global slash
datafile = strcat(getenv('DATAPATH'),slash,caseDef.crossSections.xsdirIndex);
xsdir = fileread(datafile);
check1 = strfind(xsdir, xs);
if ~isempty(check1)
output.status = 1;
output.response = "valid";
output.alt = xs;
end

[~, zaid, ext] = fileparts(char(xs));
evalNum = str2num(strtok(strtok(ext,'c'),'.'));

if evalNum < 80
altEvalNum = evalNum + 10;
altExt = strcat(".",num2str(altEvalNum),"c");
check2 = strfind(xsdir,strcat(zaid,".8"));
end

if evalNum >= 80
altEvalNum = evalNum - 10;
altExt = strcat(".",num2str(altEvalNum),"c");
check2 = strfind(xsdir,strcat(zaid,altExt)); 
end

if (~isempty(check2)) && isempty(check1)
output.status = 1;    
output.response = "wrongIdentifier";
output.alt = strcat(zaid,altExt);
end

if caseDef.crossSections.notFound.accept80s == "no"
   check2 = []; 
end

natZaid = zaid;
natZaid(end) = "0";
natZaid(end-1) = "0";
natZaid(end-2) = "0";
natXS = strcat(natZaid,ext);
natXSAlt = strcat(natZaid,altExt);

check3 = strfind(xsdir,natXS);

if (~isempty(check3)) && isempty(check2) && isempty(check1)
output.status = 1;
output.response = "natExists";
output.alt = natXS;
end

if caseDef.crossSections.notFound.acceptNatural == "no"
   check3 = []; 
end


if isempty(check3) && isempty(check2) && isempty(check1)
output.status = 0;
output.response = "fail";
output.alt = "0";
end

end
