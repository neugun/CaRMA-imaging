path = File.openDialog("Select a Log File");
strLog = File.openAsString(path);
strLines=split(strLog,"\n");
nLineCount = lengthOf(strLines);
setBatchMode(true);
for (nLine=0;nLine<nLineCount;nLine++)
{
	open(strLines[nLine]);
	run("StackReg", "transformation=Translation");
	strSavFn=substring(strLines[nLine],0,lengthOf(strLines[nLine])-4)+"_Correct.tif";
	saveAs("Tiff", strSavFn);
	close();
}
setBatchMode(false);
