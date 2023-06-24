macro "Display_Contrast" {
	setBatchMode(true);
	
	getDimensions(w, h, ch, sl, fr);
	Stack.getPosition(cch, csl, cfr);
	
	for (j=0; j < ch; j++) {
		Stack.setPosition(j+1, csl, cfr);
		run("Enhance Contrast", "saturated=0.35");
	}
	Stack.setPosition(cch, csl, cfr);

	setBatchMode("exit and display");
}