strFn_Cluster = 'Z:\Imaging\2P345\20170826\ANM378231\Reg_Cat\Avg3_nbg_exclude\Results_CueOn2Cueoff_155-207_v2\NormRow_01\NeuronCluster_MN_PCA5_Dist.fig';
strFn_Results = 'Z:\Imaging\2P345\20170826\ANM378231\Reg_Cat\Avg3_nbg_exclude\Results_CueOn2Cueoff_155-207_v2\FC1_Results_20180410T065709.mat';
strDir_Sav = 'Z:\Imaging\2P345\20170826\ANM378231\Reg_Cat\Avg3_nbg_exclude\Results_CueOn2Cueoff_155-207_v2\Examples';

vEvents_F = [78,81,155,207,290];
vtEvents = [78,81,155,207,290]*3/7.75;
vtSel = (1:81)';%setxor(1:60,[7 18 19])';
idx = [3,13,22,31,49,58,81];
%{'Vglut2','Vglut2+Gad2','Crh-NE','Trh','Crh-nNE','Vglut2+Gad2+Npy1r','sst'}



load(strFn_Results,'clResps');
hFig_Res = openfig(strFn_Cluster,'invisible');
hImg = findobj(hFig_Res,'Type','Image');
idxOrder = get(hImg,'UserData');
close(hFig_Res);

idx0 = flipud(idxOrder(:));
idx1 = idx0(idx);
idx2= vtSel(idx1);

matResp = clResps{1};
matResp = matResp(idx2,:);
matResp_Norm = clResps{2};
matResp_Norm = matResp_Norm(idx2,:);
matResp_ROC = clResps{3};
matResp_ROC = matResp_ROC(idx2,:);

nNeuronCount = size(matResp,1);
nFrmCount_S = size(matResp,2);
nFrmCount_T = size(matResp_ROC,2);
nTrialCount = nFrmCount_S/nFrmCount_T;
matResp3 = reshape(matResp, nNeuronCount,nFrmCount_T,nTrialCount);
matResp_m = mean(matResp3,3);
matResp_sem = std(matResp3,0,3)/sqrt(nTrialCount);
%%
if(~exist(strDir_Sav,'dir'))
    mkdir(strDir_Sav);
end

for nI=1:nNeuronCount
    strDir_Sav_N = [strDir_Sav filesep 'N' num2str(idx(nI))];
    if(~exist(strDir_Sav_N,'dir'))
        mkdir(strDir_Sav_N);
    end
    matResp_T = squeeze(matResp3(nI,:,:));
    hFig = CompactPlotRes_2p(matResp_T,2.58,1:nTrialCount);
    set(hFig,'Name',['Trace_Neuron_' num2str(idx(nI))]);
    savefig(hFig,[strDir_Sav_N filesep 'Example_N' num2str(idx(nI)) '_' num2str(nTrialCount) '_Traces.fig']);
    close(hFig);
    hFig = figure('Name',['M-SEM_Neuron_' num2str(idx(nI))]);
    shadedErrorBar((1:nFrmCount_T)*3/7.75,matResp_m(nI,:),matResp_sem(nI,:));
    axis tight;
    hold on;
    for n=1:length(vtEvents)
        plot([vtEvents(n);vtEvents(n)],get(gca,'ylim')','k:','linewidth',2);
    end
    set(gca,'xtick',0:30:180);
    savefig(hFig,[strDir_Sav_N filesep 'Example_N' num2str(idx(nI)) '_MSEM.fig']);
    close(hFig);
    hFig = figure('Name',['auROC_Neuron_' num2str(idx(nI))]);
    plot(matResp_ROC(nI,:));
    savefig(hFig,[strDir_Sav_N filesep 'Example_N' num2str(idx(nI)) '_auROC.fig']);
    close(hFig);
end
%%
hFig = figure('Name','Resp_Raw');
PVH_imgPlotResp_FC1(matResp,1:length(idx2),vEvents_F);
hgsave(hFig,[strDir_Sav filesep 'Resp_Raw.fig']);
close(hFig);

hFig = figure('Name','Resp_Norm');
PVH_imgPlotResp_FC1(matResp_Norm,1:length(idx2),vEvents_F);
hgsave(hFig,[strDir_Sav filesep 'Resp_Norm.fig']);
close(hFig);

hFig = figure('Name','Resp_auROC');
PVH_imgPlotResp_FC1(matResp_ROC,1:length(idx2),vEvents_F);
hgsave(hFig,[strDir_Sav filesep 'Resp_auROC.fig']);
close(hFig);


