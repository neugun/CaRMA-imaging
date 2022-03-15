stPaths_G = Init_Cluster_GlobalPaths();

clDirs = {
    '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Z_stack/1211';};
clDirs = {
    '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Z_stack/1212';};
clDirs = {
    '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Z_stack/1213';};
clDirs = {
    '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496191/1213/Reg_Cat';};
clDirs = {
    '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/492241/D7/Reg_Cat';};

% fastZ    
% clFns_RE ={
%     'ANM378231_\S*_Avg(8P)|(_2X)\.tif$';
%     };
% clFns_RE ={
% '496190_\S*_Avg(8P)|(_Avg_2X_1211)\.tif$';
%     };
% clFns_RE ={
% '496190_\S*_Avg(8P)|(_Avg_2X_1212)\.tif$';
%     };
% clFns_RE ={
% '496190_\S*_Avg(8P)|(_Avg_2X)\.tif$';
%     };
% clFns_RE ={
% '496191_\S*_Avg(8P)|(_Avg_2X)\.tif$';
%     };

% between days
% clRef_sfx = {
% '496191_\S*_Avg(8P)|(_Avg_2X)\.tif$';
%     };
clFns_RE ={
'492241_\S*_Avg(8P)|(_Avg_2X)\.tif$';
    };

% stack
% clFns_RE = {  
%     '_Avg8P.tif';
%     };
clRef_sfx = {  
    '_Avg8P.tif';
    };

nDirCount = length(clDirs);

clTiffFns = cell(1,nDirCount);

%% FAST
for nDir =1:nDirCount
    strRegExp = clFns_RE{nDir};
    clTiffs = FindFiles_RegExp(strRegExp, clDirs{nDir}, false)';
    clTiffFns(nDir) = {clTiffs};
end    

%%

for nDir =1:nDirCount
    clTiffs = clTiffFns{nDir};
    nFileCount = length(clTiffs);
    idxStack = find(endsWith(clTiffs,clRef_sfx{nDir}));
    strImgFn_Stack = clTiffs{idxStack};
    vtFileIdx = setxor(1:nFileCount,idxStack);
    for nFile = vtFileIdx
        strImgFn_Fast = clTiffs{nFile};
        Cluster_Scripts_Reg_StackZ_FastZ(stPaths_G,strImgFn_Stack, strImgFn_Fast, true);
    end
end