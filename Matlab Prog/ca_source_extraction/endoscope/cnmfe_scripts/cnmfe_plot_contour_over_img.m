function hFig = cnmfe_plot_contour_over_img(neuron,movm,vtSegShow,hParent)
%saintgene 2017/09/07

A=reshape(full(neuron.A),neuron.options.d1,neuron.options.d2,[]);

if(nargin<2||isempty(movm))
    movm = neuron.Cn;
    bAdjust = false;
else
    bAdjust = true;
end

[X,Y]=meshgrid(1:size(A,2),1:size(A,1),1:size(A,3));
X1=squeeze(sum(sum(X.*A))./sum(sum(A)));
Y1=squeeze(sum(sum(Y.*A))./sum(sum(A)));
segcentroid = [X1 Y1];

nSegCount  = size(A,3);

if(nargin <3 || isempty(vtSegShow))
    vtSegShow = 1:nSegCount;
end
nSegCount_Show = length(vtSegShow);

if(size(segcentroid,1)~=nSegCount)
    error('SG:Mismatch_Para', 'the number of segments are different from the number of their centroid!');
end

A = A(:,:,vtSegShow);
segcentroid = segcentroid(vtSegShow,:);

if(nargin<4)
    hFig = figure('Name','Contours overlay Image');
else
    hFig = hParent;
end

movm_rgb = repmat(mat2gray(movm),[1 1 3]);
%figure; imshow(movm_rgb0,[]);
if(bAdjust)
    movm_rgb = imadjust(movm_rgb,[0 0 0;0.4 0.4 0.4],[]);
end
figure(hFig);
hImg = imshow(movm_rgb,[]);
hold on;

cmap = hsv(nSegCount_Show);
hContour = zeros(nSegCount_Show,1);
hText = zeros(nSegCount_Show,1);
for nSeg=1:nSegCount_Show
    CPos = neuron.Coor{nSeg};
    CPos = medfilt1(CPos(:,2:end),5,[],2);
    CPos = medfilt1(CPos(:,1:end),5,[],2);
    hContour(nSeg) = plot(CPos(1,[1:end 1]),CPos(2,[1:end 1]),'color',cmap(nSeg,:),'linewidth',2);
    hText(nSeg) = text(segcentroid(nSeg,1), segcentroid(nSeg,2), num2str(nSeg), 'horizontalalignment','c', 'verticalalignment','m');
    set(hFig,'Name',['Contours overlay Image:' num2str(nSeg)]);
    %pause(0.1);
end

Data.hContour = hContour;
Data.hText = hText;
Data.cur_ind = 0;
Data.ica_seg = A;
Data.segcent = segcentroid;
Data.bVisible = true;
Data.bHide = false(size(hContour));

set(hImg,'UserData',Data,'ButtonDownFcn',@ShiftRect);

function ShiftRect(src,eventdata) %#ok<INUSD>

Data = get(src,'UserData');
nROICount = length(Data.hContour);
cmap = hsv(nROICount);

iWidth = size(get(src,'CData'),2);
Pts = get(get(src,'Parent'),'currentpoint');
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
    set(Data.hContour(~Data.bHide),'Visible',strContour);
    set(Data.hText(~Data.bHide),'Visible',strContour);
end

if(Data.cur_ind ~= 0)
    Clr = cmap(Data.cur_ind,:);
    set(Data.hContour(Data.cur_ind),'Color',Clr);
    set(Data.hText(Data.cur_ind),'Color','k');
    if(~Data.bVisible)
        set(Data.hContour(Data.cur_ind),'Visible','off');
        set(Data.hText(Data.cur_ind),'Visible','off');
    end
    
    if(bExtend)%%double clik left and right button hide 
        Data.bHide(Data.cur_ind) = ~Data.bHide(Data.cur_ind);
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
    set(Data.hContour(Data.cur_ind),'Color',strClr );
    set(Data.hText(Data.cur_ind),'Color',strClr);
    if(~(Data.bVisible||Data.bHide(Data.cur_ind)))
        set(Data.hContour(Data.cur_ind),'Visible','on');
        set(Data.hText(Data.cur_ind),'Visible','on');
    end
else
    Data.cur_ind = 0;
end

set(src,'UserData',Data);