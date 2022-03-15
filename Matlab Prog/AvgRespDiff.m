strFn_Bef = 'Y:\20150821\AVG_recording-ANM287315_20150817_170226-2_bef.tif';
strFn_Aft = 'Y:\20150821\AVG_recording-ANM287315_20150817_170226-2_aft.tif';
strFn_Drk = 'Y:\20150821\AVG_recording-ANM287315_20150817_170226-2_drinking.tif';

matImg_Bef = double(imread(strFn_Bef));
matImg_Aft = double(imread(strFn_Aft));
matImg_Drk = double(imread(strFn_Drk));

Diff1=matImg_Drk-matImg_Bef;
Diff2 = matImg_Aft-matImg_Drk;
Diff3= matImg_Aft-matImg_Bef;

hFig1 = figure;
imagesc(Diff1);
colormap('gray');
colorbar;
axis image;
set(gca,'xtick',[],'ytick',[]);
hgsave(hFig1,'Y:\20150821\Diff1.fig');

hFig2 = figure;
imagesc(Diff2);
colormap('gray');
colorbar;
axis image;
set(gca,'xtick',[],'ytick',[]);
hgsave(hFig2,'Y:\20150821\Diff2.fig');

hFig3 = figure;
imagesc(Diff3);
colormap('gray');
colorbar;
axis image;
set(gca,'xtick',[],'ytick',[]);
hgsave(hFig3,'Y:\20150821\Diff3.fig');
