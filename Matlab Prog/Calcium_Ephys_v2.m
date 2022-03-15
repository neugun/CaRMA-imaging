function hFig = Calcium_Ephys_v2(strFigName,ManVot)
if(nargin==0)
strFigName = '\\tier2\sternson\Shengjin & Chris\categorised GCaMP6F Data\FD 06_03 c1 c2 05_28 c1 c5 c16 bursting slow dCa\05_28 c1\05-28-14-19-20-08._CE.fig';
end
if(nargin<2)
    ManVot = 80;
end

tFiltWnd = 30e-3; %30ms
tSpikeWnd = 2e-3; %2ms
tBin = 0.3; % s

hFig = hgload(strFigName);
hAxes=findobj(hFig,'type','axes');
hLines=findobj(hAxes(1),'type','line');
ephysTrace=get(hLines(1),'YData');
ephysTime = get(hLines(1),'XData');
ephysSR  = 1/median(diff(ephysTime));

hLines=findobj(hAxes(2),'type','line');
InsVal=get(hLines(1),'YData');
InsTime = get(hLines(1),'XData');
ImgSR = 1/median(diff(InsTime));

close(hFig);

%%
% InsVal(301:end)=[];
% InsTime(301:end)=[];
% InsVal_del(301:end)=[];
%%

nSpikeHW = ceil(tSpikeWnd*ephysSR/2); %samples for half width of spike
ephysTrace_Flt=medfilt1(ephysTrace,ceil(tFiltWnd*ephysSR));
ephysTrace_Sig = ephysTrace_Flt-ephysTrace;
ephysTrace_ZS = zscore(ephysTrace_Sig);
ephysTrace_ZS(1:nSpikeHW)=0;
indC=find(abs(ephysTrace_ZS)>ManVot);
for n=1:length(indC)
    ephysTrace_ZS(indC(n)-nSpikeHW:indC(n)+nSpikeHW)=0;  %2ms for 10k sampel rate
end

spikeTimes=(detectSpikes(ephysTrace_ZS,5,4,2*nSpikeHW)-1)/ephysSR;
BinEdges = (0:ceil(ephysTime(end)/tBin))*tBin;
dFR=histc(spikeTimes,BinEdges)/tBin;
tHistTime = BinEdges(1:end-1)+0.5*tBin;
dFR = dFR(1:end-1);

hFig = figure('name', 'Calcium_Ephys','pointer','fullcrosshair');
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
set(get(ha(2),'YLabel'),'String','FR (spikes/s)');
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

strTrim = '_CE.fig';
if(strFigName(end-7)=='.')
    strTrim = '._CE.fig';
end
hgsave(hFig,[strFigName(1:end-length(strTrim)) '_CE2.fig']);

