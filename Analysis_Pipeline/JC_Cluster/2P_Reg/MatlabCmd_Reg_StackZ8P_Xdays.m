stPaths_G = Init_Cluster_GlobalPaths();

% clDirs = {
%     '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/2P_Imaging/new';
%     };
%     
% clFns_RE ={
%     'ANM494024_PIEZO_fastz_00006_S\S*_Avg8P_\S*.tif$';
%     };
% 
% clRef_sfx = {
%     '_Avg8P_Ghrelin.tif';
%     };

% clDirs = {
%     '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/ExVivo_InVivo_Reg/Reg/ZStack_FastZ_Reg';};
% clDirs = {
%     '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Reg_Cat/Acrossdays';};
% clDirs = {
%     '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496191/1213/Reg_Cat/Acrossdays';};
clDirs = {
    '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/492241/D9/Reg_Cat/Acrossdays';};

% fastZ    1211
% clFns_RE ={
% '496190_\S*(_Avg_fixed)|(_Avg_moving)\.tif$';
%     };
clFns_RE ={
'496191_\S*(_Avg_fixed)|(_Avg_moving)\.tif$';
    };
clFns_RE ={
'492241_\S*(_Avg_fixed)|(_Avg_moving)\.tif$';
    };

% % slowZ stack
% clRef_sfx = {  
%     '_Avg_2X_1211.tif';
%     };
% clRef_sfx = {  
%     '_Avg_2X_1212.tif';
%     };

% slowZ stack
clRef_sfx = {  
    '_Avg_moving.tif';
    };

nDirCount = length(clDirs);

clTiffFns = cell(1,nDirCount);

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