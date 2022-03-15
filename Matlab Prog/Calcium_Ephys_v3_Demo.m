ephysFile = '\\tier2\sternson\Shengjin & Chris\GCaMP6S Data\20140429 GCaMP6S\04_29_14 GCaMP6s in arc 28dys p55\AA0001\AA0001AAAA0008.xsg';
xlsfile='\\tier2\sternson\Shengjin & Chris\GCaMP6S Data\20140429 GCaMP6S\Good Cell Video\04-29-14-22-40-20.750.xls';

stOption.ManVot = 70;
stOption.tFiltWnd = 30e-3; %30ms
stOption.tSpikeWnd = 2e-3; %2ms
stOption.tBin = 0.3; % s
stOption.dSpikeThresh = 5.0; %std

hFig = Calcium_Ephys_v3(ephysFile,xlsfile,stOption);