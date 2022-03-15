function PVH_States_ImgDiff_Ghrelin(strFn_AVGImg_Prefix)

if(nargin==0)
    strFn_AVGImg_Prefix = 'Z:\Imaging\2P345\20170829\ANM378231\Comb_Reg_Avg\ANM378231_Saline_Comb_C1_reg_Avg_';
end

clStates_Diff = {
    '1-4min';
    '5-8min';
    '9-12min';
    '13-16min';
    '17-20min';
    };

clFn_AVGImg_Postfix = {
    'before.tif';
    'after1.tif';
    'after2.tif';
    'after3.tif';
    'after4.tif';
    'after5.tif';
    };

load('Z:\Matlab Prog\2P\Diff_RG_Map.mat');
vtDiff = [2 1;3 1;4 1;5 1;6 1];

nStatesCount = length(clFn_AVGImg_Postfix);
clIdx = cell(nStatesCount,1);
clImgData = cell(nStatesCount,1);
for nState = 1:nStatesCount
    clIdx(nState)={nState};
    strFn_AVGImg = [strFn_AVGImg_Prefix clFn_AVGImg_Postfix{nState}];
    disp(['Loading Image Data: ' strFn_AVGImg]);
    clImgData(nState) = {int32(imread(strFn_AVGImg))};
end

nImgDiffCount = size(vtDiff,1);
clImgDiffData = cell(nImgDiffCount,1);
for nDiff = 1:nImgDiffCount
    img1= clImgData{vtDiff(nDiff,1)};
    img2 = clImgData{vtDiff(nDiff,2)};
    clImgDiffData(nDiff) = {img1-img2};
end

matImgDiff_All = cell2mat(clImgDiffData);
img_top = prctile(abs(matImgDiff_All(:)),99.98);

for nDiff=1:nImgDiffCount
    img_Diff = clImgDiffData{nDiff};

    hFig = figure;
    imshow(img_Diff,'DisplayRange',img_top*int32([-1 1]),'Colormap',clrmap);
    strFn_Img_Sav = [strrep(strFn_AVGImg_Prefix,'Avg_','DIFF_') clStates_Diff{nDiff} '.fig'];
    colorbar();
    hgsave(hFig,strFn_Img_Sav);
    close(hFig);
    [matDiff_RGB16,matDiff_RGB8] = ImgDiff(img1,img2,img_top);
    %clImgDiffData(nDiff) = {matDiff_RGB16};
    strFn_Img_Sav = [strrep(strFn_AVGImg_Prefix,'Avg_','DIFF16_') clStates_Diff{nDiff} '.tif'];
    imwrite(matDiff_RGB16,strFn_Img_Sav);
    strFn_Img_Sav = [strrep(strFn_AVGImg_Prefix,'Avg_','DIFF8_') clStates_Diff{nDiff} '.tif'];
    imwrite(matDiff_RGB8,strFn_Img_Sav);
end

strFn_Sav = [fileparts(strFn_AVGImg_Prefix) 'AVGImgData_Diff.mat'];
save(strFn_Sav,'clImgData','clImgDiffData','strFn_AVGImg_Prefix', 'clFn_AVGImg_Postfix','clStates_Diff');

function [matDiff_RGB16,matDiff_RGB8] = ImgDiff(img1,img2,maxVal)
r=uint16(img1-img2);
b = zeros(size(r),'uint16');
g= uint16(img2-img1);
matDiff_RGB16 = cat(3,r,g,b);
r8=uint8(double(r)/double(maxVal)*255);
b8 = zeros(size(r8),'uint8');
g8 = uint8(double(g)/double(maxVal)*255);
matDiff_RGB8 = cat(3,r8,g8,b8);


