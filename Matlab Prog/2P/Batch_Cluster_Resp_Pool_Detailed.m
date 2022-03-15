strDir = 'Z:\PVH_Analysis\Resp_All\Pool';
strDir_Sav = 'Z:\PVH_Analysis\Cluster_By_Resp_Detailed_M1';

clFns = {
%          'Z:\PVH_Analysis\Resp_All\Pool\Fear_Resp_Pool.mat';
         'Z:\PVH_Analysis\Resp_All\Pool\Fear_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Fear_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Fear_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Feeding_Resp_Pool_v3.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Feeding_Resp_Pool_v3.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Drinking_Resp_Pool_v3.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Drinking_Resp_Pool_v3.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Ghrelin_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Ghrelin_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Ghrelin_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Saline_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Saline_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Saline_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Leptin_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Leptin_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Leptin_Resp_Pool.mat';
%          'Z:\PVH_Analysis\Resp_All\Pool\Leptin_Resp_Pool.mat';
         };
clBehav = {
%            'Fear';
           'Fear';
%            'Fear';
%            'Fear';
%            'Feeding';
%            'Feeding';
%            'Drinking';
%            'Drinking';
%            'Ghrelin';
%            'Ghrelin';
%            'Ghrelin';
%            'Saline';
%            'Saline';
%            'Saline';
%            'Leptin';
%            'Leptin';
%            'Leptin';
%            'Leptin';
            };
clIdx_Rg_C = {
%               78:155;
              160:200;
%               208:290;
%               291:450;
%               156:245;
%               246:450;
%               156:181;
%               182:450;
%               451:900;
%               901:2700;
%               1351:2700;
%               451:900;
%               901:2700;
%               1351:2700;
%               451:900;
%               901:3600;
%               1351:3600;
%               1801:3600;
              };

for nFile = 1:length(clFns)
    strFn = clFns{nFile};
    strBehav = clBehav{nFile};
    idx_rg_c = clIdx_Rg_C{nFile};
    Cluster_Resp_Pool(strFn,strBehav,strDir_Sav,idx_rg_c);
end

% Cluster_FISH_By_Resp_All