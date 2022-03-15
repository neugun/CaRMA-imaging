strDir = 'Z:\PVH_Analysis';
clBehav = {'Feeding';'Drinking';'Fear';'Ghrelin';'Saline';'Leptin'};

nBehavCount = length(clBehav);


for nBehav = 1:nBehavCount
    strBehav = clBehav{nBehav};
    strRexp_Fn = ['\\(\d)_ANM\d{6}\\' strBehav '\\\S*_Sel\\\S*_Results_\d{8}.\d{6}\.mat$'];
    clFns_Resp = FindFiles_RegExp(strRexp_Fn, strDir, true,5)';
    [clFns_Resp,vtID] = SortFnByCounter(clFns_Resp,strRexp_Fn);
    nFileCount = length(clFns_Resp);
    clTemp = cell(nFileCount,1);
    stResp = struct('ANMID',clTemp,'vtSel',clTemp,'clResps',clTemp,'vtEvents',clTemp,'idxTN_Rg',clTemp,'nTrialCount',clTemp,...
        'strFn_Resp',clTemp,'strFn_States',clTemp);
    clFieldNames = fieldnames(stResp);
    nFieldCount = length(clFieldNames);
    
    for nFile = 1:nFileCount
        stData = load(clFns_Resp{nFile});
        stResp(nFile).ANMID = vtID(nFile);
        for nField = 2:nFieldCount
            strFieldName = clFieldNames{nField};
            if(strcmp(strFieldName,'clResps'))
                for n=1:2
                    matResp = stData.(strFieldName){n};
                    matResp = reshape(matResp,size(matResp,1),[],stData.nTrialCount);
                    matResp_m = mean(matResp,3);
                    if(n==2)
                        matResp_mn = NormMatRow(matResp_m);
                    else
                        matResp_mn = matResp_m;
                    end
                    stData.(strFieldName){n} = matResp_mn;
                end
            end
            stResp(nFile).(strFieldName) = stData.(strFieldName);
        end
    end
    
    save(['Z:\PVH_Analysis\Resp_All\' strBehav '_Resp.mat'],'stResp');
end
