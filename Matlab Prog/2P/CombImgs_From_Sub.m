function CombImgs_From_Sub(strDir,strFn_Exp,nColCount)

if(nargin==0)
    strDir = 'Z:\2P_Analyze\ANM318142\20160820\16\ANM318142_00016_S';
    strFn_Exp = '_S(\d{1,2})_C1_reg.tif';
    nColCount = 4;
end

clFns = FindFiles_RegExp(strFn_Exp, strDir, false)';
[clFns,vtCount] = SortFnByCounter(clFns,strFn_Exp);
nSubCount = length(clFns);

nRowCount = ceil(nSubCount/nColCount);
matImg = readTiffStack(clFns{1});

[imgInfo.numLines, imgInfo.numPixels,imgInfo.numVolumes]=size(matImg);
matImgOut = zeros(imgInfo.numLines*nRowCount,imgInfo.numPixels*nColCount,imgInfo.numVolumes,'int16');

idxR_S = 0;
for nRow = 1:nRowCount
    idxR = idxR_S+(1:imgInfo.numLines);
    idxC_S = 0;
    for nCol = 1:nColCount
        idxC = idxC_S+(1:imgInfo.numPixels);
        nSlice = (nRow-1)*nColCount+nCol;
        if(nSlice ~=1)
            matImg = readTiffStack(clFns{nSlice});
        end
        matImgOut(idxR,idxC,:) = matImg;
        idxC_S = idxC_S+imgInfo.numPixels;
    end
    idxR_S = idxR_S + imgInfo.numLines;
end

strDir_Sav = fileparts(strDir);
[~,strFn] = fileparts(clFns{1});
strFn = strrep(strFn,['_S' num2str(vtCount(1))],'_Comb');
strFn_Sav = [strDir_Sav filesep strFn '.tif'];
writeTiffStack_UInt16(matImgOut,strFn_Sav);

