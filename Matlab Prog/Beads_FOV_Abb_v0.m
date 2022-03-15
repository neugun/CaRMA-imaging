strDir ='Y:\Imaging\2P345\20160630';
clFns = FindFiles_RegExp('FineZ_FOV_\d{5}.tif', strDir)';
nFileCount = length(clFns);

%clInfoZ={'x','y','z','z2','bz2','ss','se','stp'};
matInfoZ = zeros(nFileCount,8);

for nFile = 1%1:nFileCount
    strFn = clFns{nFile};
    disp(['getting info from file:' strFn]);
    [stHDR,matImg] = scanimage.util.opentif(strFn);
    matInfoZ(nFile,:) = [stHDR.SI.hMotors.motorPosition stHDR.SI.hMotors.motorSecondMotorZEnable ...
        stHDR.SI.hStackManager.stackZStartPos stHDR.SI.hStackManager.stackZEndPos ...
        stHDR.SI.hStackManager.stackZStepSize];
    
    strFn_Seg = [strFn(1:end-4) '_Seg.tif'];
    matSeg = readTiffStack_IJ(strFn_Seg);
    matImg = im2uint16(squeeze(matImg));
    if(any(size(matImg)~=size(matSeg)))
        warning('the size of imagestack and the size of segmentation is different. Further Analysis is skipped' );
    else
        nZCount = size(matSeg,3);
        stats = regionprops(matSeg,'PixelIdxList','Area');
        A=[stats.Area];
        idxUse = find(A>0);
        nBeadsCount = length(idxUse);
        matBeadsZ = zeros(nBeadsCount,5);%[sz,x,y,z,idxZ];
        nRCCount = ceil(sqrt(nBeadsCount));
        
        for nBead=1:nBeadsCount
            matSeg(stats(idxUse(nBead)).PixelIdxList) = nBead;
        end
        figure;
        for nBead = 1:nBeadsCount
            stBeadStats = struct('Area',num2cell(zeros(nZCount,1)),...
                'Centroid',repmat({zeros(1,2)},[nZCount,1]),...
                'BoundingBox',repmat({zeros(1,4)},[nZCount,1]));
            
            for nZ =1:nZCount
                bwBead = matSeg(:,:,nZ)==nBead;
                if(any(bwBead(:)))
                    stats = regionprops(bwBead, 'Centroid','BoundingBox','Area');
                    stBeadStats(nZ) = stats(1);
                    %                     R(nZ) = sqrt(bwarea(bwBead)/pi);
                    %                     SE = strel('disk', ceil(2*R(nZ))+2, 8);
                    %                     bwBead_D = imdilate(bwBead,SE);
                    %                     stats = regionprops(bwBead_D, 'BoundingBox');
                    %                     BB = ceil(stats(1).BoundingBox);
                    %                 idxBB_R = BB(2)+(1:BB(4));
                    %                 idxBB_C = BB(1)+(1:BB(3));
                    %                     imgBead = matImg(:,:,nZ);
                    %                     Image = imgBead;
                    %                     Image = medfilt2(imgBead,[2 2]);
                    %                     Image = double(imgBead);
                    %                     Image = (Image-min(Image(:)))/(max(Image(:))-min(Image(:)));
                    %                     FM(nZ) = fmeasure(Image, 'WAVS' , BB);
                    %                     Image = imcrop(Image, BB);
                    %                     clf;
                    %                     imshow(Image,[]);
                    %                     title(num2str(nZ));
                    %                     pause(0.1);
                end
            end
            A = [stBeadStats.Area];
            [~,idxZ] = max(A);
            BB = stBeadStats(idxZ).BoundingBox;
            BBCrop = BB +[-BB(3) -BB(4) 2*BB(3) 2*BB(4)];
            Image = imcrop(matImg(:,:,idxZ),BBCrop);
            subplot(nRCCount,nRCCount,nBead)
            imshow(Image,[]);
            Z = matInfoZ(nFile,3)+matInfoZ(nFile,5)*matInfoZ(nFile,6)+matInfoZ(nFile,8)*(idxZ-1);
            matBeadsZ(nBead,:) = [0, stBeadStats(idxZ).Centroid, Z,idxZ];
        end
        %%
        
        idxZ = min(matBeadsZ(:,5));
        bwFOV = double(matSeg(:,:,idxZ)>0);
        h = fspecial('gaussian', 40, 30);
        FOV_f = imfilter(bwFOV, h);
        L = graythresh(FOV_f);
        bwFOV_f = im2bw(FOV_f,L);
        stats = regionprops(bwFOV_f, 'Centroid');
        figure;
        subplot(2,2,1);
        imshow(label2rgb(bwFOV,'jet'));
        subplot(2,2,2);
        imshow(FOV_f,[]);
        subplot(2,2,3);
        imshow(bwFOV_f,[]);
        hold on;
        plot(stats.Centroid(1),stats.Centroid(2),'o');
    end
end