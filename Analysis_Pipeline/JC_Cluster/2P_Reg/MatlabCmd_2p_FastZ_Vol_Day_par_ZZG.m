% Batch process to register images acquired from one animal on one day. 
%
% Saintgene 2016
%%
% set the parameters for the script

dir_1='/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/';
dir_1='/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496191/';
dir_1='/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/492241/';
%
% Directories containing images to be registered. Each directory contains images acquired from one animal on one day.
clImgDirs = {[dir_1 ,'D1'],[dir_1 ,'D2'],[dir_1,'D3'],[dir_1,'D5'],[dir_1 ,'D6'],[dir_1 ,'D7'],[dir_1,'D8'],[dir_1 ,'D9']};

% Directories containing images to be registered. Each directory contains
% images acquired from one animal on one day. 
% windows
% clImgDirs = {
%     'Z:\Zhenggang\CaRMApipeline\Example_Data\ANM378231\Fear_Imaging_Exp\ANM496190_visual_guidence\1211';
%     };

% Indexes of the images used to generate reference images for individual directories.
% length(clTrials_GenRefGrp) must be equal to length(clImgDirs), the member
% of clTrials_GenRefGrp can be vector, for example, clTrials_GenRefGrp = {[1 5],[2 3]};
clTrials_GenRefGrp = {[6],[6],[6],[7],[7],[7],[8],[8]}; % {[8 4],[5 4],[5 4]};

% Indexes of the images used as reference images for individual directories.
% length(clTrials_GenRefGrp) must be equal to length(clImgDirs), the member
% of clTrials_GenRefGrp can be scalar.
clTrial_Refs = {[6],[6],[6],[7],[7],[7],[8],[8]};
% Indexes of the images to be registered to the reference images within each directory.
% length(clTrials_GenRefGrp) must be equal to length(clImgDirs), the member
% of clTrials_GenRefGrp can be vector or scalar.
clTrials_UseRefGrp = {[1 2 3 4 5 7 8 9 10],[1 2 3 4 5 6 7 8 11 12],[1 2 3 4 5 6 7 8 9 10 11 12],[7 8 9 10 11 12],[1 2 3 4 5 6 8 9 10 11 12 13],[1 2 3 4 5 6 8 9 10 11 12 13],[8 9 10 11 12 13 14 15 16 17],[1 2 3 4 7 8 9 10 11 12 13 14 15 16 17 18]};
%clTrials_UseRefGrp = {[6 7 8 9 10],[1 2 3 4 5 6 7 8 11 12],[1 2 3 4 5 6 7 8 9 10 11 12],[1 2 3 4 5 6 7 8 9 10 11 12],[1 2 3 4 5 6 7 8 9 10 11 12 13],[1 2 3 4 5 6 7 8 9 10 11 12 13],[8 9 10 11 12 13 14 15 16 17],[1 2 3 4 7 8 9 10 11 12 13 14 15 16 17 18]};
%%%
%% ZhenggangZhu edit
% initialize the global paths for the computing environment
stPaths_G = Init_Cluster_GlobalPaths();

%%
% Batch-process for each directory
nDayCount = length(clImgDirs);

% disp(nDayCount)

for nDay = 1  %edit 20211225 :nDayCount 
    strImgDir_P = clImgDirs{nDay};%
    vtTrials_GenRefGrp = clTrials_GenRefGrp{nDay};
    iTrial_Ref = clTrial_Refs{nDay};
    vtTrials_UseRefGrp = clTrials_UseRefGrp{nDay};
    
    strImgFn_Exp = '_000(\d{2})_Comb_C\d.tif';
    clImgFns = FindFiles_RegExp(strImgFn_Exp, strImgDir_P, true,2)';
    [clImgFns,vtCounter] = SortFnByCounter(clImgFns,strImgFn_Exp);
    
    %%
    % register the reference images 
    strRefTrial = [];
    strDir_Ref =[];
    [vtTrials_GenRefGrp,idxTrials_GenRefGrp] = intersect(vtCounter,vtTrials_GenRefGrp);
    disp(idxTrials_GenRefGrp)
    for nDir=1:length(idxTrials_GenRefGrp)
        idx = idxTrials_GenRefGrp(nDir);
        [strPath,strImgFn] = fileparts(clImgFns{idx});
        clImgFnParts = strsplit(strImgFn,'_');
        strDir = [strPath filesep strjoin({clImgFnParts{1:end-2},'S'},'_')];
        strFn_Exp = ['_S(\d{1,2})_' clImgFnParts{end} '.tif'];
        
        clTiffFns = FindFiles_RegExp(strFn_Exp, strDir, false)';
        
        nStep = 3;
        parfor nFile = 1:length(clTiffFns)
            strTiffFn = clTiffFns{nFile};
            disp(['Processing file: ' strTiffFn]);
            tS = tic();
            ImgFileReg_2p_par(stPaths_G, strTiffFn, 1, inf, 0, nStep,true,false);% use ave as ref edit zzg false, false
            tElapse = toc(tS);
            disp(['Elapse Time: ' num2str(tElapse) ' Seconds']);
        end
        iCounter = vtTrials_GenRefGrp(nDir);
        if(iCounter==iTrial_Ref)
            strRefTrial = strjoin({clImgFnParts{1:end-2},'S'},'_');
            strDir_Ref = strDir;
        end
    end
    
    %%
    % wait for the finish of the registration of the reference images 
    if(isempty(strRefTrial))
        idx = find(vtCounter==iTrial_Ref);
        [strPath,strImgFn] = fileparts(clImgFns{idx});
        clImgFnParts = strsplit(strImgFn,'_');
        strRefTrial = strjoin({clImgFnParts{1:end-2},'S'},'_');
        strDir_Ref = [strPath filesep strjoin({clImgFnParts{1:end-2},'S'},'_')];
    end
    Wait_Cluster_Complete_Task_v2(strRefTrial);
    
    %%
    % register other images to the assigned reference images
    [vtTrials_UseRefGrp,idxTrials_UseRefGrp] = intersect(vtCounter,vtTrials_UseRefGrp);
    for nDir=1:length(idxTrials_UseRefGrp)
        idx = idxTrials_UseRefGrp(nDir);
        [strPath,strImgFn] = fileparts(clImgFns{idx});
        clImgFnParts = strsplit(strImgFn,'_');
        strDir = [strPath filesep strjoin({clImgFnParts{1:end-2},'S'},'_')];
        strFn_Exp = ['_S(\d{1,2})_' clImgFnParts{end} '.tif'];
        iCounter = vtTrials_UseRefGrp(nDir);
        clTiffFns = FindFiles_RegExp(strFn_Exp, strDir, false)';
        parfor nFile = 1:length(clTiffFns)
            strTiffFn = clTiffFns{nFile};
            disp(['Processing file: ' strTiffFn]);
            tS = tic();
            for nStep=1:2
                ImgFileReg_2p_par_useRef(stPaths_G, strTiffFn, 1, inf, 0, nStep,true,false); %% edit 12182021
                if(nStep==1)
                    [strPath_S,strImgFn_S] = fileparts(strTiffFn);
                    strRefFn = [strDir_Ref filesep strrep(strImgFn_S,num2str(iCounter,'%05d'),num2str(iTrial_Ref,'%05d')) '_reg_ZProj.tif'];
                    strDir_S = strTiffFn(1:end-4);
                    CopyRefImg(strRefFn,strDir_S);
                end
            end
            tElapse = toc(tS);
            disp(['Elapse Time: ' num2str(tElapse) ' Seconds']);
        end
        
    end
end