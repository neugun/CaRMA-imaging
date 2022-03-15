strDir = 'Z:\PVH_Analysis\Resp_All\Pool';
strDir_Sav = 'Z:\PVH_Analysis\Cluster_By_Resp';

clFns = FindFiles_RegExp('mat$', strDir, false)';

for nFile = 1:length(clFns)
    strFn = clFns{nFile};
    [~,Fn]= fileparts(strFn);
    clFnt = split(Fn,'_');
    strBehav = clFnt{1};
    Cluster_Resp_Pool(strFn,strBehav,strDir_Sav);
end