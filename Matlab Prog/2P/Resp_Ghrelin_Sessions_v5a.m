function Resp_Ghrelin_Sessions_v5a(strFn_Resp,strFn_States)
if nargin == 0
    strFn_Resp = 'Z:\Imaging\2P345\20171105\ANM372321\Reg_Cat\Avg3_nbg\Resp.mat';
    strFn_States='Z:\Imaging\2P345\20171105\ANM372321\States.xlsx';
end

load(strFn_Resp);
[strPath,strFn] = fileparts(strFn_Resp);
%%nNeuronCount = size(matResp,1);

AvgFrm = 3;
vtEvents = [ 451 901 1351 1801 2251 2701 3151 3601 4051];
idxTN_Rg =[551 750];
nTrialCount = 1;
szBin= 20;
%%
% matResp = NormMatRow(matResp);
clResps(1) = {matResp};
clResps(2) = {NormMatRow(matResp)};
clResps(3) = {NormResROC(matResp,idxTN_Rg,nTrialCount,szBin)};
%%
idx_rg_c = 1:4500; % do functional clustering according to the temporal responses within this range
dColorThresh = 0.4;
strPath_Results = [strPath '\Results_Corrected_' num2str(idx_rg_c(1)) '-' num2str(idx_rg_c(end))];
if(~exist(strPath_Results,'dir'))
    mkdir(strPath_Results);
end
clResultTypes = {'Raw','NormRow_01','NormROC'};
%%
vtSel = 1:134;%setxor(1:60,[7 18 19])';
nNeuronCount = length(vtSel);
for nType = 1:length(clResultTypes)
    strResultType = clResultTypes{nType};
    strDir_Sav = [strPath_Results filesep strResultType];
    if(~exist(strDir_Sav,'dir'))
        mkdir(strDir_Sav);
    end
    
    matResp_C = clResps{nType};
    matResp_C = matResp_C(vtSel,:);
    hFig = figure('Name',['Resp_' strResultType]);
    PVH_imgPlotResp_FC1(matResp_C,1:nNeuronCount,vtEvents);
    hgsave(hFig,[strDir_Sav filesep 'Resp.fig']);
    close(hFig);
    
    maxResp = max(matResp_C,[],2);
    [~,idxOrder] = sort(maxResp, 'descend');
    hFig = figure('Name',['RespSorted_' strResultType]);
    PVH_imgPlotResp_FC1(matResp_C,idxOrder,vtEvents);
    hgsave(hFig,[strDir_Sav filesep 'RespSorted.fig']);
    close(hFig);
    
    if(nType ==3)
        matResp_mn = matResp_C;
        bROC = true;
    else
        bROC = false;
        stResp_States = PVH_getResp_States_Ghrelin(strFn_States,matResp_C,AvgFrm);
        X = stResp_States.matResp_States_Avg;
        Y = pdist(X');
        Z = linkage(Y);
        hFig = figure('Name',['StatesCluster_Dist_' strResultType]);
        dendrogram(Z,'Labels',strrep(stResp_States.clStates,'_','\_'));
        hgsave(hFig,[strDir_Sav filesep 'StatesCluster_Dist.fig']);
        close(hFig);
        
        Y = pdist(X','correlation');
        Z = linkage(Y);
        hFig = figure('Name',['StatesCluster_Corr_' strResultType]);
        dendrogram(Z,'Labels',strrep(stResp_States.clStates,'_','\_'));
        hgsave(hFig,[strDir_Sav filesep 'StatesCluster_Corr.fig']);
        close(hFig);
        
        matResp_m = stResp_States.matResp_m;
        hFig = figure('Name',['AvgResp_' strResultType]);
        PVH_imgPlotResp_FC1(matResp_m,1:nNeuronCount,vtEvents);
        hgsave(hFig,[strDir_Sav filesep 'AvgResp.fig']);
        close(hFig);
        
        maxResp = max(matResp_m,[],2);
        [~,idxOrder] = sort(maxResp, 'descend');
        hFig = figure('Name',['AvgRespSorted_' strResultType]);
        PVH_imgPlotResp_FC1(matResp_m,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'AvgRespSorted.fig']);
        close(hFig);
        
        matResp_mn = NormMatRow(matResp_m);
        hFig = figure('Name',['NormAvgResp_' strResultType]);
        PVH_imgPlotResp_FC1(matResp_mn,1:nNeuronCount,vtEvents);
        hgsave(hFig,[strDir_Sav filesep 'NormAvgResp.fig']);
        close(hFig);
        if(nType == 1)
            matResp_mn01 = matResp_mn;
        end
        
        hFig = figure('Name',['NormAvgRespSorted_'  strResultType]);
        PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NormAvgRespSorted.fig']);
        close(hFig);
        
        Var = [stResp_States.matResp_States_Avg stResp_States.matResp_Diff_Avg];
        hFig = figure('Name',['Var_'  strResultType]);
        imagesc(Var);
        hgsave(hFig,[strDir_Sav filesep 'Var.fig']);
        close(hFig);
        
        [~,score,~] = pca(Var);
        score_s = score(:,1:3);
        
        hFig = figure('Name',['Var_PCA3_'  strResultType]);
        imagesc(score_s);
        hgsave(hFig,[strDir_Sav filesep 'Var_PCA3.fig']);
        close(hFig);
        
        nCCount = 4;
        idxKm = kmeans(score_s,nCCount);
        clr = hsv(nCCount);
        hFig = figure('Name',['NeuronCluster_km_'  strResultType]);
        for nC=1:nCCount
            idxn=idxKm==nC;
            scatter3(score_s(idxn,1),score_s(idxn,2),score_s(idxn,3),4,clr(nC,:),'markerfacecolor','flat')
            hold on;
        end
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_km.fig']);
        close(hFig);
        
        [~,idxOrder] = sort(idxKm);
        hFig = figure('Name',['NormAvgResp_km_'  strResultType]);
        PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NormAvgResp_km.fig']);
        close(hFig);
        
        hFig = figure('Name',['Var_Dist_'  strResultType]);
        Y=pdist(Var);
        Z = linkage(Y,'average');
        subplot(1,2,1);
        idxOrder = resp_dendrogram(Z,nNeuronCount,dColorThresh);
        
        subplot(1,2,2)
        PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_Var_Dist.fig']);
        close(hFig);
        
        hFig = figure('Name',['Var_Corr_' strResultType]);
        Y=pdist(Var,'correlation');
        Z = linkage(Y,'average');
        subplot(1,2,1);
        idxOrder = resp_dendrogram(Z,nNeuronCount,dColorThresh);
        
        subplot(1,2,2);
        PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_Var_Corr.fig']);
        close(hFig);
        
        hFig = figure('Name',['Var_PCA3_Dist_' strResultType]);
        Y=pdist(score_s);
        Z = linkage(Y,'average');
        subplot(1,2,1);
        idxOrder = resp_dendrogram(Z,nNeuronCount,dColorThresh);
        
        subplot(1,2,2);
        PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_Var_PCA3_Dist.fig']);
        close(hFig);
        
        hFig = figure('Name',['Var_PCA3_Corr_' strResultType]);
        Y=pdist(score_s,'correlation');
        Z = linkage(Y,'average');
        subplot(1,2,1);
        idxOrder = resp_dendrogram(Z,nNeuronCount,dColorThresh);
        
        subplot(1,2,2);
        PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_Var_PCA3_Corr.fig']);
        close(hFig);
    end
    
    matResp_mn_c = matResp_mn(:,idx_rg_c);
    hFig = figure('Name',['MN_Dist_' strResultType]);
    Y=pdist(matResp_mn_c);
    Z = linkage(Y,'average');
    subplot(1,2,1);
    idxOrder = resp_dendrogram(Z,nNeuronCount,dColorThresh);
    
    subplot(1,2,2);
    PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
    hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_Dist.fig']);
    close(hFig);
    
    hFig = figure('Name',['MN_Corr_' strResultType]);
    Y=pdist(matResp_mn_c,'correlation');
    Z = linkage(Y,'average');
    subplot(1,2,1);
    idxOrder = resp_dendrogram(Z,nNeuronCount,dColorThresh);
    
    subplot(1,2,2);
    PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
    hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_Corr.fig']);
    close(hFig);
    
    [~,score,~,~,explained] = pca(matResp_mn_c);
    residual = 100-cumsum([0;explained]);
    hFig = figure('Name','PCA-Residual');
    plot(residual,'r-O');
    hgsave(hFig,[strDir_Sav filesep 'MN_PCA_Residual.fig']);
    close(hFig);
    
    for nSel = 3:6
        score_s= score(:,1:nSel);
        hFig = figure('Name',['MN_PCA' num2str(nSel) '_' strResultType]);
        imagesc(score_s);
        hgsave(hFig,[strDir_Sav filesep 'MN_PCA' num2str(nSel) '.fig']);
        close(hFig);
        
        hFig = figure('Name',['MN_PCA' num2str(nSel) '_Dist_' strResultType]);
        Y=pdist(score_s);
        Z = linkage(Y,'average');
        idxOrder = optimalleaforder(Z,Y);
        subplot(1,2,1);
        dendrogram(Z,0,'Orientation','left','ColorThreshold','default','reOrder',idxOrder );
        
        subplot(1,2,2);
        PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_PCA' num2str(nSel) '_Dist.fig']);
        close(hFig);
        
        hFig = figure('Name',['MN_PCA' num2str(nSel) '_Corr_' strResultType]);
        Y=pdist(score_s,'correlation');
        Z = linkage(Y,'average');
        idxOrder = optimalleaforder(Z,Y);
        subplot(1,2,1);
        resp_dendrogram(Z,nNeuronCount,dColorThresh,idxOrder);
        
        subplot(1,2,2);
        PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_PCA' num2str(nSel) '_Corr.fig']);
        close(hFig);
    end
    
    if(nType ==3)
        bROC = false;
        hFig = figure('Name',['MN_Dist_N01_' strResultType]);
        Y=pdist(matResp_mn_c);
        Z = linkage(Y,'average');
        subplot(1,2,1);
        idxOrder = resp_dendrogram(Z,nNeuronCount,dColorThresh);
        
        subplot(1,2,2);
        PVH_imgPlotResp_FC1(matResp_mn01,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_Dist_N01.fig']);
        close(hFig);
        
        hFig = figure('Name',['MN_Corr_N01_' strResultType]);
        Y=pdist(matResp_mn_c,'correlation');
        Z = linkage(Y,'average');
        subplot(1,2,1);
        idxOrder = resp_dendrogram(Z,nNeuronCount,dColorThresh);
        
        subplot(1,2,2);
        PVH_imgPlotResp_FC1(matResp_mn01,idxOrder,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_Corr_N01.fig']);
        close(hFig);
        
        for nSel = 3:6
            score_s= score(:,1:nSel);
            hFig = figure('Name',['MN_PCA' num2str(nSel) '_Dist_N01_' strResultType]);
            Y=pdist(score_s);
            Z = linkage(Y,'average');
            idxOrder = optimalleaforder(Z,Y);
            subplot(1,2,1);
            resp_dendrogram(Z,nNeuronCount,dColorThresh,idxOrder);
            
            subplot(1,2,2);
            PVH_imgPlotResp_FC1(matResp_mn01,idxOrder,vtEvents,bROC);
            hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_PCA' num2str(nSel) '_Dist_N01.fig']);
            close(hFig);
            
            hFig = figure('Name',['MN_PCA' num2str(nSel) '_Corr_N01_' strResultType]);
            Y=pdist(score_s,'correlation');
            Z = linkage(Y,'average');
            idxOrder = optimalleaforder(Z,Y);
            subplot(1,2,1);
            resp_dendrogram(Z,nNeuronCount,dColorThresh,idxOrder);
            
            subplot(1,2,2);
            PVH_imgPlotResp_FC1(matResp_mn01,idxOrder,vtEvents,bROC);
            hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_PCA' num2str(nSel) '_Corr_N01.fig']);
            close(hFig);
        end
    end
end
%%
save([strPath_Results filesep 'Ghrelin1_Results_' datestr(datetime('now'),30) '.mat']);