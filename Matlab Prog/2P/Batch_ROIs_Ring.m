strDir = 'Z:\2P_SignalExtraction_Test\ROIs';
strExp_Img = 'N(\d{1,3})_reg.tif$';

vtRing = [1 3];

clFns = FindFiles_RegExp(strExp_Img, strDir, false)';
[clFns,vtC]= SortFnByCounter(clFns,strExp_Img);

nFC = length(clFns);
SE_i = strel('disk',vtRing(1),8);
SE_o = strel('disk',vtRing(2),8);

strDir_Sav = [strDir '_Ring'];
mkdir(strDir_Sav);

for nF=1:nFC
    iC = vtC(nF);
    strFn = clFns{nF};
    disp(['Processing file: ' strFn]);
    imgData = readTiffStack(strFn);
    bwData = imgData == iC;
    idxF = find(any(bwData,[1 2]));
    bwData_i = imdilate(bwData(:,:,idxF),SE_i);
    bwData_o = imdilate(bwData(:,:,idxF),SE_o);
    bwData(:,:,idxF) = bwData_o&(~bwData_i);
    imgData_r = uint16(bwData*iC);
    writeTiffStack_UInt16(imgData_r,[strDir_Sav '\N' num2str(iC) '_ring.tif']);
end