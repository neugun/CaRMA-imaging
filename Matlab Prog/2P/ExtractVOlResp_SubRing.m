function matResp = ExtractVOlResp_SubRing(strDir_ROIs,strDir_VolResp,strFn_RgExp_Resp,vtRing)

if nargin == 0
    strDir_ROIs = 'Z:\2P_SignalExtraction_Test\ROIs';
    strDir_VolResp = 'Z:\2P_SignalExtraction_Test\Imgs_Aligned';
    strFn_RgExp_Resp = '_S(\d)_C\d.tif$';
    vtRing = 2;
end

strExp_Img = 'N(\d{1,3})_reg.tif$';

clFns = FindFiles_RegExp(strExp_Img, strDir_ROIs, false)';
[clFns,vtC]= SortFnByCounter(clFns,strExp_Img);
nRC = length(clFns);

matROI1 = readTiffStack(clFns{1});

matROIs = zeros(size(matROI1,1),size(matROI1,2),size(matROI1,3),nRC,'logical');
matROIs_r = zeros(size(matROI1,1),size(matROI1,2),size(matROI1,3),nRC,'logical');

%SE_i = strel('disk',vtRing(1),8);
SE_o = strel('disk',vtRing,8);

for nR=1:nRC
    iC = vtC(nR);
    strFn = clFns{nR};
%     disp(['Loading ROI: ' num2str(iC)]);
    imgData = readTiffStack(strFn);
    bwData = imgData == iC;
    idxF = find(any(bwData,[1 2]));
%    bwData_i = imdilate(bwData(:,:,idxF),SE_i);
    bwData_i = bwData(:,:,idxF);
    bwData_o = imdilate(bwData(:,:,idxF),SE_o);
    bwData_r = bwData;
    bwData_r(:,:,idxF) = bwData_o&(~bwData_i);
    %imgData_r = uint16(bwData*iC);
    matROIs(:,:,:,nR)=bwData;
    matROIs_r(:,:,:,nR) = bwData_r;
end

clFns_Resp = FindFiles_RegExp(strFn_RgExp_Resp, strDir_VolResp, false)';
clFns_Resp = SortFnByCounter(clFns_Resp,strFn_RgExp_Resp);

nSliceCount = size(matROIs,3);
if(length(clFns_Resp)~=nSliceCount)
    matResp = [];
    warning('ROIs file does not match with Response file!');
else
    clResp = cell(1,nSliceCount);
    for nFile=1:nSliceCount
        strFn_Resp = clFns_Resp{nFile};
        clResp{nFile} = readTiffStack(strFn_Resp);
    end
    
    matResp_All = cat(4,clResp{:});
    clearvars('clResp');
    nFrameCount = size(matResp_All,3);
 %%   
    matResp = zeros(nRC,nFrameCount);
    for nFrame=1:nFrameCount
        matResp_F = squeeze(matResp_All(:,:,nFrame,:));
        for nR = 1:nRC
            stats = regionprops(int8(matROIs(:,:,:,nR)),matResp_F,'MeanIntensity');
            stats_r = regionprops(int8(matROIs_r(:,:,:,nR)),matResp_F,'MeanIntensity');
            matResp(nR,nFrame) = max([stats.MeanIntensity-stats_r.MeanIntensity,0]);
        end
    end
    
    save([fileparts(strFn_Resp) filesep 'Resp_SubRing2.mat'],'matResp');
    disp('done');
end
