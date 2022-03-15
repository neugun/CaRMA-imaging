function Cat_Ghrelin_Resp()

clMatFns = {'Y:\All\ghrelin\20140510\02\CS\recording-ANM238901_20140510_000029-9_reg_crop_CS_Sel_norm_CrossDays.mat';
    'Y:\All\ghrelin\20141104\03\CS\recording-ANM246471_20141104_090818-4_reg_crop_CS_Sel_norm_CrossDays.mat';
    'Y:\All\ghrelin\20141105\02\CS\recording-ANM246473_20141105_093701-3_ALL_reg_crop_CS_Sel_norm_CrossDays.mat';
    'Y:\All\ghrelin\20141211\02\CS\recording-ANM259208_20141211_102012-3_ALL_reg_crop_CS_Sel_norm_CrossDays.mat'};

nSmpCount = 600;
nFileCount = length(clMatFns);
Sig_Avg_Day = zeros(nSmpCount,nFileCount);
vtNeuronCount_Day = zeros(nFileCount,1);
Sig_All = [];

for nFile = 1:nFileCount
    load(clMatFns{nFile},'cell_sig_norm');
    if(nFile ==2)
        idx = 10+(1:nSmpCount);
    else
        nCol = size(cell_sig_norm,2);
        idx=nCol-10-(1:nSmpCount);
    end
    Sig_All = cat(1,Sig_All,cell_sig_norm(:,idx,:));
end


Sig_All_Norm = NormMatRow(Sig_All);


figure;
imagesc(Sig_All_Norm(:,:,1));


save('Y:\All\ghrelin\Aft.mat','Sig_All','Sig_All_Norm');