strDir = 'Z:\Confocal\M372321_Real\Rd2';
strFnExp = '_Rd2_ReImage_';
clFns = FindFiles_RegExp(strFnExp, strDir, false)';
nFileCount = length(clFns);
for nFile =1:nFileCount
    strFnSrc = clFns{nFile};
    %[strPath,strFn] = fileparts(strFnSrc);
    strFnImg_Des = strrep(strFnSrc,'_Rd2_ReImage_','_Rd2_');
    %disp(['Moving File ' strFnSrc ' to ' strFnImg_Des]);
    movefile(strFnSrc,strFnImg_Des,'f');
end