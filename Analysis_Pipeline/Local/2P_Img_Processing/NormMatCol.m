function matL=NormMatCol(matR)
matColMin = min(matR);
matColMax = max(matR);
matMin=repmat(matColMin,[size(matR,1) 1]);
matMax=repmat(matColMax,[size(matR,1) 1]);
matRg = matMax-matMin;
matRg(matRg==0)=1;
matL = (matR-matMin)./matRg;

