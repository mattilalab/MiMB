//VID SUSTAR (PIETA MATTILA, UNIVERSITY OF TURKU)


//#################################### IMPORTANT !!! #############################################
//################################## BEFORE RUNNING ##############################################
//##################### CHECK THE ORDER AND COLORS OF CHANNELS ###################################
//############################### IN YOUR RAW FILES ##############################################
//############################## FILL APPROPRIATELY ##############################################
//WHEN YOUR RAW FILE IS IMPORTED TO IMAGEJ IT IS SPLIT IN INDVIDUAL IMAGES FOR EACH CHANNEL USED, 
//EACH CHANNEL IMAGE IS GIVEN CONSECUTIVE ORDER (ORDER OF IMAGING ON MICROSCOPE)
red=" - C=0";//write here the appropriate channel 
green=" - C=1";

//#################################### IMPORTANT !!! #############################################
//################################## BEFORE RUNNING ##############################################
//################################### ADDITIONALY ################################################
//############################## FILL APPROPRIATELY ##############################################
//IMAGE J color coding:
//c1=red,c2=green,c3=blue,c4=grey,c5=cyan,c6=magenta,c7=yellow 
redc="c1";
greenc="c2"; 
//#################################### IMPORTANT !!! #############################################


inputFolder = getDirectory("Choose Source Directory ");
output = getDirectory("Choose Saving Directory ");



print ("=======================================================new run ============================================================");
print (inputFolder);
Images= getFileList(inputFolder);
File.makeDirectory(output+"\\"+"processed");

finalstring="";
slctnm=1;

function measuresl(string){
	resultstringadd=resultstringadd+"; Area";//, row)
	resultstringadd=resultstringadd+";"+getResult("Area");//, row)
	resultstringadd=resultstringadd+"; Perim";//, row)
	resultstringadd=resultstringadd+";"+getResult("Perim.");//, row)
	resultstringadd=resultstringadd+"; INTENSITY";//, row
	resultstringadd=resultstringadd+"; Mean";//, row
	resultstringadd=resultstringadd+";"+getResult("Mean");//, row)
	resultstringadd=resultstringadd+"; Mode";//, row
	resultstringadd=resultstringadd+";"+getResult("Mode");//, row)
	resultstringadd=resultstringadd+"; Median";//, row
	resultstringadd=resultstringadd+";"+getResult("Median");//, row)
	resultstringadd=resultstringadd+"; StdDev";//, row	
	resultstringadd=resultstringadd+";"+getResult("StdDev");//, row)
	resultstringadd=resultstringadd+"; Min";//, row	
	resultstringadd=resultstringadd+";"+getResult("Min");//, row)
	resultstringadd=resultstringadd+"; Max";//, row	
	resultstringadd=resultstringadd+";"+getResult("Max");//, row)
	resultstringadd=resultstringadd+"; IntDensity:Area*MnGryVl";//, row	
	resultstringadd=resultstringadd+";"+getResult("RawIntDen");//, row)
	resultstringadd=resultstringadd+"; Skew";//, row	
	resultstringadd=resultstringadd+";"+getResult("Skew");//, row)
	resultstringadd=resultstringadd+"; Kurt";//, row	
	resultstringadd=resultstringadd+";"+getResult("Kurt");//, row)
	resultstringadd=resultstringadd+"; SHAPE";//, row	
	resultstringadd=resultstringadd+"; Major elpse";//, row	
	resultstringadd=resultstringadd+";"+getResult("Major");//, row)
	resultstringadd=resultstringadd+"; Minor elpse";//, row	
	resultstringadd=resultstringadd+";"+getResult("Minor");//, row)
	resultstringadd=resultstringadd+"; Angle elpse";//, row	
	resultstringadd=resultstringadd+";"+getResult("Angle");//, row)
	resultstringadd=resultstringadd+"; AspRt elpse";//, row	
	resultstringadd=resultstringadd+";"+getResult("AR");//, row)
	resultstringadd=resultstringadd+"; Circ=4PIxAr//Per^2";//, row	
	resultstringadd=resultstringadd+";"+getResult("Circ.");//, row)
	resultstringadd=resultstringadd+"; Feret";//, row	
	resultstringadd=resultstringadd+";"+getResult("Feret");//, row)
	resultstringadd=resultstringadd+"; Round=4xAr//PIxMajrAxs^2";//, row	
	resultstringadd=resultstringadd+";"+getResult("Round");//, row)	
	resultstringadd=resultstringadd+"; Solidity=Ar/CnvxAr";//, row	
	resultstringadd=resultstringadd+";"+getResult("Solidity");//, row)
	run("Analyze Particles...", "display summarize in_situ");
	selectWindow("Summary"); 
	lines = split(getInfo(), "\n"); 
	headings = split(lines[0], "\t"); 
	values = split(lines[lengthOf(lines)-1], "\t");
	for (i=0; i<headings.length; i++) {
		if (headings[i]=="Count")
			resultstringadd=resultstringadd+"; prtc "+headings[i]+"; "+values[i];//PARTICLE ANALYSIS";//, row
		if (headings[i]=="Average Size")
			resultstringadd=resultstringadd+"; prtc "+headings[i]+"; "+values[i];
		if (headings[i]=="Circ.")
			resultstringadd=resultstringadd+"; prtc "+headings[i]+"; "+values[i];
		if (headings[i]=="Solidity")
			resultstringadd=resultstringadd+"; prtc "+headings[i]+"; "+values[i];
		if (headings[i]=="Perimeter")
			resultstringadd=resultstringadd+"; prtc "+headings[i]+"; "+values[i];
		if (headings[i]=="Major")
			resultstringadd=resultstringadd+"; prtc "+headings[i]+"; "+values[i];	
		if (headings[i]=="Minor")
			resultstringadd=resultstringadd+"; prtc "+headings[i]+"; "+values[i];	
}


	
	return resultstringadd;
}

function saving(input, output, efilename, number){// sfilename, number) {//, dateacq, seconds, positz, positx, posity, trfang, intensity) {   	//the duplication/saving function
	number=number+1;
	selectWindow(efilename+"_RGB");
	Stack.setSlice(1);


	
	waitForUser("Please, make "+number+". selection."); //user can make a selection (it can be either oval or quadratic)
	selectWindow(efilename+"_RGB");
	Stack.setSlice(6);
	setColor(255, 255, 255);
	getSelectionBounds(x, y, width, height);
	drawRect(x, y, width, height);
	setColor(0, 0, 0);
	drawString(number, x, y, "white");
	selectWindow(efilename+red);
	run("Restore Selection"); ///making duplicates for thresholding
	run("Duplicate...", "title=["+efilename+"-"+number+"red.tif]");
	run("Duplicate...", "title=["+efilename+"-"+number+"red-lclthrshld.tif]");
	run("Duplicate...", "title=["+efilename+"-"+number+"red-thrshld.tif]");
	selectWindow(efilename+green);
	run("Restore Selection");	
	run("Duplicate...", "title=["+efilename+"-"+number+"green.tif]");
	run("Duplicate...", "title=["+efilename+"-"+number+"green-thrshld.tif]");
////////////////////////////////////////////////////////////////////////////////red whole cell selection threshold
	selectWindow(efilename+"-"+number+"red-thrshld.tif");
	run("8-bit");
	run("Auto Threshold", "method=Huang white");
	setOption("BlackBackground", true);
	//run("Make Binary");
	run("Fill Holes");
	run("Create Selection");
	getSelectionBounds(sbAtx, sbAty, sbtwidth, sbtheight);
	run("Set Measurements...", "area mean standard modal min perimeter fit shape feret's integrated median skewness kurtosis area_fraction display redirect=None decimal=9");
	selectWindow(efilename+"-"+number+"red.tif");
	run("Restore Selection");
	run("Measure");
	svngnm=replace(efilename, ".czi", "");
	resultstringadd="";
	resultstringadd="S"+svngnm+"-"+number;//dont know where "S" went, so had to add it here...
	resultstringadd=resultstringadd+";"+"# red WHL CELL#";//, row)
	selectWindow(efilename+"-"+number+"red-thrshld.tif");
	resultstringadd=resultstringadd+measuresl(resultstringadd);
	selectWindow(efilename+"-"+number+"red.tif");
	run("Draw", "slice");
/////////////////////////////////////////////////////////////////////// 
	selectWindow(efilename+"_RGB");
	Stack.setSlice(5);
	run("Restore Selection");
	setSelectionLocation(x+sbAtx, y+sbAty);
	setForegroundColor(200, 100, 100); // setting the color of  red selection
	run("Draw", " ");   /// as opposed to run("Draw", "stack"); if we wanted to process the whole stack - draw on whole stack
	selectWindow(efilename+"_RGB");
	Stack.setSlice(2);
	run("Restore Selection");
	setSelectionLocation(x+sbAtx, y+sbAty);
	setForegroundColor(100, 100, 100); // setting the color of  red selection
	run("Draw", " ");
	run("Select None");
	/////////////////////////////////////////////////////////////// red local threshold
	selectWindow(efilename+"-"+number+"red-lclthrshld.tif");
	run("8-bit");
	run("Auto Local Threshold", "method=Bernsen radius=45 parameter_1=0 parameter_2=0 white");
	setAutoThreshold("Default dark");
	run("Create Selection");
	getSelectionBounds(sbAx, sbAy, sbwidth, sbheight);
	run("Set Measurements...", "area mean standard modal min perimeter fit shape feret's integrated median skewness kurtosis area_fraction display redirect=None decimal=9");
	selectWindow(efilename+"-"+number+"red.tif");
	run("Restore Selection");
	run("Measure");
	//svngnm=replace(efilename, ".czi", "");
	//resultstringadd="";
	//resultstringadd="S"+svngnm+"-"+number;//dont know where "S" went, so had to add it here...
	resultstringadd=resultstringadd+";"+"# red LCL TRSHLD#";//, row)
	selectWindow(efilename+"-"+number+"red-lclthrshld.tif");
	resultstringadd=resultstringadd+measuresl(resultstringadd);
	selectWindow(efilename+"-"+number+"red.tif");
	run("Draw", "slice");
	/////////////////////////////////////////////////////////////////////// 
	selectWindow(efilename+"_RGB");
	Stack.setSlice(5);
	run("Restore Selection");
	setSelectionLocation(x+sbAx, y+sbAy);
	setForegroundColor(255, 0, 0); // setting the color of  red selection
	run("Draw", " ");   /// as opposed to run("Draw", "stack"); if we wanted to process the whole stack - draw on whole stack
	selectWindow(efilename+"_RGB");
	Stack.setSlice(3);
	run("Restore Selection");
	setSelectionLocation(x+sbAx, y+sbAy);
	setForegroundColor(100, 100, 100); // setting the color of  red selection
	run("Draw", " ");
	run("Select None");
	//////////////////////////////////////////////////////////////////////////green local selection threshold
	selectWindow(efilename+"-"+number+"green-thrshld.tif");
	run("8-bit");
	run("Auto Local Threshold", "method=Bernsen radius=10 parameter_1=0 parameter_2=0 white");
	setAutoThreshold("Default dark");
	run("Create Selection");
	getSelectionBounds(sbpTx, sbpTy, sbwidth, sbheight);
	run("Set Measurements...", "area mean standard modal min perimeter fit shape feret's integrated median skewness kurtosis area_fraction display redirect=None decimal=9");
	selectWindow(efilename+"-"+number+"green.tif");
	run("Restore Selection");
	run("Measure");
	resultstringadd=resultstringadd+";"+"# green #";//, row)
	selectWindow(efilename+"-"+number+"green-thrshld.tif");	
	resultstringadd=resultstringadd+";"+measuresl(resultstringadd);///ADD TO RESULTS
	selectWindow(efilename+"-"+number+"green.tif");
///////////////////////////////////////////////////////////////////////
	selectWindow(efilename+"_RGB");
	Stack.setSlice(5);
	run("Restore Selection");
	setSelectionLocation(x+sbpTx, y+sbpTy);
	setForegroundColor(0, 255, 0); // setting the color of  red selection
	run("Draw", " ");
	selectWindow(efilename+"_RGB");
	Stack.setSlice(4);
	run("Restore Selection");
	setSelectionLocation(x+sbpTx, y+sbpTy);
	setForegroundColor(150, 150, 150);  // setting the color of  red selection
	run("Draw", " ");
//////////////////////////////////////////////////////////////////////////
	print("funct. saving, current resultstring "+resultstringadd);
	return resultstringadd;
	
}
function selecting (input, output, slctnm, efilename){//, sfilename){//, dateacq, seconds, positz, positx, posity, trfang, intensity){
	resultstring="";
	for (z = 0; z < slctnm; z++){
		print ("z in function selecting is: "+z);
		addstring=saving(input, output, efilename, z);//sfilename, z);//, dateacq, seconds, positz, positx, posity, trfang, intensity); 
		print("z "+z+"current addstring "+addstring);
		resultstring=resultstring+"$"+addstring;
		print("funct. selecting: run "+z+", current resultstring "+resultstring +", current addstring "+addstring);
		}
	return resultstring;
}
function writing (finalstring) {
	listofstrings=split(finalstring,"$"); //spliting of the finalstring by implanted "$" so it can be print-parsed line by line as needed into final file
	print(lengthOf(listofstrings));
	z=lengthOf(listofstrings);
	print("funct. writing: current finalstring "+finalstring);
	f = File.open(output+"results.txt");//////File where the results will be saved into, has to be .txt or .java
	for (i=0;i<z;i++){
	writenstring=listofstrings[i];
	print(f,substring(listofstrings[i], 1, lengthOf(listofstrings[i])));//removal of first character in each line (0 from string stacking)
	//print(f,writenstring);	
	}
	File.close(f);
}

for (i = 0; i < Images.length; i++) {
	newImage("Untitled", "16-bit black", 512, 512, 1);
	efilename=Images[i];
	print(Images[i]);
	run("Bio-Formats Importer", "open="+inputFolder+Images[i]+" color_mode=Default split_channels view=[Standard ImageJ] stack_order=Default");
	selectWindow(efilename+red);
	selectWindow(efilename+green);
	cmrgstck=redc+"=["+efilename+red+"] "+greenc+"=["+efilename+green+"] create keep";  //c1=red,c2=green,c3=blue,c4=grey,c5=cyan,c6=magenta,c7=yellow 
	run("Merge Channels...", cmrgstck);
	selectWindow("Composite");
	run("RGB Color");
	selectWindow("Composite (RGB)");
	resetMinAndMax();
	//run("Enhance Contrast", "saturated=0.35");
	//run("Apply LUT");
		selectWindow("Composite (RGB)");
	rename(efilename+"_RGB");
	selectWindow("Composite");
	run("Close");
	cmrgstck1=redc+"=["+efilename+red+"] "+greenc+"=[Untitled] create keep"; 
	run("Merge Channels...", cmrgstck1);
	selectWindow("Composite");
	run("RGB Color");
	selectWindow("Composite (RGB)");
	resetMinAndMax();
	rename(efilename+"_red");
	selectWindow("Composite");
	run("Close");
	cmrgstck2=redc+"=[Untitled] "+greenc+"=["+efilename+green+"] create keep"; 
	run("Merge Channels...", cmrgstck2);
	selectWindow("Composite");
	run("RGB Color");
	selectWindow("Composite (RGB)");
	resetMinAndMax();
	rename(efilename+"_green");
	selectWindow("Composite");
	run("Close");
	selectWindow(efilename+"_RGB");
	run("Add Slice");
	run("Add Slice");
	run("Add Slice");
	run("Add Slice");
	Stack.setSlice(1);
	run("Copy");
	Stack.setSlice(5);
	run("Paste");
	selectWindow(efilename+"_red");
	run("Copy");
	selectWindow(efilename+"_RGB");
	Stack.setSlice(2);
	run("Paste");
	Stack.setSlice(3);
	run("Paste");
	selectWindow(efilename+"_green");
	run("Copy");
	selectWindow(efilename+"_RGB");
	Stack.setSlice(4);
	run("Paste");
	Stack.setSlice(1);	
	slctnm=getNumber("How many selections(cells)?", slctnm); 
	finalstring=finalstring+"$"+selecting(inputFolder, output, slctnm, efilename);//, sfilename);
	writing(finalstring);
	selectWindow(efilename+"_RGB");
	Stack.setSlice(1);
	setColor(0, 0, 0);
	x=20;
	y=20;
	drawString(efilename, x, y, "white");
	Stack.setSlice(2);
	drawString("red + red threshold selection", x, y, "white");
	Stack.setSlice(3);
	drawString("red + red local threshold selection", x, y, "white");
	Stack.setSlice(4);
	drawString("green + green threshold slctn", x, y, "white");
	Stack.setSlice(5);
	drawString("red threshold slctn + green threshold slctn, whole cell selection boundaries", x, y, "white");			
	savingname=replace(efilename+"_RGB", ".czi", "");
	saveAs("Tiff", output+"\\"+"processed"+"\\"+savingname+".tif");
	run("Close All");
}