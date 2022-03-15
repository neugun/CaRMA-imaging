function [vtFrm_BI,vtTm_BI,CuedFrmSet,matTm_Cued] = ExtractSyncBehavFrm_2P_Correct(strFn_BehaVid, stEvent,nFrm,stEvent_rep)

vidObj_R = VideoReader(strFn_BehaVid);
vidHeight = vidObj_R.Height;
vidWidth = vidObj_R.Width;
vidFrmCount = vidObj_R.NumberOfFrames;
if(nargin <3)
    nFrm =1;
end
if(nargin==4)
   stEvent_rep.Img_Cam.Time_S = stEvent_rep.Img_Cam.Time_S(1:nFrm:end);
   stEvent_rep.Img_Cam.Time_E = stEvent_rep.Img_Cam.Time_E(1:nFrm:end);
   [vtFrm_BI,vtTm_BI]= FindSyncBehavFrm(stEvent_rep,'img'); 
else
   stEvent.Img_Cam.Time_S = stEvent.Img_Cam.Time_S(1:nFrm:end);
   stEvent.Img_Cam.Time_E = stEvent.Img_Cam.Time_E(1:nFrm:end);
   [vtFrm_BI,vtTm_BI]= FindSyncBehavFrm(stEvent,'img');
end
vtInt_B = diff(vtTm_BI);
vtInt_B = vtInt_B(~isnan(vtInt_B));
FR = round(1e6/median(vtInt_B));

[strPath, strFn] = fileparts(strFn_BehaVid);
vidObj_W = VideoWriter([strPath filesep strFn '_ext.avi'],'Motion JPEG AVI');
set(vidObj_W,'FrameRate',FR);
open(vidObj_W);

matTm_Cued =[];
CuedFrmSet = [];
bCued = ~isempty(stEvent.Cue.Time_S);
if(bCued)
    [vtFrm_BC,vtTm_BC]= FindSyncBehavFrm(stEvent,'cue');
%     nCuedFrmDur = ceil(2e5/(stEvent.Behave_Cam.Time_S(2)-stEvent.Behave_Cam.Time_S(1))); %cue duration 2e5 us
%     vtCuedFrm = double(0:nCuedFrmDur-1);
%     CuedFrmSet = repmat(vtFrm_BC,[1 nCuedFrmDur])+repmat(vtCuedFrm,[size(vtFrm_BC,1) 1]);
    [vtFrm_BC_E,vtTm_BC_E]= FindSyncBehavFrm(stEvent,'cue_e');
    
    if(vtFrm_BC_E(1)<vtFrm_BC(1))
        vtFrm_BC_E(1)=[];
        vtTm_BC_E(1)=[];
    end
    if(vtFrm_BC_E(end)<vtFrm_BC(end))
        vtFrm_BC(end)=[];
        vtTm_BC(end)=[];
    end
    matTm_Cued = [vtTm_BC;vtTm_BC_E];
    
    for nCue =1:length(vtFrm_BC)
        CuedFrmSet = [CuedFrmSet vtFrm_BC(nCue):(vtFrm_BC_E(nCue)-1)]; %#ok<AGROW>
    end
    CuedFrmSet = CuedFrmSet(:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clA = {[3807 13551;2756 9804],[3822 13913;2768 10098],[4708 13918;3412 10101],[3811 12173;2759 8832],[3810 13920;2759 10102]};
% fileID = str2double(strFn(end));
% 
% A = clA{fileID-4};
% 
% C2W_fit = fit(A(2,:)',A(1,:)','poly1'); %correct 2 wrong(image) frame
% 
% vtFrm_BI1=vtFrm_BI;
% vtFrm_BI = round(C2W_fit(vtFrm_BI)); %For correction, if synchronization was not used in scispy
vtFrm_BI1=vtFrm_BI;
vtFrm_BI = round(124*vtFrm_BI/90); %For correction, if synchronization was not used in scispy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vtFrm_BI(vtFrm_BI<0)=1;
vtFrm_BI(vtFrm_BI>vidFrmCount)=[];
nFrmCount_Ext = length(vtFrm_BI);
disp(['Writing file: ' strPath filesep strFn '_ext.avi']);
for n=1:nFrmCount_Ext
    nFrm = vtFrm_BI(n);
    if(nFrm ==0)
        img = zeros(vidHeight,vidWidth,'uint8');
    else
        img = read(vidObj_R, nFrm);
        img = img(:,:,1);
    end
    if(any(CuedFrmSet==vtFrm_BI1(n)))
        img(275+(1:50),30+(1:50)) = uint8(255);
    end
    writeVideo(vidObj_W,img);
end
close(vidObj_W);
disp('done');