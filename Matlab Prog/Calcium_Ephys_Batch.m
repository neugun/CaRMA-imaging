strDir = 'E:\CE Data\FD 05_28 c6 c9 c11 c14 Less Easy';
clFiles = FindFiles_RegExp('CE2.fig$', strDir, true)';

for nFile = 1:length(clFiles)
    strFigName = clFiles{nFile};
    disp(['Processing File: ' strFigName]);
    try
    hFig = Calcium_Ephys_v5(strFigName);
    close(hFig);
    catch
        warning(['Skip processing file: ' strFigName 'something wrong!'])
    end
end
disp('processing done');

