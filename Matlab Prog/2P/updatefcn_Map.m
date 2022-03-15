function out_txt = updatefcn_Map(~,event_obj)
strType = get(event_obj.Target,'Type');
pos = get(event_obj,'Position');
if(strcmp(strType,'image'))
    cData = get(event_obj.Target,'CData');
    Val = cData(pos(2),pos(1));
    idxOrder = get(event_obj.Target,'UserData');
    if(~isempty(idxOrder))
        bRev = strcmp(get(gca,'ydir'),'reverse');
        if(bRev)
            idxOrder = fliplr(idxOrder);
        end
        nID = idxOrder(pos(2));
        out_txt = {['[X,Y]:' num2str(pos(1)) ',' num2str(pos(2))], ['NID:' num2str(nID)],['Val:' num2str(Val)]};
        hFig = findobj('-regexp','Name','Neuron-ROIs-\d{1,3}\(\d{1,3}\)');
        if(length(hFig)==1)
            Update_Neuron_ROIs(hFig,nID);
        end
    else
        out_txt = {['[X,Y]:' num2str(pos(1)) ',' num2str(pos(2))], ['Val:' num2str(Val)]};
    end
else
    out_txt = {['X:' num2str(pos(1))], ['Y:' num2str(pos(2))]};
    if(length(pos)==3)
        out_txt{3} = ['Z:' num2str(pos(3))];
    end
end