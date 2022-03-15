strDir = 'Z:\Confocal\ANM318142\M318142_Real\FISH_Rot_FlipZ_16bit\Trans\FISH\16bit\BkgAdj_All';
strExp = '\\Cat\\Ext_ROIs_65_10P_6_3_2.tif';
clFns = FindFiles_RegExp(strExp, strDir, true,4)';
%%
clChID = {'Adra2a','Adra1b','Npy1r',...
          'Bdnf','Sfrp2','Ntng1',...
          'Crh','Gad2','Reln',...
          'Vglu2','Cckar','Sst',...
          'Oxy','Avp','Trh',...
          'Gal','Penk','Pdyn'};
      
nFileCount = length(clFns);
for nFile = 1:nFileCount
    strFn_L = clFns{nFile};
    disp(['Processing file: ' strFn_L]);
    ExtractFishSignal(strFn_L,clChID);
end