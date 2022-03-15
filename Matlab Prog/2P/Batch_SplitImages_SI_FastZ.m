strDir = 'Z:\Imaging\2P345\20170803\ANM372320';
strExp = '\d{5}.tif';
 strFn_Exp = '_S(\d{1,2})_C1.tif';
nColCount = 4;
clFns = FindFiles_RegExp(strExp, strDir, false)';
nFileCount = length(clFns);
for nFile = 1:nFileCount
    strFn = clFns{nFile};
    disp(['Processing file: ' strFn]);
    strDir_Sub = SplitImages_SI_FastZ(strFn);
    CombImgs_From_Sub(strDir_Sub,strFn_Exp,nColCount)
end
