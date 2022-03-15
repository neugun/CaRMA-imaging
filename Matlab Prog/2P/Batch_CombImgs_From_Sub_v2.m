strImgDir_P = 'Z:\Imaging\2P345\20171103';
strExp_ImgDir_S = '\\ANM372321';
strExp_Img = '_(\d{5})_Comb_C\d_reg.tif';

nColCount = 4;

clImgDirs = FindSubDirs_RegExp(strExp_ImgDir_S, strImgDir_P, true,2)';
%%
for nDir = 1:length(clImgDirs)
    strImgDir = clImgDirs{nDir};
    clImgDirParts = strsplit(strImgDir,filesep);
 %   strANMID = clImgDirParts{end-1};
 %   clFns_Img = FindFiles_RegExp([strANMID strExp_Img], strImgDir, false)';
    clFns_Img = FindFiles_RegExp(strExp_Img, strImgDir, false)';
    nFileCount = length(clFns_Img);
    for nFile = 2:nFileCount
        strFn_Img = clFns_Img{nFile};
        %if(~exist([strFn_Img(1:end-4) '_reg.tif'],'file'))
            [strPath,strFn] = fileparts(strFn_Img);
            clFnParts = strsplit(strFn,'_');
            strANMID = clFnParts{1};
            strCount = clFnParts{2};
            strCh = clFnParts{4};
            strDir_Img = [strImgDir filesep strANMID '_' strCount '_S'];
            strFn_Exp = ['_S(\d{1,2})_' strCh '_reg.tif'];
            CombImgs_From_Sub(strDir_Img,strFn_Exp,nColCount);
      %  end
    end
    
end