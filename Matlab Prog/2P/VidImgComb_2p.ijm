path = File.openDialog("Select a Log File");
strLog = File.openAsString(path);
strLines=split(strLog,"\n");
nLineCount = lengthOf(strLines);
setBatchMode(true);
for (nLine=0;nLine<nLineCount;nLine+=3)
{
	print("Processing File :" + strLines[nLine]);
	open(strLines[nLine]);
	//Stack.getStatistics(a,b,StackMin,StackMax);
	//print(StackMin);
    setMinAndMax(0, 700);//0.7*StackMax);
	run("8-bit");
	strRegPath = getInfo("image.directory");
	strRegFn = getInfo("image.filename");
	run("AVI...", "open="+strLines[nLine+1]);
	run("8-bit");
	run("Bin...", "x=2 y=2 z=1 bin=Average");
	strVidFn1 = getInfo("image.filename");
	run("AVI...", "open="+strLines[nLine+2]);
	run("8-bit");
	run("Bin...", "x=2 y=2 z=1 bin=Average");
	strVidFn2 = getInfo("image.filename");
	run("Combine...", "stack1="+strVidFn1+" stack2="+strVidFn2);
	run("Combine...", "stack1="+strRegFn+" stack2=[Combined Stacks] combine");
	run("Grays");
	fn=substring(strRegFn,0,lengthOf(strRegFn)-4);
	strSavFn = strRegPath+fn+"_comb.tif";
	saveAs("Tiff", strSavFn);
	selectWindow(fn+"_comb.tif");
	run("Close");
}
setBatchMode(false);