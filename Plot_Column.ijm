// macro "Plot Columns" by Christophe Leterrier
// v. 1.0 01/02/2014
//
// This plots the colmuns of a tab-delimited text file with the headers on the first line (such as an ImageJ Results Table) as an ImageJ plot.
// - The size of the plot can be specified
// - You can plot up to three columns on the same plot
// - You can choose the symbol  and color for each plot
// - You can choose the width of the symbols for all plots
// - You can use an auto-scale or specify the X and Y scale

macro "Plot_Column" {

	sep = ","; // csv
//	sep = "\t"; // tab delimited

	Path = File.openDialog("Choose a tab-delimited text file / Results table");
	PathComp = split(Path, File.separator);
	TableName = PathComp[PathComp.length - 1];
	TableName = substring(TableName, 0, lengthOf(TableName) - 4);
	TableString = File.openAsString(Path);
	Rows = split(TableString, "\n");
	Headers = getLabels(Rows);
	
	XData = newArray(Headers.length + 1);
	XData[0] = "Numbered Index";
	for (i = 0; i < Headers.length; i++) {
		XData[i+1] = Headers[i];
	}

	YData = newArray(Headers.length + 1);
	YData[0] = "None";
	for (i = 0; i < Headers.length; i++) {
		YData[i+1] = Headers[i];
	}

	GTypes = newArray("line", "circles", "boxes", "triangles", "crosses", "dots", "x");
	GWidths = newArray(1, 2, 3, 4, 5, 6);
	GColors = newArray("black", "blue", "cyan", "darkGray", "gray", "green", "lightGray", "magenta", "orange", "pink", "red", "white", "yellow");

	Dialog.create("Choose the graph X and Y data");

	Dialog.addNumber("Plot width", 800);
	Dialog.addNumber("Plot height", 600);
	Dialog.addMessage("\n");
	
	Dialog.addChoice("X Column", XData, XData[1]);
	Dialog.addMessage("\n");	

	Dialog.addChoice("Y1 Column", YData, YData[2]);
	Dialog.addChoice("Y1 Symbol", GTypes);
	Dialog.addChoice("Y1 Color", GColors, GColors[1]);
	Dialog.addMessage("\n");	

	Dialog.addChoice("Y2 Column", YData, YData[0]);
	Dialog.addChoice("Y2 Symbol", GTypes);
	Dialog.addChoice("Y2 Color", GColors, GColors[2]);
	Dialog.addMessage("\n");
	
	Dialog.addChoice("Y3 Column", YData, YData[0]);
	Dialog.addChoice("Y3 Symbol", GTypes);
	Dialog.addChoice("Y2 Color", GColors, GColors[3]);	
	Dialog.addMessage("\n");
	
	Dialog.addChoice("Symbol Width", GWidths);
	Dialog.addMessage("\n");

	Dialog.addCheckbox("Auto X Scale", true);
	Dialog.addNumber("min X", 0);
	Dialog.addNumber("max X", 0);
	Dialog.addCheckbox("Auto Y Scale", true);
	Dialog.addNumber("min Y", 0);
	Dialog.addNumber("max Y", 0);
		
	Dialog.show;

	pSizeX = Dialog.getNumber();
	pSizeY = Dialog.getNumber();
	
	XLabel = Dialog.getChoice();
	
	Y1Label = Dialog.getChoice();
	Y1Type = Dialog.getChoice();
	Y1Color = Dialog.getChoice();
	
	Y2Label = Dialog.getChoice();
	Y2Type = Dialog.getChoice();
	Y2Color = Dialog.getChoice();

	Y3Label = Dialog.getChoice();
	Y3Type = Dialog.getChoice();
	Y3Color = Dialog.getChoice();
	

	Width = Dialog.getChoice();

	autoX = Dialog.getCheckbox();
	Xmin = Dialog.getNumber();
	Xmax = Dialog.getNumber();
	autoY = Dialog.getCheckbox();
	Ymin = Dialog.getNumber();
	Ymax = Dialog.getNumber();

	if (Y1Label != "None") {
		Y1Col = getColumnNum(Rows, Y1Label);
		Ylength = Y1Col.length;
		Array.getStatistics(Y1Col, Y1min, Y1max, mean, stdDev);
	}
	else {
		Y1min = 0;
		Y1max = 0;
	}
	

	if (Y2Label != "None") {
		Y2Col = getColumnNum(Rows, Y2Label);
		Ylength = Y2Col.length;
		Array.getStatistics(Y2Col, Y2min, Y2max, mean, stdDev);
	}
	else {
		Y2min = 0;
		Y2max = 0;
	}
	
	if (Y3Label != "None") {
		Y3Col = getColumnNum(Rows, Y3Label);
		Ylength = Y3Col.length;
		Array.getStatistics(Y3Col, Y3min, Y3max, mean, stdDev);
	}
	else {
		Y3min = 0;
		Y3max = 0;
	}
	
	if (XLabel != "Numbered Index") {
		XCol = getColumnNum(Rows, XLabel);
	}
	else {
		XCol = newArray(Ylength);
		for (i = 0; i < Ylength; i++) {
			XCol[i] = i+1;
		}
	}
	
	if (autoX == true) {
		Array.getStatistics(XCol, XminA, XmaxA, mean, stdDev);
		Xmin = XminA;
		Xmax = XmaxA;
	}
	if (autoY == true) {
		Ymin = minOf(minOf(Y1min, Y2min), Y3min);
		Ymax = maxOf(maxOf(Y1max, Y2max), Y3max);
	}

	Plot.create(TableName + " : " + Y1Label + "= f(" + XLabel + ")", XLabel, Y1Label);
	
	Plot.setFrameSize(pSizeX, pSizeY);
	Plot.setLimits(Xmin, Xmax, Ymin, Ymax);

	Plot.setLineWidth(Width);
	Plot.setColor(Y1Color);
	if (Y1Label != "None")	Plot.add(Y1Type, XCol, Y1Col);
	
	Plot.setColor(Y2Color);
	if (Y2Label != "None") Plot.add(Y2Type, XCol, Y2Col);
	
	Plot.setColor(Y3Color);
	if (Y3Label != "None") Plot.add(Y3Type, XCol, Y3Col);
	
	Plot.setColor(Y1Color);
	Plot.show();
	
}

function getLabels(Rows) {
	Labels = split(Rows[0], sep);
	return Labels;	
}

function getColumnNum(Rows, Label) {
	Labels = split(Rows[0], sep);
	IndexCol = -1;
	for (i = 0; i < Labels.length; i++) {
		if (Labels[i] == Label) {
			IndexCol = i;
		}
	}
	if (IndexCol == -1) exit("Column doesn't exist !");
	Column = newArray(Rows.length - 1);
	for (i = 1; i < Rows.length; i++) {
		CurrentLine = split(Rows[i], sep);
		Column[i - 1] = parseFloat(CurrentLine[IndexCol]);
	}
	return Column;
}
