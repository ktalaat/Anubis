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

function FOAM_MCNP_Iterator(directory,iteration,resumeExistingRun)
while 1
iteration = iteration + 1;

cd(sprintf('%s',directory));
caseDef = readCaseDef();
geomCoupling = readGeometryDef();
matDB = readMaterialsDB(caseDef);
surfExp = readSurfaceExpansionDef();

if resumeExistingRun
    cd(sprintf('%s',caseDef.outputDir));
    cd saves
    load(sprintf('%s',strcat('iteration',num2str(iteration-1))),'-regexp', '^(?!iteration)\w');
    cd ..
    resumeExistingRun = 0;
end

if caseDef.couplingFlow.startWith == "OpenFOAM"
caseDef.simCase.OpenFOAM = cloneCaseFOAM(caseDef,iteration);
try
updateHeatSourcesFOAM(caseDef,geomCoupling,cells);
catch
end
controlDict = readControlDictFOAM(caseDef);
runMapFieldsFOAM(caseDef,iteration);

if caseDef.setup.OpenFOAM.type == "local"
    executeOpenFOAM = executeFOAM(caseDef);
elseif caseDef.setup.OpenFOAM.type == "remote" && caseDef.setup.OpenFOAM.queuesystem == "PBS"
    initiateRemoteDir(caseDef,iteration,"OpenFOAM")
    uploadToHost(caseDef,iteration,"OpenFOAM")
    preparePBSFile(caseDef,iteration,"OpenFOAM")
    jobID = submitPBSToHost(caseDef,iteration,"OpenFOAM");
    checkJobStatus(caseDef,jobID,"OpenFOAM")
    downloadFromHost(caseDef,iteration,"OpenFOAM")
    cleanUpHost(caseDef,iteration,"OpenFOAM")
end


caseDef.simCase.MCNP = cloneCaseMCNP(caseDef,iteration);
cells = getCellsMCNP(caseDef);
surfaces = getSurfacesMCNP(caseDef);

mapTempField = mapTempFields(caseDef,geomCoupling,iteration);
writeRegionTempsFOAM(mapTempField,caseDef,iteration);

Isotopes = getIsotopesInpMCNP(caseDef);
Isotopes = updateIsotopes(Isotopes,mapTempField,caseDef);
xsFileNames = createSpecsFile(caseDef,Isotopes);
executeMakxsf = runMakxsf(caseDef,xsFileNames);
updateXSdirMCNP(xsFileNames,caseDef);
updateMaterialCardsMCNP(caseDef,Isotopes,iteration);
cells = updateCellsObject(cells,mapTempField,caseDef);
updateCellCardsMCNP(caseDef,cells,iteration);
surfaces = updateSurfacesObject(surfaces,surfExp,mapTempField,caseDef);
updateSurfaceCardsMCNP(caseDef,surfaces,iteration);
if caseDef.setup.MCNP.type == "local"
    runMCNP = executeMCNP(caseDef);
elseif caseDef.setup.MCNP.type == "remote" && caseDef.setup.MCNP.queuesystem == "PBS"
    uploadXSToHostMCNP(caseDef,xsFileNames)
    initiateRemoteDir(caseDef,iteration,"MCNP")
    uploadToHost(caseDef,iteration,"MCNP")
    preparePBSFile(caseDef,iteration,"MCNP")
    jobID = submitPBSToHost(caseDef,iteration,"MCNP");
    checkJobStatus(caseDef,jobID,"MCNP")
    downloadFromHost(caseDef,iteration,"MCNP")
    cleanUpHost(caseDef,iteration,"MCNP")
end
caseDef.simCase.outputMCNP = char(strrep(caseDef.simCase.MCNP,"inp","out"));
tallies = readTallies(caseDef);
cells = addTallyDataToCells(caseDef,cells,surfaces);
cd(sprintf('%s',caseDef.outputDir));
mkdir saves
cd saves
save(sprintf('%s',strcat('iteration',num2str(iteration))));
cd ..
if strcmpi(caseDef.couplingFlow.terminationCondition,'tempConvergence')
if checkForTempConvergence(caseDef,iteration)
    disp('Run successful. Temperatures are converged according to the supplied convergance criterion.');
    break;
end
end
end

if caseDef.couplingFlow.startWith == "MCNP"
    caseDef.simCase.MCNP = cloneCaseMCNP(caseDef,iteration);
    cells = getCellsMCNP(caseDef);
    surfaces = getSurfacesMCNP(caseDef);
    Isotopes = getIsotopesInpMCNP(caseDef);
    try
        Isotopes = updateIsotopes(Isotopes,mapTempField,caseDef);
        xsFileNames = createSpecsFile(caseDef,Isotopes);
        executeMakxsf = runMakxsf(caseDef,xsFileNames);
        updateXSdirMCNP(xsFileNames,caseDef);
        updateMaterialCardsMCNP(caseDef,Isotopes,iteration);
        cells = updateCellsObject(cells,mapTempField,caseDef);
        updateCellCardsMCNP(caseDef,cells,iteration);
        surfaces = updateSurfacesObject(surfaces,surfExp,mapTempField,caseDef);
        updateSurfaceCardsMCNP(caseDef,surfaces,iteration);
    catch
    end
        if caseDef.setup.MCNP.type == "local"
            runMCNP = executeMCNP(caseDef);
        elseif caseDef.setup.MCNP.type == "remote" && caseDef.setup.MCNP.queuesystem == "PBS"
            try
            uploadXSToHostMCNP(caseDef,xsFileNames)
            catch
            end
            initiateRemoteDir(caseDef,iteration,"MCNP")
            uploadToHost(caseDef,iteration,"MCNP")
            preparePBSFile(caseDef,iteration,"MCNP")
            jobID = submitPBSToHost(caseDef,iteration,"MCNP");
            checkJobStatus(caseDef,jobID,"MCNP")
            downloadFromHost(caseDef,iteration,"MCNP")
            cleanUpHost(caseDef,iteration,"MCNP")
        end
        caseDef.simCase.outputMCNP = char(strrep(caseDef.simCase.MCNP,"inp","out"));
        cells = addTallyDataToCells(caseDef,cells,surfaces);
        
        caseDef.simCase.OpenFOAM = cloneCaseFOAM(caseDef,iteration);
        updateHeatSourcesFOAM(caseDef,geomCoupling,cells);
        controlDict = readControlDictFOAM(caseDef);
        runMapFieldsFOAM(caseDef,iteration);
        if caseDef.setup.OpenFOAM.type == "local"
            executeOpenFOAM = executeFOAM(caseDef);
        elseif caseDef.setup.OpenFOAM.type == "remote" && caseDef.setup.OpenFOAM.queuesystem == "PBS"
            initiateRemoteDir(caseDef,iteration,"OpenFOAM")
            uploadToHost(caseDef,iteration,"OpenFOAM")
            preparePBSFile(caseDef,iteration,"OpenFOAM")
            jobID = submitPBSToHost(caseDef,iteration,"OpenFOAM");
            checkJobStatus(caseDef,jobID,"OpenFOAM")
            downloadFromHost(caseDef,iteration,"OpenFOAM")
            cleanUpHost(caseDef,iteration,"OpenFOAM")
        end        
        mapTempField = mapTempFields(caseDef,geomCoupling,iteration);
        writeRegionTempsFOAM(mapTempField,caseDef,iteration);
        mapTempField = mapTempFields(caseDef,geomCoupling,iteration);
        cd(sprintf('%s',caseDef.outputDir));
        mkdir saves
        cd saves
        save(sprintf('%s',strcat('iteration',num2str(iteration))));
        cd ..
        if strcmpi(caseDef.couplingFlow.terminationCondition,'tempConvergence')
        if checkForTempConvergence(caseDef,iteration)
        disp('Run successful. Temperatures are converged according to the supplied convergance criterion.');
        break;
        end
        end
end


if iteration >= str2num(caseDef.couplingFlow.maxIterations)
    break;
end

end
end
