strDir = 'Z:\Confocal\M372321_Real\Trans_DR';
strFn_Exp ='\\16bit\\S(\d{2}).tif$';
nRecurseLevel = 3;

clFns = FindFiles_RegExp(strFn_Exp,strDir,true,nRecurseLevel)';

%%

for nFile = 1:length(clFns)
    strFn = clFns{nFile};
    delete(strFn);
end