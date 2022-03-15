function hFig = Calcium_Ephys_v2(strFigName,stOption_Sp)
if(nargin==0)
strFigName = 'E:\CE Data\NFD 05_14  c8 c12 c16 bursts and 1AP dCa\c8\05-14-14-19-58-13.890_CE2.fig';
end
if(nargin<2)
    stOption_Sp.tWnd = 5;
    stOption_Sp.tShift = 0.2;
    stOption_Sp.Freq_Img = 0.2:0.005:0.5;
    stOption_Sp.Freq_ephys = 200:10:900;
end


hFig = hgload(strFigName);
hAxes=findobj(hFig,'type','axes');
hLines=findobj(hAxes(1),'type','line');
ephysTrace=get(hLines(1),'YData');
ephysTime = get(hLines(1),'XData');
ephysSR  = 1/median(diff(ephysTime));

nAxesCount = length(hAxes);

if(nAxesCount == 3)
hLines=findobj(hAxes(2),'type','line');
end
if(nAxesCount == 5)
hLines=findobj(hAxes(4),'type','line');
end
InsVal=get(hLines(1),'YData');
InsTime = get(hLines(1),'XData');
ImgSR = 1/median(diff(InsTime));

close(hFig);

%%
Smp_Wnd_Img = 2^nextpow2(stOption_Sp.tWnd *ImgSR);
Smp_nOverlap_Img= ceil((stOption_Sp.tWnd- stOption_Sp.tShift)*ImgSR);
[Y_Img,F_Img,T_Img,P_Img]=spectrogram(InsVal,Smp_Wnd_Img,Smp_nOverlap_Img,stOption_Sp.Freq_Img,ImgSR);

Smp_Wnd_ephys = 2^nextpow2(stOption_Sp.tWnd *ephysSR);
Smp_nOverlap_ephys = ceil((stOption_Sp.tWnd- stOption_Sp.tShift)*ephysSR);
[Y_ephys,F_ephys,T_ephys,P_ephys]=spectrogram(ephysTrace,Smp_Wnd_ephys,Smp_nOverlap_ephys,stOption_Sp.Freq_ephys,ephysSR);

hFig = figure('name', 'Calcium_Ephys','pointer','fullcrosshair');
hZoom = zoom();
hPan = pan();
ax=zeros(1,4);
axTime_e = max([InsTime(end) ephysTime(end)]);

ax(1) = subplot(4,1,1);
imagesc(T_Img,F_Img,10*log10(abs(P_Img)));
set(ax(1),'YDir','normal','xlim',[0 axTime_e]);
xlabel('Time');
ylabel('Frequency (Hz)');
title('Calcium\_Spectrogram');

ax(2) = subplot(4,1,2);
plot(InsTime,InsVal);
set(gca,'box','off','xlim',[0 axTime_e],'ylim',[min(InsVal(:)) max(InsVal(:))]+[-5 5]);
ylabel('Abs\_Fluo (%)');
title('Calcium');

ax(3) = subplot(4,1,3);
imagesc(T_ephys,F_ephys,10*log10(abs(P_ephys)));
set(ax(3),'YDir','normal','xlim',[0 axTime_e]);
xlabel('Time');
ylabel('Frequency (Hz)');
title('Ephys\_Spectrogram');

ax(4) = subplot(4,1,4);
plot(ephysTime,ephysTrace);
min_Val = min(ephysTrace);
max_Val = max(ephysTrace);
set(gca,'box','off','xlim',[0 axTime_e],'ylim',[min_Val max_Val]+[-0.05 0.05]*(max_Val-min_Val));
ylabel('Amp (pA)');
xlabel('Time (s)');
title('ephys');

setAxesZoomMotion(hZoom,ax,'horizontal');
setAxesPanMotion(hPan,ax,'horizontal');
linkaxes(ax,'x');

strTrim = '_CE.fig';
if(strFigName(end-7)=='.')
    strTrim = '._CE.fig';
end
hgsave(hFig,[strFigName(1:end-length(strTrim)) '_CE_Sp.fig']);

