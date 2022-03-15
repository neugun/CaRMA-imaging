%Extract calcium signals of the concatenated registered volumetric images
%with given ROIs in batch process mode.
%
%Please make sure the ROIs of individual neurons are in ROIs_Reg subfolder
%
% Saintgene 2016
%%
%set the parameters in this cell
initDir_CaRMA_Wiki();
global strDir_CaRMA_Wiki

%%directories containing concatenated registered volumetric images and
%%their corresponding ROI sets
% clDirs = {
%  [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\ANM496190_visual_guidence\1211\Reg_Cat'];
%  [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\ANM496190_visual_guidence\1212\Reg_Cat'];
%  [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\ANM496190_visual_guidence\1213\Reg_Cat'];
% };

% clDirs = {
%  [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\ANM496191\1211\Reg_Cat'];
%  [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\ANM496191\1212\Reg_Cat'];
%  [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\ANM496191\1213\Reg_Cat'];
% };

% clDirs = {
%  [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\492241\D1\Reg_Cat'];
%  [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\492241\D6\Reg_Cat'];
%  [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\492241\D7\Reg_Cat'];
% };

clDirs = {
 [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\492241\D2\Reg_Cat'];
 [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\492241\D3\Reg_Cat'];
 [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\492241\D5\Reg_Cat'];
 [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\492241\D8\Reg_Cat'];
 [strDir_CaRMA_Wiki '\Example_Data\ANM378231\Fear_Imaging_Exp\492241\D9\Reg_Cat'];
};

%the regular expression of concatenated registered images of individual
%imaging planes.
strFn_Resp_RE = '_S(\d)_C\d\.tif$';
strFn_Resp_RE = '_S(\d{1,3}).tif';

%the two radii to define the ring shape of background
vtRing3 = [2,20];

%save the exclusive ROIs and ring shape backgrounds
bROIs_Sav = true;                                             % no ROI exist so far
%%
%batch-process for all directories
nDC = length(clDirs);
for nD = 1:nDC
    strDir_VolResp = clDirs{nD};
    strDir_ROIs = [strDir_VolResp '\ROIs_Reg'];
    disp(['Processing folder: ' strDir_VolResp]);
    
    %Extract calcium signals of the concatenated registered volumetric images
    %with given ROIs in each directory
    ExtractVOlResp_SubRing_v3(strDir_VolResp,strDir_ROIs,strFn_Resp_RE,vtRing3,bROIs_Sav);
end