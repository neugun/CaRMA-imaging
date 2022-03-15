strVidDir_P = 'Z:\Imaging\BehaviorVideos\video';
strEventDir_P = 'Z:\Imaging\BehaviorVideos\LogEvent';
strReg_Vid_Sub = '20170829\\ANM378231';
nFrm = 11;
clVidDirs = FindSubDirs_RegExp(strReg_Vid_Sub, strVidDir_P, true,2)';
%%
for nDir = 1:length(clVidDirs)
    strVidDir = clVidDirs{nDir};
    clVidDirParts = strsplit(strVidDir,filesep);
    strANMID = clVidDirParts{end};
    strDay = clVidDirParts{end-1};
    strEventDir = [strEventDir_P filesep strDay];
    
    clEventFiles = FindFiles_RegExp([strANMID '_(\d{2}).evt'],strEventDir,false)';
    clEventFiles = SortFnByCounter(clEventFiles,[strANMID '_(\d{2})']);
    clFn_BehaVids = FindFiles_RegExp('Cam\S*_(\d{1,2}).avi',strVidDir,false)';
    clFn_BehaVids = SortFnByCounter(clFn_BehaVids,'(\d{1,2}).avi');

    %%
    strEventFile_Rep = 'Y:\2P_Imaging\20160303\20160303\ANM287315\ANM287315_13.evt';
    stEvent_Rep = ParseEventFile_SJ(strEventFile_Rep);
    for nFile_E = 1:length(clEventFiles)
        strEventFile = clEventFiles{nFile_E};
        stEvent = ParseEventFile_SJ(strEventFile);
        for nFile_B = 1:2
            strFn_BehaVid = clFn_BehaVids{2*(nFile_E-1)+nFile_B};
            disp(['Processing file: ' strFn_BehaVid])
            try
                ExtractSyncBehavFrm_2P(strFn_BehaVid, stEvent,nFrm);
            catch
                warning(['Something wrong with file: ' strEventFile ' Replaced with file: ' strEventFile_Rep]);
                ExtractSyncBehavFrm_2P(strFn_BehaVid, stEvent, nFrm,stEvent_Rep);
            end
        end
    end
end