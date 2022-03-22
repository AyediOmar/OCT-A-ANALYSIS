//-------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------Developed by AYEDI OMAR,MD------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
// Field of view selection
Dialog.create("Field of View (FOV)?");
Dialog.addChoice("From 3*3mm to 9*9mm :", newArray("3", "4.5", "6", "9"));
Dialog.show();
Size  = Dialog.getChoice();

// detect image path
image = getTitle();
directory = getDirectory("image");
directory2 = directory + "/" + image + "-" + "OUTPUT/";
File.makeDirectory(directory2); 
infox = getInfo("image.subtitle")
close("ROI Manager");
selectWindow(image);
repeat = false;

do {
	do { 
		// Prompt user to select the FAZ with the polygon selection tool)
		setTool("polygon");
		beep();
		waitForUser("Select the foveal avascular zone", "Select the FAZ with the polygon selection tool, then click OK.");
	} while(selectionType() == -1); 
		setOption("Changes", true);
		setBatchMode(true);
		
// FAZ biomarkers measure
run("Set Measurements...", "area perimeter shape mean redirect=None decimal=3");
run("Set Scale...", "distance=320 known=Size pixel=1 unit=mm");
run("Measure");
saveAs("Results", directory2 + "FAZ biomarkers.csv");
roiManager("Add");
roiManager("Save", directory2 + "FAZ.roi");
Area1 = getResult("Area", 0);
Circ1 = getResult("Circ." , 0);
Perim1 = getResult("Perim." , 0);
Noise1 = getResult("Mean" , 0);
close("results");

// FAZ biomarkers results
Dialog.create("FAZ BIOMARKERS");
Dialog.addNumber("FAZ-Area (mm2)", Area1);
Dialog.addNumber("FAZ-Perimeter (mm)", Perim1);
Dialog.addNumber("FAZ-Circularity", Circ1);
Dialog.addMessage("The mean gray value in the FAZ represent the noise level of this angiogram");
Dialog.addNumber("Noise-value", Noise1);
Dialog.addMessage("------------------------IMPORTANT------------------------");
Dialog.addMessage("Click OK to measure vascular density, otherwise Cancel");
Dialog.show();

// Reduce NOISE ?
run("Select All");
Dialog.create("Substract noise for vessel density measurements ?");
  Dialog.addMessage("Do you want to substract the noise value from the OCT angiogram ? Put 0 otherwise");
  Dialog.addNumber("NOISE VALUE:",Noise1);
  Dialog.show();

  NOISE = Dialog.getNumber();
  run("Duplicate...", "title=process");
  run("Duplicate...", "title=origine");
  run("Duplicate...", "title=contour");
  
// Create OUTPUT image
selectWindow("contour");
run("RGB Color");
roiManager("Select", 0);
getSelectionBounds(x, y, width, height);
xx = x + width;
yy= y + height;
setForegroundColor(255, 255, 0);
setColor("yellow");
run("Line Width...", "line=1");
run("Draw", "slice");
setFont("SansSerif",12); 
drawString("A= " + Area1 + "mm2", xx, yy , "black");
drawString("P= " + Perim1 + "mm", xx, yy+15 , "black");
drawString("C= " + Circ1, xx, yy+30 , "black");
saveAs("Jpeg", directory2 + "FAZoutline.jpg");


//----------------------------------------------------------------------------------------------------------------------------------
// Perfusion biomarkers measure + images
selectWindow("process");
run("Set Measurements...", "area_fraction redirect=None decimal=3");
run("Select All");
run("Duplicate...", "title=sub");
run("Subtract...", "value=NOISE");
run("Make Binary");
run("Create Selection");
selectWindow("process");
run("Subtract...", "value=NOISE");
run("Restore Selection");
run("Add...", "value=NOISE");
roiManager("Select", 0);
run("Set...", "value=0");
run("Make Inverse");
run("Measure"); // 1 VAD ZAC-
saveAs("Jpeg", directory2 + "VAD Without Threshold.jpg");

// VAD Mean, Huang, multilevel, VSD ZAC-
rename("White");
run("Duplicate...", "title=1");
run("Duplicate...", "title=2");
run("Duplicate...", "title=3");
run("Duplicate...", "title=4");
run("Duplicate...", "title=5");

// VSD without 
selectWindow("2");
setOption("BlackBackground", true);
run("Make Binary");
run("Skeletonize");
roiManager("Select", 0);
run("Make Inverse");
run("Measure"); 
saveAs("Jpeg", directory2 + "VSD Without Threshold.jpg");

/// VAD Mean FAZ -
selectWindow("3");
run("Auto Threshold", "method=Mean ignore_black white");
run("Measure"); 
saveAs("Jpeg", directory2 + "VAD Mean.jpg");

/// VAD Huang FAZ -
selectWindow("4");
run("Auto Threshold", "method=Huang ignore_black white");
run("Measure"); 
saveAs("Jpeg", directory2 + "VAD Huang.jpg");

/// VAD MULTILEVEL FAZ -
selectWindow("5");
run("Morphological Filters", "operation=[White Top Hat] element=Square radius=12");
rename("52");
run("Duplicate...", "title=6");
run("FeatureJ Hessian", "smallest smoothing=1.5");
rename("7");

selectWindow("7");
setOption("ScaleConversions", true);
run("8-bit");
run("Auto Threshold", "method=Huang white");
setOption("BlackBackground", true);
run("Convert to Mask");

selectWindow("52");
run("8-bit");
run("Auto Local Threshold", "method=Median radius=15 parameter_1=0 parameter_2=0 white");
imageCalculator("AND create", "7","52");
selectWindow("Result of 7");
roiManager("Select", 0);
run("Make Inverse");
run("Measure"); 
saveAs("Jpeg", directory2 + "VAD Multilevel.jpg");

/// VSD FAZ -
selectWindow("Result of 7");
run("Mexican Hat Filter", "radius=5");
setOption("BlackBackground", true);
run("Make Binary");
run("Skeletonize");
roiManager("Select", 0);
run("Make Inverse");
run("Measure"); 
saveAs("Jpeg", directory2 + "VSD Multilevel.jpg");

close("1");
close("2");
close("3");
close("4");
close("5");
close("52");
close("6");
close("7");
close("white");
close("Result of 7");
close("sub");
close("process");
close("contour");
close("origine");

//----------------------------------------------------------------------------------------------------------------------------------
//Perfusion bioamrkers results 
saveAs("Results", directory2 + "PERFUSION biomarkers.csv");
VAD = getResult("%Area", 0);
VSD = getResult("%Area", 1);
VADmean = getResult("%Area", 2);
VADhuang = getResult("%Area", 3);
VADmultilevel = getResult("%Area", 4);
VSDmultilevel = getResult("%Area", 5);
close("results");


Dialog.create("OCT-A BIOMARKERS");
Dialog.addMessage("-------------------------------FAZ BIOMARKERS-----------------------------------");
Dialog.addNumber("FAZ-Area (mm2)", Area1);
Dialog.addNumber("FAZ-Perim (mm)", Perim1);
Dialog.addNumber("FAZ-Circ", Circ1);
Dialog.addMessage("------------------------PERFUSION BIOMARKERS------------------------");
Dialog.addNumber("Vessel area density without filters/threshold %", VAD);
Dialog.addNumber("Vessel skeleton density without filters/threshold %", VSD);
Dialog.addNumber("Vessel area density with Mean threshold %", VADmean);
Dialog.addNumber("Vessel area density with Huang threshold %", VADhuang);
Dialog.addNumber("Vessel area density with Multilevel threshold %", VADmultilevel);
Dialog.addNumber("Vessel skeleton density with Multilevel threshold %", VSDmultilevel);
Dialog.show();

setOption("Changes", false);
	setBatchMode(false);
} while(repeat);

