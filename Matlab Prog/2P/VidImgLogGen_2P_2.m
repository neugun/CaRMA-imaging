function VidImgLogGen_2P_2(strImgDir_P,strVidDir_P,strExp_ImgDir_S)
if(nargin ==0)
    strImgDir_P = 'Z:\Imaging\2P345';
    strVidDir_P = 'Z:\Imaging\BehaviorVideos\video';
    strExp_ImgDir_S = '((1027)|(1028)|(1103)|(1105)|(1106)|(1107))\\ANM372321$';
end

strExp_Img = '_(\d{5})_Comb_C\d.tif';
strExp_Vid = '(\d{1,2})_ext.avi';

clImgDirs = FindSubDirs_RegExp(strExp_ImgDir_S, strImgDir_P, true,2)';

% vtSel = 1;
% clImgDirs = clImgDirs(vtSel);

fid = fopen([strImgDir_P '\ANM372321_VidImgLog.log'],'wt');

for nDir = 1:length(clImgDirs)
    strImgDir = clImgDirs{nDir};
    clImgDirParts = strsplit(strImgDir,filesep);
    strANMID = clImgDirParts{end};
    strDay = clImgDirParts{end-1};
    strVidDir = [strVidDir_P filesep strDay filesep strANMID];
    
    clFns_Img = FindFiles_RegExp([strANMID strExp_Img], strImgDir, false)';
    [clFns_Img,vtCounter_I] = SortFnByCounter(clFns_Img,strExp_Img);
    
    if(~isempty(clFns_Img))
        clFns_Vid = FindFiles_RegExp(strExp_Vid, strVidDir, false)';
        [clFns_Vid,vtCounter_V] = SortFnByCounter(clFns_Vid,strExp_Vid);
        
        nFileCount = length(clFns_Img);
        
        for nFile = 1:nFileCount
            strFn_Img = clFns_Img{nFile};
            iCounter = vtCounter_I(nFile);
            
            idxCounter_V = find(vtCounter_V==iCounter);
            if(~isempty(idxCounter_V))
                fprintf(fid,'%s\n', strFn_Img);
                for nV = 1:length(idxCounter_V)
                    fprintf(fid,'%s\n', clFns_Vid{idxCounter_V(nV)});
                end
            end
        end
    end
end

fclose(fid);