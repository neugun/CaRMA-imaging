clDirectories = {'\\dm11\sternsonlab\Shengjin & Chris\20140514 GCaMP6f Large'};
for nDir = 1:length(clDirectories)
    strDirectory =  clDirectories{nDir};
    clFileNames = FindFiles_RegExp('.seq', strDirectory, true)';
    for nFile = 1:length(clFileNames)
        strFileName = clFileNames{nFile};
        disp(['Converting file: ' strFileName]);
        Seq2TiffStack(strFileName);
    end
end
disp('Converted!');