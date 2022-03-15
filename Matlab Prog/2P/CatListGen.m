
strDir_Img_P = 'Z:\Confocal\ANM378231_Real\Trans_DR\BkgAdj';
clGenes = {'1','G','Vglut2';'1','R','Gad2';'1','Y','Npy1r';
    '2','G','Crh'; '2','R','Reln';'2','Y','Ntng1';
    '3','G','Pdyn';'3','R','Penk';'3','Y','Trh';
    '4','G','Oxy';'4','R','Avp';'4','Y','Sst'};

nGeneCount = length(clGenes);

strFn_CatList = [strDir_Img_P filesep 'CatList.log'];
fid = fopen(strFn_CatList,'wt');
for nGene = 1:nGeneCount
    
    strDir_Regexp = ['S(\d{3})_Rd' clGenes{nGene,1} '\S*_Stitched_' clGenes{nGene,2}];
    clFns_Img = FindFiles_RegExp(strDir_Regexp, strDir_Img_P, false)';
    clFns_Img = SortFnByCounter(clFns_Img,strDir_Regexp);
    
    nFileCount = length(clFns_Img);
    
    for nFile = 1:length(clFns_Img)
        strFn = clFns_Img{nFile};
        fprintf(fid,'%s\n', strFn);
    end
    strFn_Sav = [strDir_Img_P '\Cat_' clGenes{nGene,3} '.tif'];
    fprintf(fid,'#sav#:%s\n', strFn_Sav);
end

fclose(fid);