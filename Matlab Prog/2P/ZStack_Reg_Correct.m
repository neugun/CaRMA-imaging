strFn = 'Z:\2P_Analyze\ANM318142\ZStacks\20160811\ANM318142_00001_00002_Sharper_All_Reg.tif';
strFn0 = 'Z:\2P_Analyze\ANM318142\ZStacks\20160811\ANM318142_00001_00002_Sharper_All.tif';
imgData = readTiffStack(strFn);
imgData0 = readTiffStack(strFn0);

[nHeight,nWidth,nFrmCount] = size(imgData);
imgData2 = imgData;

matTrans_Reg = zeros(nFrmCount,2);

for nFrm=1:nFrmCount
    img_R = imgData(:,:,nFrm);
    xl=all(img_R==0);
    if(any(xl))
        if(xl(1))
            matTrans_Reg(nFrm,1) = find(xl,1,'last');
        else
            matTrans_Reg(nFrm,1) = find(xl,1,'first')-nWidth-1;
        end
    end
    
    yl=all(img_R==0,2);
    if(any(yl))
        if(yl(1))
            matTrans_Reg(nFrm,2) = find(yl,1,'last');
        else
            matTrans_Reg(nFrm,2) = find(yl,1,'first')-nHeight-1;
        end
    end
end

%%
figure;
subplot(1,2,1);
plot(matTrans_Reg(:,1));
ylabel('XShift');
subplot(1,2,2);
plot(matTrans_Reg(:,2));
ylabel('YShift');

%%
matTrans_Reg2 = matTrans_Reg;
for nFrm=35:nFrmCount
    matTrans_Reg2(nFrm,1) = matTrans_Reg(nFrm,1)-0.8889*(nFrm-34);
end

% for nFrm=3:19
%     matTrans_Reg2(nFrm,2) = matTrans_Reg(nFrm,2)+0.47*(nFrm-2);
% end
% for nFrm=20:37
%     matTrans_Reg2(nFrm,2) = matTrans_Reg(nFrm,2)+8;
% end
for nFrm=22:nFrmCount
    matTrans_Reg2(nFrm,2) = matTrans_Reg(nFrm,2)+0.6034*(nFrm-21);
end

Val_F = min(imgData0(:));
for nFrm=1:nFrmCount
    imgData2(:,:,nFrm) = imtranslate(imgData0(:,:,nFrm),matTrans_Reg2(nFrm,:),'FillValue',Val_F);
end

writeTiffStack_UInt16(imgData2,[strFn(1:end-4) '_Correct.tif']);