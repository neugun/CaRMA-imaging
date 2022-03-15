function CombImages_SI_FastZ(strFn,nColCount)

if(nargin==0)
    strFn = 'Z:\Process_2P\ANM329296_00006.tif';
    nColCount = 4;
end

[Header,Aout,imgInfo] = scanimage.util.opentif(strFn);
nRowCount = ceil(imgInfo.numSlices/nColCount);
matImgOut = zeros(imgInfo.numLines*nRowCount,imgInfo.numPixels*nColCount,imgInfo.numVolumes,'int16');
for nCh =1:imgInfo.numChans
    matImgCh = squeeze(Aout(:,:,nCh,:,:,:));
    idxR_S=0;
    for nRow = 1:nRowCount
        idxR = idxR_S+(1:imgInfo.numLines);
        idxC_S = 0;
        for nCol = 1:nColCount
            idxC = idxC_S+(1:imgInfo.numPixels);
            nSlice = (nRow-1)*nColCount+nCol;
            matImgOut(idxR,idxC,:) = matImgCh(:,:,nSlice,:);
            idxC_S = idxC_S+imgInfo.numPixels;
        end
        idxR_S = idxR_S + imgInfo.numLines;
    end
    strFn_Sav = [strFn(1:end-4) '_Comb_C' num2str(nCh) '.tif'];
    writeTiffStack_Int16(matImgOut,strFn_Sav);
end

strFn_Header = [strFn(1:end-4) '_Header.mat'];
save(strFn_Header,'Header');
