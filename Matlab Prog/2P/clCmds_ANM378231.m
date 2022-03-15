clFns_Script_ANM378231 = {
    'Z:\Imaging\2P345\20170820\ANM378231\Reg_Cat\Avg3_nbg\Resp_Feed_Sessions_v4_ANM378231_20170820.m';
    'Z:\Imaging\2P345\20170821\ANM378231\Reg_Cat\Avg3_nbg\Resp_Drink_Sessions_v4_ANM378231_20170821.m';
    'Z:\Imaging\2P345\20170826\ANM378231\Reg_Cat\Avg3_nbg_exclude\Resp_FC_Sessions_v4_ANM378231_20170826.m';
    'Z:\Imaging\2P345\20170828\ANM378231\Reg_Cat\Avg3_nbg\Resp_Ghrelin_Sessions_v5_ANM378231_20170828.m';
    'Z:\Imaging\2P345\20170829\ANM378231\Reg_Cat\Avg3_nbg\Resp_Saline_Sessions_v5_ANM378231_20170829.m';
    'Z:\Imaging\2P345\20170830\ANM378231\Reg_Cat\Avg3_nbg\Resp_Leptin_Sessions_v5_ANM378231_20170830.m'};

for nCmd=1:length(clFns_Script_ANM378231)
    clearvars -except clFns_Script_ANM378231 nCmd
    strCmd = clFns_Script_ANM378231{nCmd};
    run(strCmd);
end