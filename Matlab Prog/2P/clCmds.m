clCmds0 = {
    'Z:\Imaging\2P345\20171105\ANM372321\Reg_Cat\Avg3_nbg\Resp_Ghrelin_Sessions_v5_ANM372321_20171105.m';
    'Z:\Imaging\2P345\20171107\ANM372321\Reg_Cat\Avg3_nbg\Resp_Leptin_Sessions_v5_ANM372321_20171107.m';
    'Z:\Imaging\2P345\20170830\ANM372320\Reg_Cat\Avg3_nbg\Resp_Leptin_Sessions_v5_ANM372320_20170830.m';
    'Z:\Imaging\2P345\20170829\ANM372320\Reg_Cat\Avg3_nbg\Resp_Saline_Sessions_v5_ANM372320_20170829.m';
    'Z:\Imaging\2P345\20170828\ANM372320\Reg_Cat\Avg3_nbg\Resp_Ghrelin_Sessions_v5_ANM372320_20170828.m';
    };

for nCmd=1:length(clCmds0)
    clearvars -except clCmds0 nCmd
    strCmd = clCmds0{nCmd};
    run(strCmd);
end