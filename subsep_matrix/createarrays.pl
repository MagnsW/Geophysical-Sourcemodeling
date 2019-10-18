#!/usr/bin/perl
#HACKED VERSION !!!! Will create 3150 array with subarray separations 4 to 12m. 289 combinations
#This script creates a large number of PGS standard subarrays and arrays for Nucleus+
#This version supports array configurations 2360, 2620, 3090, 3930version1, 3930version2, 4130, 4720, 6180, 3111H, 4135H and 6222H. Newly added are the 4100 sanco array and the Triple sources 3260, 2820 and 2740 (Sanco). 3150 is also addedm which is a 3090 with 40s instead of 20s.
#Suggested use: 
#1. Copy script to ...NIIprojects/Sourcemod/SourceArrays/ (For Nucleus project called Sourcemod. If other project name, change $project parameter below). 
#2. Run script by cd-ing into directory and type "./createarrays.pl". No arguments needed. Range of arrays generated can be limited by changing parameters below. Existing files of same name will be overwritten.
#Updates:
#20/06/2012: New numbering convention implemented (last gun is number 14 on all arrays). Changed name of subarrays created to hide subarray depth.
#20/05/2014: Gun numbering error for 0737H subarray corrected
#27/10/2016: Added arrays 2820, 3260, 4100
#31/10/2016: Project changed from Sourcemod_newnum to Sourcemod (Old gun numbering discontinued)
#10/01/2017: Swapped 1710 and 1510 subarrays for 3260 array
#23/01/2017: 4100 array spares swapped; 3265H array added (GII version of 3260)
#30/10/2017: 1510 and 1515H subarrays - corrected pressure for other than 2000psi (affects 3260 and 3265H arrays for other than 2000psi)
#29/05/2018: 2740 (Sanco triple) and 3150 (3090 with 40s instead of 20s) arrays added. 
#Error report: magnus.wangensteen@pgs.com

#Below are the list of parameters for the range of arrays that will be created. 
#The subarrays will only be crated at one depth ($subdepth).
@pressure = (2000);
@guntype = (T_); #Note that G-gun II is covered separately since volumes are special (controlled by the $arr3111H, $arr3265H, $arr4135H and $arr6222H parameter below)
@arraydepth = (3.5);
@subarrayseparation12 = (4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12);
@subarrayseparation23 = (4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12);
$subdepth = 4;
#$project = Sourcemod_newnum; #Nucleus+ project for arrays with new gun numbering convention
$project = Sourcemod;
#$subdepth3digits = sprintf("%03d", $subdepth*10);
$subdepth3digits = SUB; #Subarray depth in filename swapped with string SUB
$subdepth3digitsV2 = VII; #Some subarrays of same volume exist in two different versions, belonging to different full arrays. (Alternative 1750, 1360 and 1310 sub-arrays will have these 3 characters instead of SUB)

#Configurations can be skipped by changing the below parameters
#Only configurations set to 'true' will be created
$arr2360 = false; 
$arr2620 = false;
$arr2740 = false; #new
$arr2820 = false; 
$arr3090 = false;
$arr3150 = true; #new
$arr3260 = false;
$arr3930ver1 = false;
$arr3930ver2 = false;
$arr4100 = false;
$arr4130 = false;
$arr4720 = false;
$arr6180 = false;
$arr3111H = false;
$arr3265H = false;
$arr4135H = false;
$arr6222H = false;

#############################################################

print("Hacked version\n");

#730 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "0730".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">9</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">20</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');

close(OUTPUT);
}
}

#750 subarray (Same as 730, but with 40s instead of 20s)
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "0750".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">9</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');

close(OUTPUT);
}
}

#737H subarray
if ($arr3111H eq true){
	$guncode1 = 21;
	$guncode2 = 21;
	foreach $press (@pressure){
	    $filename = "0737H__".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">9</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">22</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">45</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');

close(OUTPUT);
}
}


#0780 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "0780".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">9</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">20</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
	    close(OUTPUT);
	}
}

#0920 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "0920".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">6</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
	    close(OUTPUT);
	}
}

#0980 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "0980".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">9</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
	    close(OUTPUT);
	}
}

#1070 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1070".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">10</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
	    close(OUTPUT);
	}
}

#1070H subarray
if ($arr4135H eq true){
	$guncode1 = 21;
	$guncode2 = 21;
	foreach $press (@pressure){

	    $filename = "1070H__".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">10</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>

');


close(OUTPUT);
}
}


#1130 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1130".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Description="" Major="1" Minor="1" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">10</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">6</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">8</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">12</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">15</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');

close(OUTPUT);
}
}

#1140 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1140".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">20</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');


close(OUTPUT);
}
}

#1160 subarray (Same as 1140, but with 40s instead of 20s)
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1160".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');


close(OUTPUT);
}
}

#1147H subarray
if ($arr3111H eq true){
	$guncode1 = 21;
	$guncode2 = 21;
	foreach $press (@pressure){
	    $filename = "1147H__".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">22</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">45</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');


close(OUTPUT);
}
}


#1160 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1160".$gun."_".($subdepth3digitsV2)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">9</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');

close(OUTPUT);
}
}

#1220 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1220".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">20</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');

close(OUTPUT);
}
}

#1240 subarray (Same as 1220, but with 40s instead of 20s)
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1240".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');

close(OUTPUT);
}
}

#1227H subarray
if ($arr3111H eq true){
	$guncode1 = 21;
	$guncode2 = 21;
	foreach $press (@pressure){
	    $filename = "1227H__".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">45</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">22</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');

close(OUTPUT);
}
}


#1310 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1310".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">12</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>

');
close(OUTPUT);

	}
}

#1310 v2 subarray (belongs to 4100 array)
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1310".$gun."_".($subdepth3digitsV2)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Description="" Major="1" Minor="1" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">10</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">6</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">8</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">12</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">15</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>

');
close(OUTPUT);

	}
}

#1315H subarray
if ($arr4135H eq true){
	$guncode1 = 21;
	$guncode2 = 21;
	foreach $press (@pressure){
	    $filename = "1315H__".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">12</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">45</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>

');
close(OUTPUT);

	}
}


#1360 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1360".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
close(OUTPUT);

	}
}

#1360 subarray v2 for the 4100 full array
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1360".$gun."_".($subdepth3digitsV2)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Description="" Major="1" Minor="1" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">10</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">6</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">8</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">12</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">15</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>

');
close(OUTPUT);

	}
}

#1390 subarray
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1390".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
	    close(OUTPUT);
	}
}

#Subarray 1410
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1410".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
	    close(OUTPUT);
	}
}

#Subarray 1430 for 4100 full array
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1430".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Description="" Major="1" Minor="1" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">10</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">6</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">8</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">12</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">15</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>

');
	    close(OUTPUT);
	}
}

#Subarray 1510 (For 3260 full array)
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1510".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Description="" Major="1" Minor="1" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">12</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">40</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">8</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
	    close(OUTPUT);
	}
}


#Subarray 1515H for full array 3265H
if ($arr3265H eq true){
	$guncode1 = 21;
	$guncode2 = 21;
	foreach $press (@pressure){
	    $filename = "1515H__".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Description="" Major="1" Minor="1" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">12</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">45</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">8</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">60</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
	    close(OUTPUT);
	}
}



#Subarray 1560
foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1560".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">11</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
	    close(OUTPUT);
	}
}

#Subarray 1610

foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1610".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Description="" Major="1" Minor="1" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">10</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">6</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">6</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">300</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">8</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.5</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">12</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">100</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">15</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>

');
	    close(OUTPUT);
	}
}

#Subarray 1750

foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1750".$gun."_".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">12</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
close(OUTPUT);

	}
}

#1750H subarray
if ($arr4135H eq true){
	$guncode1 = 21;
	$guncode2 = 21;
	foreach $press (@pressure){
	    $filename = "1750H__".($subdepth3digits)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">12</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">10</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">12</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>

');
close(OUTPUT);

	}
}

#Subarray 1750 (version 2) for 3260 triple source (Note that this is different from the 1750 in the 4130 array)

foreach $gun (@guntype){
    if ($gun eq G_){
	$guncode1 = 14;
	$guncode2 = 14;
    }elsif ($gun eq T_){
	$guncode1 = 18;
	$guncode2 = 18;
    }elsif ($gun eq S_){
	$guncode1 = 3;
	$guncode2 = 3;
    }elsif ($gun eq LT){
	$guncode1 = 18; #1900LLXT
	$guncode2 = 13; #1500LL
    }else {
	print("Error\n");
    }
	foreach $press (@pressure){
	    $filename = "1750".$gun."_".($subdepth3digitsV2)."_".$press."_SUB.G1X"; #VII

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Description="" Major="1" Minor="1" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">12</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">6</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">8</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
close(OUTPUT);

	}
}

if ($arr3265H eq true){
	$guncode1 = 21;
	$guncode2 = 21;
	foreach $press (@pressure){
	    $filename = "1750H__".($subdepth3digitsV2)."_".$press."_SUB.G1X";

open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<SubArray Description="" Major="1" Minor="1" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="GunGroupNumber" type="integer">1</Parameter>
    <Parameter ID="NumberOfGuns" type="integer">12</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Guns">
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">1</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">2</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">0</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">90</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">3</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">4</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">3</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">0</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">5</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">6</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">5</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">7</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">8</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">7</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">9</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">9</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">250</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">11</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode1,'</Parameter>
      <Parameter ID="GunXPosition" type="float">11</Parameter>
      <Parameter ID="GunYPosition" type="float">0</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">70</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">13</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Gun Parameters">
      <Parameter ID="GunLabel" type="integer">14</Parameter>
      <Parameter ID="GunType" type="integer">',$guncode2,'</Parameter>
      <Parameter ID="GunXPosition" type="float">14</Parameter>
      <Parameter ID="GunYPosition" type="float">-0.4</Parameter>
      <Parameter ID="GunZPosition" type="float">',$subdepth,'</Parameter>
      <Parameter ID="GunVolume" type="float">150</Parameter>
      <Parameter ID="GunPressure" type="float">',$press,'</Parameter>
      <Parameter ID="GunWaveshapeKit" type="float">1</Parameter>
      <Parameter ID="GunFiringDelay" type="float">0</Parameter>
      <Parameter ID="GunActivation" type="integer">1</Parameter>
      <Parameter ID="GroupLabel" type="integer">1</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</SubArray>
');
close(OUTPUT);

	}
}


#Full array 2360
if ($arr2360 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1140".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "1220".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "2360".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "2360".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">2</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}

#Full array 2620
if ($arr2620 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "0920".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "0780".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "0920".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "2620".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "2620".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">3</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}

#Full array 2740 (triple source based on 4100 sanco array)
if ($arr2740 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1130".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "1610".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "2740".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "2740".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">2</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}


###
#Full array 2820 (based on 4130 subarrays for triple source)
if ($arr2820 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1750".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "1070".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "2820".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "2820".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Description="" Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">2</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}

#Full array 3090
if ($arr3090 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1140".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "0730".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "1220".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "3090".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "3090".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">3</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}

#Full array 3150 (same as 3090, but with 40s instead of 20s)
if ($arr3150 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1160".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "0750".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "1240".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep12 (@subarrayseparation12){
	       foreach $sep23 (@subarrayseparation23){
		   $filename = "3150T__".($depth3digits)."_".$press."_".sprintf("%03d",$sep12*10)."_".sprintf("%03d",$sep23*10).".G2X";
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">3</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',$sep12,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',$sep23,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	       }
	   }
	}
    }
}
}

#Full array 3111H
if ($arr3111H eq true){
    foreach $press (@pressure){
	$subarray1 = "1147H__".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "0737H__".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "1227H__".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "3111H__".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "3111H__".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">3</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}

#Full array 3260
if ($arr3260 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1750".$gun."_".($subdepth3digitsV2)."_".$press."_SUB";
	$subarray2 = "1510".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "3260".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "3260".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Description="" Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">2</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}
#Full array 3265H
if ($arr3265H eq true){
    foreach $press (@pressure){
	$subarray1 = "1750H__".($subdepth3digitsV2)."_".$press."_SUB";
	$subarray2 = "1515H__".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "3265H__".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "3265H__".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Description="" Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">2</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}

#Full array 3930ver1
if ($arr3930ver1 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1390".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "0980".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "1560".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "3930".$gun."_".($depth3digits)."_".$press."_0".($sep*10)."ver1.G2X";
	       }else{
		   $filename = "3930".$gun."_".($depth3digits)."_".$press."_".($sep*10)."ver1.G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">3</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

	       close(OUTPUT);
	   }
	}
    }
}
}
#Full array 3930ver2
if ($arr3930ver2 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1410".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "1160".$gun."_".($subdepth3digitsV2)."_".$press."_SUB";
	$subarray3 = "1360".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "3930".$gun."_".($depth3digits)."_".$press."_0".($sep*10)."ver2.G2X";
	       }else{
		   $filename = "3930".$gun."_".($depth3digits)."_".$press."_".($sep*10)."ver2.G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">3</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

	       close(OUTPUT);
	   }
	}
    }
}
}

#Full array 4100
if ($arr4100 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1310".$gun."_".($subdepth3digitsV2)."_".$press."_SUB";
	$subarray2 = "1430".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "1360".$gun."_".($subdepth3digitsV2)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "4100".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "4100".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">3</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}

#Full array 4130
if ($arr4130 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1310".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "1070".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "1750".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "4130".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "4130".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">3</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',$sep,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}

#Full array 4135H
if ($arr4135H eq true){
    foreach $press (@pressure){
	$subarray1 = "1315H__".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "1070H__".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "1750H__".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep12 (@subarrayseparation12){
	       foreach $sep23 (@subarrayseparation23){
		   $filename = "4135H__".($depth3digits)."_".$press."_".sprintf("%03d",$sep12*10)."_".sprintf("%03d",$sep23*10).".G2X";
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">3</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',$sep12,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',$sep23,'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	       }
	   }
	}
    }
}


#Full array 4720
if ($arr4720 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1140".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "1220".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "1220".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray4 = "1140".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "4720".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "4720".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">4</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',(($sep*3)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">4</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray4,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',(($sep*3)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}
#Full array 6180
if ($arr6180 eq true){
foreach $gun (@guntype){
    foreach $press (@pressure){
	$subarray1 = "1140".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray2 = "0730".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray3 = "1220".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray4 = "1140".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray5 = "0730".$gun."_".($subdepth3digits)."_".$press."_SUB";
	$subarray6 = "1220".$gun."_".($subdepth3digits)."_".$press."_SUB";
	foreach $depth (@arraydepth){
	    $reldepth = $depth-$subdepth;
	    $depth3digits = sprintf("%03d", $depth*10);
	    foreach $sep (@subarrayseparation){
	       if ($sep<10){
		   $filename = "6180".$gun."_".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	       }else{
		   $filename = "6180".$gun."_".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	       }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">6</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',(($sep*5)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',(($sep*3)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">4</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray4,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">5</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray5,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',(($sep*3)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">6</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray6,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',(($sep*5)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}
}
#Full array 6222H
if ($arr6222H eq true){
   foreach $press (@pressure){
       $subarray1 = "1147H__".($subdepth3digits)."_".$press."_SUB";
       $subarray2 = "0737H__".($subdepth3digits)."_".$press."_SUB";
       $subarray3 = "1227H__".($subdepth3digits)."_".$press."_SUB";
       $subarray4 = "1147H__".($subdepth3digits)."_".$press."_SUB";
       $subarray5 = "0737H__".($subdepth3digits)."_".$press."_SUB";
       $subarray6 = "1227H__".($subdepth3digits)."_".$press."_SUB";
       foreach $depth (@arraydepth){
	   $reldepth = $depth-$subdepth;
	   $depth3digits = sprintf("%03d", $depth*10);
	   foreach $sep (@subarrayseparation){
	      if ($sep<10){
		  $filename = "6222H__".($depth3digits)."_".$press."_0".($sep*10).".G2X";
	      }else{
		  $filename = "6222H__".($depth3digits)."_".$press."_".($sep*10).".G2X"; 
	      }
open(OUTPUT, ">$filename");
print("Creating file: ",$filename,"\n");
print OUTPUT ('<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FullArray Major="1" Minor="0" Patch="0">

  <ParameterGroup ID="General Parameters">
    <Parameter ID="NumberOfSubarrays" type="integer">6</Parameter>
  </ParameterGroup>

  <ParameterGroup ID="Subarrays">
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">1</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray1,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',(($sep*5)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">2</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray2,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',(($sep*3)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">3</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray3,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">4</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray4,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',($sep/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">5</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray5,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',(($sep*3)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
    <ParameterGroup ID="Subarray Parameters">
      <Parameter ID="SubarrayLabel" type="integer">6</Parameter>
      <Parameter ID="SubarrayName" entityType="SubArray" type="data">
        <Entity name="Project">
          <Key name="name">',$project,'</Key>
          <Entity name="SubArray">
            <Key name="name">',$subarray6,'</Key>
          </Entity>
        </Entity>
      </Parameter>
      <Parameter ID="SubarrayXPosition" type="float">0</Parameter>
      <Parameter ID="SubarrayYPosition" type="float">-',(($sep*5)/2),'</Parameter>
      <Parameter ID="SubarrayZPosition" type="float">',$reldepth,'</Parameter>
    </ParameterGroup>
  </ParameterGroup>

</FullArray>
');

close(OUTPUT);
	   }
	}
    }
}

