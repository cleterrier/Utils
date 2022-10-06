macro "Align Pairs" {
	
	// Macro Name
	MACRO_NAME = "Align Pairs"
	
	// Options
	SBM = false; // batch mode
	PROC_EXT = ".tif"; // type of file top process
	
	// Get the folder name
	INPUT_DIR=getDirectory("Select the input stacks directory");
	
	// Log beginning of macro
	print("\n\n\n*** " + MACRO_NAME  + " Log ***");
	print("");
	print("INPUT_DIR :"+INPUT_DIR);
	
	// Optional batch mode
	if (SBM == true) setBatchMode(true);
	
	// Get all file names
	ALL_NAMES=getFileList(INPUT_DIR);
	Array.sort(ALL_NAMES);
	N_LENGTH = ALL_NAMES.length;
	ALL_EXT=newArray(N_LENGTH);
	
	// Create extensions array
	for (i = 0; i < N_LENGTH; i++) {
	//	print(ALL_NAMES[i]);	print("\n\n\n*** Make_Projections Log ***");
	print("");
	print("INPUT_DIR :"+INPUT_DIR);
		ALL_NAMES_PARTS = getFileExtension(ALL_NAMES[i]);
		ALL_EXT[i] = ALL_NAMES_PARTS[1];
	}
	
	for (n=0; n<N_LENGTH; n++) { // Loop on all files
		if (ALL_EXT[n] == PROC_EXT) { // Loop on extensions

			// Get the file 1 path
			FILE_PATH1 = INPUT_DIR + ALL_NAMES[n];

			// Store components of the file 1 name
	//		FILE_NAME1 = File.getName(FILE_PATH1);
	//		FILE_DIR1 = File.getParent(FILE_PATH1);
	//		FILE_SEP1 = getFileExtension(FILE_NAME1);
	//		FILE_SHORTNAME1 = FILE_SEP1[0];
	//		FILE_EXT1 = FILE_SEP1[1];

			print("");
			print("INPUT_PATH1:", FILE_PATH1);
	//		print("FILE_NAME1:", FILE_NAME1);
	//		print("FILE_DIR1:", FILE_DIR1);
	//		print("FILE_EXT1:", FILE_EXT1);
	//		print("FILE_SHORTNAME1:", FILE_SHORTNAME1);

			// Get the file 2 path
			FILE_PATH2 = INPUT_DIR + ALL_NAMES[n+1];
			
			// Store components of the file 2 name
	//		FILE_NAME2 = File.getName(FILE_PATH2);
	//		FILE_DIR2 = File.getParent(FILE_PATH2);
	//		FILE_SEP2 = getFileExtension(FILE_NAME2);
	//		FILE_SHORTNAME2 = FILE_SEP2[0];
	//		FILE_EXT2 = FILE_SEP2[1];

			print("");
			print("INPUT_PATH2:", FILE_PATH2);
	//		print("FILE_NAME2:", FILE_NAME2);
	//		print("FILE_DIR2:", FILE_DIR2);
	//		print("FILE_EXT2:", FILE_EXT2);
	//		print("FILE_SHORTNAME2:", FILE_SHORTNAME2);

			// Increment loop counter to skip the second file in the loop
			n++;

			// Open both files
			open(FILE_PATH1);
			open(FILE_PATH2);

			// Make stack
			run("Images to Stack", "use");
			STACK_ID = getImageID();
			
			// Run Image Stabilizer
			run("Image Stabilizer", "transformation=Translation maximum_pyramid_levels=1 template_update_coefficient=0.90 maximum_iterations=200 error_tolerance=0.0000001");
			
			// Duplicate second slice
			run("Next Slice [>]");
			run("Duplicate...", "use");
			OUT_ID = getImageID();
			
			// Save output image in place of the input second file then close it
			// selectImage(OUT_ID);
			OUT_PATH = FILE_PATH2;
			save(OUT_PATH);
			print("OUT_PATH: " + OUT_PATH);
			close();

			// Close input stack
			selectImage(STACK_ID);
			close();

		}// end of IF loop on extensions
	}// end of FOR loop on all files


	// Exit batch mode if needed
	if (SBM == true) setBatchMode("exit and display");
	
	// Log end of macro// Loop on all files
	print("");
	print("*** " + MACRO_NAME + " end ***");
	showStatus(MACRO_NAME + " finished");

}
	

// Function that takes a file name as string and returns an array [file name without extension, file extension (with .)]
function getFileExtension(Name) {
	
	nameparts = split(Name, ".");
	shortname = nameparts[0];
	
	if (nameparts.length > 2) {
		for (k = 1; k < nameparts.length - 1; k++) {
			shortname += "." + nameparts[k];
		}
	}
	
	extname = "." + nameparts[nameparts.length - 1];
	namearray = newArray(shortname, extname);
	
	return namearray;
}
