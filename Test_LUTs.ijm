macro "Test LUTs" {
	getDimensions(width, height, channels, slices, frames);
	inTitle = getTitle();
	inID = getImageID();

	setBatchMode(true);
	
	lutdir = getDir("luts");
	luts = getFileList(lutdir);
	nluts = luts.length;
	
	newImage(inTitle + "-LUTs", "RGB black", width, height, nluts);
	outID = getImageID();
	
	for (l=0; l<nluts; l++) {
		selectImage(inID);
		run("Duplicate...", "title=temp");
		tempID = getImageID();
		open(lutdir + luts[l]);
		run("RGB Color");
		run("Select All");
		run("Copy");
		run("Close");
		selectImage(outID);
		setSlice(l+1);
		run("Paste");
		Property.setSliceLabel(luts[l], l+1)
	}
	
	run("Select None");
	setSlice(1);

	setBatchMode("exit and display");
}



