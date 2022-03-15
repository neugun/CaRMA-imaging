function hImg = PVH_imgPlotResp_FC1(matResp,idxOrder,vtFrm,bROC)

if(nargin<4)
    bROC = false;
end

matResp_R = matResp(idxOrder,:);
%hImg = imagesc(flipud(matResp_R));
hImg = imagesc(matResp_R);
hold on;
for n=1:length(vtFrm)
    plot([vtFrm(n);vtFrm(n)],[0;size(matResp,2)+0.5],'w:','linewidth',2);
end

if(bROC)
    set(gca,'clim',[0 1]);
    % edit by Zhenggang
    set(gca,'clim',[-1 1]);
%     load('D:\6_CaRMA_imaging\Matlab Prog\2P\Diff_RG_Map.mat');
    load('F:\CaRMA-imaging\Matlab Prog\2P\Diff_RG_Map.mat');
    colormap(gca,clrmap);
end

set(hImg,'UserData',idxOrder);
dcm_obj = datacursormode(gcf);
set(dcm_obj,'UpdateFcn',@updatefcn_Map);
set(gca,'ydir','norm');