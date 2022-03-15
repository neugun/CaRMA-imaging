function FindSharperImages_simple(strFn1,strFn2)
if(nargin==0)
    strFn1='Z:\Imaging\2P345\20171103\ANM372321\ANM372321_00003_reg_ZProj_ZStack.tif';
    strFn2='Z:\Imaging\2P345\20171103\ANM372321\ANM372321_00004_reg_ZProj_ZStack.tif';
end
ImgData1 = readTiffStack(strFn1);
ImgData2 = readTiffStack(strFn2);
Header1= load(strrep(strFn1,'_reg_ZProj_ZStack.tif','_Header.mat'));
Header2= load(strrep(strFn2,'_reg_ZProj_ZStack.tif','_Header.mat'));
vtZs1 = GetImgZs(Header1.Header);
vtZs2 = GetImgZs(Header2.Header);

szImg1 = size(ImgData1);
szImg2 = size(ImgData2);
% if(szImg1(3)>1)
%     ImgData1 = squeeze(ImgData1(:,:,szImg1(3),:,:));
% else
%     ImgData1 = squeeze(ImgData1);
% end
% 
% if(szImg2(3)>1)
%     ImgData2 = squeeze(ImgData2(:,:,szImg2(3),:,:));
% else
%     ImgData2 = squeeze(ImgData2);
% end

if(all(szImg1([1 2])==szImg2([1 2])))
    
    [idxZs1,idxZs2] = MatchZs(vtZs1,vtZs2);
    
    nFrmCount = length(idxZs1);
    vtZs_All = zeros(nFrmCount,1);
    idxZss = zeros(nFrmCount,1);
    Img1 = zeros(szImg1(1),szImg2(2),nFrmCount,'like',ImgData1);
    Img2 = zeros(size(Img1),'like',Img1);
    Img3 = zeros(size(Img1),'like',Img1);
    for nFrm=1:nFrmCount
        idx1=idxZs1(nFrm);
        if(idx1>0)
            Img1(:,:,nFrm)=ImgData1(:,:,idx1);
            Img3(:,:,nFrm) = Img1(:,:,nFrm);
            vtZs_All(nFrm) = vtZs1(idx1);
            idxZss(nFrm) = idx1;
        end
        idx2=idxZs2(nFrm);
        if(idx2>0)
            Img2(:,:,nFrm)=ImgData2(:,:,idx2);
            if(idx1<0)
                Img3(:,:,nFrm) = Img2(:,:,nFrm);
                vtZs_All(nFrm) = vtZs2(idx2);
                idxZss(nFrm) = -idx2;
            else
                SI1 = s_index(Img1(:,:,nFrm));
                SI2 = s_index(Img2(:,:,nFrm));
                [~,idx_si] = max([SI1 SI2]);
                if(idx_si == 1)
                    Img3(:,:,nFrm) = Img1(:,:,nFrm);
                    vtZs_All(nFrm) = vtZs1(idx1);
                    idxZss(nFrm) = idx1;
                else
                    Img3(:,:,nFrm) = Img2(:,:,nFrm);
                    vtZs_All(nFrm) = vtZs2(idx2);
                    idxZss(nFrm) = -idx2;
                end
            end
        end
        
    end
    
    idxZs = [idxZs1, idxZs2, idxZss'];
    ImgCmp = cat(2,Img1,Img2,Img3);
    strFn_ImgCmp = [strFn1(1:end-4) '_' strFn2(end-8:end-4) '_Cmp.tif'];
    writeTiffStack_Int16(ImgCmp,strFn_ImgCmp);
    
    strFn_ImgSharper_All = [strFn1(1:end-4) '_' strFn2(end-8:end-4) '_Sharper_All.tif'];
    writeTiffStack_Int16(Img3,strFn_ImgSharper_All);
    strFn_ImgSharper_All_Z = [strFn1(1:end-4) '_' strFn2(end-8:end-4) '_Sharper_All_Z.mat'];
    save(strFn_ImgSharper_All_Z,'vtZs_All','idxZs');
    
    strFn_ImgSharper = [strFn1(1:end-4) '_' strFn2(end-8:end-4) '_Sharper.tif'];
    lgSharper = all([idxZs1;idxZs2]>0);
    writeTiffStack_Int16(Img3(:,:,lgSharper),strFn_ImgSharper);
    strFn_ImgSharper_Z = [strFn1(1:end-4) '_' strFn2(end-8:end-4) '_Sharper_Z.mat'];
    vtZs_All = vtZs_All(lgSharper);
    save(strFn_ImgSharper_Z,'vtZs_All');
else
    warning('Image sizes do not match');
end


function vtZs = GetImgZs(imgHeader)
if(imgHeader.SI.hStackManager.slowStackWithFastZ)
    if(all(imgHeader.SI.hStackManager.zs>=400))
        imgHeader.SI.hStackManager.zs = imgHeader.SI.hStackManager.zs - 400;
    end
    vtZs = imgHeader.SI.hMotors.motorPosition(3)+imgHeader.SI.hStackManager.zs;
else
    vtZs = imgHeader.SI.hStackManager.stackZStartPos+imgHeader.SI.hStackManager.zs;
end

function [idxZs1,idxZs2] = MatchZs(vtZs1,vtZs2)

if(vtZs1(1)<=vtZs2(1))
   [~,idx2_1] = min(abs(vtZs1-vtZs2(1)));
   M_len = idx2_1+length(vtZs2)-1;
   if(M_len<=length(vtZs1))
       idxZs1=1:length(vtZs1);
       idxZs2= zeros(size(idxZs1));
       idxZs2(1:idx2_1-1)=-1*(1:idx2_1-1);
       idxZs2(idx2_1-1+(1:length(vtZs2))) = 1:length(vtZs2);
       idxZs2(idx2_1+length(vtZs2):end)= -1*(idx2_1+length(vtZs2):length(vtZs1));
   else
      idxZs1 = zeros(1,M_len);
      idxZs2 = zeros(1,M_len);
      idxZs2(1:idx2_1-1)=-1*(1:idx2_1-1);
      idxZs2(idx2_1:end) = 1:length(vtZs2);
      idxZs1(1:length(vtZs1)) = 1:length(vtZs1);
      idxZs1(length(vtZs1)+1:M_len) = -1*idxZs2(length(vtZs1)+1:M_len);
   end
else
    [idxZs2,idxZs1] = MatchZs(vtZs2,vtZs1);
end
