strDir ='Y:\Imaging\2P345\20160630';
clFns = FindFiles_RegExp('FineZ_FOV_\d{5}.tif', strDir)';
nFileCount = length(clFns);

%clInfoZ={'x','y','z','z2','bz2','ss','se','stp'};
matInfoZ = zeros(nFileCount,8);

for nFile = 1:nFileCount
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
        writeTiffStack_IJ(matSeg,[strFn(1:end-4) '_Seg_Cl.tif']);
        hFigB = figure('Name','BeadsZ');
        for nBead = 1:nBeadsCount
            stBeadStats = struct('Area',num2cell(zeros(nZCount,1)),...
                'Centroid',repmat({zeros(1,2)},[nZCount,1]),...
                'BoundingBox',repmat({zeros(1,4)},[nZCount,1]));
            
            for nZ =1:nZCount
                bwBead = matSeg(:,:,nZ)==nBead;
                if(any(bwBead(:)))
                    stats = regionprops(bwBead, 'Centroid','BoundingBox','Area');
                    stBeadStats(nZ) = stats(1);
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
        h = fspecial('gaussian', 150, 50);
        FOV_f = imfilter(bwFOV, h);
        L = graythresh(FOV_f);
        bwFOV_f = im2bw(FOV_f,L);
        stats = regionprops(bwFOV_f, 'Centroid','Area');
        if(length(stats)>1)
            [~,idx] = max([stats.Area]);
            stats = stats(idx);
        end
        hFigC=figure('Name','FOV_Center');
        subplot(2,2,1);
        imshow(label2rgb(bwFOV,'jet'));
        subplot(2,2,2);
        imshow(FOV_f,[]);
        subplot(2,2,3);
        imshow(bwFOV_f,[]);
        hold on;
        plot(stats.Centroid(1),stats.Centroid(2),'o');
        stFOVZ.matBeadsZ = matBeadsZ;
        stFOVZ.Center = stats.Centroid;
        
        strFn_Sav = [ strFn(1:end-4) '_BeadsZ.fig'];
        hgsave(hFigB,strFn_Sav);
        strFn_Sav = [ strFn(1:end-4) '_FOVC.fig'];
        hgsave(hFigC,strFn_Sav);
        strFn_Sav = [ strFn(1:end-4) '_stFOVZ.mat'];
        save(strFn_Sav,'stFOVZ');
        
        close(hFigB);
        close(hFigC);
    end
end

save([strDir '\matInfoZ.mat'],'matInfoZ');