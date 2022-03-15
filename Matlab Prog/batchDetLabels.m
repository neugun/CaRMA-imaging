strDir = '\\tier2\sternson\Trace2SJ\Erosion_tests';
strExp = '_watershed.tif';
clFns = FindFiles_RegExp(strExp, strDir, true,2)';
nFileCount = length(clFns);
for nFile = 1:nFileCount
    strFn_L = clFns{nFile};
    disp(['Processing file: ' strFn_L]);
    strFn_LD = [strFn_L(1:end-4) '_D.tif'];
    if(exist(strFn_LD,'file'))
        DetLabels_v2(strFn_L,strFn_LD);
    end
    strFn_LE = [strFn_L(1:end-4) '_E.tif'];
    if(exist(strFn_LE,'file'))
        DetLabels_v2(strFn_L,strFn_LE,'E');
    end
end