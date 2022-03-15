% Combine the registered images of individual imaging planes into a big image file
% so that it can be easily examined simultaneously.
%
% Saintgene 2016
%%
%set the parameters in this cell. these parameters depend on the starage
%organization of your data.
initDir_CaRMA_Wiki();
global strDir_CaRMA_Wiki;

%the parent directory containing registered images to be combined
strImgDir_P = [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\ANM496190_visual_guidence'];
strImgDir_P = [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\ANM496191'];
strImgDir_P = [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\492241'];

%regular expression of the file names of subfolders to be combined
strImgSubDir_RE = '\\1211$';
strImgSubDir_RE = '\\1212$';
strImgSubDir_RE = '\\1213$';
strImgSubDir_RE = '\\D9$';

%regular expression of the file names of unregistered combined images
strImg_RE = '_(\d{5})_Comb_C\d\.tif$';

%the number of columns in the combined images
nColCount = 4;
%%
clImgDirs = FindSubDirs_RegExp(strImgSubDir_RE, strImgDir_P, true,2)';
nDC = length(clImgDirs);
for nDir = 1:nDC
    strImgDir = clImgDirs{nDir};
%     clANMIDs = regexp(strImgDir,'\\(ANM\d{6})\\','tokens');
%     clANMIDs = regexp(strImgDir,'\\(fastz\\','tokens');
%     strANMID = clANMIDs{1}{1};
%     strANMID = '496190_fastz';
%     strANMID = '496190obs_91dem_fastz';
%     strANMID = '496190_obsspout_fastZ';
%     strANMID = '496191_fastz';
%     strANMID = '496191obs_spoutdem_fastz';
%     strANMID = '496191_obs90_fastZ';
    strANMID = '492241_fastz';
    strANMID = '492241_saline2';
%     strANMID = '492241_social3';
%     strANMID = '496191obs_spoutdem_fastz';
%     strANMID = '496191_obs90_fastZ';

    clFns_Img = FindFiles_RegExp([strANMID strImg_RE], strImgDir, false)';
    
    nFileCount = 1:length(clFns_Img);
    for nFile = nFileCount
        strFn_Img = clFns_Img{nFile};
        [strPath,strFn] = fileparts(strFn_Img);
        clFnParts = strsplit(strFn,'_');
        
        % edit by zhenggang
        strCount = clFnParts{3};
%         strCount = clFnParts{4};
%         strCount = clFnParts{4};
        
        strCh = clFnParts{5};
%         strCh = clFnParts{6};
%         strCh = clFnParts{6};

        strDir_Img = [strImgDir filesep strANMID '_' strCount '_S'];
        strFn_Exp = ['_S(\d{1,2})_' strCh '_reg.tif'];
        [matImgStack,strFn_Avg_Sav] = CombImgs_From_Sub(strDir_Img, strFn_Exp, nColCount);
        
        
        
    end
    
end


%% merge max projection and generate 8p of reg images ZhenggangZhu 1/4/2022

% Batch_SplitImages_SI_FastZ_ZZG
