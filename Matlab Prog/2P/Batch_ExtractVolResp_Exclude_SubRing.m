clDirs = {
    'Z:\Imaging\2P345\20170826\ANM372320\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170826\ANM378231\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170828\ANM372320\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170828\ANM378231\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170829\ANM372320\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170829\ANM378231\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170830\ANM372320\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170830\ANM378231\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170820\ANM372320\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170820\ANM378231\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170821\ANM372320\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20170821\ANM378231\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20171103\ANM372321\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20171105\ANM372321\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20171106\ANM372321\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20171107\ANM372321\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20171030\ANM372321\Reg_Cat\Avg3';
    'Z:\Imaging\2P345\20171027\ANM372321\Reg_Cat\Avg3';
    };

nDC = length(clDirs);
strFn_RgExp_Resp = '_S(\d)_C\d\.tif$';
iRing = 2;


%%
tic
parfor nD = 1:nDC
    strDir = clDirs{nD};
    disp(['Processing folder: ' strDir]);
    clROIs = FindFiles_RegExp('ROIs_reg.tif$', strDir, false);
    strFn_ROIs = clROIs{1};
    ExtractVOlResp_Exclude_SubRing(strFn_ROIs,strDir,strFn_RgExp_Resp,iRing);
end
toc
datestr(now);