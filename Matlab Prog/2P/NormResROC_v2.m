function matRespN = NormResROC_v2(matResp,idxTN_Rg,nTrialCount,szBin)

matResp = reshape(matResp,size(matResp,1),size(matResp,2)/nTrialCount,nTrialCount);
[nRowCount,nColCount,~]=size(matResp);

matRespN = zeros(nRowCount,nColCount);
if(~mod(szBin,2))
    szBin = szBin+1;
end

nPad = floor(szBin/2);
matResp_p=padarray(matResp,[0 nPad 0],'replicate');

for nRow = 1:nRowCount
    idxTP_S=0;
    for nCol=1:nColCount
        idxTP_E = idxTP_S+szBin;
        idxTP_S = idxTP_S+1;
        vtTN = matResp(nRow,idxTN_Rg(1):idxTN_Rg(2),:);
        vtTN = vtTN(:);
        vtTP = matResp_p(nRow,idxTP_S:idxTP_E,:);
        vtTP = vtTP(:);
        vtPred = [vtTN;vtTP];
        if(nRow==1&&nCol==1)
            vtRes = [false(size(vtTN));true(size(vtTP))];
        end
        
        %         mdl = fitglm(vtPred,vtRes,'Distribution','binomial','Link','logit');
        %         scores = mdl.Fitted.Probability;
        %         [~,~,~,AUC] = perfcurve(vtRes,scores,'true');
        matData = [vtPred vtRes];
        ROCout=roc_v2(matData);
        if(mean(vtTP)<mean(vtTN)&&AUC>0.5)
            ROCout.AUC = 1 - ROCout.AUC;
        end
        matRespN(nRow,nCol) = ROCout.AUC;
    end
end
