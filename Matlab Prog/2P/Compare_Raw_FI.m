strDir = 'Z:\Labmeeting\Labmeeting20180601\Raw_Fluo';
clBehav = {'Feeding','Drinking','Fear','Ghrelin','Saline'};
strFn_CRH = 'Z:\Labmeeting\Labmeeting20180601\Raw_Fluo\SumInts_BkgAdj_Orig.fig';
dThresh = 0.025;

hFig = openfig(strFn_CRH,'invisible');
hImg = findobj(gcf,'type','image');
matFISH = get(hImg,'cdata');
close(hFig);
vtCRH = matFISH(:,4);
idxCRH = find(vtCRH>dThresh);

nBCount = length(clBehav);
clResp = cell(nBCount,1);
for nB = 1:nBCount
    strBehav = clBehav{nB};
    strFn_Resp = [strDir '\AvgResp_' strBehav];
    hFig = openfig(strFn_Resp,'invisible');
    hImg = findobj(gcf,'type','image');
    matResp= flipud(get(hImg,'cdata'));
    close(hFig);
    clResp{nB} = matResp(idxCRH,:);
end

nCRHCount = length(idxCRH);
nRow =2;
nCol = ceil(nCRHCount/nRow);
clr = hsv(nBCount);
%%
figure();
for n=1:nCRHCount
    subplot(nRow,nCol,n);
    hold on;
    for m = 1:nBCount
        matResp = clResp{m};
        plot(matResp(n,:),'color',clr(m,:));
    end
    if(n==nCol)
        legend(clBehav);
    end
    axis tight;
    title(['Neuron-' num2str(idxCRH(n))]);
end