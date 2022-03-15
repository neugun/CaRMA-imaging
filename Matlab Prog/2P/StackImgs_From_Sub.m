function StackImgs_From_Sub(strDir,strFn_Exp)

if(nargin==0)
    strDir = 'Z:\2P_Analyze\ANM318142\20160811_2\ANM318142_00005_S';
    strFn_Exp = '_S(\d{1,2})_C1_reg_ZProj.tif';
end

clFns = FindFiles_RegExp(strFn_Exp, strDir, false)';
[clFns,vtCount] = SortFnByCounter(clFns,strFn_Exp);

nSubCount = length(clFns);
matImg = readTiffStack(clFns{1});

[imgInfo.numLines, imgInfo.numPixels]=size(matImg);
matImgOut = zeros(imgInfo.numLines,imgInfo.numPixels,nSubCount,'int16');
matImgOut(:,:,1)=matImg;

for nSub = 2:nSubCount
    matImg = readTiffStack(clFns{nSub});
    matImgOut(:,:,nSub)=matImg;
end

strDir_Sav = fileparts(strDir);
[~,strFn] = fileparts(clFns{1});
strFn = strrep(strFn,['_S' num2str(vtCount(1))],'_Stack');
strFn_Sav = [strDir_Sav filesep strFn '.tif'];
writeTiffStack_Int16(matImgOut,strFn_Sav);

