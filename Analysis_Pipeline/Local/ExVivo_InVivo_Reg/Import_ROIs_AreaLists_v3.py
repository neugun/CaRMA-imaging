# saintgene 2017
# import each 3D ROI Mask as a arealist for a neuron

from ini.trakem2 import Project
from ini.trakem2.tree import ProjectTree, ProjectThing
from ini.trakem2.utils import AreaUtils
from ini.trakem2.display import AreaList, Display
from java.awt import Color
from java.util import Random
from java.util import List
from ij import WindowManager as WM
from ij import IJ

#you need to open the TrakEM2 project, then run the script

#the directory to save the 3D ROI masks
strDir = "D:/Dropbox/Dropbox (HHMI)/PVH_Analysis/CaRMA_Wiki/Example_Data/ANM378231/ExVivo_InVivo_Reg/Reg/ZStacks_Xdays_Reg/2p_ROIs_Fear/"
strDir = "Z:/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Z_stack/1211/2p_ROIs_1211/"
strDir = "Z:/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496191/1212/Reg_Cat/ROIs_Reg/"
strDir = "Z:/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496190_visual_guidence/1213/Reg_Cat/Acrossdays/ROIs/"
strDir = "Z:/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/ANM496191/1213/Reg_Cat/Acrossdays/ROIs/"
strDir = "Z:/Zhenggang/CaRMApipeline/Example_Data/ANM378231/Fear_Imaging_Exp/492241/D9/Reg_Cat/Acrossdays/ROIs/"
#
#the number of neurons to be imported
nROIsCount = 44
nROIsCount = 23
nROIsCount = 38
nROIsremove = []
nROIslist1 = range(1,nROIsCount+1)
nROIslist = list(set(nROIslist1) - set(nROIsremove))

def DistinctColors(nColor):
	Rnd = Random()
	cls = [Color.red,Color.pink,Color.orange,Color.yellow,Color.green,Color.magenta,Color.cyan,Color.blue]
	CL = []
	for ii in range(0,nColor):
		idx = Rnd.nextInt(len(cls))
		CL.append(cls[idx])
	return CL

p = Project.getProjects()[0]
p_tree_r = p.getRootProjectThing()
layerset = p.getRootLayerSet()
TempThing = p.getTemplateThing("neuron")
CL = DistinctColors(nROIsCount)


for k in nROIslist:

    #editbyZhenggang
    if k>0:
    	N_ROI = str(k)
    else:
        N_ROI = str(0) + str(k)
   
    #print(N_ROI)
    strFn = strDir + "N" + N_ROI + "_final_reg.tif"
    print("Processing file: " + strFn)
    imp = IJ.openImage(strFn)
    ali = AreaList(p, "N" + N_ROI, 0, 0)
    layerset.add(ali)

    pt = ProjectThing(TempThing,p,ali)
    p_tree_r.addChild(pt)
    
    stack = imp.getImageStack()
    
    for i in range(1, imp.getNSlices() +1):
			ip = stack.getProcessor(i) # 1-based
			m = AreaUtils.extractAreas(ip)
			# Report progress
			#print i, ":", len(m)
			# Get the Layer instance at the corresponding index
			layer = layerset.getLayers().get(i-1) # 0-based
			if len(m)>0:
				for j in range(1,len(m)+1):
					ali.addArea(layer.getId(), m.values()[j-1])
    ali.setColor(CL[k-1])
    ali.calculateBoundingBox(None)
    imp.close()
p.getProjectTree().rebuild(p_tree_r)
Display.repaint()