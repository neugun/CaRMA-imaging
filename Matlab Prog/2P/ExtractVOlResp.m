function matResp = ExtractVOlResp(strFn_ROIs,strDir_VolResp,strFn_RgExp_Resp)

if nargin == 0
    strFn_ROIs = 'Z:\Imaging\2P345\20170830\ANM378231\Reg_Cat\Avg3_nbg\2p_Neurons_v2_Exclude_ROIs_reg.tif';
    strDir_VolResp = 'Z:\Imaging\2P345\20170830\ANM378231\Reg_Cat\Avg3_nbg';
    strFn_RgExp_Resp = '_S(\d)_C\d\_subBk.tif';
end


matROIs = readTiffStack(strFn_ROIs);
nROICount = max(matROIs(:));

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
    
    matResp = zeros(nROICount,nFrameCount);
    for nFrame=1:nFrameCount
        matResp_F = squeeze(matResp_All(:,:,nFrame,:));
        stats = regionprops(matROIs,matResp_F,'MeanIntensity');
        matResp(:,nFrame) = [stats.MeanIntensity];
    end
    
    save([fileparts(strFn_Resp) filesep 'Resp.mat'],'matResp');
    disp('done');
end
