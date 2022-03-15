clFns ={
'Z:\Imaging\2P345\20160812\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160813\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160815\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160822\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160823\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160824\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160825\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160826\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160827\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160829\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160830\ANM329296\ANM329296_00002.tif'
'Z:\Imaging\2P345\20160831\ANM329296\ANM329296_00002.tif'
};

nFileCount = length(clFns);
for nFile=1:nFileCount
    strFn = clFns{nFile};
    [Header,Aout,imgInfo] = scanimage.util.opentif(strFn);
    Aout = uint16(Aout);
    matImg = imsubtract(squeeze(Aout(:,:,2,:,:,:)),squeeze(Aout(:,:,1,:,:,:)));
    clFnParts = strsplit(strFn,'\');
    strFn_Sav = ['Z:\Reconstruction\ANM329296\ZStacks\' clFnParts{4} '\' clFnParts{6}(1:end-4) '_Diff.tif'];
    mkdir(fileparts(strFn_Sav));
    writeTiffStack_UInt16(matImg,strFn_Sav);
end