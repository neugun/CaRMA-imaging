strVidDir_P = 'Z:\Imaging\BehaviorVideos\video';
strEventDir_P = 'Z:\Imaging\BehaviorVideos\LogEvent';
clImgDirs = {
%     'Z:\Imaging\2P345\20170804\ANM378231';
%     'Z:\Imaging\2P345\20170805\ANM378231';
%     'Z:\Imaging\2P345\20170806\ANM378231';
%     'Z:\Imaging\2P345\20170808\ANM378231';
%     'Z:\Imaging\2P345\20170816\ANM378231';
%     'Z:\Imaging\2P345\20170817\ANM378231';
%     'Z:\Imaging\2P345\20170818\ANM378231';
%     'Z:\Imaging\2P345\20170820\ANM378231';
%     'Z:\Imaging\2P345\20170821\ANM378231';
%     'Z:\Imaging\2P345\20170822\ANM378231';
%     'Z:\Imaging\2P345\20170824\ANM378231';
%     'Z:\Imaging\2P345\20170826\ANM378231';
% %     'Z:\Imaging\2P345\20170827\ANM378231';
% %     'Z:\Imaging\2P345\20170828\ANM378231';
% %     'Z:\Imaging\2P345\20170829\ANM378231';
% %     'Z:\Imaging\2P345\20170830\ANM378231';
%     'Z:\Imaging\2P345\20170803\ANM372320';
%     'Z:\Imaging\2P345\20170804\ANM372320';
%     'Z:\Imaging\2P345\20170805\ANM372320';
%     'Z:\Imaging\2P345\20170808\ANM372320';
%     'Z:\Imaging\2P345\20170816\ANM372320';
%     'Z:\Imaging\2P345\20170817\ANM372320';
%     'Z:\Imaging\2P345\20170818\ANM372320';
%     'Z:\Imaging\2P345\20170820\ANM372320';
%     'Z:\Imaging\2P345\20170821\ANM372320';
%     'Z:\Imaging\2P345\20170822\ANM372320';
%     'Z:\Imaging\2P345\20170824\ANM372320';
%     'Z:\Imaging\2P345\20170826\ANM372320';
%     'Z:\Imaging\2P345\20170827\ANM372320';
%     'Z:\Imaging\2P345\20170828\ANM372320';
%     'Z:\Imaging\2P345\20170829\ANM372320';
%     'Z:\Imaging\2P345\20170830\ANM372320';
    'Z:\Imaging\2P345\20171011\ANM372321';
    'Z:\Imaging\2P345\20171012\ANM372321';
    'Z:\Imaging\2P345\20171013\ANM372321';
    'Z:\Imaging\2P345\20171017\ANM372321';
    'Z:\Imaging\2P345\20171019\ANM372321';
    'Z:\Imaging\2P345\20171020\ANM372321';
    'Z:\Imaging\2P345\20171021\ANM372321';
    'Z:\Imaging\2P345\20171022\ANM372321';
    'Z:\Imaging\2P345\20171023\ANM372321';
    'Z:\Imaging\2P345\20171026\ANM372321';
    'Z:\Imaging\2P345\20171027\ANM372321';
    'Z:\Imaging\2P345\20171028\ANM372321';
    'Z:\Imaging\2P345\20171029\ANM372321';
    'Z:\Imaging\2P345\20171030\ANM372321';
    'Z:\Imaging\2P345\20171101\ANM372321';
    'Z:\Imaging\2P345\20171103\ANM372321';
    'Z:\Imaging\2P345\20171104\ANM372321';
    'Z:\Imaging\2P345\20171105\ANM372321';
    'Z:\Imaging\2P345\20171106\ANM372321';
    'Z:\Imaging\2P345\20171107\ANM372321';
    'Z:\Imaging\2P345\20160812\ANM329296';
    'Z:\Imaging\2P345\20160813\ANM329296';
    'Z:\Imaging\2P345\20160815\ANM329296';
    'Z:\Imaging\2P345\20160822\ANM329296';
    'Z:\Imaging\2P345\20160823\ANM329296';
    'Z:\Imaging\2P345\20160824\ANM329296';
    'Z:\Imaging\2P345\20160825\ANM329296';
    'Z:\Imaging\2P345\20160826\ANM329296';
    'Z:\Imaging\2P345\20160827\ANM329296';
    'Z:\Imaging\2P345\20160829\ANM329296';
    'Z:\Imaging\2P345\20160830\ANM329296';
    'Z:\Imaging\2P345\20160831\ANM329296';
    };
      
strImgExp_SI = '(\d{5}).tif';
nColCount = 4;
strExp_Img = '_(\d{5})_Comb_C\d.tif';
strExp_Vid = '(\d{1,2})_ext.avi';

%%
nDirCount = length(clImgDirs);
clTiffFns_SI = cell(1,nDirCount);

for nDir =1:nDirCount
    clFns = FindFiles_RegExp(strImgExp_SI, clImgDirs{nDir}, false)';
    clFns = SortFnByCounter(clFns,strImgExp_SI);
    clTiffFns_SI(nDir) = {clFns};
end
%%
%clSel = {[5:15],[1 2 13 14],[1 2 14 15],[1 2 14 15],[1 2 13 14],[2 13 14],[1 2 7 8],[1 2 7 8]};
%%
for nDir = 1:nDirCount
    strImgDir = clImgDirs{nDir};
    clFns = clTiffFns_SI{nDir};
    vtSel = 1:length(clFns); %clSel{nDir};%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Imaging
%     for nFile = vtSel
%         strFn = clFns{nFile};
%         disp(['Processing file: ' strFn]);
%         try
%             [strDir_Sub,imgInfo] = SplitImages_SI_FastZ(strFn);
%             %         strDir_Sub = [strFn(1:end-4) '_S'];
%             if(imgInfo.bFastZ)
%                 strFn_Exp = ['_S(\d{1,2})_C' num2str(imgInfo.numChans) '.tif'];
%                 CombImgs_From_Sub(strDir_Sub,strFn_Exp,nColCount);
%                 strFn_Exp_Avg = ['_S(\d{1,2})_C' num2str(imgInfo.numChans) '_Avg.tif'];
%                 CombImgs_From_Sub(strDir_Sub,strFn_Exp_Avg,nColCount);
%             end
%         catch ME
%             disp(ME.message);
%         end
%     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%Video
    clDirParts = strsplit(strImgDir,filesep);
    strANMID = clDirParts{end};
    strDay = clDirParts{end-1};
    strVidDir = [strVidDir_P filesep strDay filesep strANMID];
    strEventDir = [strEventDir_P filesep strDay];
    
    clEventFiles = FindFiles_RegExp([strANMID '_(\d{2})\.evt'],strEventDir,false)';
    [clEventFiles,vtCounter_E] = SortFnByCounter(clEventFiles,[strANMID '_(\d{2})\.evt']);
    clFn_BehaVids = FindFiles_RegExp('Cam\S*_(\d{1,2})\.',strVidDir,false)';
    [clFn_BehaVids,vtCounter_B] = SortFnByCounter(clFn_BehaVids,'_(\d{1,2})\.');

    strEventFile_Rep = 'Y:\2P_Imaging\20160303\20160303\ANM287315\ANM287315_13.evt';
    stEvent_Rep = ParseEventFile_SJ(strEventFile_Rep);
    for nFile_E = 1:length(clEventFiles)
        strEventFile = clEventFiles{nFile_E};
        iCounter = vtCounter_E(nFile_E);
        strFn_ImgHdr = [strImgDir filesep strANMID '_' num2str(iCounter,'%05d') '_Header.mat'];
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
                            ExtractSyncBehavFrm_2P(strFn_BehaVid, stEvent,nFrm);
                        catch
                            warning(['Something wrong with file: ' strEventFile ' Replaced with file: ' strEventFile_Rep]);
                            ExtractSyncBehavFrm_2P(strFn_BehaVid, stEvent, nFrm,stEvent_Rep);
                        end
                    end
                end
            catch ME
                warning(ME.message);
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%Image-Video-Sync
%     fid = fopen([strImgDir '\VidImgLog.log'],'wt');
%     
%     clFns_Img = FindFiles_RegExp([strANMID strExp_Img], strImgDir, false)';
%     [clFns_Img,vtCounter_I] = SortFnByCounter(clFns_Img,strExp_Img);
%     
%     clFns_Vid = FindFiles_RegExp(strExp_Vid, strVidDir, false)';
%     [clFns_Vid,vtCounter_V] = SortFnByCounter(clFns_Vid,strExp_Vid);
%     
%     nFileCount = length(clFns_Img);
%     
%     for nFile = 1:nFileCount
%         strFn_Img = clFns_Img{nFile};
%         iCounter = vtCounter_I(nFile);
%         
%         idxCounter_V = find(vtCounter_V==iCounter);
%         if(~isempty(idxCounter_V))
%             fprintf(fid,'%s\n', strFn_Img);
%             for nV = 1:length(idxCounter_V)
%                 fprintf(fid,'%s\n', clFns_Vid{idxCounter_V(nV)});
%             end
%         end
%     end
%     
%     fclose(fid);
end
