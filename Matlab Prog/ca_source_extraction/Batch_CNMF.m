clReg_Crop_Files =FindFiles_RegExp('_C1\.tif','Z:\2P_Analyze\ANM318142\20160819_2\Reg_Cat\Avg3_3',true,2)';
vtTau = linspace(4,2,8);
%%
for nFile = 1:length(clReg_Crop_Files)
    clearvars -except clReg_Crop_Files nFile vtTau;
    clc; close all;  
    strFn = clReg_Crop_Files{nFile};
    tau = vtTau(nFile);
    disp(['Processing File: ' strFn]);
    Ts = tic;
    my_demo_script_class;
    disp(['Total elapsed time: ' num2str(toc (Ts)) 'Seconds']);
end