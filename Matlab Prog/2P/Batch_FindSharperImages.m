strDir = 'Z:\2P_Analyze\ANM318142\ZStacks';
strFn_Exp = 'ANM318142_\d{5}\.tif$';
clFns = FindFiles_RegExp(strFn_Exp, strDir, true,3)';
%%
for nFile = 9:10%length(clFns)
    strFn1 = clFns{2*(nFile-1)+1};
    strFn2 = clFns{2*(nFile-1)+2};
    FindSharperImages(strFn1,strFn2);
end