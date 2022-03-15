function stResp_States = PVH_getResp_States_Grooming1(strFn_States,matResp,AvgFrm)

[~,~,raw] = xlsread(strFn_States);
nFileCount = size(raw,1)-1;
clStates = raw(1,3:end);
nStatesCount = length(clStates);
vtFrmRange = zeros(nStatesCount,2);
matResp_T = reshape(matResp,size(matResp,1),size(matResp,2)/nFileCount,nFileCount);
nNeuronCount = size(matResp,1);
matResp_States = zeros(nNeuronCount,nStatesCount,nFileCount);
for nFile=1:nFileCount
    for nState=1:nStatesCount
        strFrmRange = raw{nFile+1,nState+2};
        vtRange = sscanf(strFrmRange,'%d-%d')';
        vtRange = max(floor(vtRange/AvgFrm),[1 1]);
        vtFrmRange(nState,:)= vtRange;
        matResp_States(:,nState,nFile) = mean(matResp_T(:,vtRange(1):vtRange(2),nFile),2);
    end
end

clStates_Diff = {
    'Grooming-before';
    'After-before';
    'After-grooming'
    };

vtDiff = [2 1;3 1;3 2];

nDiffCount = length(clStates_Diff);
matResp_Diff = zeros(nNeuronCount,nDiffCount,nFileCount);

for nDiff=1:nDiffCount
    matResp_Diff(:,nDiff,:) = diff(matResp_States(:,vtDiff(nDiff,:),:),1,2);
end

matResp_States_Avg = mean(matResp_States,3);
matResp_States_Std = std(matResp_States,0,3);
matResp_Diff_Avg = mean(matResp_Diff,3);
matResp_Diff_Std = std(matResp_Diff,0,3);

stResp_States.matResp_m = mean(matResp_T,3);
stResp_States.matResp_States_Avg = matResp_States_Avg;
stResp_States.matResp_States_Std = matResp_States_Std;
stResp_States.matResp_Diff_Avg = matResp_Diff_Avg;
stResp_States.matResp_Diff_Std = matResp_Diff_Std;
stResp_States.clStates_Diff = clStates_Diff;
stResp_States.clStates = clStates;