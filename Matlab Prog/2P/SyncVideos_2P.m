%           'Z:\2P_Analyze\ANM318142\20160723';
%           'Z:\2P_Analyze\ANM318142\20160724';
%           'Z:\2P_Analyze\ANM318142\20160801';
%           'Z:\2P_Analyze\ANM318142\20160802';
%           'Z:\2P_Analyze\ANM318142\20160804';
%           'Z:\2P_Analyze\ANM318142\20160805';
%           'Z:\2P_Analyze\ANM318142\20160806';
%           'Z:\2P_Analyze\ANM318142\20160808';
%           'Z:\2P_Analyze\ANM318142\20160809';
%           'Z:\2P_Analyze\ANM318142\20160811';
%           'Z:\2P_Analyze\ANM318142\20160814';
%           'Z:\2P_Analyze\ANM318142\20160816';
%           'Z:\2P_Analyze\ANM318142\20160817';
%           'Z:\2P_Analyze\ANM318142\20160819';
%           'Z:\2P_Analyze\ANM318142\20160821';
%%
strImgDir_P = 'Z:\2P_Analyze';
strVidDir_P = 'Z:\Imaging\BehaviorVideos\video';
strEventDir_P = 'Z:\Imaging\BehaviorVideos\LogEvent';
strReg_Vid_Sub = '\\20160819\\ANM318142$';%'\\2016((0723)|(0724)|(08\d{2}))\\ANM318142$';
%nFrm = 10;
clVidDirs = FindSubDirs_RegExp(strReg_Vid_Sub, strVidDir_P, true,2)';
%%
% vtSel = [1:7 9 10 12 13 15:19];
% clVidDirs = clVidDirs(vtSel);
%%
strEventFile_Rep = 'Y:\2P_Imaging\20160303\20160303\ANM287315\ANM287315_13.evt';
stEvent_Rep = ParseEventFile_SJ(strEventFile_Rep);
for nDir = 1:length(clVidDirs)
    strVidDir = clVidDirs{nDir};
    clVidDirParts = strsplit(strVidDir,filesep);
    strANMID = clVidDirParts{end};
    strDay = clVidDirParts{end-1};
    strEventDir = [strEventDir_P filesep strDay];
    
    clEventFiles = FindFiles_RegExp([strANMID '_(\d{2})\.evt'],strEventDir,false)';
    [clEventFiles,vtCounter_E] = SortFnByCounter(clEventFiles,[strANMID '_(\d{2})\.evt']);
    clFn_BehaVids = FindFiles_RegExp('Cam\S*_(\d{1,2})\.',strVidDir,false)';
    [clFn_BehaVids,vtCounter_B] = SortFnByCounter(clFn_BehaVids,'_(\d{1,2})\.');
    
    %%
    for nFile_E = [1:4 10:15]%1:length(clEventFiles)
        strEventFile = clEventFiles{nFile_E};
        iCounter = vtCounter_E(nFile_E);
        strFn_ImgHdr = [strImgDir_P filesep strANMID filesep strDay filesep strANMID '_' num2str(iCounter,'%05d') '_Header.mat'];
        if(exist(strFn_ImgHdr,'file'))
            load(strFn_ImgHdr);
            if(Header.SI.hFastZ.enable)
                nFrm = Header.SI.hFastZ.numFramesPerVolume;
            else
                nFrm = Header.SI.hStackManager.framesPerSlice;
            end
            
            try
                idxCounter_B = find(vtCounter_B==iCounter);
                if(~isempty(idxCounter_B))
                    disp(['Parsing Event: ' strEventFile]);
                    stEvent = ParseEventFile_SJ(strEventFile);
                    for nB = 1:length(idxCounter_B)
                        strFn_BehaVid = clFn_BehaVids{idxCounter_B(nB)};
                        disp(['Processing file: ' strFn_BehaVid])
                        try
                            ExtractSyncBehavFrm_2P_Correct(strFn_BehaVid, stEvent,nFrm);
                        catch
                            warning(['Something wrong with file: ' strEventFile ' Replaced with file: ' strEventFile_Rep]);
                            ExtractSyncBehavFrm_2P_Correct(strFn_BehaVid, stEvent, nFrm,stEvent_Rep);
                        end
                    end
                end
            catch ME
                warning(ME.message);
            end
        end
    end
end