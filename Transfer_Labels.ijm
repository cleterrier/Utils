// Transfer Labels macro by Christophe Leterrier
// Allow to transfer label from one stack to another stack, changing one string into another in the slice labels. Useful if a process creates a new stack without carrying labels information

macro "Transfer_Labels" {

	setBatchMode(true);
	
	// We need at least two stacks
	if (nImages < 1) exit("Not enough images open");
	
	// Get titles of all opened images
	TITLES = newArray(nImages);
	for (i = 1; i< = nImages; i++) {
		selectImage(i);
		TITLES[i-1] = getTitle;
	}
	
	//Dialog
	Dialog.create("Label Parameters");
	Dialog.addChoice("Source stack", TITLES, TITLES[0]);
	Dialog.addChoice("Destination stack", TITLES, TITLES[0]);
	Dialog.addString("Replace source string", "", 6);
	Dialog.addString("by new string", "", 6);
	Dialog.show;
	
	SOURCE = Dialog.getChoice;
	DEST = Dialog.getChoice;
	OLD = Dialog.getString;
	NEW = Dialog.getString;

	// Slice number for destination stack
	selectImage(DEST);
	nDEST = nSlices;
	if (nDEST == 1) exit("Destination is not a stack");

	// Slice number for destination stack
	selectImage(SOURCE);
	nSOURCE = nSlices;

	// Exit if Slice number is different
	if (nSOURCE != nDEST) exit("Source and destination stacks do not have the same number of slices!");

	// Store all labels from source stack and modify them
	LABELS = newArray(nSOURCE);	
	for (i = 0; i < nSOURCE; i++) {
		setSlice(i+1);	
		LAB = getInfo("slice.label");	
		// Replace source string with new string in label 
		LABELS[i] = replace(LAB, OLD, NEW);
	}
	
	// Apply new labels to destination stack
	selectImage(DEST);
	for (i = 0; i < nSOURCE; i++) {
		setSlice(i+1);
		setMetadata("Label", LABELS[i]);
	}
	setBatchMode("exit and display");
}
