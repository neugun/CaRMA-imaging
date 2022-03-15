# saintgene 2017
# save each arealist as a 3D ROI Mask

from java.io import File
from ini.trakem2.display import *
#edit by zhenggangzhu
#from ini.trakem2.display import Display, Patch
from java.util import List
from ij import IJ
from ij import WindowManager as WM
from ij.io import FileSaver
from ij.process import ImageConverter

#you need to open the TrakEM2 project, then run the script

#the directory to save the 3D ROI masks
#
#savDir = "Z:/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Z_stack/1213/2p_ROIs_1213/"
#savDir = "Z:/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496191/1213/Z_stack/1212/2p_ROIs_1212/"
#savDir = "Z:/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Z_stack/1213/2p_ROIs_1213/"
savDir = "Z:/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496191/1211/Reg_Cat/ROIs_Reg/"

#the number of neurons to be exported
Label_Max = 44
Label_Max = 23

print("ls")

ls = Display.getFront().getLayerSet()
#print(ls.getZDisplayables())

#als = ls.getZDisplayables(AreaList)
#editbyzhenggangzhu
als = ls.getZDisplayables()
print(als)

for al in als:
	al.setProperty("label",None)
	al.setVisible(False,True)

for i in range(1,Label_Max+1):
	NN = "N"+str(i)
	bFound = False
	for al in als:
		if NN == al.title:
			bFound = True
			al.setProperty("label",str(i))
			break
	if(not bFound):
		print(NN)
		print("miss")

File(savDir).mkdirs()
print(al.title)
for al in als:
	if al.title.startswith('N'):
		print("processing: "+al.title)
		al.setVisible(True, True)
		print(int(ls.getDepth()))
		al.exportAsLabels([al],None,1,0,int(ls.getDepth()),True,False,False)
		al.setVisible(False,True)
		imp = WM.getImage("Labels")
		ImageConverter(imp).convertToGray16()
#		FileSaver(imp).saveAsTiff(savDir+al.title+"_final.tif")
		FileSaver(imp).saveAsTiff(savDir+al.title+".tif")
		print(savDir+al.title+".tif")
		imp.close()
		
print("done")
