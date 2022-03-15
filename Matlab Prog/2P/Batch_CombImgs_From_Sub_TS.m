strImgDir_P = 'Z:\Imaging\Trace_Sabine';
strExp_ImgDir_S = '\\(CEA$)|(LHA$)';
strExp_Img = '_(\d{5})_Comb_C\d.tif';

nColCount = 4;

clImgDirs = FindSubDirs_RegExp(strExp_ImgDir_S, strImgDir_P, true,2)';
%%
for nDir = 1:length(clImgDirs)
    strImgDir = clImgDirs{nDir};
%     clImgDirParts = strsplit(strImgDir,filesep);
%     strANMID = clImgDirParts{end};
    clFns_Img = FindFiles_RegExp(strExp_Img, strImgDir, false)';
    
    nFileCount = 1:length(clFns_Img);
    for nFile = nFileCount
        strFn_Img = clFns_Img{nFile};
        %if(~exist([strFn_Img(1:end-4) '_reg.tif'],'file'))
            [strPath,strFn] = fileparts(strFn_Img);
            clFnParts = strsplit(strFn,'_');
            strCh = clFnParts{end};
            strDir_Img = [strImgDir filesep strjoin({clFnParts{1:end-2},'S'},'_')];
            strFn_Exp = ['_S(\d{1,2})_' strCh '_reg.tif'];
            CombImgs_From_Sub(strDir_Img,strFn_Exp,nColCount);
      %  end
    end
    
end