strDir = 'Y:\Imaging\2P345\20160620';
clFns = FindFiles_RegExp('Fine_ZRes_\d{5}.tif', strDir)';

nFileCount = length(clFns);

%clInfoZ={'x','y','z','z2','bz2','ss','se','stp','zm','zwl','zwh','Dia'};
matInfoZ = zeros(nFileCount,12);

for nFile = 1:nFileCount
    strFn_Fig = [strDir '\' num2str(nFile) 'zfig.fig'];
    disp(['loading file:' strFn_Fig]);
    hFig = hgload(strFn_Fig);
    
    zi=get(findobj(hFig,'Marker','none','Type','Line'),'YData');
    [~,zim_ind]=max(zi);
    zm=get(findobj(hFig,'Marker','*'),'XData');
    zw=get(findobj(gcf,'Marker','o'),'XData');
    zw = cell2mat(zw);
    zwl = min(zw(:));
    zwh = max(zw(:));
    close(hFig);
    
    strFn = clFns{nFile};
    disp(['getting info from file:' strFn]);
    [stHDR,matImg] = scanimage.util.opentif(strFn);
    matInfoZ(nFile,1:11) = [stHDR.SI.hMotors.motorPosition stHDR.SI.hMotors.motorSecondMotorZEnable ...
                                          stHDR.SI.hStackManager.stackZStartPos stHDR.SI.hStackManager.stackZEndPos ...
                                          stHDR.SI.hStackManager.stackZStepSize zm zwl zwh];
                                      
   
      Image = double(matImg(:,:,1,zim_ind));
      Image = (Image-min(Image(:)))/(max(Image(:))-min(Image(:)));
      level = graythresh(Image);
      level = max(level,0.5);
      bwImg = im2bw(Image,level);
      SE = strel('disk', 10);
      bwImg = imclose(bwImg,SE);
      lbImg =bwlabel(bwImg,8);
      stats = regionprops(bwImg,lbImg, 'Centroid','MeanIntensity');
      matC = reshape([stats.Centroid],2,[])';
      ImgC = [size(Image,2)/2 size(Image,1)/2];
      k = dsearchn(matC,ImgC);

      bwSel = lbImg == stats(k).MeanIntensity;
      SE = strel('rectangle', [30,30]);
      bwSel = imdilate(bwSel,SE);
      
      stats = regionprops(bwSel, 'BoundingBox');
      BB = ceil(stats(1).BoundingBox);
      idxBB_R = BB(2)+(1:BB(4));
      idxBB_C = BB(1)+(1:BB(3));
      ImageS = Image.*double(bwSel);
      ImageMax = max(ImageS(:));
      bwImageS = ImageS>=(ImageMax/2);
      Area = sum(bwImageS(:));
      matInfoZ(nFile,12) = sqrt(Area);
      hFig = figure;
      subplot(2,2,[1 2]);
      imshow(Image);
      hold on;
      rectangle('Position',BB,'EdgeColor','r');
      subplot(2,2,3)
      imshow(ImageS(idxBB_R,idxBB_C),[]);
      subplot(2,2,4);
      imshow(bwImageS(idxBB_R,idxBB_C),[]);
      hgsave(hFig,[strFn(1:end-3) '_Beads.fig']);
      close(hFig);
end

save([strDir '\matInfoZ.mat'],'matInfoZ');

%%
step = 10.08;
idxUse = [1:11 13:size(matInfoZ,1)];
matInfoZ = matInfoZ(idxUse,:);
Z=matInfoZ(:,3)+matInfoZ(:,6)+matInfoZ(:,9);
B = matInfoZ(:,10:11)-matInfoZ(:,[9 9]);
X=(0:size(matInfoZ)-1)*step;
Bp=B(:,[2 1])';
Bp(2,:)=-Bp(2,:);
figure;shadedErrorBar(X,Z,Bp,{'r*-'});
%%
Y = matInfoZ(:,12);
Y= Y/Y(24);
figure;plot(X,Y,'*-');

%%
for n=1:length(Z);
    ZZ = Z(n);
    idx = find(Z>ZZ+400,1);
    if(~isempty(idx))
        d(1,n) = Z(n);
        d(2,n) = X(n);
        d(3,n) = X(idx)-X(n);
    else
        break;
    end
end