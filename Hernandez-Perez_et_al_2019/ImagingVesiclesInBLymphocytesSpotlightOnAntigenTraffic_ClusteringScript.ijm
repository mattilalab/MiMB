///DECONVOLUTED IMAGES HAVE TIF EXTENSION! for example             green S3_90min-W9_pEGFP_XY1492496687_Z00_T0_C0_cmle_ch00.tif and red S3_90min-W9_pEGFP_XY1492496687_Z00_T0_C0_cmle_ch01.tif
///WHEREAS NONDECONVOLUTED IMAGES HAVE tifF EXTENSION! for example green S3_90min-W9_pEGFP_XY1492496687_Z00_T0_C0.tiff          and red S3_90min-W9_pEGFP_XY1492496687_Z00_T0_C1.tiff



title = "Please make some choices";
width=512; height=512;
Dialog.create(title);


//IMPORTANT NOTE, THE SCRIPT RUNS DIFFERENTLY ON DIFFERENT COMPUTERS!
//THEREFORE PLEASE CHECK WHICH VERSION RUNS BY PUTING ALTERNATIVE ANSWERS TO ALTERNATIVE


Dialog.addCheckbox("Alternative (change if it is not working!)", true)
Dialog.addCheckbox("Deconvoluted ?", true);
Dialog.addCheckbox("Save results as .TXT ?", true);
Dialog.addChoice("Automatic Thresholding", newArray("Default", "Huang", "Intermodes", "IsoData", "Li", "MaxEntropy", "Mean", "MinError(I)", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen"));//, "Default");

Dialog.show();
var alter = 0;
var decon = 0;
var txtfile = 0;
var ThrshType = 0;
alter = Dialog.getCheckbox();
decon = Dialog.getCheckbox();
txtfile = Dialog.getCheckbox();
ThrshType = Dialog.getChoice();


//var decon="YES"; /// change this to anything but YES if the source images are NOT deconvoluted
//var txtfile="YES";/// change this to anything but YES if you want the results to be saved as .csv and only on the end of all selection, 
				//however if you want intermediary savings between each selection, then the results need to be saved as txt and txtfile variable value should be "YES"


var filext=0;
var csvtxt=0;
if (decon==true){
	filext=".tif";
}
else {
	filext=".tiff";
}


if (txtfile==true){
	csvtxt=".txt";
}
else {
	csvtxt=".csv";
}

animation="YES"; ///if "YES", then it will play 3D projection if anything else, like "NO" or uhfalekuhr it will skip the rotation animation, for faster selections


var title1 = "Text Window";
var title2 = "["+title1+"]";
b = title2;
if (isOpen(title1))
print(b, "\\Update:"); // clears the window
else
run("Text Window...", "name="+title2+" width=72 height=8 menu");




widthsl1=0;///selection width - - used later


var top01IntDnssouterRadius=1; ///var - - - making global variable!!!!
var top02IntDnssouterRadius=1;
var top03IntDnssouterRadius=1;
var top04IntDnssouterRadius=1;
var top05IntDnssouterRadius=1;
var top06IntDnssouterRadius=1;
var top07IntDnssouterRadius=1;
var top08IntDnssouterRadius=1;
var top09IntDnssouterRadius=1;
var allIntDnssouterRadius=1;
var MaxCellRadius=0;
var Xmass=0;//centre of mass of particles
var Ymass=0;
var Zmass=0;
var Xgcentroid=0;//old centroid of cell
var Ygcentroid=0;
var Zgcentroid=0;
var xCoordinates=newArray();//thresholded made selection coordinates
var yCoordinates=newArray();
var zCoordinates=newArray();
var GX=0; //green channel centroid
var GY=0;
var GZ=0;
var selwidth=0;
var selheight=0;
var sumIntDenR=0; //sum of integrated densities for red
var abpartsumcnt=0;
var redparticles=0;
var rdmeansrfd=0;
var rdmeansrfdmx=0;
var rdmaxVol=0;
var rdmeanElVlsml=0;
var rdMedianordrmxobj=0;
var rdMeanordrmxobj=0;
var rdMaxordrmxobj=0;
var rdmeanMedian=0;
var rdIntDenordrmxobj=0;
var rdmeanIntDen=0;
var rdVolordrmxobj=0;
var rdVolElipsxyordrmxobj=0;
var rdrtmx=0;
var rdsumIntDen=0;
var rdmeansrfd=0;
var AbPartSumIntDnssouterRadius=0;
var top02cnt=0;
var top10prcofsumIntDnssouterRadius=0;
var top10prcofsumcellcnt=0;
var redmedIntDen=0;
var sumdist=0;
var reddistancesforsum=0;
var MAXtop02cnt=0;
var MAXtop02IntDnssouterRadius=0;
var MEANtop02IntDnssouterRadius=0;
var MeanMedian02IntDnssouterRadius=0;
var MaxMedian02IntDnssouterRadius=0;
var redmeanVol=0;
var sumVol=0;
var topIDradius=0;
var redmaxIntDen=0;
var finalstring="";
var resultstring="";
var brghtgrncntrx=0; ///centroid coordinates of brightest green particle 
var brghtgrncntry=0;
var brghtgrncntrz=0;
var sumlengthredbrghtgrn=0;///sum of lengths of red particles to centroid coordinates of brightest green particle 
var allredx=newArray();//put here all the centroids of red particles
var allredy=newArray();
var allredz=newArray();
var sumrgdstncs=0;

nm=0;
print ("=======================================================new run ============================================================");
function timep(){
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
print ("time: year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec:",year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
}

inputFolder = getDirectory("Choose Source Directory ");
output = getDirectory("Choose Saving Directory ");

finalstring="";
print (inputFolder);

var SPTimages;

SPTinput=inputFolder;//+"Experiment\\";

nmchnls=2;//write here the number of channels
RED=" - C=1";//write here the appropriate channel //RED/ later on also identified as C1-////////// _C1
GREEN=" - C=0"; //GREEN / / / later on also identified as C2-//////////_C0
redvesicular="YES";///in case for some reason the red channel wouldnt be the vesicular antigen channel write here no


////for later use when channels are joined and lookup tables are allocated 
////and composites are made, and split:
RED2="C"+substring(RED, lengthOf(RED)-1, lengthOf(RED))+"-";//write here the appropriate channel //RED/ later on also identified as C1-
GREEN2="C"+parseInt(substring(GREEN, lengthOf(GREEN)-1, lengthOf(GREEN)))+2+"-";//GREEN / / / later on also identified as C2-

print ("RED, GREEN, RED2, GREEN2", RED,GREEN,RED2,GREEN2);

SPTimages= getFileList(SPTinput);
print(SPTimages[0]);

slctnm=1;

////with this function we measure distances between top integrated density particles
function distancess (ranktrim, heighthhhhh3, selwidth, number, mean){
	TOPIDdistances=newArray();
	TOPIDdistbtwOUTsurfcs=newArray();
	if (lengthOf(ranktrim)==1) {
		cradius=(((Bwidth[ranktrim[0]]+Bheight[ranktrim[0]])/2)/2)/9.94;  
		
	}
	else {
		

	
	for (g = 0; g < lengthOf(ranktrim); g++){ 
		////TURN PIXELS INTO MICRONS	
		x1=(X[ranktrim[g]])*0.1005944; /// HERE IT SHOULD ONLY TAKE THE OBJECTS WITH HIGHEST INT DENSITY
		y1=(Y[ranktrim[g]])*0.1005944;
	
		////TURN SLICES INTO MICRONS
		z1=(Z[ranktrim[g]])*0.27;
		for (o = 0; o < lengthOf(ranktrim); o++){ ///note that starting o is equalised to g, in order to avoid two directional relations between objects
			x2=(X[ranktrim[o]])*0.1005944;
			y2=(Y[ranktrim[o]])*0.1005944;
			z2=(Z[ranktrim[o]])*0.27;
			////calculating the distances between objects centroids
			dstnc = pow((pow((x1-x2), 2)+pow((y1-y2), 2)+pow((z1-z2), 2)),0.5);
			TOPIDdistances=Array.concat(TOPIDdistances, dstnc);//array of all the distances between objects (centroids)
			////calculating the distances between objects surfaces
			ekssurf=x1-x2-Bwidth[ranktrim[g]]*0.1005944/2-Bwidth[ranktrim[o]]*0.1005944/2; ////////////////////////////////////////////////NOTE THE MINUS AS OPPOSED IN THE ABOVE FOR LOOP
			whysurf=y1-y2-Bheight[ranktrim[g]]*0.1005944/2-Bheight[ranktrim[o]]*0.1005944/2;
			zetsurf=z1-z2-(Bheight[ranktrim[g]]*0.1005944/2+Bwidth[ranktrim[g]]*0.1005944/2)/2-(Bheight[ranktrim[o]]*0.1005944/2+Bwidth[ranktrim[o]]*0.1005944/2)/2;	//here the z surface distance is calculated as an average of X and Y surface distances because Z has huge artifactual PSF error	
			distancesrf = pow((pow((ekssurf), 2)+pow((whysurf), 2)+pow((zetsurf), 2)),0.5);
			TOPIDdistbtwOUTsurfcs=Array.concat(TOPIDdistbtwOUTsurfcs, distancesrf);//array of all the distances between objects (surfaces)
			}
		}
		Array.getStatistics(TOPIDdistbtwOUTsurfcs,minOUTsrfd, maxOUTsrfd, meanOUTsrfd, stdDOUTsrfd);
		if (mean==1) cradius=meanOUTsrfd/2;
		else cradius=maxOUTsrfd/2; ///##################         cluster radius, half of the maximum distances between any of the two objects among objects with top X% of the integrated density
		//cradius=meanOUTsrfd/2; // ---------INSTEAD OF MAX DISTANCE THE AVERAGE DISTANCE-----------------------------------------------------------------------------------------------------------------------------------------------------------
		//print("############################################### cradius: ",cradius);
			}
		return cradius;
}

///###################################################################################################################################################################################
function particleanly (stacktoanalyse, channel, heighthhhhh3, selwidth, number){
	selectWindow(stacktoanalyse);
	showStatus("particleanaly 185 "+stacktoanalyse);
	print(b, number+" particleanaly 195 "+stacktoanalyse+"\n");
	//wait(3000);
	Stack.getDimensions(wid, hei, chann, slic, fram);
	if (slic!=1) setSlice(slic/2);
	else  setSlice(slic);
	//setSlice(slic/2);//for some reason some of the selections don't work if the stack is set to first or last slice, therefore they need to be set for the middle...	
	resetMinAndMax();
	origtitle=getTitle();
	print ("origtitle for 3dprtcl measurement: ",origtitle);
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	print(b, number+" particleanaly 203 "+max+"\n");	
	//if (max>3000){ ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////WHY DOES IT NEED TO BE ABOVE 3000??????????????
	print(b, number+" particleanaly 205 "+max+"\n");	
	//print("nPixels, mean, min, max, std, histogram: ",);
	//run("Apply LUT", "stack");
	run("Duplicate...", "title=[pretest] duplicate");
	print ("DUPLICATION WORKED");
	rename("pretest");///SOMETIMES THIS DOESNT HAPPEN!!!!
	run("8-bit");
	print(b, number+" particleanaly 210 "+stacktoanalyse+"\n");
	
	if (1)//((redvesicular=="YES") & (channel==" - C=1"))/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	{

	//
		if ((decon!=true) )/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	{
		run("Subtract Background...", "rolling=5 stack");	
	}
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	selectWindow("pretest");
	if (slic!=1) setSlice(slic/2);
	else  setSlice(slic);
	Stack.getDimensions(wid, hei, chann, slic, fram);
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	//version for some systems - put into comment when not needed:
	if (alter ==1){
	run("Convert to Mask", "method="+ThrshType+" background=Dark black");//put into comments for Marikas computer
	}
	else {
	run("Convert to Mask", "method="+ThrshType);///#######################################################+++--- MOST IMPORTANT PART OF THE CODE THRESHOLDING ---++++#########################################################################
	}
	run("Fill Holes", "stack");
	run("Watershed", "stack"); //only the red channel
	run("Z Project...", "projection=[Average Intensity]");
	selectWindow(stacktoanalyse);
	selectWindow("AVG_pretest");
	run("Enhance Contrast", "saturated=2.5");	
	run("Restore Selection");
	setColor(50, 250, 50);
	run("Draw");
	run("Select None");
	run("Copy");
	selectWindow("concatenated");
	makeRectangle(selwidth, heighthhhhh3, wid, hei);
	run("Paste");
	close("AVG_pretest");
	selectWindow("pretest");	
	run("Set Scale...", "distance=9.9409 known=1 pixel=1 unit=micron global");
	run("Properties...", "channels=1 slices="+slic+" frames="+fram+" unit=micron pixel_width=0.1005944 pixel_height=0.1005944 voxel_depth=0.27 global");
	}
	else //// green channel
	{
	print(b, number+" particleanaly 242 GREEN\n");
	selectWindow("pretest");
	if (slic!=1) {
		setSlice(slic/2);
	}
	else  {
		setSlice(slic);
	}
	Stack.getDimensions(wid, hei, chann, slic, fram);
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	if (alter ==1){
	//setThreshold(10, 255);
	run("Convert to Mask", "method=Percentile background=Dark black");
	}
	else
	{
	run("Convert to Mask", "method=Percentile");///method="+ThrshType);///#######################################################+++--- MOST IMPORTANT PART OF THE CODE THRESHOLDING ---++++#########################################################################
	}
	run("Set Scale...", "distance=9.9409 known=1 pixel=1 unit=micron global");
	run("Properties...", "channels=1 slices="+slic+" frames="+fram+" unit=micron pixel_width=0.1005944 pixel_height=0.1005944 voxel_depth=0.27 global");
	run("Duplicate...", "title=[pretest2] duplicate");
	run("Z Project...", "projection=[Max Intensity]");
	selectWindow("MAX_pretest2");
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	run("Create Selection");
	type = selectionType();
 	if (type!=-1) {
 	getSelectionCoordinates(xCoordinates, yCoordinates);
	if (mean<100)
	{
		selectWindow("pretest");
		run("Invert", "stack");
		wait(500);
	}
	}
	close("MAX_pretest2");
	close("pretest2");
	
	}
	selectWindow("pretest");
	showStatus("particleanaly 259 pretest");
	print(b, number+" particleanaly 274 pretest\n");
	wait(500);
	selectWindow("pretest");
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels integrated_density mean_gray_value std_dev_gray_value median_gray_value minimum_gray_value maximum_gray_value centroid mean_distance_to_surface std_dev_distance_to_surface median_distance_to_surface centre_of_mass bounding_box dots_size=1 font_size=10 redirect_to=["+origtitle+"]");
	selectWindow("pretest");
	run("3D Objects Counter", "threshold=128 slice=24 min.=2 max.=569772 statistics summary");//min 2, so the objects are larger than just 1 voxel, to avoid some noise
	print(b, number+" after particleanaly 270 Results\n");
	selectWindow("Results");
	wait(10000);
	showStatus("particleanaly 266 Results");
	print(b, number+" particleanaly 282 Results\n");
	selectWindow("pretest");
	//print ("nResults:"+nResults);
	//print ("nImages:"+nImages);
	//seq number of elements: (0-"Volume (micron^3)",1-"Surface (micron^2)", 2-"Nb of obj. voxels", 3-"Nb of surf. voxels",4-"IntDen",5-"Mean",6-"StdDev",7-"Median",8-"Min",9-"Max",10-"X",11-"Y",12-"Z",13-"Mean dist. to surf. (micron)",14-"SD dist. to surf. (micron)",15-"Median dist. to surf. (micron)",16-"XM",17-"YM",18-"ZM",19-"BX",20-"BY",21-"BZ",22-"B-width",23-"B-height",24-"B-depth")); 
	PrAnClNm=newArray("Volume (micron^3)", "Surface (micron^2)", "Nb of obj. voxels", "Nb of surf. voxels","IntDen","Mean","StdDev","Median","Min","Max","X","Y","Z","Mean dist. to surf. (micron)","SD dist. to surf. (micron)","Median dist. to surf. (micron)","XM","YM","ZM","BX","BY","BZ","B-width","B-height","B-depth"); 
	Vol=newArray();
	Surf=newArray();
	NbObjvox=newArray();
	NbSufvox=newArray();
	IntDen=newArray();
	Mean=newArray();
	StdDev=newArray();
	Median=newArray();
	Min=newArray();
	Max=newArray();
	X=newArray();
	Y=newArray();
	Z=newArray();
	MnDstSrf=newArray();
	SDDstSrf=newArray();
	MDDstSrf=newArray();
	XM=newArray();
	YM=newArray();
	ZM=newArray();
	BX=newArray();
	BY=newArray();
	BZ=newArray();
	Bwidth=newArray();
	Bheight=newArray();
	Bdepth=newArray();
	VolRound=newArray();//calculated volume (assuming the vesicles are round and radius is calculated as average of X and Y box boundaries)
	//PrAnClNmAr=newArray(Vol,Surf,NbObjvox,NbSufvox,IntDen,Mean,StdDev,Median,Min,Max,X,Y,Z,MnDstSrf,SDDstSrf,MDDstSrf,XM,YM,ZM,BX,BY,BZ,Bwidth,Bheight,Bdepth);
	if (nResults!=0){
		for (z = 0; z < nResults; z++){
				t=0;
				//print ("row: "+(z+1)+", Volume: "+getResult("Volume (micron^3)", z)+", Surface: "+getResult("Surface (micron^2)", z)+", NmObVox: "+getResult("Nb of obj. voxels", z));
				Vol=Array.concat(Vol, getResult(PrAnClNm[t], z));
				t=t+1;
				Surf=Array.concat(Surf, getResult(PrAnClNm[t], z));
				t=t+1;
				NbObjvox=Array.concat(NbObjvox, getResult(PrAnClNm[t], z));
				t=t+1;
				NbSufvox=Array.concat(NbSufvox, getResult(PrAnClNm[t], z));
				t=t+1;
				IntDen=Array.concat(IntDen, getResult(PrAnClNm[t], z));
				t=t+1;
				Mean=Array.concat(Mean, getResult(PrAnClNm[t], z));
				t=t+1;
				StdDev=Array.concat(StdDev, getResult(PrAnClNm[t], z));
				t=t+1;
				Median=Array.concat(Median, getResult(PrAnClNm[t], z));
				t=t+1;
				Min=Array.concat(Min, getResult(PrAnClNm[t], z));
				t=t+1;
				Max=Array.concat(Max, getResult(PrAnClNm[t], z));//MAX GREY INTENSITY
				t=t+1;
				X=Array.concat(X, getResult(PrAnClNm[t], z));//CENTROID IN PIXELS! NOT MICRONS
				t=t+1;
				Y=Array.concat(Y, getResult(PrAnClNm[t], z));
				t=t+1;
				Z=Array.concat(Z, getResult(PrAnClNm[t], z));
				t=t+1;
				MnDstSrf=Array.concat(MnDstSrf, getResult(PrAnClNm[t], z));
				t=t+1;
				SDDstSrf=Array.concat(SDDstSrf, getResult(PrAnClNm[t], z));
				t=t+1;
				MDDstSrf=Array.concat(MDDstSrf, getResult(PrAnClNm[t], z));
				t=t+1;
				XM=Array.concat(XM, getResult(PrAnClNm[t], z));
				t=t+1;
				YM=Array.concat(YM, getResult(PrAnClNm[t], z));
				t=t+1;
				ZM=Array.concat(ZM, getResult(PrAnClNm[t], z));
				t=t+1;
				BX=Array.concat(BX, getResult(PrAnClNm[t], z));
				t=t+1;
				BY=Array.concat(BY, getResult(PrAnClNm[t], z));
				t=t+1;
				BZ=Array.concat(BZ, getResult(PrAnClNm[t], z));
				t=t+1;
				Bwidth=Array.concat(Bwidth, getResult(PrAnClNm[t], z));
				t=t+1;
				Bheight=Array.concat(Bheight, getResult(PrAnClNm[t], z));
				t=t+1;
				Bdepth=Array.concat(Bdepth, getResult(PrAnClNm[t], z));
				t=t+1;				
				xrad=Bwidth[z]/2;//*0.1005944;////CHECK				
				yrad=Bheight[z]/2;//*0.1005944;
				Volume=((4/3)*PI*xrad*yrad*((xrad+yrad)/2));///in microns
				VolElipsxy=Array.concat(VolElipsxy, Volume);//calculated volume as of an approximated ellipsoid where x and y are known and z is an average of x and y
		}
		VolElipsxysrt=Array.sort(VolElipsxy);
		ElVlsml=Array.trim(VolElipsxysrt, (VolElipsxysrt.length-1));
		Array.getStatistics(ElVlsml,minElVlsml, maxElVlsml, meanElVlsml, stdDElVlsml);//calculation of the statistics (mean) of the volumes calculated from x-y elipsoids (other than the largest one)
		Array.getStatistics(Vol,minVol, maxVol, meanVol, stdDVol);//calculation of the statistics as measured with 3d particle analysis 
		Array.getStatistics(Median,minMedian, maxMedian, meanMedian, stdDMedian);//calculating the statistics of median intensity values array
		Array.getStatistics(IntDen,minIntDen, maxIntDen, meanIntDen, stdDIntDen);//calculating the statistics of integrated density values array
		Array.getStatistics(Bwidth,minBwidth, maxBwidth, meanBwidth, stdDBwidth);//calculating the statistics of largest bounding box width
		Array.getStatistics(Bheight,minBheight, maxBheight, meanBheight, stdDBheight);//calculating the statistics of largest bounding box height
		Array.getStatistics(Bdepth,minBdepth, maxBdepth, meanBdepth, stdDBdepth);
		Array.getStatistics(BZ,minBZ, maxBZ, meanBZ, stdDBZ);
		//calculating the average distance between all objects and average distance from largest object
		distances=newArray();
		distbtwsurfcs=newArray();
		//reddistancesforsum=0;
		sumIntDen=0;
		for (g = 0; g < nResults; g++){
			////TURN PIXELS INTO MICRONS	
			x1=(X[g])*0.1005944;//TRANSFORMING PIXEL POSITION OF CENTROID INTO MICRONS
			y1=(Y[g])*0.1005944;
			////TURN SLICES INTO MICRONS
			z1=(Z[g])*0.27;
			distbtwsurfcs2=newArray();
			sumIntDen=sumIntDen+IntDen[g];
			for (o = 0; o < nResults; o++){ ///note that starting o is equalised to g, in order to avoid two directional relations between objects
				x2=(X[o])*0.1005944;
				y2=(Y[o])*0.1005944;
				z2=(Z[o])*0.27;
				////calculating the distances between objects centroids
				dstnc = pow((pow((x1-x2), 2)+pow((y1-y2), 2)+pow((z1-z2), 2)),0.5);
				distances=Array.concat(distances, dstnc);//array of all the distances between objects (centroids)
				////calculating the distances between objects surfaces
				ekssurf=x1-x2+Bwidth[g]*0.1005944/2+Bwidth[o]*0.1005944/2;
				whysurf=y1-y2+Bheight[g]*0.1005944/2+Bheight[o]*0.1005944/2;
				zetsurf=z1-z2+(Bheight[g]*0.1005944/2+Bwidth[g]*0.1005944/2)/2+(Bheight[o]*0.1005944/2+Bwidth[o]*0.1005944/2)/2;	//here the z surface distance is calculated as an average of X and Y surface distances because Z has huge artifactual PSF error	
				distancesrf = pow((pow((ekssurf), 2)+pow((whysurf), 2)+pow((zetsurf), 2)),0.5);
				distbtwsurfcs=Array.concat(distbtwsurfcs, distancesrf);//array of all the distances between objects (surfaces)
				distbtwsurfcs2=Array.concat(distbtwsurfcs, distancesrf);//for calculating averages
			Array.getStatistics(distbtwsurfcs2,mindistbtwsurfcs2, maxdistbtwsurfcs2, meandistbtwsurfcs2, stdDdistbtwsurfcs2);
			if ((redvesicular=="YES") & (channel==" - C=1")){
				reddistancesforsum=reddistancesforsum+meandistbtwsurfcs2;
				rdmaxVol=maxVol;
				rdmeanElVlsml=meanElVlsml;
				rdmeanMedian=meanMedian;
				rdmeanIntDen=meanIntDen;
				print ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				allredx=X;
				allredy=Y;
				allredz=Z;
				print ("alredx, alredy, alredz");
				for (z=0; z < lengthOf(allredx); z++){
					print (z+"."+", allredx: "+allredx[z]+", allredy: "+allredy[z]+", allredz: "+allredz[z]);
				}

			}
			
			
			}
		}
		Array.getStatistics(distbtwsurfcs,minsrfd, maxsrfd, meansrfd, stdDsrfd);
		if ((redvesicular=="YES") & (channel==" - C=1")){
			rdmeansrfd=meansrfd;
		}

		///////////CALCULATING THE COMMON MASS CENTRE OF ALL THE PARTICLES TO SEE HOW DISTANT IT IS FROM CENTRE OF THE CELL (IN GREEN CHANNEL)  
		///////////////////////////////////////////////////////////////////////////////////////should be only for red channel-----------------------------------------------------------
		
		if ((redvesicular=="YES") & (channel==" - C=1")){
			redparticles=nResults;
			XIntDsum=0;
			YIntDsum=0;
			ZIntDsum=0;
			IntDsum=0;	
			for (g = 0; g < redparticles; g++){
				////TURN PIXELS INTO MICRONS	
				//x1=(X[g])*0.1005944;//TRANSFORMING PIXEL POSITION OF CENTROID INTO MICRONS
				XIntDsum=XIntDsum+(X[g]*IntDen[g]);
				//y1=(Y[g])*0.1005944;
				YIntDsum=YIntDsum+(Y[g]*IntDen[g]);
				////TURN SLICES INTO MICRONS
				//z1=(Z[g])*0.27;	
				ZIntDsum=ZIntDsum+(Z[g]*IntDen[g]);
				IntDsum=IntDsum+IntDen[g];
				}
			Xmass=XIntDsum/IntDsum;
			Ymass=YIntDsum/IntDsum;
			Zmass=ZIntDsum/IntDsum;
			selectWindow("concatenated");
			setColor(250, 250, 250);
			drawRect((Xmass)-2, (Ymass+heighthhhhh3)-2, 5, 5);
			setColor(200, 50, 50);
			drawRect((Xmass+selwidth)-3, (Ymass+heighthhhhh3)-3, 5, 5);
			setColor(250, 100, 100);
			drawRect((Xmass+selwidth)-1, (Ymass+heighthhhhh3)-1, 3, 3);
			setColor(250, 200, 200);
			drawRect((Xmass+selwidth), (Ymass+heighthhhhh3), 1, 1);
			setColor(200, 0, 0);
			for (g = 0; g < redparticles; g++){
				drawRect((X[g]+selwidth), (Y[g]+heighthhhhh3), 1, 1);
			}
			setFont("SansSerif", 12, "bold antiliased");
			setColor(250, 200, 200);
		//drawString(l, eks, why, "black");
			drawString("#"+redparticles, selwidth, heighthhhhh3+14, "black");
			setFont("SansSerif", 8, "bold antiliased");
			drawString("V"+d2s(maxVol, 1), 2*selwidth-10, heighthhhhh3+8, "black");
			drawString("v"+d2s(meanVol, 1), 2*selwidth-10, heighthhhhh3+16, "black");
			drawString("IDr"+d2s((maxIntDen/(IntDsum-maxIntDen)), 1), 2*selwidth-10, heighthhhhh3+24, "black");
			
			print("MASS OF PARTICLES : CENTROID : MASS OF PARTICLES : CENTROID : MASS OF PARTICLES : CENTROID : MASS OF PARTICLES : CENTROID : ");
			print("(Xmass+selwidth): "+(Xmass+selwidth)+"(Ymass+heighthhhhh3): "+(Ymass+heighthhhhh3));		
		}

		else {
			for (v = 0; v < nResults; v++){ //finding the centroid coordinates of the green particle with highest median brightness 
				if (Median[v]==maxMedian){
					brghtgrncntrx=X[v];
					brghtgrncntry=Y[v];
					brghtgrncntrz=Z[v];
					print ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIISSSSSSSSSSSSSSSSSSSSSSSSSSSEEEEEEEEEEEEEEEEEEEEEEEEEEEEe#########################################3");
					print ("channel" + channel);
					print ("nResults" + nResults);	
					print ("VOLUME V" + Vol[v]);
				}
			}
			rgdistances=newArray();
			sumrgdstncs=0;
			for (z=0; z < lengthOf(allredx); z++){
				dstnc = pow((pow((brghtgrncntrx-allredx[z])*0.1005944, 2)+pow((brghtgrncntry-allredy[z])*0.1005944, 2)+pow((brghtgrncntrz-allredz[z])*0.27, 2)),0.5);
				print ("dstnc: "+dstnc);//////////////////////////////////////////////////FIGURE OUT IF NEEDS TO BE FACTORED STILL!
				rgdistances=Array.concat(rgdistances, dstnc);//array of all the distances between objects (centroids)
				sumrgdstncs=sumrgdstncs+dstnc;
			}
			print ("####/////######@@@@@@########=======#########00000000###########/////######@@@@@@########=======#########00000000###########/////######@@@@@@########=======###");
			print ("sumrgdstncs: "+sumrgdstncs); //////////////////////////////////////////////////FIGURE OUT IF NEEDS TO BE FACTORED STILL!	
			Xgcentroid=maxBheight/2;///9.94;
			Ygcentroid=maxBwidth/2;///9.94;
			Zgcentroid=maxBdepth/2;///9.94;
			selectWindow("concatenated");
			setColor(30, 250, 30);		
		}
	
		if ((redvesicular=="YES") & (channel==" - C=1"))
		{ 
		///IntDen
		for (o = 0; o < redparticles; o++){				//getting the sum of integrated densities for red channel
			sumIntDenR=sumIntDenR+IntDen[o];
		}

		IntDenrank=Array.rankPositions(IntDen);/////making an array of integrated density order smallest to largest
		if (((redvesicular=="YES") & (channel==" - C=1"))&redparticles!=1)
		{ 
		redmedIntDen=IntDen[IntDenrank[round(redparticles/2)]];
		}
		else redmedIntDen=IntDen[IntDenrank[0]];
		//medIntDen=IntDen[IntDenrank[round(redparticles/2)]];
		print ("print IntDen[z]");
		for (z = 0; z < lengthOf(IntDen); z++){
		//	print (z+" - "+IntDen[z]);
		}
		print ("print IntDenrank[z]");
		for (z = 0; z < lengthOf(IntDenrank); z++){
		//	print (z+" - "+IntDenrank[z]);
		}
		print ("WORK");
		Array.invert(IntDenrank);/////making an inversion of an array of integrated density order smallest to largest
		///////////////////////////////////////////////////////Calculating distances among top Integ Density particles based on the % of the SUM of IntDen of all particles
		abpartsum = 0;
		for (o=0; o < redparticles; o++){
			print("o "+o);
			print("IntDen[o] "+IntDen[o]);
			if (IntDen[o]>=round(sumIntDenR*0.02)){/////////SETTING - - -  the number of particles with integrated density equal or above 2% of total integrated density
							print("o --"+o);
							print("IntDen[o] --"+IntDen[o]);
				abpartsum=abpartsum+1;    ////the number of particles with integrated density equal or above 2% of total integrated density
			}
		}
		print("sumIntDenR "+sumIntDenR);
		print("round(sumIntDenR*0.2) "+round(sumIntDenR*0.2));
		print("abpartsum "+abpartsum);
		abpartsumcnt=abpartsum;	
		if (abpartsum==0) {
			abpartsum=1;
		}
		print("abpartsum "+abpartsum);

		ranktrim = Array.trim(IntDenrank, abpartsum); /// top 10% IntDensity particles included in distance calculations
		print ("WORK2");
		print ("print IntDenrank[z]");
		for (z = 0; z < lengthOf(IntDenrank); z++){
		//	print (z+" - "+IntDenrank[z]);
		}
		AbPartSumIntDnssouterRadius=distancess(ranktrim, heighthhhhh3, selwidth, number, 0);
		print ("WORK3");
		print ("print top01IntDranktrimranktrim");
		for (z = 0; z < lengthOf(ranktrim); z++){
		//	print (z+" - "+ranktrim[z]);
		}
		print ("############################################### cradius function AbPartSumIntDnssouterRadius: "+AbPartSumIntDnssouterRadius);
		///procedure to get median 20% Int density particles array
		ranktrim = Array.trim(IntDenrank, 0.4*redparticles);///////////////////
		Array.invert(ranktrim);
		ranktrim = Array.trim(ranktrim, 0.4*redparticles);///////////////////
		MeanMedian02IntDnssouterRadius=distancess(ranktrim, heighthhhhh3, selwidth, number, 1);
		MaxMedian02IntDnssouterRadius=distancess(ranktrim, heighthhhhh3, selwidth, number, 0);	
		top10prcofsum=0;
		top10prcofsumcnt=0;
		//limit=round(sumIntDenR*0.1);
		limit=sumIntDenR*0.1;
		var done = false;
		for (top10prcofsumcnt=0; top10prcofsum < limit && !done;top10prcofsumcnt++){	
			print ("top10prcofsum: "+top10prcofsum+"limit: "+limit+"sumIntDenR: "+sumIntDenR);
			if (top10prcofsumcnt==redparticles-1) {
				done = true; // break
			}
			top10prcofsum=top10prcofsum+IntDen[top10prcofsumcnt];					
			}
		ranktrim = Array.trim(IntDenrank, top10prcofsumcnt); /// top 30% IntDensity particles included in distance calculations
		top10prcofsumIntDnssouterRadius=distancess(ranktrim, heighthhhhh3, selwidth, number, 0);
		top10prcofsumcellcnt=lengthOf(ranktrim);	
		print ("############################################### cradius function top10prcofsumIntDnssouterRadius: "+top10prcofsumIntDnssouterRadius);
		///////////////////////////////////////////////////////Calculating distances among top Integ Density particles based on ranking of all particles by their INT Density and taking top 20%
		ranktrim = Array.trim(IntDenrank, round(0.2*redparticles)); /// top 30% IntDensity particles included in distance calculations
		MAXtop02IntDnssouterRadius=distancess(ranktrim, heighthhhhh3, selwidth, number, 0);
		MAXtop02cnt=lengthOf(ranktrim);	
		print ("############################################### cradius function top02IntDnssouterRadius: "+MAXtop02IntDnssouterRadius);
		MEANtop02IntDnssouterRadius=distancess(ranktrim, heighthhhhh3, selwidth, number, 1); ///here the mean distance between top 20% integrated density particles is calculated rather than maximum distance
	
		ranktrim = Array.trim(IntDenrank, round(1*redparticles)); /// all IntDensity particles included in distance calculations
		MAXallIntDnssouterRadius=distancess(ranktrim, heighthhhhh3, selwidth, number, 0);
		print ("############################################### cradius function allIntDnssouterRadius: "+allIntDnssouterRadius);
		MEANallIntDnssouterRadius=distancess(ranktrim, heighthhhhh3, selwidth, number, 1);
		allIntDnssouterRadius=lengthOf(ranktrim);
		}
		else 		{    /////////////////POINT 2			
					for (z = 0; z < lengthOf(IntDen); z++){
						if (BZ[z]==minBZ){
							GX=selwidth/2;
							GY=selheight/2;
							GZ=(maxBZ+(minBZ+Bdepth[z]))/2;				
						}						
					}
					MaxCellRadius=(((selheight+selwidth)/2)/2)/9.94;    /// very approximate it takes largest bounding box width and height and calculates the average, divides by 2 to get radius, divides by 9.94 to get microns, 	
					print ("############################################### MaxCellRadius: "+MaxCellRadius);
					selectWindow("concatenated");///////////////////////////////////////////////////////////////////////////////////////////////marking top 20% int dens particles centroids
					run("Select None");					
					setColor(10, 150, 10);
					drawLine((selwidth+GX), (GY+heighthhhhh3+4), (selwidth+GX+(MaxCellRadius*9.94)), (GY+heighthhhhh3+4));
					setColor(50, 250, 50);
					drawRect(selwidth+GX, GY+heighthhhhh3, 3, 2);
					setFont("SansSerif", 10, "bold antiliased");
					setColor(150, 250, 150);
					dstncCmsCllCntrd=pow((pow((Xmass-GX), 2)+pow((Ymass-GY), 2)+pow((Zmass-GZ), 2)),0.5);
					drawString("Pl:"+d2s(dstncCmsCllCntrd/MaxCellRadius, 1), 2*selwidth-10, heighthhhhh3+selheight, "black");
					setFont("SansSerif", 8, "bold antiliased");
					setColor(250, 200, 200);
					drawString("Md"+d2s(MaxMedian02IntDnssouterRadius/MaxCellRadius, 1), 2*selwidth-10, heighthhhhh3+selheight-20, "black");
					drawString("Mx"+d2s(MAXtop02IntDnssouterRadius/MaxCellRadius, 1), 2*selwidth-10, heighthhhhh3+selheight-10, "black");
					setColor(0, 0, 0);
					drawRect(GX, GY+heighthhhhh3, 2, 2);
					selectWindow("concatenated");
					setColor(100, 250, 100);
			print ("PRETESTESTESTESTESTESTETESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESS"); //Drawing of the selection should be able to reset the array of selection coordinates, doesnt initialise always...
					for (o = 0; o < lengthOf(xCoordinates); o++){
						//drawRect((xCoordinates[o]+selwidth), (yCoordinates[o]+heighthhhhh3), 1, 1);
						//print ("xCoordinates[o] : "+xCoordinates[o]+"yCoordinates[o] : "+yCoordinates[o]);
						}
						Array.print(xCoordinates);
						Array.print(yCoordinates);
						Array.fill(xCoordinates, 0);
						Array.fill(yCoordinates, 0);
			print ("PRETESTESTESTESTESTESTETESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESTESS");					
		}		
		Array.getStatistics(VolElipsxy,minVolElips, maxVolElips, meanVolElips, stdDVolElips);
		//////////////////////////////////THE CALCULATION OF DISTANCES FROM lARGEST VOLUME PARTICLE
		distancesmx=newArray();
		distbtwsurfcsmx=newArray();
		///bins for distances of other objects to max int dens object 
		//probably could be done with some sort of an array, with 11 elements, and then those elements could be renamed as needed...
		mxintdensdist_1=0;//will contain count of all the objects that have distance from max int dens object 0-1 um
		mxintdensdist_2=0;
		mxintdensdist_3=0;
		mxintdensdist_4=0;
		mxintdensdist_5=0;
		mxintdensdist_6=0;
		mxintdensdist_7=0;
		mxintdensdist_8=0;
		mxintdensdist_9=0;
		mxintdensdist_10=0;
		mxintdensdist_11=0;//will contain count of all the objects that have distance from max int dens object 0-1 um
		mxintdensdist_12=0;
		mxintdensdist_13=0;
		mxintdensdist_14=0;
		mxintdensdist_15=0;
		mxintdensdist_16=0;
		mxintdensdist_17=0;
		mxintdensdist_18=0;
		mxintdensdist_19=0;
		mxintdensdist_20=0;
		mxintdensdist_20inf=0;

		Array.getStatistics(Vol, minvol, maxvol, meanvol, stdDevvol);
		sumIntDen=0;
		for (g = 0; g < nResults; g++){
			if (IntDen[g]==maxIntDen){ /////////////////////////---------------------------------------------------------------
				ordrmxobj=g;//////////////////////determination which order number does the object of largest integrated density have - this is used elsewhere
				////TURN PIXELS INTO MICRONS	
				x1=(X[g])*0.1005945;
				//print("x1",x1);
				y1=(Y[g])*0.1005945;
				//print("y1",y1);
				////TURN SLICES INTO MICRONS
				z1=(Z[g])*0.27;
				//print("z1",z1);
				for (o = 0; o < nResults; o++){
					sumIntDen=sumIntDen+IntDen[o];///sum up all the IntDen for the ratio of the biggest ones vs sum of all the others
					x2=(X[o])*0.1005944;
					y2=(Y[o])*0.1005944;
					z2=(Z[o])*0.27;
					////calculating the distances between objects centroids
					dstnc = pow((pow((x1-x2), 2)+pow((y1-y2), 2)+pow((z1-z2), 2)),0.5);
					//print("dstnc",dstnc);
					distancesmx=Array.concat(distancesmx, dstnc);//array of all the distances between objects (centroids)

					//some clumsy if sentences used to add counters to each bin - - - - - there surely is more elegant way of doing this
					if (dstnc < 0.5){
						mxintdensdist_0=mxintdensdist_0+1;
					} 
					if ((dstnc > 0.5)&(dstnc < 1)){
						mxintdensdist_1=mxintdensdist_1+1;
					}
					if ((dstnc > 1)&(dstnc < 1.5)){
						mxintdensdist_2=mxintdensdist_2+1;
					}
					if ((dstnc > 1.5)&(dstnc < 2)){
						mxintdensdist_3=mxintdensdist_4+1;
					}
					if ((dstnc > 2)&(dstnc < 2.5)){
						mxintdensdist_5=mxintdensdist_5+1;
					}
					if ((dstnc > 2.5)&(dstnc < 3)){
						mxintdensdist_6=mxintdensdist_6+1;
					}
					if ((dstnc > 3)&(dstnc < 3.5)){
						mxintdensdist_7=mxintdensdist_7+1;
					}
					if ((dstnc > 3.5)&(dstnc < 4)){
						mxintdensdist_8=mxintdensdist_8+1;
					}
					if ((dstnc > 4)&(dstnc < 4.5)){
						mxintdensdist_9=mxintdensdist_9+1;
					}
					if ((dstnc > 4.5)&(dstnc < 5)){
						mxintdensdist_10=mxintdensdist_10+1;
					}
					if ((dstnc >5)&(dstnc < 5.5)){
						mxintdensdist_11=mxintdensdist_11+1;
					}
					if ((dstnc > 5.5)&(dstnc < 6)){
						mxintdensdist_12=mxintdensdist_12+1;
					}
					if ((dstnc > 6)&(dstnc < 6.5)){
						mxintdensdist_13=mxintdensdist_13+1;
					}
					if ((dstnc > 6.5)&(dstnc < 7)){
						mxintdensdist_14=mxintdensdist_14+1;
					}
					if ((dstnc > 7)&(dstnc < 7.5)){
						mxintdensdist_15=mxintdensdist_15+1;
					}
					if ((dstnc > 7.5)&(dstnc < 8)){
						mxintdensdist_16=mxintdensdist_16+1;
					}
					if ((dstnc > 8)&(dstnc < 8.5)){
						mxintdensdist_17=mxintdensdist_17+1;
					}
					if ((dstnc > 8.5)&(dstnc < 9)){
						mxintdensdist_18=mxintdensdist_18+1;
					}
					if ((dstnc > 9)&(dstnc < 9.5)){
						mxintdensdist_19=mxintdensdist_19+1;
					}
					if ((dstnc > 9.5)&(dstnc < 10)){
						mxintdensdist_20=mxintdensdist_20+1;
					}				
					if (dstnc > 10){
						mxintdensdist_20inf=mxintdensdist_20inf+1;	
					}				
					////calculating the distances between objects surfaces
					ekssurf=x1-x2+Bwidth[g]*0.1005944/2+Bwidth[o]*0.1005944/2;
					//print("ekssurf "+ekssurf);
					whysurf=y1-y2+Bheight[g]*0.1005944/2+Bheight[o]*0.1005944/2;
					//print("whysurf "+whysurf);
					zetsurf=z1-z2+(Bheight[g]*0.1005944/2+Bwidth[g]*0.1005944/2)/2+(Bheight[o]*0.1005944/2+Bwidth[o]*0.1005944/2)/2;	//here the z surface distance is calculated as an average of X and Y surface distances because Z has huge artifactual PSF error	
					//print("zetsurf "+zetsurf);
					distancesrf=pow((pow((ekssurf), 2)+pow((whysurf), 2)+pow((zetsurf), 2)),0.5);
					//print("distancesrf "+distancesrf);
					////////////////////////////////////////////////////////////
					distbtwsurfcsmx=Array.concat(distbtwsurfcsmx, distancesrf);//array of all the distances between objects (surfaces)

		}
		}
		}

		mxintdensdistsum=mxintdensdist_1+mxintdensdist_2+mxintdensdist_3+mxintdensdist_4+mxintdensdist_5+mxintdensdist_6+mxintdensdist_7+mxintdensdist_8+mxintdensdist_9+mxintdensdist_10+mxintdensdist_11+mxintdensdist_12+mxintdensdist_13+mxintdensdist_14+mxintdensdist_15+mxintdensdist_16+mxintdensdist_17+mxintdensdist_18+mxintdensdist_19+mxintdensdist_20+mxintdensdist_20inf;
	
		Array.getStatistics(distbtwsurfcsmx,minsrfdmx, maxsrfdmx, meansrfdmx, stdDsrfdmx);
		if ((redvesicular=="YES") & (channel==" - C=1")){
			rdmeansrfdmx=meansrfdmx;
		}

		
		print ("minsrfdmx, maxsrfdmx, meansrfdmx, stdDsrfdmx:"+minsrfdmx, maxsrfdmx, meansrfdmx, stdDsrfdmx);


		/////////////////////checking projection making
		selectWindow("pretest");
		stcklngth=nSlices;

	////////////////////////////////////////////////////////////////////////drawing on thresholded stack
		for (m = 0; m < stcklngth-1; m++){
			setSlice(m+1);	
			run("Max...", "value=50");  ///making max value of thresholded areas, so other drawings in the centre of 3d projection can be seen better
			for (l = 0; l < nResults; l++){
				zet=round(Z[l]);//geometrical centre coordinates of each object, rounding for easier counting and drawings
				eks=round(X[l]);//geometrical centre coordinates of each object
				why=round(Y[l]);//geometrical centre coordinates of each object
				if (m==zet){ //going through all the slices, drawing by the centroids
					setSlice(m+1);	 //because zet starts with 0
					setColor(255, 255, 255); //set color to white
					//print("x, y: ",X[l],Y[l]);
					drawRect(eks, why, 1, 1); //draw the centroid as a square of 1x1 pixel in the eks why coordinates in the given frame
					//waitForUser("check");
					//run("Draw", " ");//drawRect(xm, ym, width, height);
					//if (l==(nResults-1)){  //number just the last object, so one can read the number of objects		
					}		
			}
		}
		newImage("Untitled", "8-bit black", wid, 120, 1);
		setColor(200, 200, 200); //writing on the first frame the info of measurements
		setFont("SansSerif", 9, "bold antiliased");
		//drawString(l, eks, why, "black");
		dstring="count: "+l;
		drawString(dstring, 0, 9, "black");
		//dsrfstring="avdist: "+meansrfd+" um";//mean distances between objects (surfaces)
		drawString("avdist: "+d2s(meansrfd,2), 0, 18, "black");
		//dsrfstringmx="avdstmx: "+meansrfdmx+" um"; //mean distances between objects and the largest one (surfaces)
		drawString("avdstmx: "+d2s(meansrfdmx, 2), 0, 27, "black");
		//mxVl="mxVol: "+maxVol+" um^3"; //max Volume				
		drawString("mxVol: "+d2s(maxVol, 2), 0, 36, "black");
		drawString("mnVlp: "+d2s(meanElVlsml, 2), 0, 45, "black");
					/////
		drawString("mxmdInt: "+d2s(Median[ordrmxobj], 2), 0, 56, "black"); //maxMedian, meanMedian,
		drawString("avmdInt: "+d2s(meanMedian, 2), 0, 65, "black");
		drawString("mxIntD: "+d2s(IntDen[ordrmxobj], 2), 0, 74, "black");
		drawString("avIntD: "+d2s(meanIntDen, 2), 0, 83, "black");//maxIntDen, meanIntDen
		selectWindow("Untitled");
			if ((redvesicular=="YES") & (channel==" - C=1"))/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		{
				wait(500);
		}
				//wait(500);
		selectWindow("pretest");

		resultstringadd="";
		resultstringadd=resultstringadd+" CHANNEL";//, row)
		resultstringadd=resultstringadd+";"+substring(channel, lengthOf(channel)-3, lengthOf(channel));//+number;//, row)/////////////////////////////add in the start of the function the variable which channel the measurement it is done upon
		//resultstringadd=resultstringadd+"; IMG TITLE";//, row)
		//resultstringadd=resultstringadd+";"+origtitle;//, row)
		resultstringadd=resultstringadd+"; COUNT";//, row)
		resultstringadd=resultstringadd+";"+nResults;//, row)
		if ((redvesicular=="YES") & (channel==" - C=1")){
			topIDradius=(((Bwidth[ordrmxobj]+Bheight[ordrmxobj])/2)/2)/9.94;
			redmaxIntDen=maxIntDen;		
			redmeanVol=meanVol;
			rdmeansrfd=meansrfd;
		}
		
		resultstringadd=resultstringadd+"; AVRG DST BTW OBJ SRF-SRF";//, row)
		resultstringadd=resultstringadd+";"+meansrfd;//, row)
		resultstringadd=resultstringadd+"; AVRG DST BTW MX-OBJ SRF-SRF";//, row)
		resultstringadd=resultstringadd+";"+meansrfdmx;//, row)
		resultstringadd=resultstringadd+"; MX VOL";//, row)
		resultstringadd=resultstringadd+";"+maxVol;//, row)
		resultstringadd=resultstringadd+"; AVRG X-Y ELPSD 0MX VOL";//, row)
		resultstringadd=resultstringadd+";"+meanElVlsml;//, row)
		resultstringadd=resultstringadd+"; MX INT D OBJ MEDIAN INT";//, row)
		resultstringadd=resultstringadd+";"+Median[ordrmxobj];//, row)
		resultstringadd=resultstringadd+"; MX INT D OBJ AVERAGE INT";//, row)////////////////////////////////////////////////////////////////////////////////**************************
		resultstringadd=resultstringadd+";"+Mean[ordrmxobj];//, row)
		resultstringadd=resultstringadd+"; MX INT D OBJ MAX INT";//, row)////////////////////////////////////////////////////////////////////////////////**************************
		resultstringadd=resultstringadd+";"+Max[ordrmxobj];//, row)
		resultstringadd=resultstringadd+"; AVRG MEDIAN INT";//, row)
		resultstringadd=resultstringadd+";"+meanMedian;//, row)
		resultstringadd=resultstringadd+"; MX INT D INT DEN";//, row)
		resultstringadd=resultstringadd+";"+IntDen[ordrmxobj];//, row)
		resultstringadd=resultstringadd+"; AVRG INT DEN";//, row)
		resultstringadd=resultstringadd+";"+meanIntDen;//, row)
		resultstringadd=resultstringadd+"; MX INT D VOL";//, row)
		resultstringadd=resultstringadd+";"+Vol[ordrmxobj];//, row)
		resultstringadd=resultstringadd+"; MX INT D XY ELPSD VOL";//, row)
		resultstringadd=resultstringadd+";"+VolElipsxy[ordrmxobj];//, row)	
		resultstringadd=resultstringadd+"; RATIO MX/OTHR INT DEN";//, row)
		resultstringadd=resultstringadd+";"+(redmaxIntDen/(sumIntDen-redmaxIntDen));//, row)
		resultstringadd=resultstringadd+"; SUM INT DEN";//, row)
		resultstringadd=resultstringadd+";"+sumIntDen;//, row)

		if ((redvesicular=="YES") & (channel==" - C=1"))
		{	
		print("channel"+channel+"top01IntDnssouterRadius: "+top01IntDnssouterRadius);
		rdMedianordrmxobj=Median[ordrmxobj];
		rdMeanordrmxobj=Mean[ordrmxobj];
		rdMaxordrmxobj=Max[ordrmxobj];
		rdIntDenordrmxobj=IntDen[ordrmxobj];
		rdVolordrmxobj=Vol[ordrmxobj];
		rdVolElipsxyordrmxobj=VolElipsxy[ordrmxobj];
		rdrtmx=redmaxIntDen/(sumIntDen-redmaxIntDen);
		rdsumIntDen=sumIntDen;

		resultstringadd=resultstringadd+"; 0-5/5-inf um FRM MX INT D ";//, row)
		//resultstringadd=resultstringadd+";";//, row)/// also make some summary statistics to be reported as for example percentage of particles closer to the max int dens object than 5 um vs those further away...
		resultstringadd=resultstringadd+"; 20 BINS in 0.5 um FRM MX INT D count";//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_0);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_1);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_2);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_3);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_4);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_5);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_6);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_7);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_8);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_9);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_10);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_11);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_12);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_13);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_14);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_15);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_16);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_17);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_18);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_19);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_20);//, row)
		resultstringadd=resultstringadd+";"+(mxintdensdist_20inf);//, row)
		}
		else 
		{	
		print("channel"+channel+"top01IntDnssouterRadius: "+top01IntDnssouterRadius);		
		print("((4/3)*3.14*pow(MaxCellRadius, 3))"+((4/3)*3.14*pow(MaxCellRadius, 3)));
		print("(((4/3)*3.14*pow(top01IntDnssouterRadius, 3))/((4/3)*3.14*pow(MaxCellRadius, 3)))"+(((4/3)*3.14*pow(top01IntDnssouterRadius, 3))/((4/3)*3.14*pow(MaxCellRadius, 3))));


		resultstringadd=resultstringadd+"; MAXtop02cnt";//, row)
		resultstringadd=resultstringadd+";"+MAXtop02cnt; 
		resultstringadd=resultstringadd+"; MAXtop02IntDnRadRatio";//, row)
		resultstringadd=resultstringadd+";"+(MAXtop02IntDnssouterRadius/MaxCellRadius);
		resultstringadd=resultstringadd+"; MEANtop02IntDnRadRatio";//, row)
		resultstringadd=resultstringadd+";"+(MEANtop02IntDnssouterRadius/MaxCellRadius);				
		resultstringadd=resultstringadd+"; MaxMedian02IntDnssouterRadius";//, row)
		resultstringadd=resultstringadd+";"+(MaxMedian02IntDnssouterRadius/MaxCellRadius);
		resultstringadd=resultstringadd+"; MeanMedian02IntDnssouterRadius";//, row)
		resultstringadd=resultstringadd+";"+(MeanMedian02IntDnssouterRadius/MaxCellRadius);
		resultstringadd=resultstringadd+"; MaxMedian02/MaxTop02";//, row)
		resultstringadd=resultstringadd+";"+(MaxMedian02IntDnssouterRadius/MAXtop02IntDnssouterRadius);		
		resultstringadd=resultstringadd+"; MeanMedian02/MeanTop02";//, row)
		resultstringadd=resultstringadd+";"+(MeanMedian02IntDnssouterRadius/MEANtop02IntDnssouterRadius);
		resultstringadd=resultstringadd+"; topIDradius/MaxCellRadius";//, row)
		resultstringadd=resultstringadd+";"+(topIDradius/MaxCellRadius);		
		resultstringadd=resultstringadd+"; topIDradius/MeanTop02";//, row)
		resultstringadd=resultstringadd+";"+(topIDradius/MEANtop02IntDnssouterRadius);

		resultstringadd=resultstringadd+"; topIDradius/MaxTop02";//, row)
		resultstringadd=resultstringadd+";"+(topIDradius/MAXtop02IntDnssouterRadius);

		resultstringadd=resultstringadd+"; prtclmedIntDen";//, row)

		resultstringadd=resultstringadd+";"+(redmedIntDen);
		
		resultstringadd=resultstringadd+"; dstncsv/cntxClRadius";//, row)

		resultstringadd=resultstringadd+";"+(reddistancesforsum/(redparticles*MaxCellRadius));//normalised sumed average distances between particles
		resultstringadd=resultstringadd+"; dstncsv/Radius";//, row)

		resultstringadd=resultstringadd+";"+(reddistancesforsum/MaxCellRadius);//normalised sumed average distances between particles		
		resultstringadd=resultstringadd+"; PrtclmeanVol";//, row)

		resultstringadd=resultstringadd+";"+redmeanVol;
		
		resultstringadd=resultstringadd+"; sumPrtcVol/ClVol";//, row)

		resultstringadd=resultstringadd+";"+((redmeanVol*redparticles)/((4/3)*PI*MaxCellRadius*MaxCellRadius*MaxCellRadius));

		print("MAXtop02IntDnssouterRadius   "+MAXtop02IntDnssouterRadius+"  MxCellRadius   "+MaxCellRadius);
		print("Xmass "+Xmass+" GX "+GX+"Xmass-GX"+(Xmass-GX));
		print("Ymass "+Ymass+" GY "+GY+"Ymass-GY"+(Ymass-GY));
		print("Zmass "+Zmass+" GZ "+GZ+"Zmass-GZ"+(Zmass-GZ));
		dstncCmsCllCntrd=pow((pow((Xmass-GX), 2)+pow((Ymass-GY), 2)+pow((Zmass-GZ), 2)),0.5);
		resultstringadd=resultstringadd+"; dstncCmsCllCntrd/MaxCellRadius";//, row)
		print("dstncCmsCllCntrd   "+dstncCmsCllCntrd+"  MaxCellRadius   "+MaxCellRadius);
		resultstringadd=resultstringadd+";"+(dstncCmsCllCntrd/MaxCellRadius);
		resultstringadd=resultstringadd+"; MODEL";//, row)
		model=4.85973+0.03513*redparticles-0.42904*rdmeansrfd+0.27038*rdmeansrfdmx+0.14473*rdmaxVol+0.00005639*rdmeanElVlsml-0.00037758*rdMedianordrmxobj+0.00035251*rdMeanordrmxobj-0.00001613*rdMaxordrmxobj;
		print("4.85973+0.03513*redparticles-0.42904*meansrfd+0.27038*rdmeansrfdmx+0.14473*rdmaxVol+0.00005639*rdmeanElVlsml-0.00037758*rdMedianordrmxobj+0.00035251*rdMeanordrmxobj-0.00001613*rdMaxordrmxobj"+redparticles,meansrfd,rdmeansrfdmx,rdmaxVol,rdmeanElVlsml,rdMedianordrmxobj,rdMeanordrmxobj,rdMaxordrmxobj);		
		model=model+0.00000988*rdmeanMedian-0.000000085797*rdIntDenordrmxobj-0.000000265107*rdmeanIntDen-0.15389*rdVolordrmxobj+0.00116*rdVolElipsxyordrmxobj-0.02658*rdrtmx+0.00000005241003*rdsumIntDen;
		print("model+0.00000988*rdmeanMedian-0.000000085797*rdIntDenordrmxobj-0.000000265107*rdmeanIntDen-0.15389*rdVolordrmxobj+0.00116*rdVolElipsxyordrmxobj-0.02658*rdrtmx+0.00000005241003*rdsumIntDen"+rdmeanMedian,rdIntDenordrmxobj,rdmeanIntDen,rdVolordrmxobj,rdVolElipsxyordrmxobj,rdrtmx,rdsumIntDen);
		model=model+0.0004154*MAXtop02cnt+0.79665*(MAXtop02IntDnssouterRadius/MaxCellRadius)-0.98259*(MEANtop02IntDnssouterRadius/MaxCellRadius)+1.88992*(MaxMedian02IntDnssouterRadius/MaxCellRadius);
		print("model=model+0.0004154*MAXtop02cnt+0.79665*(MAXtop02IntDnssouterRadius/MaxCellRadius)-0.98259*(MEANtop02IntDnssouterRadius/MaxCellRadius)+1.88992*(MaxMedian02IntDnssouterRadius/MaxCellRadius)"+MAXtop02cnt,MAXtop02IntDnssouterRadius/MaxCellRadius,MEANtop02IntDnssouterRadius/MaxCellRadius,MaxMedian02IntDnssouterRadius/MaxCellRadius);
		model=model-4.85186*(MeanMedian02IntDnssouterRadius/MaxCellRadius)-0.87894*(MaxMedian02IntDnssouterRadius/MAXtop02IntDnssouterRadius);
		print("model=model-4.85186*(MeanMedian02IntDnssouterRadius/MaxCellRadius)-0.87894*(MaxMedian02IntDnssouterRadius/MAXtop02IntDnssouterRadius);"+(MeanMedian02IntDnssouterRadius/MaxCellRadius),(MaxMedian02IntDnssouterRadius/MAXtop02IntDnssouterRadius));
		model=model+2.32044*(MeanMedian02IntDnssouterRadius/MEANtop02IntDnssouterRadius)+4.88769*topIDradius/MaxCellRadius-6.78151*(topIDradius/MEANtop02IntDnssouterRadius)+4.27125*(topIDradius/MAXtop02IntDnssouterRadius);
		print("model+2.32044*(MeanMedian02IntDnssouterRadius/MEANtop02IntDnssouterRadius)+4.88769*topIDradius/MaxCellRadius-6.78151*(topIDradius/MEANtop02IntDnssouterRadius)+4.27125*(topIDradius/MAXtop02IntDnssouterRadius)"+(MeanMedian02IntDnssouterRadius/MEANtop02IntDnssouterRadius),topIDradius/MaxCellRadius,(topIDradius/MEANtop02IntDnssouterRadius),(topIDradius/MAXtop02IntDnssouterRadius));
		model=model+0.0000003884076*redmedIntDen+0.00014094*(reddistancesforsum/(redparticles*MaxCellRadius))+0.0000002681509*(reddistancesforsum/MaxCellRadius)+0.08827*redmeanVol-3.40319*((redmeanVol*redparticles)/((4/3)*PI*MaxCellRadius*MaxCellRadius*MaxCellRadius));
		print("model=model+0.0000003884076*redmedIntDen+0.00014094*(reddistancesforsum/(redparticles*MaxCellRadius))+0.0000002681509*(reddistancesforsum/MaxCellRadius)+0.08827*redmeanVol-3.40319*((redmeanVol*redparticles)/((4/3)*PI*MaxCellRadius*MaxCellRadius*MaxCellRadius))"+redmedIntDen,(reddistancesforsum/(redparticles*MaxCellRadius)),(reddistancesforsum/MaxCellRadius),redmeanVol,(redmeanVol*redparticles)/((4/3)*PI*MaxCellRadius*MaxCellRadius*MaxCellRadius));
		model=model+0.01518*(dstncCmsCllCntrd/MaxCellRadius);
		print("dstncCmsCllCntrd/MaxCellRadius"+dstncCmsCllCntrd/MaxCellRadius);		
		resultstringadd=resultstringadd+";"+(model);
		}


	
		print ("resultstringadd ",resultstringadd);

		close("pretest");
		close("Untitled");

	
		}
		else {
		if ((redvesicular=="YES") & (channel==" - C=1"))
		resultstringadd="CHANNEL;C=1; COUNT;0; AVRG DST BTW OBJ SRF-SRF;0; AVRG DST BTW MX-OBJ SRF-SRF;0; MX VOL;0; AVRG X-Y ELPSD 0MX VOL;0; MX INT D OBJ MEDIAN INT;0; MX INT D OBJ AVERAGE INT;0; MX INT D OBJ MAX INT;0; AVRG MEDIAN INT;0; MX INT D INT DEN;0; AVRG INT DEN;0; MX INT D VOL;0; MX INT D XY ELPSD VOL;0; RATIO MX/OTHR INT DEN;0; SUM INT DEN;0; 0-5/5-inf um FRM MX INT D ; 20 BINS in 0.5 um FRM MX INT D count;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0; top02IntDnssouterRadius;0";
		else
		resultstringadd="CHANNEL;C=0; COUNT;0; AVRG DST BTW OBJ SRF-SRF;0; AVRG DST BTW MX-OBJ SRF-SRF;0; MX VOL;0; AVRG X-Y ELPSD 0MX VOL;0; MX INT D OBJ MEDIAN INT;0; MX INT D OBJ AVERAGE INT;0; MX INT D OBJ MAX INT;0; AVRG MEDIAN INT;0; MX INT D INT DEN;0; AVRG INT DEN;0; MX INT D VOL;0; MX INT D XY ELPSD VOL;0; RATIO MX/OTHR INT DEN;0; SUM INT DEN;0; MAXtop02cnt;0; MAXtop02IntDnRadRatio;0; MEANtop02IntDnRadRatio;0; MaxMedian02IntDnssouterRadius;0; MeanMedian02IntDnssouterRadius;0; MaxMedian02/MaxTop02;0; MeanMedian02/MeanTop02;0; topIDradius/MaxCellRadius;0; topIDradius/MeanTop02;0; topIDradius/MaxTop02;0; medIntDen;0; dstncsv/cntxClRadius;0; dstncsv/Radius;0; meanVol;0; sumPrtcVol/ClVol;0; dstncCmsCllCntrd/MaxCellRadius;0";
	}
	
	return resultstringadd;
	
}


//saving as different files and getting the information about each selection
function saving(input, output, efilename, number, slctnm){// sfilename, number) {//, dateacq, seconds, positz, positx, posity, trfang, intensity) {   	//the duplication/saving function
	resultstring=0;
	number=number+1;
	selectWindow("MAX_Merged (RGB)");//+".tif");// + " Composite"+".tif");
	setLocation(0, 62);
	waitForUser("Please, make "+number+". of "+slctnm+" selection."); //user can make a selection (it can be either oval or quadratic)



////////##################################################CONCATENATED (RGB MERGE) IMAGE############################################
	getSelectionBounds(xsel, ysel, selwidth, selheight);//////////////////////////////////////////////////////////////////////////////////POINT 1
	run("Duplicate...", "title=[_mxintzproj] duplicate");
	selectWindow("_mxintzproj");
	setColor(0, 0, 0);//////////////////////////////////////////////////////////////////////////SETING THE NUMBERING OF THE CELLS, FONT POSITION ETC.....<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	setFont("SansSerif", 20, "bold antiliased");
	//	drawString(number, (xm+width/2), (ym+height/2), "white");
	drawString(number, 0, 20, "white");/////-----------------------------------------------------------------------------------------------selections
	selectWindow("_mxintzproj");
	///////////////////////////////////////////////////////////////////set max value of selection width for previous selection (probably needs to be bounced to mother function)...
	run("Copy");	
	selectWindow("concatenated");
	getDimensions(widthhhhh, heighthhhhh, channels, slicesc, framesc);
	if (widthsl1<selwidth){ // / / / trying to compare the other cells 
		widthsl1=selwidth;
		}
	if (widthsl1>selwidth){ // / / / trying to compare the other cells 
		selwidth=widthsl1;
		}	
	if (3*selwidth>widthhhhh)
		widthhhhh=4*selwidth;
	heighthhhhh2=heighthhhhh+selheight;
	heighthhhhh3=heighthhhhh;//-selheight;
	print ("CHECKING : CHECKING : CHECKING : CHECKING : CHECKING : CHECKING : CHECKING : CHECKING : ");
	print ("selheight: "+selheight);
	print ("heighthhhhh: "+heighthhhhh);
	print ("heighthhhhh3: "+heighthhhhh3);
	
	string="width="+widthhhhh+" height="+heighthhhhh2+" position=Top-Center";//"width=512 height=1512 position=Top-Center"
	run("Canvas Size...", string);
	print (string);
	selectWindow("concatenated");
	
	makeRectangle(0, heighthhhhh, selwidth, selheight);
	run("Paste");
	setColor(0, 0, 0);
	setFont("SansSerif", 6, "bold antiliased");
	selectWindow("concatenated");
	drawString(number, 0, 6, "white");	
	close("_mxintzproj");
	
	//###############################################################################adding the max int z projection of individual channels
	selectWindow("MAX_Merged (RGB)");	
	selectWindow(efilename +RED+"_orig");///************better select the original 
	Stack.getDimensions(wid, hei, chann, slic, frams);
	run("Restore Selection");
	run("Duplicate...", "title=["+RED+"_mxintzproj] duplicate");
	run("Z Project...", "projection=[Max Intensity]");
	selectWindow("MAX_"+RED+"_mxintzproj");
	getMinAndMax(minm, maxm);
	print(minm, maxm);
	setMinAndMax(minm, maxm);//change if you want brighter
	run("Copy");
	selectWindow("concatenated");
	makeRectangle(2*selwidth, heighthhhhh, selwidth, selheight);
	run("Paste");
	
	selectWindow("MAX_Merged (RGB)");	
	selectWindow(efilename +GREEN+"_orig");///************better select the original 
	Stack.getDimensions(wid, hei, chann, slic, frams);
	run("Restore Selection");
	run("Duplicate...", "title=["+GREEN+"_mxintzproj] duplicate");
	run("Z Project...", "projection=[Max Intensity]");
	selectWindow("MAX_"+GREEN+"_mxintzproj");
	getMinAndMax(minm, maxm);
	print(minm, maxm);
	setMinAndMax(minm, maxm);//change if you want brighter
	run("Copy");
	selectWindow("concatenated");
	makeRectangle(3*selwidth, heighthhhhh, selwidth, selheight);
	run("Paste");
	close(RED+"_mxintzproj");
	//run("Close");	
	close(GREEN+"_mxintzproj");
	//run("Close");
	close("MAX_"+RED+"_mxintzproj");
	//run("Close");	
	close("MAX_"+GREEN+"_mxintzproj");
	//run("Close");
	//###################################################CONCATENATED IMAGE###################################################3
	selectWindow("MAX_Merged (RGB)");
	setColor(255, 255, 255);
	getSelectionBounds(xm, ym, width, height);	
	run("Line Width...", "line=2");
	run("Draw", " ");//drawRect(xm, ym, width, height);
	setColor(0, 0, 0);//////////////////////////////////////////////////////////////////////////SETING THE NUMBERING OF THE CELLS, FONT POSITION ETC.....<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	setFont("SansSerif", 40, "bold antiliased");
	//	drawString(number, (xm+width/2), (ym+height/2), "white");
	drawString(number, xm, (ym+height/2), "white");
	seltyp=selectionType();
	print ("seltyp: ", seltyp);
	
	selectWindow("Merged-1");
	run("Restore Selection");
	efilenamecln=replace(efilename,filext,"");
	efilenamecln=replace(efilename,"Z00_T0_C0","");
	Stack.getDimensions(wid, hei, chann, slic, frams);
	run("Duplicate...", "title=["+efilenamecln+"-"+number+"] duplicate range=1-"+slic);
	if (seltyp!=0) run("Clear Outside", "add stack");
	saveAs("tif",  output+"\\"+"selections_RGB"+"\\"+efilenamecln+"-RGB-"+number+filext);//saving with one generic name
	close(efilenamecln+"-RGB-"+number+filext);
	//run("Close");
	selectWindow("Merged");
	run("Restore Selection");
	efilenamecln=replace(efilename,filext,"");
	efilenamecln=replace(efilename,"Z00_T0_C0","");
	Stack.getDimensions(wid, hei, chann, slic, frams);
	run("Duplicate...", "title=["+efilenamecln+"-cmpst-"+number+"] duplicate range=1-"+slic);
	if (seltyp!=0) run("Clear Outside", "add stack");
	saveAs("tif",  output+"\\"+"selections_composite"+"\\"+efilenamecln+"-cmpst-"+number+filext);//saving with one generic name
		
	resultstring=" SELECTION (CELL)";//, row)
	resultstring=resultstring+";"+number;//, row)
	resultstring=resultstring+"; FILENAME";//, row)
	resultstring=resultstring+";"+efilename;//, row)	
	
	selectWindow(efilenamecln+"-cmpst-"+number+filext);
	/////////////////////////////////////////////////////////////////////////////////////////////
	compositetit=getTitle();
	run("Split Channels");
	///script can be unstable, it may produce C1-name,C2-name after split or name(blue), name(green), name(red)...
	///so I need to make it able to handle both possibilites
	if(isOpen(RED2+compositetit)==1){
		resultstring=resultstring+";"+particleanly(RED2+compositetit, RED, heighthhhhh3, selwidth, number);
		selectWindow(RED2+compositetit);
		showStatus("saving 1262 "+RED2+compositetit);
		print(b, number+"saving 1262 "+RED2+compositetit+"\n");
		//wait(3000);
		close(RED2+compositetit);
		run("Clear Results");
		resultstring=resultstring+";"+particleanly(GREEN2+compositetit, GREEN, heighthhhhh3, selwidth, number);	
		selectWindow(GREEN2+compositetit);
		showStatus("saving 1269 "+GREEN2+compositetit);
		print(b, number+"saving 1269 "+GREEN2+compositetit+"\n");
		//wait(3000);
		close(GREEN2+compositetit);	
		run("Clear Results");
	}
	if(isOpen(compositetit+" (red)")==1){
		resultstring=resultstring+";"+particleanly(compositetit+" (red)", RED, heighthhhhh3, selwidth, number);
		close(compositetit+" (red)");
		run("Clear Results");
		resultstring=resultstring+";"+particleanly(compositetit+" (green)", GREEN, heighthhhhh3, selwidth, number);
		close(compositetit+" (green)");
		run("Clear Results");	
		close(compositetit+" (blue)");	
			
	}
		
	/////////////////////////////////////////////////////////////////////////////////////////////	
	
	/////////////////////////////INSERTING THE SUMMED DISTANCES FROM ALL RED PARTICLES TO MTOC IN THE BEGGINING OF THE RESULTS, JUST AFTER THE PARTICLE COUNT
	insrtsummed=indexOf(resultstring,"AVRG DST BTW OBJ SRF-SRF")-2;
	resultstring1=substring(resultstring,0,insrtsummed);
	print ("resultstringadd1",resultstring1);
	resultstring2=substring(resultstring,insrtsummed);
	print ("resultstringadd2",resultstring2);
	resultstring=resultstring1+"; SUMMEDDISTANCESTOMTOC"+";"+sumrgdstncs+resultstring2;//, row)
	return resultstring;

}


function selecting (input, output, slctnm, efilename){//, sfilename){//, dateacq, seconds, positz, positx, posity, trfang, intensity){
	resultstring="";
	for (z = 0; z < slctnm; z++){
		print (" SELECTION : "+z+" SELECTION : "+z+" SELECTION : "+z+" SELECTION : "+z+" SELECTION : "+z+" SELECTION : "+z+" SELECTION : "+z+" SELECTION : "+z+" SELECTION : "+z);
		IJ.redirectErrorMessages();
		print ("z in function selecting is: "+z);
		addstring=saving(input, output, efilename, z, slctnm);//sfilename, z);//, dateacq, seconds, positz, positx, posity, trfang, intensity); 
	
		print("z "+z+"current addstring "+addstring);
		
		if (txtfile==true){
		finalstring=finalstring+"$"+addstring;
		writing(finalstring);
		}
		else {
			resultstring=resultstring+"$"+addstring;
		}
		}
	return resultstring;
}

function writing (finalstring) {
	listofstrings=split(finalstring,"$"); //spliting of the finalstring by implanted "$" so it can be print-parsed line by line as needed into final file
	print(lengthOf(listofstrings));
	z=lengthOf(listofstrings);
	print("funct. writing: current finalstring "+finalstring);
	f = File.open(output+efilename+"-results"+csvtxt);//////File where the results will be saved into, has to be .txt or .java
	for (i=0;i<z;i++){
	writenstring=listofstrings[i];
	print(f,substring(listofstrings[i], 1, lengthOf(listofstrings[i])));//removal of first character in each line (0 from string stacking)
	}
	File.close(f);
}
for (i = 0; i < SPTimages.length; i++) {
	IJ.redirectErrorMessages();
	max=SPTimages.length;
	efilename=SPTimages[i];//experiment##.czi - SPT file	//sfilename=BFimages[i];//snap##.czi - BF file
	print(SPTimages[i]);
	
	if (endsWith(SPTimages[i], filext)){	
			
		for (i = i; i < nmchnls; i++){
			//[" + path + "] square brackets are important for opening of spaced filenames, paths
			run("Bio-Formats Importer", "open=["+SPTinput+SPTimages[i]+"] color_mode=Default split_channels view=[Standard ImageJ] stack_order=Default");	
			timep();
			Stack.getDimensions(wid, hei, chann, slic, fram);
			if (decon!=true){
				print("1. wid, hei, chann, slic, fram",wid, hei, chann, slic, fram);
				Stack.setDimensions(chann, fram, slic);//originaly Stack.setDimensions(channels, slices, frames); //so that's how we switch slices and frames
				Stack.getDimensions(wid, hei, chann, slic, fram);
				print("2. wid, hei, chann, slic, fram",wid, hei, chann, slic, fram);
			}

			run("Properties...", "channels=1 slices="+slic+" frames="+fram+" unit=micron pixel_width=0.1005944 pixel_height=0.1005944 voxel_depth=0.27 global");
		}
		if (indexOf(getTitle(), "ch01") != -1){
			Stack.getDimensions(wid, hei, chann, slic, fram);
			print("if sentence red dimensions wid, hei, chann, slic, fram: "+wid, hei, chann, slic, fram);
			name=getTitle();
			print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			print (name);
			name=replace(name,"ch01"+filext+" - C=0","ch00"+filext+" - C=1");
			print (name);
			rename(name);
			print(getTitle());//////////////////////////////////////////////////////////////////////////////////////////////////
					//////////////////////////////////////////////////////////////////////////////////////////////////
		}													//////////////////////////////////////////////////////////////////////////////////////////////////
		selectWindow(efilename+RED);//that is why it needs to be duplicated into "ordinary" stack
		Stack.getDimensions(wid, hei, chann, slic, fram);
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		selectWindow(efilename +RED);
		//run("Duplicate...", "title=["+efilenamecln+"-"+number+"] duplicate range=1-"+frams);
		run("Duplicate...", "title=["+efilename +RED+"_orig] duplicate range=1-"+slic);
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		selectWindow(efilename +RED);
		//run("Brightness/Contrast...");//enhancing contrast
		//resetMinAndMax();
		//run("Enhance Contrast", "saturated=0.35");
		setLocation(0, 624);
		setSlice(slic);
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		run("Set Measurements...", "area mean standard modal min median skewness redirect=None decimal=3");
		run("Measure");
		print(getResult("StdDev"));//, row)
		print(getResult("Mean"));//, row)
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		selectWindow(efilename+GREEN);
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		run("Duplicate...", "title=["+efilename +GREEN+"_orig] duplicate range=1-"+slic);
		selectWindow(efilename +GREEN);
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//run("Brightness/Contrast...");//enhancing contrast
		//resetMinAndMax();
		//run("Enhance Contrast", "saturated=0.35");
		cmrgstck="c1=["+efilename+RED+"] c2=["+efilename+GREEN+"] create"; //line for merging when stacks
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		run("Merge Channels...", cmrgstck);
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		rename("Merged");
		//run("RGB Color", "frames keep");
		//run("Stack to RGB", "slices keep");
		run("RGB Color", "slices keep");
		rename("Merged-1");
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		run("Animation Options...", "speed=19.813 first=1 last=197");
		selectWindow("Merged-1");//+".tif");// + " Composite"+".tif");
		setLocation(512, 112);
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//selectWindow(efilename+GREEN);
		//setLocation(0, 112);
		//selectWindow(efilename+RED);
		setLocation(1024, 112);
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		selectWindow("Merged");
		run("Z Project...", "projection=[Max Intensity]");
		run("Brightness/Contrast...");//enhancing contrast
		resetMinAndMax();
		run("Enhance Contrast", "saturated=0.35");	
		run("RGB Color");
		//selectWindow("Composite");
		//run("Close");
		close("Merged");
		//run("Close");
		close("Merged-1");
		print("until here reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//run("Close");
		cmrgstck="c1=["+efilename+RED+"_orig] c2=["+efilename+GREEN+"_orig] create keep"; //line for merging when stacks
		run("Merge Channels...", cmrgstck);
		rename("Merged");		
		run("RGB Color", "slices keep");		
		print("reporter#: "+(nm++)+" ",getTitle());////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		selectWindow("MAX_Merged (RGB)");
		run("Enhance Contrast", "saturated=0.35");	
		setLocation(0, 62);
		////
		brgth=1;
		brgth=getNumber("How much brighter? Set 1-5 (0.4 same as is, 5 much brigther)", brgth); 
		getMinAndMax(minm, maxm); //##########################################change the brightness on selection image
		print (minm,maxm);
		setMinAndMax(minm, maxm/brgth);
		print (minm,maxm);
		///
		slctnm=getNumber("How many selections(cells)?", slctnm); 
		File.makeDirectory(output+"\\"+"selections_RGB");	
		File.makeDirectory(output+"\\"+"selections_composite");	
		newImage("concatenated", "RGB black", 1, 1, 1);
		selectWindow("MAX_Merged (RGB)");	
		if (txtfile!=true){
		finalstring=finalstring+"$"+selecting(SPTinput, output, slctnm, efilename);//, sfilename);
		writing(finalstring);
		}
		else{
			selecting(SPTinput, output, slctnm, efilename);//, sfilename);
		}
		selectWindow("concatenated");
		saveAs("jpg",  output+"\\"+efilename+"-all-selections-concatenated.jpg");	
		selectWindow("MAX_Merged (RGB)");
		saveAs("jpg",  output+"\\"+efilename+"-all-selections.jpg");//saving with one generic name
		run("Close All");
	}

}
//writing(finalstring);