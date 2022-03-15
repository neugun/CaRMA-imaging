function hFig = Neuron_Spatial_Explorer_v1(strFn_Img,strDir_ROIs)
if(nargin == 0)
    strFn_Img = 'Z:\Imaging\2P345\20170826\ANM372320\ZStacks\Stack_FastZ_Reg\ANM372320_00002_reg_ZProj_ZStack_Correct_8P_Gamma0.45.tif';
    strDir_ROIs = 'Z:\Imaging\2P345\20170826\ANM372320\ZStacks\Stack_FastZ_Reg\2p_2X_ROIs';
end
strRexp_ROIs = 'N(\d{1,3})\.tif$';
clFn_ROIs = FindFiles_RegExp(strRexp_ROIs, strDir_ROIs, false)';
[clFn_ROIs,vtCounter] = SortFnByCounter(clFn_ROIs,strRexp_ROIs);

%%
ImgData = readTiffStack(strFn_Img);
[~,~,nZCount] = size(ImgData);
nColCount = 4;
nRowCount = ceil(nZCount/nColCount);
%%
hFig = figure('Name',['Neuron-ROIs-' num2str(vtCounter(end)) '(0)']);
hAs = gobjects(1,nZCount);
for nZ=1:nZCount
    hAs(nZ)=subplot(nRowCount,nColCount,nZ);
    imshow(ImgData(:,:,nZ),[]);
    hold on;
end

%%
idxROIs=1:vtCounter(end);
idxD = setdiff(idxROIs,vtCounter);
if(~isempty(idxD))
    disp(['Missed ROIs: ' num2str(idxD)]);
else
    nROICount = length(vtCounter);
    cmap = hsv(nROICount);
    cmap = cmap(randperm(nROICount),:);
    hContours = gobjects(nROICount,nZCount);
    hTexts = gobjects(nROICount,nZCount);
    for nROI = 1:nROICount
        disp(['Processing ROI: ' num2str(nROI)]);
        strFn_ROI = clFn_ROIs{nROI};
        ImgData_ROIs = readTiffStack(strFn_ROI);
        for nZ=1:nZCount
            ImgData_Z = ImgData_ROIs(:,:,nZ);
            bwROI = imfill(ImgData_Z==nROI,'holes');
            CPos = contourc(double(bwROI),1);
            tPos = median(CPos(:,2:end),2);
            if(~isempty(CPos))
                hContours(nROI,nZ) = plot(hAs(nZ),CPos(1,[2:end 2]),CPos(2,[2:end 2]),'color',cmap(nROI,:),'linewidth',1);
                hTexts(nROI,nZ) = text(hAs(nZ),tPos(1), tPos(2), num2str(nROI), 'horizontalalignment','c', 'verticalalignment','m','Color','k');
            end
            %[~,hContours(nROI,nZ)] = contour(hAs(nZ),bwROI,1,'color',cmap(nROI,:),'linewidth',2);
        end
    end
    bContours = isgraphics(hContours,'Line');
    Data.hContours = hContours;
    Data.bContours = bContours;
    Data.hTexts = hTexts;
    Data.cur_ind = 0;
    Data.cmap = cmap;
    Data.bVisible = true;
    Data.bHide = false(size(hContours));
    
    set(hFig,'UserData',Data,'ButtonDownFcn',@ShiftROIs_3D);
end

savefig(hFig,[fileparts(strFn_Img) filesep 'Neurons_ROIs_Overlay.fig']);

%%
function ShiftROIs_3D(src,eventdata) %#ok<INUSD>

Data = get(src,'UserData');
bContours = Data.bContours;

[nROICount,~] = size(Data.hContours);
cmap = Data.cmap;

Pos = get(src,'pos');
iWidth = Pos(3);
Pts = get(src,'currentpoint');
CurrentX = Pts(1);

if(CurrentX>0.3*iWidth) % click right side of image [0.3 1] to increase the number
    bInc = true;
else
    bInc = false; % % click left side of image [0 0.3] to increase the number
end

strButSel = get(gcf,'SelectionType');
bAlt = strcmp(strButSel,'alt'); %
bExtend = strcmp(strButSel,'extend');
if(bAlt) % (Ctl+left click)/(right click) to switch show all/one
    Data.bVisible = ~Data.bVisible;
    strContour = 'off';
    if(Data.bVisible)
        strContour = 'on';
    end
    set(Data.hContours(bContours&(~Data.bHide)),'Visible',strContour);
    set(Data.hTexts(bContours&(~Data.bHide)),'Visible',strContour);
end

if(Data.cur_ind ~= 0)
    Clr = cmap(Data.cur_ind,:);
    lgValid = bContours(Data.cur_ind,:);
    set(Data.hContours(Data.cur_ind,lgValid),'Color',Clr);
    set(Data.hTexts(Data.cur_ind,lgValid),'Color','k');
    if(~Data.bVisible)
        set(Data.hContours(Data.cur_ind,lgValid),'Visible','off');
        set(Data.hTexts(Data.cur_ind,lgValid),'Visible','off');
    end
    
    if(bExtend)%%clik both left and right button hide or Shift-click left mouse button.
        Data.bHide(Data.cur_ind,:) = ~Data.bHide(Data.cur_ind,:);
    end
end

switch(strButSel)
    case {'normal','open'}
        if(bInc)
            Data.cur_ind = Data.cur_ind +1;
        else
            Data.cur_ind = Data.cur_ind -1;
            if(Data.cur_ind <0)
                Data.cur_ind = nROICount;
            end
        end
end

if(Data.cur_ind>0 && Data.cur_ind<=nROICount)
    if(Data.bVisible)
        strClr = 'w';
    else
        strClr = 'r';
    end
    lgValid = bContours(Data.cur_ind,:);
    set(Data.hContours(Data.cur_ind,lgValid),'Color',strClr );
    set(Data.hTexts(Data.cur_ind,lgValid),'Color',strClr);
    strContour = 'on';
    if(all(Data.bHide(Data.cur_ind,:)))
        strContour = 'off';       
    end
    set(Data.hContours(Data.cur_ind,lgValid),'Visible',strContour);
    set(Data.hTexts(Data.cur_ind,lgValid),'Visible',strContour);
else
    Data.cur_ind = 0;
end

set(src,'Name',['Neuron-ROIs-' num2str(nROICount) '(' num2str(Data.cur_ind) ')'])
set(src,'UserData',Data);