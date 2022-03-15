function [strDir_Sav, imgInfo] = SplitImages_SI_StackZ(strFn)

if(nargin==0)
    strFn = 'Z:\Imaging\2P345\20170806\ANM378231\ANM378231_00001.tif';
end

[Header,Aout,imgInfo] = scanimage.util.opentif(strFn); %#ok<ASGLU>

[strDir,strFn_p]=fileparts(strFn);
strDir_Sav = [strDir filesep strFn_p '_S'];
mkdir(strDir_Sav);

for nSlice = 1:imgInfo.numSlices
    for nCh =1:imgInfo.numChans
        matImgCh = squeeze(Aout(:,:,nCh,:,nSlice,:));
        strFn_Sav = [strDir_Sav filesep strFn_p '_S' num2str(nSlice) '_C' num2str(nCh) '.tif'];
        writeTiffStack_Int16(matImgCh,strFn_Sav);
        matImgCh_Avg = mean(matImgCh,3);
        strFn_Avg_Sav = [strFn_Sav(1:end-4) '_Avg.tif'];
        writeTiffStack_Int16(matImgCh_Avg,strFn_Avg_Sav);
    end
    
    if(imgInfo.numChans==2)
        matImgCh = imsubtract(squeeze(Aout(:,:,2,:,nSlice,:)),squeeze(Aout(:,:,1,:,nSlice,:)));
        strFn_Sav = [strDir_Sav filesep strFn_p '_S' num2str(nSlice) '_D.tif'];
        writeTiffStack_Int16(matImgCh,strFn_Sav);
    end
end

strFn_Header = [strFn(1:end-4) '_Header.mat'];
save(strFn_Header,'Header');
