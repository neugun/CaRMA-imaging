nFileCount = length(clFnImg);
strDir_Des = 'Z:\Confocal\ANM318142\M318142_Real\FISH_Rot_FlipZ_16bit\Trans';
for nFile =1:nFileCount
    strFnImg_Src = clFnImg{nFile};
    strFnImg_Src = strrep(strFnImg_Src,'/groups/sternson/sternsonlab/from_tier2/XSJ','Z:');
    strFnImg_Src = strrep(strFnImg_Src,'/','\');
    [strPath,strFn] = fileparts(strFnImg_Src);
    strFnImg_Src =[strPath filesep strFn '_reg.tif'];
    strFnImg_Des = [strDir_Des filesep strFn '.tif'];
    disp(['Moving File ' strFnImg_Src ' to ' strFnImg_Des]);
    movefile(strFnImg_Src,strFnImg_Des,'f');
end