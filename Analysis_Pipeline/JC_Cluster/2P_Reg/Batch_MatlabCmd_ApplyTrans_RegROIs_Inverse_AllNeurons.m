% clDirs = {
%     '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Z_stack/1211/2p_ROIs_1211';
% };
% clDirs = {
%     '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Z_stack/1212/2p_ROIs_1212';
% };
clDirs = {
    '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1212/Reg_Cat/ROIs_Reg';
};
% clDirs = {
%     '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496191/1213/Reg_Cat/ROIs_Reg';
% };
clDirs = {
    '/groups/sternson/sternsonlab/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/492241/D1/Reg_Cat/ROIs_Reg';
};
nDC = length(clDirs);

for nD=1:nDC
    strDir_ROIs = clDirs{nD};
    strDir_P = fileparts(strDir_ROIs);
%     clFn = FindFiles_RegExp('_reg_Avg.tif', strDir_P, false)';
    clFn = FindFiles_RegExp('_reg_Avg.tif', strDir_P, false)';
%     clDns = FindSubDirs_RegExp('_Comb_C1_reg_Avg_2X/ImgSeq', strDir_P,true,2)';
%     clDns = FindSubDirs_RegExp('_Comb_C1_reg_Avg/ImgSeq', strDir_P,true,2)';
%     clFn = FindFiles_RegExp('_reg_Avg_1212.tif', strDir_P, false)';
%     clDns = FindSubDirs_RegExp('_Comb_C1_reg_Avg_2X_1212/ImgSeq', strDir_P,true,2)';
%         clFn = FindFiles_RegExp('_reg_Avg.tif', strDir_P, false)';
    clDns = FindSubDirs_RegExp('Avg_2X/ImgSeq', strDir_P,true,2)';
%     
    strFn_Ref= clFn{1};
    strDir_Trans = clDns{1};
    bSave = false;
    disp('Processing file:');
    disp(strDir_ROIs);
    disp(strFn_Ref);
    disp(strDir_Trans);
    MatlabCmd_ApplyTrans_RegROIs_Inverse_AllNeurons(strDir_ROIs,strFn_Ref,strDir_Trans,bSave);
end
