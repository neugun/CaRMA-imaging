clDirs = {
%           'Z:\2P_Analyze\ANM318142\20160723';
%           'Z:\2P_Analyze\ANM318142\20160724';
%           'Z:\2P_Analyze\ANM318142\20160801';
%           'Z:\2P_Analyze\ANM318142\20160802';
%           'Z:\2P_Analyze\ANM318142\20160804';
%           'Z:\2P_Analyze\ANM318142\20160805';
%           'Z:\2P_Analyze\ANM318142\20160806';
%           'Z:\2P_Analyze\ANM318142\20160808';
          '\\dm11\sternsonlab\XSJ\from_Trace\gCamp_2P_Reg\CEA';
          '\\dm11\sternsonlab\XSJ\from_Trace\gCamp_2P_Reg\LHA';
%           'Z:\2P_Analyze\ANM318142\20160811';
%           'Z:\2P_Analyze\ANM318142\20160814';
%           'Z:\2P_Analyze\ANM318142\20160816';
%           'Z:\2P_Analyze\ANM318142\20160817';
%           'Z:\2P_Analyze\ANM318142\20160819';
%           'Z:\2P_Analyze\ANM318142\20160821';
          };
strImgExp_SI = '(\d{5}).tif';
nColCount = 4;

nDirCount = length(clDirs);
clTiffFns_SI = cell(1,nDirCount);

for nDir =1:nDirCount
    clFns = FindFiles_RegExp(strImgExp_SI, clDirs{nDir}, false)';
    clFns = SortFnByCounter(clFns,strImgExp_SI);
    clTiffFns_SI(nDir) = {clFns};
end
%%
%clSel = {[4:13],[1 2 13 14],[1 2 14 15],[1 2 14 15],[1 2 13 14],[2 13 14],[1 2 7 8],[1 2 7 8]};
%%
for nDir = 1:nDirCount
    strDir = clDirs{nDir};
    clFns = clTiffFns_SI{nDir};
    vtSel = 1:length(clFns);%clSel{nDir};
    for nFile = vtSel
        strFn = clFns{nFile};
        disp(['Processing file: ' strFn]);
        try
            [strDir_Sub,imgInfo] = SplitImages_SI_FastZ(strFn);
            %         strDir_Sub = [strFn(1:end-4) '_S'];
            if(imgInfo.bFastZ)
                strFn_Exp = ['_S(\d{1,2})_C' num2str(imgInfo.numChans) '.tif'];
                CombImgs_From_Sub(strDir_Sub,strFn_Exp,nColCount);
                strFn_Exp_Avg = ['_S(\d{1,2})_C' num2str(imgInfo.numChans) '_Avg.tif'];
                CombImgs_From_Sub(strDir_Sub,strFn_Exp_Avg,nColCount);
            end
        catch ME
            disp(ME.message);
        end
    end
end
