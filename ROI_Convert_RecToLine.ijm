macro "ROI: Convert Rectangle to Line" {
	
	nROI = roiManager("count");	
	for (r = 0; r < nROI; r++) {
		
		roiManager("select", r);
		rType = Roi.getType;
		
		if (rType == "Rectangle"){
			
			Roi.getBounds(rX, rY, rW, rH);
			if (rH > rW) {
				makeLine(rX+(rW/2), rY, rX+(rW/2), rY+rH, rW);
			}
			else {
				makeLine(rX, rY+(rH/2), rX+rW, rY+(rH/2), rH);
			}
			roiManager("Update");
		}	
	
	}

}