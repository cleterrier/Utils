macro "Landmark Correspondances Stack" {
	
	MACROSTRING = "Landmark Correspondances Stack"
	TITLES = getList("image.titles");
	METHODS = newArray("Least Squares", "Moving Least Squares (non-linear)");
	ALPHA_DEF = 1;
	MESH_RES_DEF = 32;
	T_CLASS = newArray("Translation", "Rigid", "Similarity", "Affine", "Perspective");
	INT_DEF = true;
	SHOWM_DEF = false;
	

	//Dialog
	Dialog.create(MACROSTRING + " parameters");
	Dialog.addChoice("Source stack", TITLES, TITLES[0]);
	Dialog.addChoice("Source image", TITLES, TITLES[1]);
	Dialog.addChoice("Template image", TITLES, TITLES[2]);
	Dialog.addChoice("Method", METHODS, METHODS[0]);
	Dialog.addNumber("Alpha", ALPHA_DEF, 2, 5, "");
	Dialog.addNumber("Mesh resolution", MESH_RES_DEF, 0, 5, "");
	Dialog.addChoice("Transformation class", T_CLASS, T_CLASS[3]);
	Dialog.addCheckbox("Interpolate", INT_DEF);
//	Dialog.addCheckbox("Show matrix", SHOWM_DEF);
	Dialog.show;
	STACK_TITLE = Dialog.getChoice();
	IM_TITLE =  Dialog.getChoice();
	TEMP_TITLE =  Dialog.getChoice();
	METH = Dialog.getChoice()
	ALPHA = Dialog.getNumber();
	MESH_RES = Dialog.getNumber();
	TRANSFO = Dialog.getChoice();
	INTERP = Dialog.getCheckbox();
//	SHOWM = Dialog.getCheckbox();

	OUT_TITLE = replace(STACK_TITLE, ".tif", "_transfo.tif");
	if (OUT_TITLE == STACK_TITLE) OUT_TITLE = STACK_TITLE + "_transfo";

	selectWindow(STACK_TITLE);
	STACK_ID = getImageID();
	SLICES = nSlices;
	
	selectWindow(IM_TITLE);
	IM_ID = getImageID();
	
	selectWindow(TEMP_TITLE);
	TEMP_ID = getImageID();
	run("Duplicate...", " ");
	run("Select All");
	run("Clear");
	OUT1_ID = getImageID();
	run("Pad Image to Stack", "number=" + SLICES);
	rename(OUT_TITLE);
	OUT_ID = getImageID();
	selectImage(OUT1_ID);
	close();
	selectImage(OUT_ID);

	for (s = 0; s < SLICES; s++) {
		
		selectImage(STACK_ID);
		setSlice(s+1);
		run("Duplicate...", " ");
		DUP_TITLE = getTitle();
		DUP_ID = getImageID();
		
		selectImage(IM_ID);
		selectImage(DUP_ID);
		run("Restore Selection");

		LC_PARAM = "source_image=[" + DUP_TITLE + "] template_image=[" + TEMP_TITLE + "] transformation_method=[" + METH + "] alpha=" + ALPHA + " mesh_resolution=" + MESH_RES + " transformation_class=" + TRANSFO;
		if (INTERP == true) LC_PARAM += " interpolate";
		//	if (SHOWM == true && METH == "Least Squares") LC_PARAM += "show_matrix";
		
		run("Landmark Correspondences", LC_PARAM);
		
		TRANSFO_TITLE = getTitle();
		TRANSFO_ID = getImageID();
		
		run("Select All");
		run("Copy");
		selectImage(OUT_ID);
		setSlice(s+1);
		run("Paste");
		run("Select None");
		resetMinAndMax();
		
		selectImage(TRANSFO_ID);
		close();
		
		selectImage(DUP_ID);
		close();
		
	}

}

