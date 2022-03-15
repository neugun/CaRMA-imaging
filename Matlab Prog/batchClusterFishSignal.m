strDir = 'Y:\RNAScope\Satb2_Examples_for_Analysis';
strExp = '_watershed_Df_S_Stats_Sig.mat';
clFns = FindFiles_RegExp(strExp, strDir, true,4)';
clChID = {'Satb2','vgat','vglut'};
nFileCount = length(clFns);
for nFile = 1:nFileCount
    strFn_L = clFns{nFile};
    disp(['Processing file: ' strFn_L]);
    ClusterFishSignal(strFn_L,clChID);
end