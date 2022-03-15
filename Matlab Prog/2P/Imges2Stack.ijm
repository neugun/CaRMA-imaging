path = File.openDialog("Select a Log File");
strLog = File.openAsString(path);
strLines=split(strLog,"\n");
nLineCount = lengthOf(strLines);
setBatchMode(true);
for (nLine=0;nLine<nLineCount;nLine++)
{
	print("Processing File :" + strLines[nLine]);
	open(strLines[nLine]);
	if(nLine==0)
	{
		strPath = getInfo("image.directory");
	}
	strFn = getInfo("image.filename");
	rename("UID" + strFn);
}
run("Images to Stack", "title=UID");
strSavFn = strPath+"ZStack.tif";
saveAs("Tiff", strSavFn);
setBatchMode(false);