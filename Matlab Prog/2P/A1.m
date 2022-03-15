clFns_Resp = {'Z:\Imaging\2P345\20171106\ANM372321\Reg_Cat\Avg3_nbg\Resp_Correct.mat';
              'Z:\Imaging\2P345\20171107\ANM372321\Reg_Cat\Avg3_nbg\Resp_Correct.mat' };
clFns_States= {'Z:\Imaging\2P345\20171106\ANM372321\States.xlsx';
    'Z:\Imaging\2P345\20171107\ANM372321\States.xlsx'};

for nDir = 1:length(clFns_Resp)
    strFn_Resp = clFns_Resp{nDir};
    strFn_States= clFns_States{nDir};
    Resp_Ghrelin_Sessions_v5a(strFn_Resp,strFn_States);
end


%%
clDirs_Results_NC = {
'Z:\Imaging\2P345\20170826\ANM372320\Reg_Cat\Avg3_nbg\Results_Whole_1-450_Sel';
'Z:\Imaging\2P345\20170826\ANM372320\Reg_Cat\Avg3_nbg\Results_S2Retract_1-290_Sel';
'Z:\Imaging\2P345\20170820\ANM372320\Reg_Cat\Avg3_nbg\Results_1-600_Sel';
'Z:\Imaging\2P345\20170821\ANM372320\Reg_Cat\Avg3_nbg\Results_1-600_Sel';
'Z:\Imaging\2P345\20170828\ANM372320\Reg_Cat\Avg3_nbg\Results_1-2700_Sel';
'Z:\Imaging\2P345\20170829\ANM372320\Reg_Cat\Avg3_nbg\Results_1-3150_Sel';
'Z:\Imaging\2P345\20170830\ANM372320\Reg_Cat\Avg3_nbg\Results_1-3600_Sel';
};
for nDir = 1:length(clDirs_Results_NC)
    strDir_Results_NC = clDirs_Results_NC{nDir};
    FISH_ClusterByResp_v2a(strDir_Results_NC);
    close all;
end

%%
clCmds_ANM378231 = {
    'Z:\Imaging\2P345\20170820\ANM378231\Reg_Cat\Avg3_nbg\Resp_Feed_Sessions_v4_ANM378231_20170820.m';
    'Z:\Imaging\2P345\20170821\ANM378231\Reg_Cat\Avg3_nbg\Resp_Feed_Sessions_v4_ANM378231_20170821.m';
    'Z:\Imaging\2P345\20170826\ANM378231\Reg_Cat\Avg3_nbg_exclude\Resp_FC_Sessions_v4_ANM378231_20170826.m';
    'Z:\Imaging\2P345\20170828\ANM378231\Reg_Cat\Avg3_nbg\Resp_Ghrelin_Sessions_v5_ANM378231_20170828.m';
    'Z:\Imaging\2P345\20170829\ANM378231\Reg_Cat\Avg3_nbg\Resp_Saline_Sessions_v5_ANM378231_20170829.m';
    'Z:\Imaging\2P345\20170830\ANM378231\Reg_Cat\Avg3_nbg\Resp_Leptin_Sessions_v5_ANM378231_20170830.m'};

%%
clCmds = {
    'Z:\Imaging\2P345\20171105\ANM372321\Reg_Cat\Avg3_nbg\Resp_Ghrelin_Sessions_v5_ANM372321_20171105.m';
    'Z:\Imaging\2P345\20171107\ANM372321\Reg_Cat\Avg3_nbg\Resp_Leptin_Sessions_v5_ANM372321_20171107.m';
    'Z:\Imaging\2P345\20170830\ANM372320\Reg_Cat\Avg3_nbg\Resp_Leptin_Sessions_v5_ANM372320_20170830.m';
    'Z:\Imaging\2P345\20170829\ANM372320\Reg_Cat\Avg3_nbg\Resp_Saline_Sessions_v5_ANM372320_20170829.m';
    'Z:\Imaging\2P345\20170828\ANM372320\Reg_Cat\Avg3_nbg\Resp_Ghrelin_Sessions_v5_ANM372320_20170828.m';
    };
