function Update_Neuron_ROIs(Src,vtNID)
Data = get(Src,'UserData');
bContours = Data.bContours;

[nROICount,~] = size(Data.hContours);
vtNID = intersect(vtNID,1:nROICount,'stable');

Data.bHide=true(size(Data.bHide));
Data.bHide(vtNID,:)=false;

lgShow = (~Data.bHide)&bContours;
lgHide = Data.bHide&bContours;
set(Data.hContours(lgShow),'Visible','on');
set(Data.hTexts(lgShow),'Visible','on');

set(Data.hContours(lgHide),'Visible','off');
set(Data.hTexts(lgHide),'Visible','off');

Data.cur_ind = vtNID(1);
set(Src,'Name',['Neuron-ROIs-' num2str(nROICount) '(' num2str(Data.cur_ind) ')'])
set(Src,'UserData',Data);