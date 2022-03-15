function matResp = ExtractVOlResp_Exclude_SubRing(strFn_ROIs,strDir_VolResp,strFn_RgExp_Resp,iRing)

if nargin == 0
    strFn_ROIs = 'Z:\Imaging\2P345\20170821\ANM372320\Reg_Cat\Avg3\2p_Neurons_v2_Exclude_ROIs_reg.tif';
    strDir_VolResp = 'Z:\Imaging\2P345\20170821\ANM372320\Reg_Cat\Avg3';
    strFn_RgExp_Resp = '_S(\d)_C\d\.tif$';
    iRing = 2;
end


matROIs1 = readTiffStack(strFn_ROIs);
nRC = max(matROIs1(:));

matROIs = zeros(size(matROIs1,1),size(matROIs1,2),size(matROIs1,3),nRC,'logical');
matROIs_r = zeros(size(matROIs1,1),size(matROIs1,2),size(matROIs1,3),nRC,'logical');

SE_o = strel('disk',iRing,8);

for nR=1:nRC
    bwData = matROIs1 == nR;
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
    
    matResp = zeros(nRC,nFrameCount);
    for nFrame=1:nFrameCount
        matResp_F = squeeze(matResp_All(:,:,nFrame,:));
        for nR = 1:nRC
            stats = regionprops(int8(matROIs(:,:,:,nR)),matResp_F,'MeanIntensity');
            stats_r = regionprops(int8(matROIs_r(:,:,:,nR)),matResp_F,'MeanIntensity');
            %matResp(nR,nFrame) = max([stats.MeanIntensity-stats_r.MeanIntensity,0]);
            if(~isempty(stats))
                matResp(nR,nFrame) = stats.MeanIntensity-stats_r.MeanIntensity;
            end
        end
    end
    
    save([fileparts(strFn_Resp) filesep 'Resp_Exclude_SubRing.mat'],'matResp');
    disp('done');
end
