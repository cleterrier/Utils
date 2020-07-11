macro "ROI: Fix Size" {

	getPixelSize(unit, pW, pH);
	
	LengthScaled = getNumber("fixed ROI length/width (" + unit + "):", 1); 
	LengthPix = LengthScaled / pW;
	
	nROI = roiManager("count");	
	for (r = 0; r < nROI; r++) {
		
		roiManager("select", r);
		rType = Roi.getType;
		
		if (rType == "Line") {
			rCoor = Roi.getCoordinates(rX, rY);
			rLength = Math.sqrt(Math.sqr(rX[1]-rX[0]) + Math.sqr(rY[1]-rY[0]));
			factor = LengthPix / rLength;
			run("Scale... ", "x=" + factor + " y=" + factor + " centered");
			roiManager("Update");
		}
		
		else {
			Roi.getBounds(rX, rY, rW, rH);
			factor = LengthPix / rW;
			run("Scale... ", "x=" + factor + " y=" + factor + " centered");
			roiManager("Update");
		}	
	
	}

}