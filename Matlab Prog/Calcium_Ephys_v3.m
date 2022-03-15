function hFig = Calcium_Ephys_v3(ephysFile,xlsfile,stOption)

if (nargin ==0)
    ephysFile = '\\tier2\sternson\Chris backup space\Slice Cell Data 14\11-19 c att GCaMP6F in arc and muscimol mM\AA0001\AA0001AAAA0011.xsg';
    xlsfile='\\tier2\sternson\Chris backup space\Slice Cell Data 14\11-19 c att GCaMP6F in arc and muscimol mM\Camera 1 GCaMP6f in arc AGRP 11-19-2014 24h FD\11-19-14-17-25-06 II.xls';
end

if(nargin < 3)
    stOption.ManVot = 70;
    stOption.tFiltWnd = 30e-3; %30ms
    stOption.tSpikeWnd = 2e-3; %2ms
    stOption.tBin = 0.3; % s
    stOption.dSpikeThresh = 5.0; %std
end

if(xlsfile(end)=='x')
    InsVal = xlsread(xlsfile);
    InsVal = InsVal(:,2)*100;
else
    try
        InsVal = dlmread(xlsfile,'',1,1)*100;
    catch
        InsVal = xlsread(xlsfile);
        InsVal = InsVal(:,2)*100;
    end
end

InsVal_del = (InsVal-mean(InsVal(1:30)))./mean(InsVal(1:30))*100;
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