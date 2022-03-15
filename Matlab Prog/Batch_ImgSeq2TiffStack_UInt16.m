clImgDir_P = {  'Z:\Imaging\2P345\20170830\ANM372320';
    };
strImgFn_Exp = '_000\d{2}_C\d_ZStack.tif';
clImgPostFix = {'_reg_ZProj';'_reg_lin_ZProj'};


for nDir = 1:length(clImgDir_P)
    strImgDir_P = clImgDir_P{nDir};
    clImgFns = FindFiles_RegExp(strImgFn_Exp, strImgDir_P, true,2)';
    for nPostFix = 1:length(clImgPostFix)
        strImgPostFix = clImgPostFix{nPostFix};
        for nFile=1:length(clImgFns)
            [strPath,strImgFn] = fileparts(clImgFns{nFile});
            clImgFnParts = strsplit(strImgFn,'_');
            strDir_ImgSeq = [strPath filesep clImgFnParts{1} '_' clImgFnParts{2} '_S'];%'/groups/sternson/sternsonlab/from_tier2/XSJ/Process_2P/ANM329296_00006_S';
            strFn_Exp = ['_S(\d{1,3})_' clImgFnParts{end-1} strImgPostFix];
            strFn_TiffStack = strrep(strDir_ImgSeq,'_S',[strImgPostFix,'_ZStack.tif']);
            ImgSeq2TiffStack_UInt16(strDir_ImgSeq,strFn_Exp,strFn_TiffStack);
        end
    end
end