strDir = 'Y:\RNAScope\Nuc_seg_problems\Seg';
strExp = '_watershed.tif';
szDes = [1024 1024];
clFns = FindFiles_RegExp(strExp, strDir, true,2)';
nFileCount = length(clFns);
for nFile = 1:nFileCount
    strFn_L = clFns{nFile};
    disp(['Processing file: ' strFn_L]);
    img_L = readTiffStack_IJ(strFn_L);
    img_LS = imresize(img_L, szDes,'Antialiasing', true,'Method', 'nearest');
    strFn_Sav = [strFn_L(1:end-4) '_S.tif'];
    writeTiffStack_IJ(img_LS,strFn_Sav);
end