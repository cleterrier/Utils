macro "Randomize Stack" {
	slices = nSlices;
	for (n = 0; n < slices; n++) {
		curr = n + 1;
		swap = floor(random * nSlices) + 1;	
		Stack.swap(curr, swap);
	}	
	
}
