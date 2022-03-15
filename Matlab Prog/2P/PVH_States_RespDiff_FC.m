function stRespDiff = PVH_States_RespDiff_FC(matRes,clStates)

clStates_Diff = {
    'Extend';
    'Eating_onset';
    'Eating';
    'Fear-eating';
    'Fear-before';
    'Fear_off';
    'Retract';
    'After-stim_off';
    'After-before';
    };

% clStates_U = {
%     'before.tif';
%     'extend.tif';
%     'eating_onset.tif';
%     'eating.tif';
%     'fear_stim.tif';
%     'stim_off.tif';
%     'retract.tif'
%     'after.tif';
%     };
vtDiff = [2 1;3 1;4 1;5 4;5 1;6 5;7 6;8 6;8 1];

nStatesCount = length(clStates_U);
clIdx = cell(nStatesCount,1);
clImgData = cell(nStatesCount,1);
for nState = 1:nStatesCount
    clIdx(nState)={nState};
    strFn_AVGImg = [clStates clStates_U{nState}];
    disp(['Loading Image Data: ' strFn_AVGImg]);
    clImgData(nState) = {imread(strFn_AVGImg)};
end

nImgDiffCount = size(vtDiff,1);
clImgDiffData = cell(nImgDiffCount,1);
for nDiff = 1:nImgDiffCount
    img1= clImgData{vtDiff(nDiff,1)};
    img2 = clImgData{vtDiff(nDiff,2)};
    img_Diff = img1-img2;
    img_top = prctile(abs(img_Diff(:)),99.8);
    hFig = figure;
    imshow(img_Diff,'DisplayRange',img_top*int16([-1 1]),'Colormap',clrmap);
    strFn_Img_Sav = [strrep(clStates,'AVG_','DIFF_') clStates_Diff{nDiff} '.fig'];
    colorbar();
    hgsave(hFig,strFn_Img_Sav);
    close(hFig);
    [matDiff_RGB16,matDiff_RGB8] = ImgDiff(img1,img2);
    clImgDiffData(nDiff) = {matDiff_RGB16};
    strFn_Img_Sav = [strrep(clStates,'AVG_','DIFF16_') clStates_Diff{nDiff} '.tif'];
    imwrite(matDiff_RGB16,strFn_Img_Sav);
    strFn_Img_Sav = [strrep(clStates,'AVG_','DIFF8_') clStates_Diff{nDiff} '.tif'];
    imwrite(matDiff_RGB8,strFn_Img_Sav);
end

strFn_Sav = [fileparts(clStates) 'AVGImgData_Diff.mat'];
save(strFn_Sav,'clImgData','clImgDiffData','strFn_AVGImg_Prefix', 'clFn_AVGImg_Postfix','clStates_Diff');

function [matDiff_RGB16,matDiff_RGB8] = ImgDiff(img1,img2)
r=uint16(img1-img2);
b = zeros(size(r),'uint16');
g= uint16(img2-img1);
matDiff_RGB16 = cat(3,r,g,b);
maxVal = max(matDiff_RGB16(:));
r8=uint8(double(r)/double(maxVal)*255);
b8 = zeros(size(r8),'uint8');
g8 = uint8(double(g)/double(maxVal)*255);
matDiff_RGB8 = cat(3,r8,g8,b8);


