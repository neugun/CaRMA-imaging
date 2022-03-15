load('Y:\from_nrs\PVH_Analysis\ANM287315\matRes_CS_Sel_Match(nosc).mat')
figure;imagesc(matRes);
figure;imagesc(matRes(:,1:15));
matRes = matRes(:,1:15);
Y=pdist(matRes,'correlation');
Z = linkage(Y);
dendrogram(Z)
figure;imagesc(matRes);
dendrogram(Z)
c = cophenet(Z,Y)
Z = linkage(Y,'average');
c = cophenet(Z,Y)
Z = linkage(Y,'complete');
c = cophenet(Z,Y)
Z = linkage(Y,'centroid');
c = cophenet(Z,Y)
clc
Y=pdist(matRes,'correlation');
Z = linkage(Y);
dendrogram(Z)
Y=pdist(matRes,'spearman');
Z = linkage(Y);
dendrogram(Z)
clc
Y=pdist(matRes','correlation');
Z = linkage(Y);
dendrogram(Z)
clc
clear
clc
load('Y:\PVH_Analysis\ANM287315\matRes_CS_Sel_Match(All).mat')
figure;imagesc(matRes);
Y=pdist(matRes,'correlation');
Z = linkage(Y);
dendrogram(Z)
c = cophenet(Z,Y)
Y=pdist(matRes','correlation');
Z = linkage(Y);
dendrogram(Z)
c = cophenet(Z,Y)
clear
clc
load('Y:\PVH_Analysis\ANM287315\matRes_CS_Sel_Match(nosc).mat')
matRes = matRes(:,1:15);
load('Y:\PVH_Analysis\ANM287315\matRes_CS_Sel_Match(nosc).mat')
matRes(:,3)=matRes(:,3)-matRes(:,1);
matRes(:,4)=matRes(:,4)-matRes(:,3);
matRes(:,6)=matRes(:,6)-matRes(:,5);
matRes(:,7)=matRes(:,7)-matRes(:,6);
matRes(:,8)=matRes(:,8)-matRes(:,7);
matRes(:,10)=matRes(:,10)-matRes(:,9);
matRes(:,11)=matRes(:,11)-matRes(:,9);
matRes(:,13)=matRes(:,13)-matRes(:,12);
matRes(:,15)=matRes(:,15)-matRes(:,14);
matRes = matRes(:,1:15);
figure;imagesc(matRes);
Y=pdist(matRes,'correlation');
Z = linkage(Y);
dendrogram(Z)
Y=pdist(matRes,'correlation');
Z = linkage(Y);
dendrogram(Z)
c = cophenet(Z,Y)
dendrogram(Z,0)
load('Y:\PVH_Analysis\ANM287315\matRes_CS_Sel_Match(nosc).mat')
matRes = matRes(:,1:15);
figure;imagesc(matRes);
Y=pdist(matRes,'correlation');
Z = linkage(Y);
dendrogram(Z,0)
load('Y:\PVH_Analysis\ANM287315\matRes_CS_Sel_Match(All).mat')
Y=pdist(matRes,'correlation');
Z = linkage(Y);
dendrogram(Z,0)
clc
PVH_matRes_Diff
matRes_Diff = matRes(:,[2:4 6:8 10 11:2:23]);
figure;imagesc(matRes);
figure;imagesc(matRes_Diff);
Y=pdist(matRes_Diff,'correlation');
Z = linkage(Y);
dendrogram(Z,0)
c = cophenet(Z,Y)
Y=pdist(matRes_Diff','correlation');
Z = linkage(Y);
dendrogram(Z,0)
c = cophenet(Z,Y)
clc
clear
clc
load('Y:\PVH_Analysis\ANM287315\matRes_Diff_CS_Sel_Match(nosc).mat')
PVH_matRes_Diff
matRes_Diff = matRes_Diff(:,1:10);
Z = linkage(Y);
dendrogram(Z)
figure;imagesc(matRes_Diff);
Y=pdist(matRes_Diff,'correlation');
Z = linkage(Y);
dendrogram(Z,0)
c = cophenet(Z,Y)
Y=pdist(matRes_Diff','correlation');
Z = linkage(Y);
dendrogram(Z,0)
c = cophenet(Z,Y)
clStates_Diff = clStates([2:4 6:8 10 11:2:23]);
clStates_Diff = clStates{[2:4 6:8 10 11:2:23]};
clStates_Diff = clStates([2:4 6:8 10 11:2:23]);
clc
hist(matRes_Diff(:))
hist(matRes_Diff(:),[-150:10:150])
hist(matRes_Diff(:),[-300:10:300])
idx0 =(matRes_Diff<20&&matRes_Diff>=-20);
idx0 =(matRes_Diff<20&matRes_Diff>=-20);
idx1 = matRes_Diff>=20;
idx_1 = matRes_Diff<-20;
matRes_Diff(idx0)=0;
matRes_Diff(idx1)=1;
matRes_Diff(idx_1) = -1;
Y=pdist(matRes_Diff,'correlation');
Z = linkage(Y);
dendrogram(Z,0)
c = cophenet(Z,Y)
Y=pdist(matRes_Diff','correlation');
Z = linkage(Y);
dendrogram(Z,0)
c = cophenet(Z,Y)
Y=pdist(matRes_Diff,'correlation');
Y=pdist(matRes_Diff);
Z = linkage(Y);
dendrogram(Z,0)
Y=pdist(matRes_Diff,'cityblock');
Z = linkage(Y);
dendrogram(Z,0)
figure;imagesc(matRes_Diff);
clc
clear
clc
load('Y:\PVH_Analysis\ANM287315\matRes_Diff_CS_Sel_Match(All).mat')
hist(matRes_Diff(:),[-300:10:300])
Y=pdist(matRes_Diff,'cityblock');
Z = linkage(Y);
dendrogram(Z,0)
hist(matRes_Diff(:),[-300:5:300])
load('Y:\PVH_Analysis\ANM287315\matRes_Diff_CS_Sel_Match(All).mat')
hist(matRes_Diff(:),[-300:5:300])
Y=pdist(matRes_Diff,'cityblock');
Z = linkage(Y);
dendrogram(Z,0)
load('Y:\PVH_Analysis\ANM287315\matRes_Diff_CS_Sel_Match(All).mat')
Y=pdist(matRes_Diff,'cityblock');
Z = linkage(Y);
dendrogram(Z,0)
load('Y:\PVH_Analysis\ANM287315\matRes_Diff_3Lvl_CS_Sel_Match(nosc).mat')
clc
clear
clc
load('Y:\PVH_Analysis\ANM287315\AVGImgData.mat')
img_Diff=cat(3,clImgData{2}-clImgData{1},clImgData{1}-clImgData{2})
clc
imwrite(img_Diff,'Diff_FD.tif');
help tiff
t = Tiff('myfile.tif','w');
t.write(img_Diff);
imdata=img_Diff;
t.setTag('ImageLength',size(imdata,1));
t.setTag('ImageWidth', size(imdata,2));
t.setTag('Photometric', Tiff.Photometric.RGB);
t.setTag('BitsPerSample', 16);
t.setTag('SamplesPerPixel', size(imdata,3));
t.write(imdata);
t.close();
t.setTag('Photometric', Tiff.Photometric.uint16);
t.close
clear
clc
load('Y:\PVH_Analysis\ANM287315\AVGImgData.mat')
r=clImgData{2}-clImgData{1};
g = zeros(size(r),'uint16');
b = clImgData{1}-clImgData{2};
imdata = cat(3,r,g,b);
imwrite(imdata,'diff_fd.tif');
imdata = cat(3,r,b);
imwrite(imdata,'diff_fd.tif');
clc
imdata = cat(3,r,g,b);
imwrite(imdata,'diff_fd.tif');
r=clImgData{3}-clImgData{1};
b = clImgData{1}-clImgData{3};
imdata = cat(3,r,g,b);
imwrite(imdata,'diff_fd2.tif');
imdata = cat(3,r,b,g);
imwrite(imdata,'diff_fd2.tif');
clear
clc
vtDiff = [2 1;3 1;4 3;6 5;7 6;8 7;10 9;11 9; 13 12;15 14;17 16;19 18;21 20;23 22];
PVH_States_ImgDiff
SegOverlayDiffImg
clc
clear
SegOverlayDiffImg
doc imshow
figure;imshow(movm)
figure;imshow(double(movm))
figure;imshow(double(movm)/double(max(movm(:))))
SegOverlayDiffImg
PVH_States_ImgDiff
clc
PVH_States_ImgDiff
SegOverlayDiffImg
CLC
clc
clear
clc
load('matRes_CS_Sel_Match(nosc).mat')
doc zscore
matRes = zscore(matRes,0,2);
load('matRes_CS_Sel_Match(nosc).mat')
matRes = zscore(matRes);
Y=pdist(matRes,'correlation');
Z = linkage(Y);
c = cophenet(Z,Y)
dendrogram(Z,0)
load('matRes_Diff_CS_Sel_Match(nosc).mat')
matRes= zscore(matRes_Diff);
Y=pdist(matRes,'correlation');
Z = linkage(Y);
c = cophenet(Z,Y)
dendrogram(Z,0)
load('matRes_Diff_CS_Sel_Match(nosc).mat')
clear
clc
load('matRes_Diff_CS_Sel_Match(nosc).mat')
[coeff,score,latent] = pca(matRes_Diff);
cumsum(latent)/sum(latent)*100
score_3= score(:,1:3);
doc scatter
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3))
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),'.')
set(gca,'grid','off');
set(gca,'grid','none');
box on;
view(0,45);
view(45,45);
view(90,45);
view(90,90);
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),size(score_3,1),'.')
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),3,size(score_3,1),'.')
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),3,size(score_3,1))
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),3,1:size(score_3,1))
get(gca)
CaptureFigVid_Example
clc
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),3,1:size(score_3,1))
set(gca,'grid','none','box','off');
set(gca,'grid','none','box','on');
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),3,1:size(score_3,1))
set(gca,'grid','none','box','on');
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markertype','.')
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'.')
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),16,1:size(score_3,1),'.')
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markerfacecolor','auto')
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markerfacecolor','flat')
set(gca,'grid','none','box','on');
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markerfacecolor','flat')
set(gca,'grid','none','box','on');
view
get(gca,'view')
get(gca,'xlim')
get(gca,'ylim')
get(gca,'zlim')
set(gca,'xlim',[-600 200],'ylim',[-400 200],'zlim',[-150 100]);
clc
load('Y:\PVH_Analysis\ANM287315\clStates_Diff.mat')
Y=pdist(matRes_Diff);
Z = linkage(Y);
c = cophenet(Z,Y)
dendrogram(Z,0)
Y=pdist(score_3);
Z = linkage(Y);
c = cophenet(Z,Y)
dendrogram(Z,0)
Z = linkage(Y,'centroid');
Y=pdist(matRes_Diff);
Z = linkage(Y,'centroid');
dendrogram(Z,0)
Z = linkage(Y,'average');
dendrogram(Z,0)
clc
Y=pdist(score_3);
Z = linkage(Y,'average');
dendrogram(Z,0)
c = cophenet(Z,Y)
clc
load('matRes_CS_Sel_Match(nosc).mat')
Y=pdist(matRes);
Z = linkage(Y);
dendrogram(Z,0)
c = cophenet(Z,Y)
Z = linkage(Y,'centroid');
Z = linkage(Y,'average');
dendrogram(Z,0)
c = cophenet(Z,Y)
[coeff,score,latent] = pca(matRes);
cumsum(latent)/sum(latent)*100
matRes = matRes(:,1:15);
Y=pdist(matRes);
Z = linkage(Y);
dendrogram(Z,0)
cumsum(latent)/sum(latent)*100
[coeff,score,latent] = pca(matRes);
cumsum(latent)/sum(latent)*100
Y=pdist(score_3);
Z = linkage(Y);
dendrogram(Z,0)
Z = linkage(Y,'average');
dendrogram(Z,0)
Y=pdist(matRes');
Z = linkage(Y);
dendrogram(Z,0)
load('matRes_Diff_CS_Sel_Match(nosc).mat')
Y=pdist(matRes_Diff');
Z = linkage(Y);
dendrogram(Z,0)
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markerfacecolor','flat')
set(gca,'grid','none','box','on');
get(gca,'xlim')
get(gca,'ylim')
get(gca,'zlim')
set(gca,'xlim',[-600 200],'ylim',[-400 200],'zlim',[-150 100]);
figure;plot(100-cumsum(latent)/sum(latent)*100)
figure;plot(100-cumsum(latent)/sum(latent)*100,'o-')
clc
[coeff,score,latent] = pca(matRes_Diff);
cumsum(latent)/sum(latent)*100
figure;plot(100-cumsum(latent)/sum(latent)*100,'o-')
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markerfacecolor','flat')
set(gca,'grid','none','box','on');
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markerfacecolor','flat')
set(gca,'grid','none','box','on');
set(gca,'xlim',[-600 200],'ylim',[-400 200],'zlim',[-150 100]);
[coeff,score,latent] = pca(matRes);
cumsum(latent)/sum(latent)*100
score_3=score(:,1:3);
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markerfacecolor','flat')
set(gca,'grid','none','box','on');
get(gca,'xlim')
get(gca,'ylim')
get(gca,'zlim')
set(gca,'xlim',[-200 600],'ylim',[-200 200],'zlim',[-100 150]);
Y=pdist(score_3);
Z = linkage(Y);
dendrogram(Z,0)
Z = linkage(Y,'average');
dendrogram(Z,0)
clc
clear
load('matRes_Diff_CS_Sel_Match(nosc).mat')
[coeff,score,latent] = pca(matRes_Diff);
cumsum(latent)/sum(latent)*100
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markerfacecolor','flat')
score_3=score(:,1:3);
figure;scatter3(score_3(:,1),score_3(:,2),score_3(:,3),4,1:size(score_3,1),'markerfacecolor','flat')
set(gca,'grid','none','box','on');
idx = kmeans(score_3);
idx = kmeans(score_3,4);
idx1= idx==1;
idx2= idx==2;
idx3= idx==3;
idx4 = idx==4;
figure;scatter3(score_3(idx1,1),score_3(idx1,2),score_3(idx1,3),4,'r','markerfacecolor','flat')
hold on;
scatter3(score_3(idx2,1),score_3(idx2,2),score_3(idx2,3),4,'g','markerfacecolor','flat')
scatter3(score_3(idx3,1),score_3(idx3,2),score_3(idx3,3),4,'b','markerfacecolor','flat')
scatter3(score_3(idx4,1),score_3(idx4,2),score_3(idx4,3),4,'c','markerfacecolor','flat')
set(gca,'grid','none','box','on');
Cluster_Kmeans
clc
set(gca,'xlim',[-600 200],'ylim',[-400 200],'zlim',[-150 100]);
clc
idx1=find(idx==1);
idx2=find(idx==2);
idx3=find(idx==3);
idx4=find(idx==4);
idx5=find(idx==5);
clc
load('AVGImgData_Diff.mat')
load('clStates_Diff.mat')
PVH_Sel_Sig
PVH_States_Mean
clear
clc
load('matRes_CS_Sel_Match(nosc).mat')
matRes_Diff = matRes_Diff(:,1:10);
load('matRes_CS_Sel_Match(All).mat')
load('matRes_Diff_CS_Sel_Match(nosc).mat')
clear
clc
load('matRes_CS_Sel_Match(nosc).mat')
Y=pdist(matRes');
matRes = matRes(:,1:15);
Y=pdist(matRes');
Z = linkage(Y);
dendrogram(Z,0)
get(gca,'xticklabel');
a=get(gca,'xticklabel');
b=str2num(a);
xticklabel = clStates(b);
set(gca,'xticklabel',xticklabel);
dendrogram(Z,0)
a=get(gca,'xticklabel');
b=str2num(a);
xticklabel = clStates(b);
set(gca,'xticklabel',xticklabel);
Y=pdist(matRes','correlation');
Z = linkage(Y);
dendrogram(Z,0)
a=get(gca,'xticklabel');
b=str2num(a);
xticklabel = clStates(b);
set(gca,'xticklabel',xticklabel);
clc
clear
clc
load('matRes_Diff_CS_Sel_Match(nosc).mat')
Y=pdist(matRes_Diff');
Z = linkage(Y);
dendrogram(Z,0)
a=get(gca,'xticklabel');
b=str2num(a);
load('clStates_Diff.mat')
xticklabel = clStates_Diff(b);
set(gca,'xticklabel',xticklabel);
clear
clc
load('matRes_CS_Sel_Match(nosc).mat')
matRes = matRes(:,1:15);
Y=pdist(matRes','correlation');
Z = linkage(Y);
dendrogram(Z,0)
a=get(gca,'xticklabel');
b=str2num(a);
xticklabel = clStates(b);
set(gca,'xticklabel',xticklabel);
clear
clc
load('matRes_Diff_CS_Sel_Match(nosc).mat')
Y=pdist(matRes');
Y=pdist(matRes_Diff);
Z = linkage(Y);
dendrogram(Z,0)
load('matRes_CS_Sel_Match(nosc).mat')
Y=pdist(matRes_Diff);
Z = linkage(Y);
load('matRes_Diff_CS_Sel_Match(nosc).mat')
Y=pdist(matRes_Diff);
Z = linkage(Y,'centroid');
clc
hist(matRes_Diff(:),-400:10:400)
hist(matRes_Diff(:),-200:10:200)
hist(matRes_Diff(:),-100:5:200)
hist(matRes_Diff(:),-100:2:200)
hist(matRes_Diff(:),-100:5:200)
box off;
clc
clear
load('Y:\lab meeting 20151123\km5_idx.mat')
idx2=idx2';
idx3=idx3';
idx4=idx4';
idx5=idx5';
Untitled3
clear
clc