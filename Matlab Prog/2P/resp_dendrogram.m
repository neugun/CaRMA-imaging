function idxOrder_O = resp_dendrogram(Z,nNeuronCount,dColorThresh,idxOrder_I)

dColorThresh = dColorThresh*max(Z(:,3));
if(nargin == 3)
    [~,~,idxOrder_O] = dendrogram(Z,0,'Orientation','left','ColorThreshold',dColorThresh);
end

if(nargin==4)
    dendrogram(Z,0,'Orientation','left','ColorThreshold',dColorThresh,'reOrder',idxOrder_I);
    idxOrder_O = idxOrder_I;
end

ylim([0.5 0.5+nNeuronCount]);
set(gca,'UserData',Z);