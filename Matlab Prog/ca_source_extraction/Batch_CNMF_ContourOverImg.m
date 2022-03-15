strDir = 'Z:\2P_Analyze\ANM318142\20160819_2\Reg_Cat\Avg3_3';
clFn_Max = FindFiles_RegExp('_Max-Avg.tif', strDir, true)';
%%
for nFile = 1:length(clFn_Max)
    strFn_Max = clFn_Max{nFile};
    [strP,strFn]=fileparts(strFn_Max);
    strFn_CNMF_Res = [strP filesep strFn(1:end-8) '_Results.mat'];
    disp(['Reading file: ' strFn_Max]);
    tic
    movm = imread(strFn_Max);
    toc
    disp(['Loading File: ' strFn_CNMF_Res]);
    load(strFn_CNMF_Res,'Neuron');
    hFig = figure;
    Neuron.viewContours(0.95, 1);
    strFn_FigSav = [strFn_Max(1:end-4) '_Contour_CorrImg.fig'];
    hgsave(hFig,strFn_FigSav);
    close(hFig);
    hFig = cnmfe_plot_contour_over_img(Neuron,movm);
    strFn_FigSav = [strFn_Max(1:end-4) '_Contour_Max-Avg.fig'];
    hgsave(hFig,strFn_FigSav);
    close(hFig);
end