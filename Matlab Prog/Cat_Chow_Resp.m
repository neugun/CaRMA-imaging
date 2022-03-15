function Cat_Chow_Resp()

vtExtFrames = [-600 600];
clMatFns = {'Y:\All\Feeding\Chow2\20150125\02\CS\recording-ANM259208_20150125_192528-8_reg_crop_CS_Sel_norm_CrossDays.mat';
    'Y:\All\Feeding\Chow2\20150126\02\CS\recording-ANM246473_20150126_170221-5_reg_crop_CS_Sel_norm_CrossDays.mat';
    'Y:\All\Feeding\Chow_Cont\20140620\02\CS\recording-ANM238901_20140620_232828-2_reg_crop_CS_Sel_norm.mat';
    'Y:\All\Feeding\Others\GCamp6s\20140326\02\CS\recording-ANM216688_20140326_181458-3_reg_crop_CS_Sel_norm.mat'};
vtChow_Frm = [943,917,997,993];%chow
% vtChow_Frm = [900,905,916,936];%hand
vtEat_Frm = [943,917,997,993];

% clMatFns = {'Y:\All\Feeding\Wood2\20150127\02\CS\recording-ANM259208_20150127_230936-3_reg_crop_CS_Sel_norm_CrossDays.mat';
%     'Y:\All\Feeding\Wood2\20150122\02\CS\recording-ANM246473_20150122_231301-3_reg_crop_CS_Sel_norm_CrossDays.mat';
%     'Y:\All\Feeding\Others\ANM238901_False_Food\20140630\02\CS\recording-ANM238901_20140630_230653-2_reg_crop_CS_Sel_norm_CrossDays.mat';
%     'Y:\All\Feeding\Others\GCamp6s\20140326\03\CS\recording-ANM216688_20140326_182358-4_reg_crop_CS_Sel_norm.mat'};
% % vtChow_Frm = [956,1081,1091,1100];%false food
% vtChow_Frm = [906,907,917,903];%hand
% vtEat_Frm = [956,1081,1091,1100];%false food

nSmpCount = vtExtFrames(2)-vtExtFrames(1)+1; 
nFileCount = length(clMatFns);
Sig_Avg_Day = zeros(nSmpCount,nFileCount);
vtNeuronCount_Day = zeros(nFileCount,1);
Sig_All = [];
Counter =1;
for nFile = [1 3 2 4]
    load(clMatFns{nFile},'cell_sig_norm');
    idx_S = vtChow_Frm(nFile)+vtExtFrames(1);
    idx_E = vtChow_Frm(nFile)+vtExtFrames(2);
    Sig_All = cat(1,Sig_All,cell_sig_norm(:,idx_S:idx_E,:));
    Sig_Avg_Day(:,Counter) = mean(cell_sig_norm(:,idx_S:idx_E,1));
    vtNeuronCount_Day(Counter) = size(cell_sig_norm,1);
    Counter = Counter+1;
end

vtNeuronCount_Day

Sig_All_Norm = NormMatRow(Sig_All);
nNeuronCount = size(Sig_All_Norm,1);

figure;
imagesc(Sig_All_Norm(:,:,1));
hold on;
plot([601 601],[0.5 nNeuronCount+0.5]);
vtCumCount_Day = [0;cumsum(vtNeuronCount_Day)];
Counter =1;
for nFile = [1 3 2 4]
    Xs = vtEat_Frm(nFile)-vtChow_Frm(nFile)+601;
    plot([Xs Xs],0.5+vtCumCount_Day([Counter Counter+1]),'r');
    Counter = Counter+1;
end

figure;
plot(Sig_Avg_Day);

save('Y:\All\Feeding\Food_4mice.mat','Sig_All','Sig_All_Norm');