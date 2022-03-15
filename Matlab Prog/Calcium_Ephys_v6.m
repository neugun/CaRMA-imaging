function hFig = Calcium_Ephys_v6(ephysFile,xlsfile,stOption)

if (nargin ==0)
    ephysFile = 'Y:\All\Slice\POMC\Mus\01\AA0001AAAA0010.xsg';
    xlsfile='Y:\All\Slice\POMC\Mus\01\12-04-14-20-49-52.xls';
end

if(nargin < 3)
    stOption.ManVot = 200;
    stOption.tFiltWnd = 30e-3; %30ms
    stOption.tSpikeWnd = 2e-3; %2ms
    stOption.tBin = 0.3; % s
    stOption.dSpikeThresh = 5.0; %std
end

if(xlsfile(end)=='x')
    InsVal = xlsread(xlsfile);
    InsVal = InsVal(:,2);
else
    try
        InsVal = dlmread(xlsfile,'',1,1);
    catch
        InsVal = xlsread(xlsfile);
        InsVal = InsVal(:,2);
    end
end

InsVal_0 = prctile(InsVal,5);
InsVal_del = (InsVal-InsVal_0)./InsVal_0*100;
InsTime = (0:size(InsVal,1)-1)/10;%10Hz

ephysData =load(ephysFile,'-mat');
ephysTrace = ephysData.data.ephys.trace_1;
ephysSR = ephysData.header.ephys.ephys.sampleRate;
ephysTime = (0:length(ephysTrace)-1)./ephysSR;


nSpikeHW = ceil(stOption.tSpikeWnd*ephysSR/2); %samples for half width of spike
ephysTrace_Flt=medfilt1(ephysTrace,ceil(stOption.tFiltWnd*ephysSR));
ephysTrace_Sig = ephysTrace_Flt-ephysTrace;
ephysTrace_ZS = zscore(ephysTrace_Sig);
ephysTrace_ZS(1:nSpikeHW)=0;
indC=find(abs(ephysTrace_ZS)>stOption.ManVot);
for n=1:length(indC)
    ephysTrace_ZS(indC(n)-nSpikeHW:indC(n)+nSpikeHW)=0;  %2ms for 10k sampel rate
end

spikeTimes=(detectSpikes_v2(ephysTrace_ZS,stOption.dSpikeThresh,4,2*nSpikeHW)-1)/ephysSR;
BinEdges = (0:ceil(ephysTime(end)/stOption.tBin))*stOption.tBin;
dFR=histc(spikeTimes,BinEdges)/stOption.tBin;
tHistTime = BinEdges(1:end-1)+0.5*stOption.tBin;
dFR = dFR(1:end-1);

[~,strFn,ext]=fileparts(xlsfile);

hFig = figure('name', [strFn ':Calcium_Ephys'],'pointer','fullcrosshair');
hZoom = zoom();
hPan = pan();
axTime_e = max([InsTime(end) ephysTime(end)]);

subplot(2,1,1);
[ha,hLine,hBar]=plotyy(InsTime,InsVal_del,tHistTime,dFR,'plot','bar');
YL = min(InsVal_del(:));
YU = max(InsVal_del(:))+0.05*range(InsVal_del(:));
set(ha(1),'box','off','xlim',[0 axTime_e],'ylim',[YL YU]);
set(ha(2),'box','off','xlim',[0 axTime_e]);
ylabel(ha(1),'\DeltaF/F_0 (%)');
ylabel(ha(2),'FR (spiks/s)');
set(hLine,'color','k');
uistack(hLine,'top');
set(hBar,'FaceColor','r','EdgeColor','r');
title('Calcium');

ax= subplot(2,1,2);
plot(ephysTime,ephysTrace_Sig,'r');
% RasterHeight = 0.05*range(ephysTrace_Sig(:));
% RasterYL = max(ephysTrace_Sig(:))+2*RasterHeight;
% RasterYU = RasterYL+RasterHeight;
% if(~isempty(spikeTimes))
%     hold on;
%     plot([spikeTimes;spikeTimes],repmat([RasterYL;RasterYU],[1 length(spikeTimes)]),'b');
% end
set(gca,'box','off','xlim',[0 axTime_e]);
ylabel('Amp (pA)');
xlabel('Time (s)');
title('ephys');


setAxesZoomMotion(hZoom,[ha ax],'horizontal');
setAxesPanMotion(hPan,[ha ax],'horizontal');
linkaxes([ha ax],'x');


hgsave(gcf,[xlsfile(1:end-length(ext)) '_CE2.fig']);
hgsave(gcf,[xlsfile(1:end-length(ext)) ' .jpg']);