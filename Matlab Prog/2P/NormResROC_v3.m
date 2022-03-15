function matRespN = NormResROC_v3(matResp,idxTN_Rg,nTrialCount,szBin,AvgFrm)

%% average each 4 planes
avg_N = AvgFrm;
if avg_N > 1
    aa = matResp;
    idxTN_Rg = round(idxTN_Rg/avg_N);
    szBin = round(szBin/avg_N);
%     matResp = squeeze(mean(reshape(aa{1,1},size(aa{1,1},1),avg_N,[]),2));  % dividable
    matResp = squeeze(mean(reshape(aa,size(aa,1),avg_N,[]),2));  % for compare signals
end
%%
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
%         vtTN = matResp(nRow,idxTN_Rg(1):idxTN_Rg(2),:); % in the middle of pre-behavior
        vtTN = matResp(nRow,1:3:idxTN_Rg(1)*3,:); % in the middle of pre-behavior
        
        vtTN = vtTN(:);
        vtTP = matResp_p(nRow,idxTP_S:idxTP_E,:);
        vtTP = vtTP(:);
        vtPred = [vtTN;vtTP];
        if(nRow==1&&nCol==1)
            vtRes = [false(size(vtTN));true(size(vtTP))];
        end
        
        mdl = fitglm(vtPred,vtRes,'Distribution','binomial','Link','logit'); % 0.5 sec; if 100*600 will need 3000s, and takes 50min to run.
        scores = mdl.Fitted.Probability;
        [~,~,~,AUC] = perfcurve(vtRes,scores,'true');
        
        if(mean(vtTP)<mean(vtTN)&&AUC>0.5)
            AUC = 1 - AUC;
        end
        %% t-AuROC
        AUC = 2*AUC -1;
        
        matRespN(nRow,nCol) = AUC;
        
    end
end
