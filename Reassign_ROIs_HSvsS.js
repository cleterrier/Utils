importClass(Packages.ij.IJ);
importClass(Packages.ij.gui.GenericDialog);
importClass(Packages.ij.plugin.frame.RoiManager);

var gd = new GenericDialog("Reassign ROIs HS to S");

gd.addCheckbox("Reverse (S to HS):", false);
gd.addNumericField("Number of channels (only for S to HS)", 3, 0, 2,"");
// gd.addNumericField("Initial channel (only for S to HS)", 1, 0, 2,"");
gd.showDialog();
var rev = gd.getNextBoolean();
var chan = gd.getNextNumber();
// var offset = gd.getNextNumber();

if (gd.wasOKed()) {
	var imp = IJ.getImage();
	var rm = RoiManager.getInstance();
	var ra = rm.getRoisAsArray();
	rm.runCommand("Deselect");
	rm.runCommand("Delete");
	for (r = 0; r < ra.length; r++) {
				
		if (rev == false) {

			var rZ = ra[r].getZPosition();
			
			var rName = ra[r].getName();	
			var nameParts = rName.split("-");
			var newNameEnd = "";
			for (i = 1; i< nameParts.length; i++) newNameEnd += "-" + nameParts[i];
			var newSlice = pad(rZ, 4);	
			var newName = newSlice + newNameEnd;
				
			IJ.log("roi#" + r + ": oldPos=" + nameParts[0] + ", posZ=" + rZ +", newPos=" + newSlice);
			
			ra[r].setPosition(rZ);
			imp.setPosition(rZ);
			rm.addRoi(ra[r]);
			
			rm.select(rm.getCount()-1);
			rm.runCommand("Rename", newName);			
		
		}
		else {
			var rPos = ra[r].getPosition();
			var newPos = (rPos - 1) * chan + 1;

			var rName = ra[r].getName();
			var nameParts = rName.split("-");
			var newNameEnd = "";
			for (i = 1; i< nameParts.length; i++) newNameEnd += "-" + nameParts[i];
			var newSlice = pad(newPos, 4);	
			var newName = newSlice + newNameEnd;			
			
			IJ.log("roi#" + r + ": oldPos=" + nameParts[0] + ", newPos=" + newSlice);
			
			ra[r].setPosition(newPos , 1, 1);
			imp.setPosition(newPos , 1, 1);
			rm.addRoi(ra[r]);
			
			rm.select(rm.getCount()-1);
			rm.runCommand("Rename", newName);
		}
		
	}
}

function pad(n, width, z) {
  z = z || '0';
  n = n + '';
  return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}
