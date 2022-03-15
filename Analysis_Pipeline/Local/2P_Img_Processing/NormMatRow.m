function matL=NormMatRow(matR)
matRowMin = min(matR,[],2);
matRowMax = max(matR,[],2);
matMin=repmat(matRowMin,[1 size(matR,2)]);
matMax=repmat(matRowMax,[1 size(matR,2)]);
matRg = matMax-matMin;
matRg(matRg==0)=1;
matL = (matR-matMin)./matRg;