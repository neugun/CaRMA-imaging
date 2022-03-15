function Cluster_Resp_Pool(strFn,strBehav,strDir_Sav,idx_rg_c)
if(nargin ==0)
    strFn = 'Z:\PVH_Analysis\Resp_All\Pool\Fear_Resp_Pool.mat';
    strBehav = 'Fear';
    strDir_Sav = 'Z:\PVH_Analysis\Cluster_By_Resp';
end
vtPCA_Sel = 3:6;
%%
load(strFn);
vtEvents = stResp_Pool.vtEvents;
nFrmCount = size(stResp_Pool.Raw(:,3:end),2);
if(nargin <3)
    idx_rg_c = 1:nFrmCount; % do functional clustering according to the temporal responses within this range
end
dColorThresh = 0.5;
%%
strPath_Results = [strDir_Sav '\Results_' strBehav '_' num2str(idx_rg_c(1)) '-' num2str(idx_rg_c(end)) '_Sel'];
if(~exist(strPath_Results,'dir'))
    mkdir(strPath_Results);
end
clResTypes = {'N01','ROC'};
clDistTypes = {'Dist','Corr'};
for nResType = 1:length(clResTypes)
    strResultType = clResTypes{nResType};
    strDir_Sav = [strPath_Results filesep strResultType];
    if(~exist(strDir_Sav,'dir'))
        mkdir(strDir_Sav);
    end
    
    matResp_mn = stResp_Pool.(strResultType)(:,3:end);
    vtID = stResp_Pool.(strResultType)(:,1);
    matResp_mn_c = matResp_mn(:,idx_rg_c);
    
    [~,score,~,~,explained] = pca(matResp_mn_c);
    residual = 100-cumsum([0;explained]);
    hFig = figure('Name',['PCA_Residual_' strResultType '_' strBehav]);
    plot(residual,'r-O');
    hgsave(hFig,[strDir_Sav filesep 'MN_PCA_Residual.fig']);
    close(hFig);
    
    for nSel = vtPCA_Sel
        score_s= score(:,1:nSel);
        hFig = figure('Name',['MN_PCA' num2str(nSel) '_' strResultType '_' strBehav]);
        imagesc(score_s);
        set(gca,'ydir','normal');
        hgsave(hFig,[strDir_Sav filesep 'MN_PCA' num2str(nSel) '_' strResultType '_' strBehav '.fig']);
        close(hFig)
    end
    
    for nDistType = 1:length(clDistTypes )
        strDistType = clDistTypes{nDistType};
        
        bROC = strcmp(strResultType,'ROC');
        
        switch(strDistType)
            case 'Dist'
                strDist = 'euclidean';
            case 'Corr'
                strDist = 'correlation';
            otherwise
                strDist = 'euclidean';
        end
        
        hFig = figure('Name',['MN_' strDistType '_' strResultType '_' strBehav]);
        PltDendroMap3(matResp_mn_c,strDist,dColorThresh,vtID,matResp_mn,vtEvents,bROC);
        hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_' strDistType '_' strResultType '_' strBehav '.fig']);
        close(hFig);
        
        for nSel = vtPCA_Sel
            score_s= score(:,1:nSel);
            hFig = figure('Name',['MN_PCA' num2str(nSel) '_' strDistType '_' strResultType '_' strBehav]);
            PltDendroMap3(score_s,strDist,dColorThresh,vtID,matResp_mn,vtEvents,bROC);
            hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_PCA' num2str(nSel) '_' strDistType '_' strResultType '_' strBehav '.fig']);
            close(hFig);
        end
        
        if(nResType ==2)
            bROC = false;
            matResp_mn01 = stResp_Pool.N01(:,3:end);
            hFig = figure('Name',['MN_' strDistType '_N01_' strResultType '_' strBehav]);
            PltDendroMap3(matResp_mn_c,strDist,dColorThresh,vtID,matResp_mn01,vtEvents,bROC);
            hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_' strDistType '_' strResultType '_' strBehav '_N01.fig']);
            close(hFig);
            
            for nSel = vtPCA_Sel
                score_s= score(:,1:nSel);
                hFig = figure('Name',['MN_PCA' num2str(nSel) '_' strDistType '_N01_' strResultType '_' strBehav]);
                PltDendroMap3(score_s,strDist,dColorThresh,vtID,matResp_mn01,vtEvents,bROC);
                hgsave(hFig,[strDir_Sav filesep 'NeuronCluster_MN_PCA' num2str(nSel) '_' strDistType '_' strResultType '_' strBehav '_N01.fig']);
                close(hFig);
            end
        end
    end
    
end
save([strPath_Results filesep strBehav '_Results_' datestr(datetime('now'),30) '.mat']);

function PltDendroMap3(matResp_mn_c,strDist,dColorThresh,vtID,matResp_mn,vtEvents,bROC)
pos_f = [450,160,600,800];
pos_a = [0.1,0.1,0.12,0.85;
    0.245,0.1,0.05,0.85;
    0.3,0.1,0.6,0.85;
    ];

set(gcf,'position',pos_f);
nNeuronCount = size(matResp_mn_c,1);
Y=pdist(matResp_mn_c,strDist);
Z = linkage(Y,'average');
subplot(1,3,1);
idxOrder = resp_dendrogram(Z,nNeuronCount,dColorThresh);
set(gca,'pos',pos_a(1,:),'ytick',[],'fontname','Times New Roman','fontsize',14);

subplot(1,3,2);
PVH_imgPlotResp_FC1(vtID,idxOrder,[],false);
set(gca,'pos',pos_a(2,:),'ytick',[],'xtick',1,'xticklabel','ID','xticklabelrotation',-60,'fontname','Times New Roman','fontsize',14);
colormap(gca,jet);

subplot(1,3,3);
PVH_imgPlotResp_FC1(matResp_mn,idxOrder,vtEvents,bROC);
set(gca,'pos',pos_a(3,:),'ytick',[],'xtick',[],'fontname','Times New Roman','fontsize',14);