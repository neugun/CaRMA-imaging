function matL=NormMatCol_single(matR)
for i = 1: size(matR,1)    
    matColMin = min(matR(i,:));
    matColMax = max(matR(i,:));
    matMin=(repmat(matColMin,[size(matR,2) 1]))';
    matMax=(repmat(matColMax,[size(matR,2) 1]))';
    matRg = matMax-matMin;
    matRg(matRg==0)=1;
    matL(i,:) = (matR(i,:)-matMin)./matRg;
end
end

