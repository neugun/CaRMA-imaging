function hFig = Calcium_Ephys(ephysFile,xlsfile,ManVot)

if (nargin ==0)
    ephysFile = '\\tier2\sternson\Shengjin & Chris\GCaMP6S Data\20140429 GCaMP6S\04_29_14 GCaMP6s in arc 28dys p55\AA0001\AA0001AAAA0008.xsg';
    xlsfile='\\tier2\sternson\Shengjin & Chris\GCaMP6S Data\20140429 GCaMP6S\Good Cell Video\04-29-14-22-40-20.750.xls';
end

if(nargin < 3)
    ManVot = 70;
end

tFiltWnd = 30e-3; %30ms
tSpikeWnd = 2e-3; %2ms
tBin = 0.3; % s

if(xlsfile(end)=='x')
    InsVal = xlsread(xlsfile);
    InsVal = InsVal(:,2)*100;
else
    InsVal = dlmread(xlsfile,'',1,1)*100;
end
InsVal_del = (InsVal-mean(InsVal(1:30)))./mean(InsVal(1:30))*100;
%InsVal=InsVal(221:520,:); %%4:end for AAAA0002 221:520 for AAAA0003, 84:384 for AAAA0004 369:668 for AAAA0005
InsTime = (0:size(InsVal,1)-1)/10;%10Hz

ephysData =load(ephysFile,'-mat');
ephysTrace = ephysData.data.ephys.trace_1;
ephysSR = ephysData.header.ephys.ephys.sampleRate;
ephysTime = (0:length(ephysTrace)-1)./ephysSR;


nSpikeHW = ceil(tSpikeWnd*ephysSR/2); %samples for half width of spike
ephysTrace_Flt=medfilt1(ephysTrace,ceil(tFiltWnd*ephysSR));
ephysTrace_Sig = ephysTrace_Flt-ephysTrace;
ephysTrace_ZS = zscore(ephysTrace_Sig);
ephysTrace_ZS(1:nSpikeHW)=0;
indC=find(abs(ephysTrace_ZS)>ManVot);
for n=1:length(indC)
    ephysTrace_ZS(indC(n)-nSpikeHW:indC(n)+nSpikeHW)=0;  %2ms for 10k sampel rate
end

spikeTimes=(detectSpikes_v2(ephysTrace_ZS,5,4,2*nSpikeHW)-1)/ephysSR;
BinEdges = (0:ceil(ephysTime(end)/tBin))*tBin;
dFR=histc(spikeTimes,BinEdges)/tBin;
tHistTime = BinEdges(1:end-1)+0.5*tBin;
dFR = dFR(1:end-1);

[~,strFn,ext]=fileparts(xlsfile);

hFig = figure('name', [strFn ':Calcium_Ephys'],'pointer','fullcrosshair');
hZoom = zoom();
hPan = pan();
ax=zeros(1,4);
axTime_e = max([InsTime(end) ephysTime(end)]);

ax(1) = subplot(4,1,1);
plot(InsTime,InsVal_del);
set(gca,'box','off','xlim',[0 axTime_e],'ylim',[min(InsVal_del(:)) max(InsVal_del(:))]+[-5 5]);
ylabel('\DeltaF/F_0 (%)');
title('Calcium');

ax(2) = subplot(4,1,2);
[ha]=plotyy(InsTime,InsVal,tHistTime,dFR);
set(ha(1),'box','off','xlim',[0 axTime_e],'ylim',[min(InsVal(:)) max(InsVal(:))]+[-5 5]);
set(ha(2),'box','off','xlim',[0 axTime_e]);
set(get(ha(1),'YLabel'),'String','Abs\_F');
set(get(ha(2),'YLabel'),'String','FR (spks/s)');
title('Calcium');

ax(3) = subplot(4,1,3);
plot(ephysTime,ephysTrace_ZS);
if(~isempty(spikeTimes))
    hold on;
    plot(spikeTimes,5,'r+');
end
ylabel('ZScore Amp');
title('Spike Detection');

ax(4) = subplot(4,1,4);
plot(ephysTime,ephysTrace);
min_Val = min(ephysTrace);
max_Val = max(ephysTrace);
set(gca,'box','off','xlim',[0 axTime_e],'ylim',[min_Val max_Val]+[-0.05 0.05]*(max_Val-min_Val));
ylabel('Amp (mV)');
xlabel('Time (s)');
title('ephys');

setAxesZoomMotion(hZoom,ax,'horizontal');
setAxesPanMotion(hPan,ax,'horizontal');
linkaxes(ax,'x');


hgsave(gcf,[xlsfile(1:end-length(ext)) '_CE.fig']);
hgsave(gcf,[xlsfile(1:end-length(ext)) ' .jpg']);