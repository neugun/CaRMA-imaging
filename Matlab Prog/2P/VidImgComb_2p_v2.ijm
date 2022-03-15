path = File.openDialog("Select a Log File");
strLog = File.openAsString(path);
strLines=split(strLog,"\n");
nLineCount = lengthOf(strLines);
setBatchMode(true);
for (nLine=0;nLine<nLineCount;nLine+=2)
{
	print("Processing File :" + strLines[nLine]);
	open(strLines[nLine]);
	Stack.getStatistics(a,b,StackMin,StackMax);
    setMinAndMax(StackMin, StackMax);
	run("8-bit");
	strRegPath = getInfo("image.directory");
	strRegFn = getInfo("image.filename");
	run("AVI...", "open="+strLines[nLine+1]);
	run("8-bit");
	run("Bin...", "x=2 y=2 z=1 bin=Average");
	strVidFn1 = getInfo("image.filename");
//	run("AVI...", "open="+strLines[nLine+2]);
//	run("8-bit");
//	run("Bin...", "x=2 y=2 z=1 bin=Average");
//	strVidFn2 = getInfo("image.filename");
	run("Combine...", "stack1="+strRegFn+" stack2="+strVidFn1+" combine");
//	run("Combine...", "stack1="+strRegFn+" stack2=[Combined Stacks] combine");
	run("Grays");
	fn=substring(strRegFn,0,lengthOf(strRegFn)-4);
	strSavFn = strRegPath+fn+"_comb.tif";
	saveAs("Tiff", strSavFn);
	selectWindow(fn+"_comb.tif");
	run("Close");
}
setBatchMode(false);