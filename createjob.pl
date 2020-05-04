#!/usr/bin/perl
#This script creates standard source modeling Job files for Nucleus+. Jobs are automatically executed.
#The argument when launching the script is the Request ID number in sharepoint 2013. Parameters are downloaded from Sharepoint automatically. 
##If user answers "yes" to the question "Do you want the Project generating job to be created?", a job for creating the project will be created in the Sourcemod project. 
##This job can be run manually to create the new project, or the user can answer the next question:"Do you want to stop the automatic execution of the Nucleus jobs?". 
##If no is answered, the project will be created and all the source modeling jobs will be automatically launched. Before launched, the jobs will be moved into the Jobs directory of the new project. 
##If yes is answered (to stop execution), the files that are created (J2X-files) must be copied to the Jobs-folder under the respective project before loading into masomo.
#Tested on Nucleus+ version 2.8.0, Masomo version 2.0.0. Error reporting: magnus.wangensteen@pgs.com

#19/08/2009: (MW) Upgraded to handle Geostreamer; Implemented consistent bubble-picking (Manual 50-200ms) 
#17/06/2010: (MW) Array depth defined with 3 digits
#15/11/2010: (MW) Making script compatible with Infopath form and N+ 2.0. Colour scale on directivity plots changed. Array check implemented.
#14/04/2011: (MB) Changed output names for .arr and .dan files
#19/06/2012: (MW) Implemented to model without source ghost. Implemented old or new gun numbering convention.
#28/09/2012: (MW) Ghost free tick-box in request implemented. Compatibility with new GeoSource modules. Separate signature lengths for processing and recording. Signature plotting of 400ms for all signature lengths.
#05/10/2012: (MW): Improved handling of x-corr in dropout
#22/10/2012: (MW): Test on number of characters in Nucleus project
#11/12/2012: (MW): Ghost free signatures only for full system response. Plotting range bug fixed. Outputting additional Nucleus dropout job for substituted guns (For use by vessel crew)
#17/10/2014: (MW): User asked to confirm or enter reflection coefficient for dropout modeling
#30/10/2014: (MW): Spectral dropout implemented
#14/11/2014: (MW): Dropout signature length set to 1000ms when spectral dropout is selected. Spectral dropout also for Remodelling job.
#17/03/2016: (MW): Script adapted to new request form. PRO: Ghost free section; DRP: Broadband option; TND: Syntrak and Hydroscience filters removed
#08/11/2016: (MB): Changed the order of the annotation parameters in the MasomoFarfieldPlotSpec page id to be compatible with 2.6.0 N+ release.
#08/11/2016: (MB): Implemented the automatic loading and execution of the generated jobs.
#14/11/2016: (MW): Discontinued separate new and old gun numbering array libraries
#15/11/2016: (MW): Automatic Nucleus project creation. Signature length question skipped.
#01/12/2016: (MW): Some improvements made to handling of subarrays. Triple/dual/single source options. Script is now costumized for Nucleus 2.6.
#07/02/2017: (MW): Source mode corrected for dropout listing
#07/03/2017: (MW): Recording filter for ghots free corrected for other than Geostreamer
#28/06/2017: (MW): Major update: Most significant is Sharpoint 2013 upgrade with automatic download of request form parameters. Possible to execute new source modeling. Automatic tar archive etc..
#10/08/2017: (MW): Bug corrected: Dropout remodeling job reflection coefficient
#18/05/2018: (MW): Handling of 2740 array added. Update of remodeling job to avoid warnings while loading. Update to N271.
#08/02/2019: (MW): Updated to work with N280 and source kernel 1 or 2
#20/03/2019: (MW): 3260 subarray 1 and 2 swapped. Affects only the dropoutmatrix remodeling.
#16/08/2019: (MW): 3280 array added with subarray definition
#18/10/2019: (MW): Screendump of dropoutmatrix changed to 2600x1500
#30/10/2019: (MW): Minor bug fixes related to the dropout remodeling job
#31/03/2020: (MW): Hard coded in that nucDir is set to /pgsdev/Nucleus+GS/latest/

#Note that for this version, where parameters from an XML file is parsed into perl variables, you need to have XML::Simple installed.(To install: "perl -MCPAN -e shell" then "install XML::Simple")

#Picking parameters from xml-file
#use module
use XML::Simple;
use Data::Dumper;
use JSON;

####################################################################################################################################################
##########-------------THESE PATHS NEEDS TO BE ADJUSTED TO THE LOCATION/MACHINE WHERE THE SCRIPT IS RUN----------------------#######################
$NIIdir = '/research/sourcemod/NIIProjects/'; ##<<<<---------------------The directory where new source modeling projects will be created
$sourcemoddir = '/research/sourcemod/NIIProjects/Sourcemod/'; ##<<<<-----The directory for the Sourcemod project. (This project is used for running the create-project job when the new project is created)
$nucDir = '/pgsdev/Nucleus+GS/latest';
#$nucDir = '/data/Nucleus/release/com/pgs/research/NII'; ##<<<<-----The NUCLEUS_DIR path. (The part that comes before /usr/bin/Nucleus+.sh in the Nucleus+ alias) 
#By changing the nucDir path, you can also change which version of Nucleus/masomo is launched. 
####################################################################################################################################################
####################################################################################################################################################

$xml = new XML::Simple (ForceArray => 1, suppressempty => '');

#$inputfile = $ARGV[0];
$id =  $ARGV[0];
my @args =  ("curl", "-k", "--ntlm", "-u", "ONSHORE/F_HOU-SPVesselPerf:CD1Xng0aHF", "-O", "http://sourcemodel.onshore.pgs.com/_api/web/lists/GetByTitle('Forms')/items/getById(".$id.")"); #Password to Sharepoint hardcoded here
system(@args) == 0
    or die "system @args failed: $?";
$inputfile = "getById(".$id.")";
sleep(2);
$data = $xml->XMLin($inputfile);

#print Dumper($data);

#$scrap = $data->{'entry'}->[0]->{'content'}->[0]->{'m:properties'}->[0]->{'d:Depth'}->[0]->{content};
#$scrap = $data->{'content'}->{'m:properties'}->[0]->{'d:SigType_Tender'}->[0]->{'content'};


#print('************Scrap is: ',$scrap, "\n");
#Finding and downloading second file (html/json)
$htmlfilename = $data->{'content'}->{'m:properties'}->[0]->{'d:FileName'}->[0];
$htmlfilename =~ s/ /\%20/g;
$localfile = "temp".$id.".html";
print("Downloading HTML file name: ",$htmlfilename,"\n");
my @args =  ("curl", "-k", "--ntlm", "-u", "ONSHORE/F_HOU-SPVesselPerf:CD1Xng0aHF", "-o", $localfile, "http://sourcemodel.onshore.pgs.com/".$htmlfilename); #Password to sharepoint hardcoded here
system(@args) == 0
    or die "system @args failed: $?";
sleep(2);

#my $json;
#{
#    local $/;
#    open my $fh, "<", $localfile;
#    $json = <$fh>;
#    close $fh;
#}

#my $data2 = decode_json($json);
$data2 = $xml->XMLin($localfile);

$json = $data2->{'script'}->[0];
$pattern = "{";
$offset = index($json,$pattern);
$json = substr($json,$offset);
#print("json string: ",$json,"\n");
$jsondecode =  decode_json($json);
#print XMLout($jsondecode);
#$json = $data2->{'head'}->{'script'}->[0]->{'content'};
print Dumper($jsondecode);
#


$submitter = $jsondecode->{'submitter'};
#print("maxdBdrop = ",$maxdbdrop,"\n");
#print("broadbandenable = ",$bb_dropout,"\n");
#
$urgency = $data->{'content'}->{'m:properties'}->[0]->{'d:Urgency'}->[0];
$tender = $data->{'content'}->{'m:properties'}->[0]->{'d:SigType_Tender'}->[0]->{'content'};
$processing = $data->{'content'}->{'m:properties'}->[0]->{'d:SigType_Processing'}->[0]->{'content'};
$dropout = $data->{'content'}->{'m:properties'}->[0]->{'d:SigType_Dropout'}->[0]->{'content'};
$location =  $data->{'content'}->{'m:properties'}->[0]->{'d:PGSLocation'}->[0];
$vessel = $data->{'content'}->{'m:properties'}->[0]->{'d:Vessel'}->[0];
if ($survey = $data->{'content'}->{'m:properties'}->[0]->{'d:SurveyName'}->[0]->{'m:null'} eq 'true'){
    $survey = 'NA';
} else {
    $survey = $data->{'content'}->{'m:properties'}->[0]->{'d:SurveyName'}->[0];
    $survey =~ s/&/and/g; 
}
if ($bidnumber = $data->{'content'}->{'m:properties'}->[0]->{'d:BidNumber'}->[0]->{'m:null'} eq 'true'){
    $bidnumber = 'NA';
} else {
    $bidnumber = $data->{'content'}->{'m:properties'}->[0]->{'d:BidNumber'}->[0];
}
if ($data->{'content'}->{'m:properties'}->[0]->{'d:ProjectNumber'}->[0]->{'m:null'} eq 'true'){
    $jobnumber = $bidnumber; #If no job number, job number eq bidnumber.
} else {    
    $jobnumber =  $data->{'content'}->{'m:properties'}->[0]->{'d:ProjectNumber'}->[0];
}
$volume = $data->{'content'}->{'m:properties'}->[0]->{'d:ArrayVolume'}->[0];
$guntypename = $data->{'content'}->{'m:properties'}->[0]->{'d:GunType'}->[0];
$arrdepth = $data->{'content'}->{'m:properties'}->[0]->{'d:ArrayDepthM'}->[0]->{'content'};
$pressure = $data->{'content'}->{'m:properties'}->[0]->{'d:Pressure'}->[0]->{'content'};
$separation = $data->{'content'}->{'m:properties'}->[0]->{'d:SubarraySeparation'}->[0]->{'content'};
$temperature = $data->{'content'}->{'m:properties'}->[0]->{'d:SeaSurfaceTemperature'}->[0];
$recfilter = $data->{'content'}->{'m:properties'}->[0]->{'d:RecordingFilter'}->[0];
$cabletype = $data->{'content'}->{'m:properties'}->[0]->{'d:CableType'}->[0];
#$recdepth = $data->{'my:ProcessingSignatureParameters'}->[0]->{'my:rec_depth'}->[0];
$recdepth = $data->{'content'}->{'m:properties'}->[0]->{'d:RecDepthM'}->[0]->{'content'};
$grouplength = "12.5"; #Hard code
#$ghostfree = $data->{'my:ProcessingSignatureParameters'}->[0]->{'my:ghost_free'}->[0];


$pamp = $jsondecode->{'maxPeakAmpDrop'};
$maxavgdbdrop = $jsondecode->{'maxAvgDbDrop'};
$ptobperc = $jsondecode->{'maxPeakBubbleRatioDrop'};
$maxdbdrop = $jsondecode->{'maxDbDrop'};
$xcorr = $jsondecode->{'minXCorrelation'};
$minpbval = $jsondecode->{'minPeakBubbleValue'};
$bb_dropout = $jsondecode->{'BroadbandDropout'};
$maxphval = $jsondecode->{'maxPhase'};

if ($pamp){
    $pampcrit = "Yes";
} else {
    $pampcrit = "No";
    $pamp = 99;
}

if ($maxavgdbdrop){
    $maxavgdbdropcrit = "Yes";
} else {
    $maxavgdbdropcrit = "No";
    $maxavgdbdrop = 99;
}

if ($ptobperc){
    $ptobperccrit = "Yes";
} else {
    $ptobperccrit = "No";
    $ptobperc = 99;
}

if ($maxdbdrop){
    $maxdbdropcrit = "Yes";
} else {
    $maxdbdropcrit = "No";
    $maxdbdrop = 99;
}

if ($xcorr){
    $xcorrcrit = "Yes";
} else {
    $xcorrcrit = "No";
    $xcorr = 0;
}

if ($minpbval){
    $minpbvalcrit = "Yes";
} else {
    $minpbvalcrit = "No";
    $minpbval = 99;
}

if ($maxphval){
    $maxphvalcrit = "Yes";
} else {
    $maxphvalcrit = "No";
    $maxphval = 99;
}

print("INPUT PARAMETERS:\n");
print("Urgency: ",$urgency,"\n");
print("Tender signature: ",$tender,"\n");
print("Processing signature: ",$processing,"\n");
print("Dropout signature: ",$dropout,"\n");
print("Location: ",$location,"\n");
print("Vessel: ",$vessel,"\n");
print("Submitter: ",$submitter,"\n");
print("Survey: ",$survey,"\n");
print("Job number: ",$jobnumber,"\n");
print("Bid number: ",$bidnumber,"\n");
print("Array volume: ",$volume,"\n");
print("Gun type: ",$guntypename,"\n");
print("Array depth: ",$arrdepth,"\n");
print("Pressure: ",$pressure,"\n");
print("Separation: ",$separation,"\n");
print("Temperature: ",$temperature,"\n");
print("Recording filter: ",$recfilter,"\n");
print("Cable type: ",$cabletype,"\n");
print("Recording depth: ",$recdepth,"\n");
print("Group length: ",$grouplength,"\n");
#print("Ghost free: ",$ghostfree,"\n");
print("Peak amplitude criteria: ",$pampcrit,"; Value: ",$pamp,"\n");
print("Max average dB drop criteria: ",$maxavgdbdropcrit,"; Value: ",$maxavgdbdrop,"\n");
print("Peak/Bubble drop percent criteria: ",$ptobperccrit,"; Value: ",$ptobperc,"\n");
print("Max dB drop criteria: ",$maxdbdropcrit,"; Value: ",$maxdbdrop,"\n");
print("X-correlation criteria: ",$xcorrcrit,"; Value: ",$xcorr,"\n");
print("Minimum Peak/Bubble criteria: ",$minpbvalcrit,"; Value: ",$minpbval,"\n");
print("Max phase: ",$maxphvalcrit,"; Value: ",$maxphval,"\n");
print("Broadband dropout specs: ",$bb_dropout,"\n");
print("GENERATED NUCLEUS PARAMETERS:\n");

if ($jobnumber eq "") {
    print("Error - no jobnumber. Enter jobnumber: ");
    $jobnumber = <STDIN>;
    chomp($jobnumber);
    print("Job number set to: ",$jobnumber,"\n");
}
if (($volume =~ /\D/)||($volume eq "")) {
    print("Error - no volume. Enter volume: ");
    $volume = <STDIN>;
    chomp($volume);
    print("Volume set to: ",$volume,"\n");
}
if ($guntypename eq "G-gun"){
    $guntype = "G_";
} elsif ($guntypename eq "Bolt 1900LLXT"){
    $guntype = "T_";
} elsif ($guntypename eq "Sleeve"){
    $guntype = "S_";
} elsif ($guntypename eq "Bolt 1500LL/1900LLXT"){
    $guntype = "LT";
} elsif ($guntypename eq "G-gun II"){
    $guntype = "H_";
} else {
    print("Unknown gun type. Enter 2 guntype characters (example: L_, GX,..): "); #please enter guntype characters
    $guntype = <STDIN>;
    chomp($guntype);
}
print("Gun type code: ",$guntype,"\n");

if (($arrdepth =~/\D\./)||($arrdepth eq "")) {
    print("Error - no array depth. Enter depth: ");
    $arrdepth = <STDIN>;
    chomp($arrdepth);
    print("Volume set to: ",$arrdepth,"\n");
}

if (($pressure =~/\D\./)||($pressure eq "")) {
    print("Error - no pressure. Enter pressure: ");
    $pressure = <STDIN>;
    chomp($pressure);
    print("Volume set to: ",$pressure,"\n");
}

if (($separation =~/\D\./)||($separation eq "")) {
    print("Error - no separation. Enter separation: ");
    $separation = <STDIN>;
    chomp($separation);
    print("Separation set to: ",$separation,"\n");
}

if (($temperature =~/\D/)||($temperature eq "")) {
    print("Error - no temperature. Enter temperature: ");
    $temperature = <STDIN>;
    chomp($temperature);
    print("Temperature set to: ",$temperature,"\n");
}

#Standard array name
$arraydepth = $arrdepth*10;
$arraydepth = sprintf("%03d", $arraydepth); #array depth with 3 digits
$subarrsep = $separation*10;

if ($subarrsep < 100){
    $arrayname = ($volume.$guntype."_".$arraydepth."_".$pressure."_0".$subarrsep);
} else {
    $arrayname = ($volume.$guntype."_".$arraydepth."_".$pressure."_".$subarrsep);
}

#if volume=3930, test ver1 or ver2
if ($volume eq "3930"){
    print("The 3930 array exists in two versions. Please input version number (1/2) followed by enter: ");
    $arr3930version = <STDIN>;
    chomp($arr3930version);
    if ($subarrsep < 100){
        $arrayname = ($volume.$guntype."_".$arraydepth."_".$pressure."_0".$subarrsep."ver".$arr3930version);
    } else {
        $arrayname = ($volume.$guntype."_".$arraydepth."_".$pressure."_".$subarrsep."ver".$arr3930version);
    }
}
print("Array name: ",$arrayname,"\n");

#Subarray definitions

#$subarrdepth = 40;
#$subarrdepth = sprintf("%03d", $subarrdepth);
$subarraydepth = 4; #Subarray depth in array library
$reldepth = $arrdepth - $subarraydepth;
$subarrdepth = SUB;
$subarrdepthV2 = VII;

$subarray1 = ("SUB1");
$subarray2 = ("SUB2");
$subarray3 = ("SUB3");
$subarray4 = ("SUB4");    

if ($volume eq "2360"){
    $subarray1 = ("1140".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray2 = ("1220".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    $numofsubarrays = 2;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "no";
    $ypos1 = 0.5*$separation;
    $ypos2 = -0.5*$separation;
} elsif ($volume eq "2620"){
    $subarray1 = ("0920".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray2 = ("0780".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray3 = ("0920".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    print("Subarray 3: ",$subarray3,"\n");
    $numofsubarrays = 3;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "yes";
    $ypos1 = $separation;
    $ypos2 = 0;
    $ypos3 = -$separation;
} elsif ($volume eq "2740"){
    $subarray1 = ("1130".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray2 = ("1610".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    $numofsubarrays = 2;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "no";
    $ypos1 = 0.5*$separation;
    $ypos2 = -0.5*$separation;
} elsif ($volume eq "2820"){
    $subarray1 = ("1750".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray2 = ("1070".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    $numofsubarrays = 2;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "no";
    $ypos1 = 0.5*$separation;
    $ypos2 = -0.5*$separation;
} elsif ($volume eq "3260"){   
    $subarray1 = ("1750".$guntype."_".$subarrdepthV2."_".$pressure."_SUB");
    $subarray2 = ("1510".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    $numofsubarrays = 2;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "no";
    $ypos1 = 0.5*$separation;
    $ypos2 = -0.5*$separation;
} elsif ($volume eq "3280"){   
    $subarray1 = ("1680".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray2 = ("1600".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    $numofsubarrays = 2;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "no";
    $ypos1 = 0.5*$separation;
    $ypos2 = -0.5*$separation;
} elsif ($volume eq "3090"){
    $subarray1 = ("1140".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray2 = ("0730".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray3 = ("1220".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    print("Subarray 3: ",$subarray3,"\n");
    $numofsubarrays = 3;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "yes";
    $ypos1 = $separation;
    $ypos2 = 0;
    $ypos3 = -$separation;
} elsif ($volume eq "3111"){
    $subarray1 = "1147H__".$subarrdepth."_".$press."_SUB";
    $subarray2 = "0737H__".$subarrdepth."_".$press."_SUB";
    $subarray3 = "1227H__".$subarrdepth."_".$press."_SUB";
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    print("Subarray 3: ",$subarray3,"\n");
    $numofsubarrays = 3;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "yes";
    $ypos1 = $separation;
    $ypos2 = 0;
    $ypos3 = -$separation;
} elsif ($volume eq "3930"){
    if ($arr3930version eq "1"){
        $subarray1 = ("1390".$guntype."_".$subarrdepth."_".$pressure."_SUB");
	$subarray2 = ("0980".$guntype."_".$subarrdepth."_".$pressure."_SUB");
	$subarray3 = ("1560".$guntype."_".$subarrdepth."_".$pressure."_SUB");
	print("Subarray 1: ",$subarray1,"\n");
	print("Subarray 2: ",$subarray2,"\n");
	print("Subarray 3: ",$subarray3,"\n");
    } elsif ($arr3930version eq "2"){
        $subarray1 = ("1410".$guntype."_".$subarrdepth."_".$pressure."_SUB");
	$subarray2 = ("1160".$guntype."_".$subarrdepth."_".$pressure."_SUB");
	$subarray3 = ("1360".$guntype."_".$subarrdepth."_".$pressure."_SUB");
        print("Subarray 1: ",$subarray1,"\n");
	print("Subarray 2: ",$subarray2,"\n");
	print("Subarray 3: ",$subarray3,"\n");
    } else {
	print ("Error in subarray definition of 3930 array.\n");
    }
    $numofsubarrays = 3;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "yes";
    $ypos1 = $separation;
    $ypos2 = 0;
    $ypos3 = -$separation;
} elsif ($volume eq "4100"){
    $subarray1 = ("1310".$guntype."_".$subarrdepthV2."_".$pressure."_SUB");
    $subarray2 = ("1430".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray3 = ("1360".$guntype."_".$subarrdepthV2."_".$pressure."_SUB");
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    print("Subarray 3: ",$subarray3,"\n");
    $numofsubarrays = 3;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "yes";
    $ypos1 = $separation;
    $ypos2 = 0;
    $ypos3 = -$separation;
} elsif ($volume eq "4130"){
    $subarray1 = ("1310".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray2 = ("1070".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    $subarray3 = ("1750".$guntype."_".$subarrdepth."_".$pressure."_SUB");
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    print("Subarray 3: ",$subarray3,"\n");
    $numofsubarrays = 3;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "yes";
    $ypos1 = $separation;
    $ypos2 = 0;
    $ypos3 = -$separation;
} elsif ($volume eq "4135"){
    $subarray1 = "1315H__".$subarrdepth."_".$pressure."_SUB";
    $subarray2 = "1070H__".$subarrdepth."_".$pressure."_SUB";
    $subarray3 = "1750H__".$subarrdepth."_".$pressure."_SUB";
    print("Subarray 1: ",$subarray1,"\n");
    print("Subarray 2: ",$subarray2,"\n");
    print("Subarray 3: ",$subarray3,"\n");
    $numofsubarrays = 3;
    $sub1enable = "yes";
    $sub2enable = "yes";
    $sub3enable = "yes";
    $ypos1 = $separation;
    $ypos2 = 0;
    $ypos3 = -$separation;
} else {
    print("Subarray definition failed. Using default\n");
}

if ($recfilter eq "Syntrak-24bit"){
    $recfilt = "Syntrak-24_3/12-206/276";
    $filename = "recfilt";
} elsif ($recfilter eq "Hydroscience 24-bit"){
    $recfilt = "Hydroscience_4.6/6-206/276";
    $filename = "recfilt";
} elsif ($recfilter eq "Syntrak-16bit"){
    $recfilt = "Syntron_3/6-218/484";
    $filename = "recfilt";
} elsif ($recfilter eq "GeoStreamer LC4.4"){
    $recfilt = "GeoStr LChyd_4.4/12-214/341";
    $filename = "recfilt";
} elsif ($recfilter eq "GeoStreamer LC3"){
    $recfilt = "GeoStr LChyd_3/7-214/341";
    $filename = "recfilt";
} else {
    print("Non-standard recording filter - correct filter must be selected in Nucleus+\n");
    $filename = "recfilt";
}
print("Nucleus+ recording filter: ",$recfilt,"\n");

#Defining full system response name
if ($processing eq "true"){
    if (($recfilt eq "Syntrak-24_3/12-206/276") and ($cabletype eq "RDH/RDHS")){
	$fullsys = "S-24 g-12.5_6.3/12-206/276"; 
    } elsif (($recfilt eq "Syntrak-24_3/12-206/276") and ($cabletype eq "LDA")){
	$fullsys = "S-24 g-6.25_8.8/18-206/276"; 
    } elsif (($recfilt eq "Syntron_3/6-218/484") and ($cabletype eq "RDH/RDHS")){
	$fullsys = "S-16 g-12.5_5.7/12-218/72";
    } elsif (($recfilt eq "Syntron_3/6-218/484") and ($cabletype eq "LDA")){
	$fullsys = "S-16 g-6.25_8.1/12-218/72";
    } elsif (($recfilt eq "Hydroscience_4.6/6-206/276") and ($cabletype eq "RDH/RDHS")){
	$fullsys = $recfilt;
    } elsif (($recfilt eq "GeoStr LChyd_4.4/12-214/341") and ($cabletype eq "GeoStreamer")){
	$fullsys = $recfilt;
    } elsif (($recfilt eq "GeoStr LChyd_3/7-214/341") and ($cabletype eq "GeoStreamer")){
	$fullsys = $recfilt;
    } else {
	print ("Error - no full system response defined or recording filter/cable type mismatch. Must be defined in Nucleus+ later.\n");
    }
    print("Full system response: ",$fullsys,"\n");
}

if (($tender eq "true")||($processing eq "true")){
    if ($recdepth =~/\D\./) {
	print("Error - no recording depth. Enter depth: ");
	$recdepth = <STDIN>;
	chomp($recdepth);
	print("Recording depth set to: ",$recdepth,"\n");
    }
    if ($grouplength =~/\D\./) {
	print("Error - no group length. Enter group length: ");
	$grouplength = <STDIN>;
	chomp($grouplength);
	print("Group length set to: ",$grouplength,"\n");
    }
}

$signlength = 400; #used in plots
$drpsignlength = 400; #used in drop, changed to 1000ms if spectral dropout
$procsignlength = 2000; #used in processing signatures

print("Signature length: ",$procsignlength,"ms. Note that this will be applied to processing signatures only.\n"); #Signature (time) plots will use ",$signlength,".\n");
print("Which modeling kernel do you want to use? (1/2, default:2): ");
$newmodel = <STDIN>;
chomp($newmodel);
if ($newmodel eq "1"){
    $usenewmodel = "1.0";
} else {
    $usenewmodel = "2.0";
}
print ("Source modeling kernel set to: ",$usenewmodel,"\n");

if ($dropout eq "true"){
	if ($bb_dropout eq "false"){
		$refcoeffdrp = -1;
		$refcoeffnotiondrp = -1;
	    }
	elsif ($bb_dropout eq "true"){
		$refcoeffdrp = 0.0;
		$refcoeffnotiondrp = -1;
#		if ($usenewmodel eq "No"){
#		    $refcoeffnotiondrp = 0.0; ###If broadband is selected and new modeling is No, the old error is repeated. Notional ref coefficient of zero.
#		}
		$spectral = "true";
	    }
	else {
		#print ("Wrong input. \n");
		$refcoeffdrp = -1;
		$refcoeffnotiondrp = -1;
    	}

 	print("Reflection coefficient used in dropout modeling for farfield is ",$refcoeffdrp,".\n");
 	print("Reflection coefficient used in dropout modeling for notional is ",$refcoeffnotiondrp,".\n");

 	if ($spectral eq "true"){
		$spect_enable = "yes";
		$conv_enable = "no";
		$drpsignlength = 1000;
		print("Spectral statistics enabled, dropout signature length set to ",$drpsignlength,".\n");
	}
	else {
		$spect_enable = "no";
		$conv_enable = "yes";
		print("Spectral statistics disabled, dropout signature length set to ",$drpsignlength,".\n");
	}
	print ("Please enter source mode: 1-single, 2-dual(default), 3-triple (1/2/3): ");
	$sourcemodenum = <STDIN>;
	chomp($sourcemodenum);
	if ($sourcemodenum eq "1"){
		$sourcemode = "Single";
	}
	elsif ($sourcemodenum eq "3"){
		$sourcemode = "Triple";
	}
	else {
	    $sourcemode = "Dual";
	}
	print ("Sourcemode set to: ",$sourcemode,".\n");
}


$project_length = 99;
while ($project_length > 25){
    print("Please set Nucleus+ project name (max 25 characters): ");
    $project = <STDIN>;
    chomp($project);
    $project_length = length($project);
}

print("Nucleus+ project: ",$project,"\n");
$projectdir = $NIIdir.$project;
print("Project directory: ",$projectdir,"\n");

#print("Default gun numbering convention is 'new' (last gun 14). Type 'old' if you want the old convention: ");
#$numbconv = <STDIN>;
#chomp($numbconv);
#if ($numbconv eq "old"){
    $arraylib = "Sourcemod"; #Project containing array library - old convention
#}
#else{
#    $arraylib = "Sourcemod_newnum"; #Project containing array library - new convention
#    print("Computer says that you didn't type 'old'. The new convention will be used.\n")
#}
print("Array library set to: ",$arraylib,"\n");

print("Please input author name for report: ");
$author = <STDIN>;
chomp($author);

print("Do you want the Project generating job to be created (must be run in the Sourcemod project)? (y/n): ");
$autocreateproj = <STDIN>;
chomp($autocreateproj);
if ($autocreateproj eq "y"){
    open(OUTPUT, ">".$sourcemoddir."Jobs/CreateProject.Top\ Page.Workspace.J1X") or die("Error creating Nucleus project");
    print("Project creating job: CreateProject.Top\ Page.Workspace.J1X in Sourcemod project ...\n");
    print OUTPUT ('<!DOCTYPE PGS_N2_JOB>
<Pages ID="root" ParentID="workspace">
<Page Expanded="yes" Enabled="yes" ID="root">
<Parameter ID="GlobalProject">
<Entity name="Project">
<Key name="name" state="default">Sourcemod</Key>
</Entity>
</Parameter>
<Parameter ID="GlobalOverwrite" state="default">Yes</Parameter>
<Page Expanded="yes" Enabled="yes" ID="DataManagerRoot">
<Parameter ID="DataMgrDefaultProject">
<Entity name="Project">
<Key name="name" state="default">Sourcemod</Key>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="DataMgrProject">
<Parameter ID="ProjectSpec">
<Entity name="Project">
<Key name="name" state="default">Sourcemod</Key>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="ProjectEdit">
<Parameter ID="ProjectSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="ProjectDirectory" state="changed">',$NIIdir,'</Parameter>
<Parameter ID="ProjectOwner" state="default">sourcemod</Parameter>
<Parameter ID="ProjectSecurity" state="default">Public</Parameter>
<Parameter ID="ProjectCreateOption" state="changed">Create</Parameter>
</Page>
</Page>
</Page>
</Page>
</Pages>
');
close(OUTPUT);
      }


if ($dropout eq "true"){
open(OUTPUT, ">Dropout.Marine\ Source\ Modelling.Null\ Page.J2X") or die("Error creating job file");
print("Created job file: Dropout.Marine Source Modelling.Null Page.J2X\n"); 
$drpreportname = ("DRP_".$jobnumber."_".$survey);
print OUTPUT ('<!DOCTYPE PGS_N2_JOB>
<Pages ID="MasomoRoot" ParentID="masomo">
<Page Expanded="yes" Enabled="yes" Description="Dropout Signature" ID="MasomoRoot">
<Parameter ID="GlobalProject">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="GlobalOverwrite" state="default">Yes</Parameter>
<Page Expanded="yes" Enabled="yes" ID="DataMgrFullArray">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="FullArrayCopy">
<ParameterGroup ID="FullArrayInputGroup">
<Parameter ID="ProjectInputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$arraylib,'</Key>
</Entity>
</Parameter>
<Parameter ID="FullArrayInputSpec">
<Entity name="Project">
<Key name="name" state="default">',$arraylib,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<ParameterGroup ID="FullArrayOutputGroup">
<Parameter ID="ProjectOutputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="FullArrayOutputSpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Parameter ID="FullArrayCopyFlag" state="changed">Yes</Parameter>
<Parameter ID="FullArrayOverwriteRefsFlag" state="changed">Yes</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="DataMgrFullArray">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="FullArrayCheck">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Array plot" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FullArrayPlot">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<ParameterGroup ID="Masomo_plotBySubsource">
<Parameter ID="Masomo_subsourcePlotOpt" state="default">No</Parameter>
<Parameter ID="Masomo_subsourcePlotIndex" state="default"></Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">array</Key>
<Key name="type" state="changed">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Dropout 1,2,spare" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" ID="DropoutSetupCreate">
<Parameter ID="Masomo_DropoutArray">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutReferenceArray">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutOption" state="changed">1 and 2 gun dropouts with sparesub</Parameter>
<Parameter ID="Masomo_DropoutNoCombinations" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutSetupSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="DropoutSetup">
<Key name="name" state="changed">12drop-setup</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_DropoutModelling">
<Parameter ID="Masomo_DropoutSetupInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="DropoutSetup">
<Key name="name" state="changed">12drop-setup</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">',$drpsignlength,'</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionalsDropout">',$refcoeffnotiondrp,'</Parameter>
<Parameter state="changed" ID="Masomo_ReflectionCoeffFarfieldDropout">',$refcoeffdrp,'</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">',$temperature,'</Parameter>
<Parameter state="default" ID="Masomo_SeaVelocity">1470.9105</Parameter>
<Parameter ID="Masomo_InstrumentFilterDropout">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$recfilt,'</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_UseNewModellingOption">',$usenewmodel,'</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<ParameterGroup ID="Masomo_DropoutCoordinates">
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">12drop-dataset</Key>
<Key name="type" state="changed">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Illegal Dropout Listing" ID="Masomo_Analysis">
<Page Expanded="no" Enabled="',$conv_enable,'" ID="Masomo_CompDropoutStatisticsXC">
<Parameter ID="Masomo_DropoutInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">12drop-dataset</Key>
<Key name="type" state="changed">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<ParameterGroup ID="Masomo_DropoutPrimary">
<Parameter ID="Masomo_DropoutPrimaryStart" state="default">-58</Parameter>
<Parameter ID="Masomo_DropoutPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_DropoutBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_DropoutBubble">
<Parameter ID="Masomo_DropoutBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_DropoutBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_DropoutBandwidth">
<Parameter ID="DropoutBandwidthStart" state="default">10</Parameter>
<Parameter ID="DropoutBandwidthEnd" state="default">70</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_DropoutFrequencyOption" state="default">Average absolute deviation</Parameter>
<Parameter ID="Masomo_AmplitudePeakOption" state="default">Primary positive peak</Parameter>
<Parameter ID="Masomo_DropoutReferenceText" state="default"></Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutStatisticsOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop-stat</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutColumnDataOption" state="default">No</Parameter>
<Parameter ID="Masomo_Dropout_ColumnData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ColumnData">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" Enabled="',$spect_enable,'" ID="Masomo_CompDropoutStatisticsGS">
<Parameter ID="Masomo_DropoutInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">12drop-dataset</Key>
<Key name="type" state="changed">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<ParameterGroup ID="Masomo_DropoutBandwidth">
<Parameter ID="DropoutBandwidthStart" state="changed">5</Parameter>
<Parameter ID="DropoutBandwidthEnd" state="changed">200</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_DropoutWeighting" state="default">None</Parameter>
<Parameter ID="Masomo_DropoutFrequencyOption" state="default">Average absolute deviation</Parameter>
<Parameter ID="Masomo_DropoutReferenceText" state="default"></Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutStatisticsOutput">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop-stat</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutColumnDataOption" state="default">No</Parameter>
<Parameter ID="Masomo_Dropout_ColumnData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ColumnData">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_ListIllegalDropouts">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop-stat</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_UnaccDefSetOption" state="changed">PGS MultiClient</Parameter>
<ParameterGroup ID="Masomo_UnaccPrimaryOption">
<Parameter ID="Masomo_DropoutUnaccPrimaryOption" state="changed">',$pampcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccPrimaryMatch" state="changed">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccPrimaryValue" state="changed">',$pamp,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBchangeOption">
<Parameter ID="Masomo_DropoutUnaccPBchangeOption" state="changed">',$ptobperccrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBchangeMatch" state="changed">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBchangeValue" state="changed">',$ptobperc,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccCombPrimPBchangeOption">
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeOption" state="changed">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeMatch" state="changed">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeValue" state="changed">15</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBvalueOption">
<Parameter ID="Masomo_DropoutUnaccPBvalueOption" state="changed">',$minpbvalcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBvalueMatch" state="changed">Le</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBvalueValue" state="changed">',$minpbval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccXcorrOption">
<Parameter ID="Masomo_DropoutUnaccXcorrOption" state="changed">',$xcorrcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccXcorrMatch" state="changed">Le</Parameter>
<Parameter ID="Masomo_DropoutUnaccXcorrValue" state="changed">',$xcorr,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccAvedevOption">
<Parameter ID="Masomo_DropoutUnaccAvedevOption" state="changed">',$maxavgdbdropcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccAvedevMatch" state="changed">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccAvedevValue" state="changed">',$maxavgdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxdevOption">
<Parameter ID="Masomo_DropoutUnaccMaxdevOption" state="changed">',$maxdbdropcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxdevMatch" state="changed">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxdevValue" state="changed">',$maxdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxPhaseDevOption">
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevOption" state="changed">',$maxphvalcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevMatch" state="default">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevValue" state="default">',$maxphval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccVolumeOption">
<Parameter ID="Masomo_DropoutUnaccVolumeOption" state="changed">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccVolumeMatch" state="changed">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccVolumeValue" state="changed">10</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_PositivePercentage" state="default">No</Parameter>
<Parameter ID="Masomo_UnaccClusterOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_UnaccTwoGunOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutStatisticsOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop-illegal-stat</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Dropout matrix" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_DropoutMatrixPlot">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop-stat</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_UnaccDefSetOption" state="changed">PGS MultiClient</Parameter>
<ParameterGroup ID="Masomo_UnaccPrimaryOption">
<Parameter ID="Masomo_DropoutUnaccPrimaryOption" state="changed">',$pampcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccPrimaryMatch" state="changed">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccPrimaryValue" state="changed">',$pamp,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBchangeOption">
<Parameter ID="Masomo_DropoutUnaccPBchangeOption" state="changed">',$ptobperccrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBchangeMatch" state="changed">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBchangeValue" state="changed">',$ptobperc,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccCombPrimPBchangeOption">
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeOption" state="changed">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeMatch" state="changed">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeValue" state="changed">15</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBvalueOption">
<Parameter ID="Masomo_DropoutUnaccPBvalueOption" state="changed">',$minpbvalcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBvalueMatch" state="changed">Le</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBvalueValue" state="changed">',$minpbval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccXcorrOption">
<Parameter ID="Masomo_DropoutUnaccXcorrOption" state="changed">',$xcorrcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccXcorrMatch" state="changed">Le</Parameter>
<Parameter ID="Masomo_DropoutUnaccXcorrValue" state="changed">',$xcorr,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccAvedevOption">
<Parameter ID="Masomo_DropoutUnaccAvedevOption" state="changed">',$maxavgdbdropcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccAvedevMatch" state="changed">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccAvedevValue" state="changed">',$maxavgdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxdevOption">
<Parameter ID="Masomo_DropoutUnaccMaxdevOption" state="changed">',$maxdbdropcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxdevMatch" state="changed">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxdevValue" state="changed">',$maxdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxPhaseDevOption">
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevOption" state="changed">',$maxphvalcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevMatch" state="default">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevValue" state="default">',$maxphval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccVolumeOption">
<Parameter ID="Masomo_DropoutUnaccVolumeOption" state="changed">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccVolumeMatch" state="changed">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccVolumeValue" state="changed">10</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_PositivePercentage" state="default">No</Parameter>
<Parameter ID="Masomo_UnaccClusterOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_UnaccTwoGunOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_SourceMode" state="changed">',$sourcemode,'</Parameter>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="changed">2600</Parameter>
<Parameter ID="ScreenDumpSizeY" state="changed">1500</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="changed">Yes</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dropoutmatrix</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FullArrayPrint">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$jobnumber,'</Key>
<Key name="type" state="default">Array print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="no" Enabled="yes" Description="Complete statistics" ID="Masomo_DropoutStatisticsPrint">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop-stat</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutStatPrintOption" state="default">No</Parameter>
<Parameter ID="Masomo_DropoutArrayInfo" state="default">',$arrayname,'</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$jobnumber,'-legal</Key>
<Key name="type" state="default">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Illegal drop-outs only" ID="Masomo_DropoutStatisticsPrint">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop-illegal-stat</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutStatPrintOption" state="default">No</Parameter>
<Parameter ID="Masomo_DropoutArrayInfo" state="default">',$arrayname,'</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$jobnumber,'</Key>
<Key name="type" state="default">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_DropoutMatrixPrint">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop-stat</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_UnaccDefSetOption" state="changed">PGS MultiClient</Parameter>
<ParameterGroup ID="Masomo_UnaccPrimaryOption">
<Parameter ID="Masomo_DropoutUnaccPrimaryOption" state="changed">',$pampcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccPrimaryMatch" state="changed">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccPrimaryValue" state="changed">',$pamp,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBchangeOption">
<Parameter ID="Masomo_DropoutUnaccPBchangeOption" state="changed">',$ptobperccrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBchangeMatch" state="changed">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBchangeValue" state="changed">',$ptobperc,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccCombPrimPBchangeOption">
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeOption" state="changed">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeMatch" state="changed">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeValue" state="changed">15</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBvalueOption">
<Parameter ID="Masomo_DropoutUnaccPBvalueOption" state="changed">',$minpbvalcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBvalueMatch" state="changed">Le</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBvalueValue" state="changed">',$minpbval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccXcorrOption">
<Parameter ID="Masomo_DropoutUnaccXcorrOption" state="changed">',$xcorrcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccXcorrMatch" state="changed">Le</Parameter>
<Parameter ID="Masomo_DropoutUnaccXcorrValue" state="changed">',$xcorr,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccAvedevOption">
<Parameter ID="Masomo_DropoutUnaccAvedevOption" state="changed">',$maxavgdbdropcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccAvedevMatch" state="changed">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccAvedevValue" state="changed">',$maxavgdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxdevOption">
<Parameter ID="Masomo_DropoutUnaccMaxdevOption" state="changed">',$maxdbdropcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxdevMatch" state="changed">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxdevValue" state="changed">',$maxdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxPhaseDevOption">
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevOption" state="changed">',$maxphvalcrit,'</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevMatch" state="default">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevValue" state="default">',$maxphval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccVolumeOption">
<Parameter ID="Masomo_DropoutUnaccVolumeOption" state="changed">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccVolumeMatch" state="changed">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccVolumeValue" state="changed">10</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_PositivePercentage" state="default">No</Parameter>
<Parameter ID="Masomo_UnaccClusterOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_UnaccTwoGunOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dropoutmatrix</Key>
<Key name="type" state="default">Dropout matrix</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_ReportGeneration">
<Page Expanded="yes" Enabled="yes" ID="Masomo_ReportDropout">
<Parameter ID="Masomo_ReportGeneration_Author" state="changed">',$author,'</Parameter>
<Parameter ID="Masomo_ReportGeneration_Project">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_ArrayFile">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$jobnumber,'</Key>
<Key name="type" state="default">Array print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Filter">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$recfilt,'</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DropoutPrint">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$jobnumber,'-legal</Key>
<Key name="type" state="default">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DropoutIllegalPrint">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$jobnumber,'</Key>
<Key name="type" state="default">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_ArrayImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">array</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DropoutImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dropoutmatrix</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Output">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$drpreportname,'</Key>
<Key name="type" state="default">Report</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SourceMode" state="changed">',$sourcemode,'</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="no" Enabled="yes" Description="Renaming subarrays with postfix sub for editing" ID="DataMgrSubArray">
<Parameter ID="SubArraySpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="',$sub1enable,'" ID="SubArrayCopy">
<ParameterGroup ID="SubArrayInputGroup">
<Parameter ID="ProjectInputSpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="SubArrayInputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="changed">',$subarray1,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<ParameterGroup ID="SubArrayOutputGroup">
<Parameter ID="ProjectOutputSpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="SubArrayOutputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="changed">',$subarray1,'_sub1</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="',$sub2enable,'" ID="SubArrayCopy">
<ParameterGroup ID="SubArrayInputGroup">
<Parameter ID="ProjectInputSpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="SubArrayInputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="changed">',$subarray2,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<ParameterGroup ID="SubArrayOutputGroup">
<Parameter ID="ProjectOutputSpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="SubArrayOutputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="changed">',$subarray2,'_sub2</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="',$sub3enable,'" ID="SubArrayCopy">
<ParameterGroup ID="SubArrayInputGroup">
<Parameter ID="ProjectInputSpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="SubArrayInputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="changed">',$subarray3,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<ParameterGroup ID="SubArrayOutputGroup">
<Parameter ID="ProjectOutputSpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="SubArrayOutputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="changed">',$subarray3,'_sub3</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="no" Enabled="yes" Description="Assigning edited subarrays to new full array with postfix subst" ID="DataMgrFullArray">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="FullArrayCreate">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'_subst</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="FullArrayNumberOfSubarrays" state="changed">',$numofsubarrays,'</Parameter>
<Page Expanded="yes" Enabled="yes" ID="FullArray_Subarrays">
<ParameterGroup ID="SubarrayParameters">
<Parameter ID="FullArraySubarrayLabel" state="default">1</Parameter>
<Parameter ID="FullArraySubarrayName">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="changed">',$subarray1,'_sub1</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="FullArraySubarrayX" state="default">0</Parameter>
<Parameter ID="FullArraySubarrayY" state="changed">',$ypos1,'</Parameter>
<Parameter ID="FullArraySubarrayZ" state="changed">',$reldepth,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="SubarrayParameters">
<Parameter ID="FullArraySubarrayLabel" state="default">2</Parameter>
<Parameter ID="FullArraySubarrayName">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="changed">',$subarray2,'_sub2</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="FullArraySubarrayX" state="default">0</Parameter>
<Parameter ID="FullArraySubarrayY" state="changed">',$ypos2,'</Parameter>
<Parameter ID="FullArraySubarrayZ" state="changed">',$reldepth,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="SubarrayParameters">
<Parameter ID="FullArraySubarrayLabel" state="default">3</Parameter>
<Parameter ID="FullArraySubarrayName">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="changed">',$subarray3,'_sub3</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="FullArraySubarrayX" state="default">0</Parameter>
<Parameter ID="FullArraySubarrayY" state="changed">',$ypos3,'</Parameter>
<Parameter ID="FullArraySubarrayZ" state="changed">',$reldepth,'</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
</Page>
</Pages>
');
close(OUTPUT);
# Substituted gun modeling comes here...
open(OUTPUT, ">DropoutReModelling.Marine\ Source\ Modelling.Workspace.J2X") or die("Error creating job file");
print("Created job file: DropoutReModelling.Marine Source Modelling.Workspace.J2X \n");
$drpreportname = ("DRP_".$jobnumber."_remodeled");
#########
print OUTPUT ('
<!DOCTYPE PGS_N2_JOB>
<Pages ParentID="masomo" ID="MasomoRoot">
<Page Enabled="yes" Description="Modeling job for edited source array" ID="MasomoRoot" Expanded="yes">
<Notes>This job should be used to create a dropout report for an edited array, specifically for creating a new dropout matrix after gun substitutions. 
Before runnung the job, subarrays must be edited to reflect the changes in the array. Dropped guns must be set to spare and spare guns substituting the dropped gun, must be set to active. Do the edits in the Edit SubArray modules in the following workflow. First, run the copy array modules, then make the edits in the array edit modules.</Notes>
<Parameter ID="GlobalProject">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
</Entity>
</Parameter>
<Parameter state="default" ID="GlobalOverwrite">Yes</Parameter>
<Page Enabled="yes" Description="Plotting nominal full array" ID="Masomo_Plotting" Expanded="yes">
<Page Enabled="yes" ID="Masomo_FullArrayPlot" Expanded="yes">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="FullArray">
<Key state="changed" name="name">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<ParameterGroup ID="Masomo_plotBySubsource">
<Parameter state="default" ID="Masomo_subsourcePlotOpt">No</Parameter>
<Parameter state="default" ID="Masomo_subsourcePlotIndex">1</Parameter>
</ParameterGroup>
<Parameter state="default" ID="Masomo_PlotFullArraySetPlotRange">No</Parameter>
</Page>
<Page Enabled="yes" ID="Masomo_DropoutMatrixPlot" Expanded="yes">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">12drop-stat</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_UnaccDefSetOption">Spectral specifications</Parameter>
<ParameterGroup ID="Masomo_UnaccPrimaryOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryOption">',$pampcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryValue">',$pamp,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBchangeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeOption">',$ptobperccrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeValue">',$ptobperc,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccCombPrimPBchangeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeOption">No</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeValue">15</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBvalueOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueOption">',$minpbvalcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueMatch">Le</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueValue">',$minpbval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccXcorrOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrOption">',$xcorrcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrMatch">Le</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrValue">',$xcorr,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccAvedevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevOption">',$maxavgdbdropcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevValue">',$maxavgdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxdevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevOption">',$mavdbdropcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevValue">',$maxdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxPhaseDevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxPhaseDevOption">',$maxphvalcrit,'</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccMaxPhaseDevMatch">Ge</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccMaxPhaseDevValue">',$maxphval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccVolumeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccVolumeOption">No</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccVolumeMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccVolumeValue">10</Parameter>
</ParameterGroup>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_PositivePercentage">No</Parameter>
<Parameter state="default" ID="Masomo_UnaccClusterOption">Yes</Parameter>
<Parameter state="default" ID="Masomo_UnaccTwoGunOption">Yes</Parameter>
<Parameter state="changed" ID="Masomo_SourceMode">',$sourcemode,'</Parameter>
</Page>
</Page>
<Page Enabled="yes" Description="Editing subarrays" ID="DataMgrSubArray" Expanded="yes">
<Notes>Here, the operator has to edit the relevant subarrays. Guns that are dropped must be set to spare. Spare guns that are used to substitute dropped guns must be set to active.
In the Edit Subarray module, use the tab AirgunSubarrayParameters to make the edits.</Notes>
<Parameter ID="SubArraySpec">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="SubArray">
<Key state="default" name="name">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Enabled="',$sub1enable,'" Description="Subarray 1" ID="SubArrayEdit" Expanded="no">
<Parameter ID="SubArraySpec">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="SubArray">
<Key state="changed" name="name">',$subarray1,'_sub1</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="SubArrayNumberOfGuns">12</Parameter>
<Parameter state="default" ID="SubArrayMainType">Airguns</Parameter>
</Page>
<Page Enabled="',$sub2enable,'" Description="Subarray 2" ID="SubArrayEdit" Expanded="no">
<Parameter ID="SubArraySpec">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="SubArray">
<Key state="changed" name="name">',$subarray2,'_sub2</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="SubArrayNumberOfGuns">10</Parameter>
<Parameter state="default" ID="SubArrayMainType">Airguns</Parameter>
</Page>
<Page Enabled="',$sub3enable,'" Description="Subarray 3" ID="SubArrayEdit" Expanded="no">
<Parameter ID="SubArraySpec">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="SubArray">
<Key state="changed" name="name">',$subarray3,'_sub3</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="SubArrayNumberOfGuns">12</Parameter>
<Parameter state="default" ID="SubArrayMainType">Airguns</Parameter>
</Page>
</Page>
<Page Expanded="no" ID="DataMgrFullArray" Enabled="yes">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'_subst</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="FullArrayEdit" Enabled="yes">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'_subst</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="FullArrayNumberOfSubarrays" state="default">',$numofsubarrays,'</Parameter>
<Parameter ID="FullArray_Separator_eSourceSequence" state="changed"></Parameter>
<Parameter ID="FullArray_FiringWindow" state="default">0</Parameter>
<Parameter ID="FullArray_RandomizationWindow" state="default">0</Parameter>
<Page Expanded="yes" ID="FullArray_Subarrays" Enabled="yes">
<ParameterGroup ID="SubarrayParameters">
<Parameter ID="FullArraySubarrayLabel" state="default">1</Parameter>
<Parameter ID="FullArraySubarrayName">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="default">',$subarray1,'_sub1</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="FullArraySubarrayX" state="default">0</Parameter>
<Parameter ID="FullArraySubarrayY" state="default">8</Parameter>
<Parameter ID="FullArraySubarrayZ" state="default">4</Parameter>
</ParameterGroup>
<ParameterGroup ID="SubarrayParameters">
<Parameter ID="FullArraySubarrayLabel" state="default">2</Parameter>
<Parameter ID="FullArraySubarrayName">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="default">',$subarray2,'_sub2</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="FullArraySubarrayX" state="default">0</Parameter>
<Parameter ID="FullArraySubarrayY" state="default">0</Parameter>
<Parameter ID="FullArraySubarrayZ" state="default">4</Parameter>
</ParameterGroup>
<ParameterGroup ID="SubarrayParameters">
<Parameter ID="FullArraySubarrayLabel" state="default">3</Parameter>
<Parameter ID="FullArraySubarrayName">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="SubArray">
<Key name="name" state="default">',$subarray3,'_sub3</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="FullArraySubarrayX" state="default">0</Parameter>
<Parameter ID="FullArraySubarrayY" state="default">-8</Parameter>
<Parameter ID="FullArraySubarrayZ" state="default">4</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Enabled="yes" Description="Plotting edited full array" ID="Masomo_Plotting" Expanded="no">
<Page Enabled="yes" ID="Masomo_FullArrayPlot" Expanded="yes">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="FullArray">
<Key state="changed" name="name">',$arrayname,'_subst</Key>
</Entity>
</Entity>
</Parameter>
<ParameterGroup ID="Masomo_plotBySubsource">
<Parameter state="default" ID="Masomo_subsourcePlotOpt">No</Parameter>
<Parameter state="default" ID="Masomo_subsourcePlotIndex">1</Parameter>
</ParameterGroup>
<Parameter state="default" ID="Masomo_PlotFullArraySetPlotRange">No</Parameter>
</Page>
<Page Enabled="yes" ID="ScreenDump" Expanded="yes">
<Parameter state="default" ID="ScreenDumpFormat">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter state="default" ID="ScreenDumpSizeX">1200</Parameter>
<Parameter state="default" ID="ScreenDumpSizeY">900</Parameter>
</ParameterGroup>
<Parameter state="default" ID="ScreenDumpOrientation">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter state="default" ID="ScreenDumpExternalOutputSelector">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">array_subst</Key>
<Key state="changed" name="type">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Enabled="yes" Description="Drop out modeling of edited array with nominal array as reference" ID="Masomo_Modelling" Expanded="no">
<Page Enabled="yes" ID="DropoutSetupCreate" Expanded="yes">
<Parameter ID="Masomo_DropoutArray">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="FullArray">
<Key state="changed" name="name">',$arrayname,'_subst</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutReferenceArray">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="FullArray">
<Key state="changed" name="name">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_DropoutOption">1 and 2 gun dropouts with sparesub</Parameter>
<Parameter state="default" ID="Masomo_DropoutNoCombinations">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_DropoutSetupSpec">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="DropoutSetup">
<Key state="changed" name="name">12drop_remod</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Enabled="yes" ID="Masomo_DropoutModelling" Expanded="yes">
<Parameter ID="Masomo_DropoutSetupInput">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="DropoutSetup">
<Key state="changed" name="name">12drop_remod</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">',$drpsignlength,'</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionalsDropout">',$refcoeffnotiondrp,'</Parameter>
<Parameter state="changed" ID="Masomo_ReflectionCoeffFarfieldDropout">',$refcoeffdrp,'</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">',$temperature,'</Parameter>
<Parameter state="default" ID="Masomo_SeaVelocity">1534.5605</Parameter>
<Parameter ID="Masomo_InstrumentFilterDropout">
<Entity name="Project">
<Key state="changed" name="name">Default</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">',$recfilt,'</Key>
<Key state="changed" name="type">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_UseNewModellingOption">',$usenewmodel,'</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<ParameterGroup ID="Masomo_DropoutCoordinates">
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_DropoutOutput">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">12dropsign_remod</Key>
<Key state="default" name="type">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Enabled="yes" Description="Statistics generation" ID="Masomo_Analysis" Expanded="no">
<Page Enabled="',$conv_enable,'" ID="Masomo_CompDropoutStatisticsXC" Expanded="yes">
<Parameter ID="Masomo_DropoutInput">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">12dropsign_remod</Key>
<Key state="changed" name="type">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<ParameterGroup ID="Masomo_DropoutPrimary">
<Parameter state="default" ID="Masomo_DropoutPrimaryStart">0</Parameter>
<Parameter state="default" ID="Masomo_DropoutPrimaryEnd">30</Parameter>
</ParameterGroup>
<Parameter state="changed" ID="Masomo_DropoutBubbleMode">Manual</Parameter>
<ParameterGroup ID="Masomo_DropoutBubble">
<Parameter state="default" ID="Masomo_DropoutBubbleStart">50</Parameter>
<Parameter state="default" ID="Masomo_DropoutBubbleEnd">200</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_DropoutBandwidth">
<Parameter state="default" ID="DropoutBandwidthStart">10</Parameter>
<Parameter state="default" ID="DropoutBandwidthEnd">70</Parameter>
</ParameterGroup>
<Parameter state="default" ID="Masomo_DropoutFrequencyOption">Absolute deviation</Parameter>
<Parameter state="default" ID="Masomo_AmplitudePeakOption">Primary positive peak</Parameter>
<Parameter state="default" ID="Masomo_DropoutReferenceText"></Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_DropoutStatisticsOutput">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">12dropstat_remod</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_DropoutColumnDataOption">No</Parameter>
<Parameter ID="Masomo_Dropout_ColumnData">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ColumnData">
<Key state="default" name="name">*</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Enabled="',$spect_enable,'" ID="Masomo_CompDropoutStatisticsGS" Expanded="yes">
<Parameter ID="Masomo_DropoutInput">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">12dropsign_remod</Key>
<Key state="changed" name="type">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<ParameterGroup ID="Masomo_DropoutBandwidth">
<Parameter state="changed" ID="DropoutBandwidthStart">5</Parameter>
<Parameter state="changed" ID="DropoutBandwidthEnd">200</Parameter>
</ParameterGroup>
<Parameter state="default" ID="Masomo_DropoutWeighting">None</Parameter>
<Parameter state="default" ID="Masomo_DropoutFrequencyOption">Absolute deviation</Parameter>
<Parameter state="default" ID="Masomo_DropoutReferenceText"></Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_DropoutStatisticsOutput">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">12dropstat_remod</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_DropoutColumnDataOption">No</Parameter>
<Parameter ID="Masomo_Dropout_ColumnData">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ColumnData">
<Key state="default" name="name">*</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Enabled="yes" ID="Masomo_ListIllegalDropouts" Expanded="yes">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">12dropstat_remod</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_UnaccDefSetOption"></Parameter>
<ParameterGroup ID="Masomo_UnaccPrimaryOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryOption">',$pampcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryValue">',$pamp,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBchangeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeOption">',$ptobperccrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeValue">',$ptobperc,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccCombPrimPBchangeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeOption">No</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeValue">15</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBvalueOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueOption">',$minpbvalcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueMatch">Le</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueValue">',$minpbval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccXcorrOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrOption">',$xcorrcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrMatch">Le</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrValue">',$xcorr,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccAvedevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevOption">',$maxavgdbdropcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevValue">',$maxavgdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxdevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevOption">',$maxdbdropcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevValue">',$maxdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxPhaseDevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxPhaseDevOption">',$maxphvalcrit,'</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccMaxPhaseDevMatch">Ge</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccMaxPhaseDevValue">',$maxphval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccVolumeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccVolumeOption">No</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccVolumeMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccVolumeValue">10</Parameter>
</ParameterGroup>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_PositivePercentage">No</Parameter>
<Parameter state="default" ID="Masomo_UnaccClusterOption">Yes</Parameter>
<Parameter state="default" ID="Masomo_UnaccTwoGunOption">Yes</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_DropoutStatisticsOutput">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">12drop-illegal-stat-remod</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Enabled="yes" Description="New Dropout matrix" ID="Masomo_Plotting" Expanded="no">
<Page Enabled="yes" ID="Masomo_DropoutMatrixPlot" Expanded="yes">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">12dropstat_remod</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_UnaccDefSetOption"></Parameter>
<ParameterGroup ID="Masomo_UnaccPrimaryOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryOption">',$pampcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryValue">',$pamp,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBchangeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeOption">',$ptobperccrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeValue">',$ptobperc,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccCombPrimPBchangeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeOption">No</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeValue">15</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBvalueOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueOption">',$minpbvalcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueMatch">Le</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueValue">',$minpbval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccXcorrOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrOption">',$xcorrcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrMatch">Le</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrValue">',$xcorr,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccAvedevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevOption">',$maxavgdbdropcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevValue">',$maxavgdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxdevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevOption">',$maxdbdropcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevValue">',$maxdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxPhaseDevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxPhaseDevOption">',$maxphvalcrit,'</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccMaxPhaseDevMatch">Ge</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccMaxPhaseDevValue">',$maxphval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccVolumeOption">
<Parameter state="default" ID="Masomo_DropoutUnaccVolumeOption">No</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccVolumeMatch">Ge</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccVolumeValue">10</Parameter>
</ParameterGroup>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_PositivePercentage">No</Parameter>
<Parameter state="default" ID="Masomo_UnaccClusterOption">Yes</Parameter>
<Parameter state="default" ID="Masomo_UnaccTwoGunOption">Yes</Parameter>
<Parameter state="changed" ID="Masomo_SourceMode">',$sourcemode,'</Parameter>
</Page>
<Page Enabled="yes" ID="ScreenDump" Expanded="yes">
<Parameter state="default" ID="ScreenDumpFormat">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter state="changed" ID="ScreenDumpSizeX">2600</Parameter>
<Parameter state="changed" ID="ScreenDumpSizeY">1500</Parameter>
</ParameterGroup>
<Parameter state="changed" ID="ScreenDumpOrientation">Yes</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter state="default" ID="ScreenDumpExternalOutputSelector">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">dropoutmatrix_remod</Key>
<Key state="default" name="type">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Enabled="yes" Description="New statistics" ID="Masomo_Printing" Expanded="no">
<Page Enabled="yes" ID="Masomo_FullArrayPrint" Expanded="yes">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="FullArray">
<Key state="changed" name="name">',$arrayname,'_subst</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter state="default" ID="Masomo_ExternalPrintOutputSelector">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">',$jobnumber,'_remod</Key>
<Key state="default" name="type">Array print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Enabled="yes" Description="Complete statistics" ID="Masomo_DropoutStatisticsPrint" Expanded="no">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">12dropstat_remod</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_DropoutStatPrintOption">No</Parameter>
<Parameter state="default" ID="Masomo_DropoutArrayInfo"></Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter state="default" ID="Masomo_ExternalPrintOutputSelector">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">',$jobnumber,'-legal-remod</Key>
<Key state="default" name="type">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Enabled="yes" Description="Illegal drop-outs only" ID="Masomo_DropoutStatisticsPrint" Expanded="yes">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">12drop-illegal-stat-remod</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_DropoutStatPrintOption">No</Parameter>
<Parameter state="default" ID="Masomo_DropoutArrayInfo"></Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter state="default" ID="Masomo_ExternalPrintOutputSelector">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">',$jobnumber,'-remod</Key>
<Key state="default" name="type">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Enabled="yes" ID="Masomo_DropoutMatrixPrint" Expanded="yes">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key state="changed" name="name">',$project,'</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">12dropstat_remod</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_UnaccDefSetOption"></Parameter>
<ParameterGroup ID="Masomo_UnaccPrimaryOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryOption">',$pampcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPrimaryValue">',$pamp,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBchangeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeOption">',$ptobperccrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBchangeValue">',$ptobperc,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccCombPrimPBchangeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeOption">No</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeMatch">Gt</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccCombPrimPBchangeValue">15</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBvalueOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueOption">',$minpbvalcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueMatch">Le</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccPBvalueValue">',$minpbval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccXcorrOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrOption">',$xcorrcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrMatch">Le</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccXcorrValue">',$xcorr,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccAvedevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevOption">',$maxavgdbdropcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccAvedevValue">',$maxavgdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxdevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevOption">',$maxdbdropcrit,'</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxdevValue">',$maxdbdrop,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxPhaseDevOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccMaxPhaseDevOption">',$maxphvalcrit,'</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccMaxPhaseDevMatch">Ge</Parameter>
<Parameter state="default" ID="Masomo_DropoutUnaccMaxPhaseDevValue">',$maxphval,'</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccVolumeOption">
<Parameter state="changed" ID="Masomo_DropoutUnaccVolumeOption">No</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccVolumeMatch">Ge</Parameter>
<Parameter state="changed" ID="Masomo_DropoutUnaccVolumeValue">10</Parameter>
</ParameterGroup>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_PositivePercentage">No</Parameter>
<Parameter state="default" ID="Masomo_UnaccClusterOption">Yes</Parameter>
<Parameter state="default" ID="Masomo_UnaccTwoGunOption">Yes</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter state="default" ID="Masomo_ExternalPrintOutputSelector">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">dropoutmatrix_remod</Key>
<Key state="default" name="type">Dropout matrix</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Enabled="yes" Description="New report" ID="Masomo_Printing" Expanded="no">
<Page Enabled="yes" ID="Masomo_ReportGeneration" Expanded="yes">
<Page Enabled="yes" ID="Masomo_ReportDropout" Expanded="yes">
<Parameter state="changed" ID="Masomo_ReportGeneration_Author">Onboard Geo</Parameter>
<Parameter ID="Masomo_ReportGeneration_Project">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_ArrayFile">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">',$jobnumber,'_remod</Key>
<Key state="changed" name="type">Array print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Filter">
<Entity name="Project">
<Key state="default" name="name">Default</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">',$recfilt,'</Key>
<Key state="default" name="type">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DropoutPrint">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">',$jobnumber,'-legal-remod</Key>
<Key state="changed" name="type">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DropoutIllegalPrint">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">',$jobnumber,'-remod</Key>
<Key state="changed" name="type">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_ArrayImage">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">array_subst</Key>
<Key state="changed" name="type">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DropoutImage">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">dropoutmatrix_remod</Key>
<Key state="changed" name="type">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Output">
<Entity name="Project">
<Key state="default" name="name">',$project,'</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">',$drpreportname,'</Key>
<Key state="default" name="type">Report</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_SourceMode">',$sourcemode,'</Parameter>
</Page>
</Page>
</Page>
</Page>
</Pages>');
close(OUTPUT);
# End of substituted gun modeling here..
}

if ($tender eq "true"){
#open(OUTPUT, ">./",$project,"/Jobs/TenderSignature.Marine\ Source\ Modelling.Null\ Page.J2X");
open(OUTPUT, ">TenderSignature.Marine\ Source\ Modelling.Null\ Page.J2X") or die("Error creating job file"); 
print("Created job file: TenderSignature.Marine Source Modelling.Null Page.J2X\n");
$tendreportname = ("TD_".$arrayname."_".$temperature);
print OUTPUT ('<!DOCTYPE PGS_N2_JOB>
<Pages ID="MasomoRoot" ParentID="masomo">
<Page Expanded="yes" Enabled="yes" Description="Tender Signature" ID="MasomoRoot">
<Parameter ID="GlobalProject">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="GlobalOverwrite" state="default">Yes</Parameter>
<Page Expanded="yes" Enabled="yes" ID="DataMgrFullArray">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="FullArrayCopy">
<ParameterGroup ID="FullArrayInputGroup">
<Parameter ID="ProjectInputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$arraylib,'</Key>
</Entity>
</Parameter>
<Parameter ID="FullArrayInputSpec">
<Entity name="Project">
<Key name="name" state="default">',$arraylib,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<ParameterGroup ID="FullArrayOutputGroup">
<Parameter ID="ProjectOutputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="FullArrayOutputSpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Parameter ID="FullArrayCopyFlag" state="changed">Yes</Parameter>
<Parameter ID="FullArrayOverwriteRefsFlag" state="changed">Yes</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="DataMgrFullArray">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="FullArrayCheck">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FullArrayPrint">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">array</Key>
<Key name="type" state="default">Array print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Notional" ID="Masomo_Modelling">
<Notes>Common notional signature set used for all the farfield signature computations in this job</Notes>
<Page Expanded="yes" Enabled="yes" ID="Masomo_NotionalModelling">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">',$signlength,'</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">',$temperature,'</Parameter>
<Parameter state="default" ID="Masomo_SeaVelocity">1490.048</Parameter>
<Parameter state="changed" ID="Masomo_UseNewModellingOption">',$usenewmodel,'</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">Syntrak-24_3/12-206/276</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_GSNotionalModelling">
<ParameterGroup ID="Masomo_delayOptionGroup">
<Parameter ID="Masomo_applyDelayOption" state="default">No</Parameter>
<Parameter ID="Masomo_applyDelayType" state="default">Manually</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="DFS filter" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" Description="DFS" ID="Masomo_FarfieldModelling">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfield" state="default">-1</Parameter>
<Parameter ID="Masomo_FilterOptionFarfield" state="changed">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">DFS V_Out-128/72</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_GeometricalSpreading" state="default">2</Parameter>
<Parameter ID="Masomo_SpecificationSystem" state="default">Individual positions</Parameter>
<Parameter ID="Masomo_CoordinateSystem" state="default">Polar coordinates</Parameter>
<Parameter ID="Masomo_NoFarfieldPositions" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_PressureOutputScale" state="default">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Farfield_Ind_Polar">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter ID="FarfieldPositionNumber" state="default">1</Parameter>
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="DFS" ID="Masomo_Plotting">
<Notes>Plots the array configuration and the DFS farfield signature in time and frequency. The picture are also saved as png files. </Notes>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FullArrayPlot">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<ParameterGroup ID="Masomo_plotBySubsource">
<Parameter ID="Masomo_subsourcePlotOpt" state="default">No</Parameter>
<Parameter ID="Masomo_subsourcePlotIndex" state="default"></Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">array</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" Description="DFS Time" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="default">Signatures</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="default">1000</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dfs_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" Description="DFS Freq" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="changed">Absolute spectra</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="changed">250</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldBubbleOption" state="changed">No</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dfs_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePrint">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePrint">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldNumber" state="default">1</Parameter>
<Parameter ID="Masomo_SampleIntervalPr" state="changed">2.0</Parameter>
<Parameter ID="Masomo_SeparatorBubbles" state="changed"></Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimaryPrint">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleModePrint" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubblePrint">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorStreamer" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dfs</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" Description="Hydroscience" ID="Masomo_FarfieldModelling">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfield" state="default">-1</Parameter>
<Parameter ID="Masomo_FilterOptionFarfield" state="changed">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">Hydroscience_4.6/6-206/276</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_GeometricalSpreading" state="default">2</Parameter>
<Parameter ID="Masomo_SpecificationSystem" state="default">Individual positions</Parameter>
<Parameter ID="Masomo_CoordinateSystem" state="default">Polar coordinates</Parameter>
<Parameter ID="Masomo_NoFarfieldPositions" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_PressureOutputScale" state="default">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Farfield_Ind_Polar">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter ID="FarfieldPositionNumber" state="default">1</Parameter>
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Record Filter No Ghost" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" Description="Hydroscience" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="default">Signatures</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="default">1000</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">Hyd24_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" Description="Hyd freq" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="changed">Absolute spectra</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="changed">250</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldBubbleOption" state="changed">No</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">Hyd24_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePrint">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePrint">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldNumber" state="default">1</Parameter>
<Parameter ID="Masomo_SampleIntervalPr" state="changed">2.0</Parameter>
<Parameter ID="Masomo_SeparatorBubbles" state="changed"></Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimaryPrint">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleModePrint" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubblePrint">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorStreamer" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">hyd</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" Description="Syntrak-24" ID="Masomo_FarfieldModelling">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfield" state="default">-1</Parameter>
<Parameter ID="Masomo_FilterOptionFarfield" state="changed">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">Syntrak-24_3/12-206/276</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_GeometricalSpreading" state="default">2</Parameter>
<Parameter ID="Masomo_SpecificationSystem" state="default">Individual positions</Parameter>
<Parameter ID="Masomo_CoordinateSystem" state="default">Polar coordinates</Parameter>
<Parameter ID="Masomo_NoFarfieldPositions" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_PressureOutputScale" state="default">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Farfield_Ind_Polar">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter ID="FarfieldPositionNumber" state="default">1</Parameter>
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Record Filter No Ghost" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" Description="S24 time" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="default">Signatures</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="default">1000</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldBubbleOption" state="changed">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">S24_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" Description="S24 freq" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="changed">Absolute spectra</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="changed">250</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldBubbleOption" state="changed">No</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">S24_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePrint">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePrint">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldNumber" state="default">1</Parameter>
<Parameter ID="Masomo_SampleIntervalPr" state="changed">2.0</Parameter>
<Parameter ID="Masomo_SeparatorBubbles" state="changed"></Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimaryPrint">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleModePrint" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubblePrint">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorStreamer" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">S24</Key>
<Key name="type" state="default">Text file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" Description="GeoStreamer" ID="Masomo_FarfieldModelling">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfield" state="default">-1</Parameter>
<Parameter ID="Masomo_FilterOptionFarfield" state="changed">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_GeometricalSpreading" state="default">2</Parameter>
<Parameter ID="Masomo_SpecificationSystem" state="default">Individual positions</Parameter>
<Parameter ID="Masomo_CoordinateSystem" state="default">Polar coordinates</Parameter>
<Parameter ID="Masomo_NoFarfieldPositions" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_PressureOutputScale" state="default">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Farfield_Ind_Polar">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter ID="FarfieldPositionNumber" state="default">1</Parameter>
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Record Filter No Ghost" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" Description="GeoStreamer time" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="default">Signatures</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="default">1000</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldBubbleOption" state="changed">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">GSLC_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" Description="GeoStreamer freq" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="changed">Absolute spectra</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="changed">250</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldBubbleOption" state="changed">No</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">GSLC_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePrint">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePrint">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldNumber" state="default">1</Parameter>
<Parameter ID="Masomo_SampleIntervalPr" state="changed">2.0</Parameter>
<Parameter ID="Masomo_SeparatorBubbles" state="changed"></Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimaryPrint">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleModePrint" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubblePrint">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorStreamer" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">GSLC</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Directivity" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" Description="Az 90" ID="Masomo_ArrayDirectivityPlot">
<Parameter ID="Masomo_ArrayDirInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ArrayDirPlotMode" state="changed">Constant azimuth, polar plot</Parameter>
<Parameter ID="Masomo_ArrayDirSurfRefl" state="default">-1</Parameter>
<ParameterGroup ID="Masomo_ArrayDirStrGhost">
<Parameter ID="Masomo_ArrayDirGhost" state="default">No</Parameter>
<Parameter ID="Masomo_ArrayDirStrDepth" state="default">0</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_ArrayDirdBRange" state="changed">60</Parameter>
<ParameterGroup ID="Masomo_ArrayDirAzim">
<Parameter ID="Masomo_ArrayDirAzimMin" state="default">-180</Parameter>
<Parameter ID="Masomo_ArrayDirAzimMax" state="default">180</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_ArrayDirFreq">
<Parameter ID="Masomo_ArrayDirFreqMin" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirFreqMax" state="changed">125</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_ArrayDirDip">
<Parameter ID="Masomo_ArrayDirDipMin" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirDipMax" state="default">45</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_ArrayDirMaxDip" state="default">45</Parameter>
<Parameter ID="Masomo_ArrayDirConstFreq" state="default">30</Parameter>
<Parameter ID="Masomo_ArrayDirConstAzim" state="changed">90</Parameter>
<Parameter ID="Masomo_ArrayDirConstVert" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirColorScale">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="ColorScale">
<Key name="name" state="changed">Nucleus30</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ArrayDirInterpolate" state="changed">Yes</Parameter>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="changed">600</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dir90</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Az 0" ID="Masomo_ArrayDirectivityPlot">
<Parameter ID="Masomo_ArrayDirInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ArrayDirPlotMode" state="changed">Constant azimuth, polar plot</Parameter>
<Parameter ID="Masomo_ArrayDirSurfRefl" state="default">-1</Parameter>
<ParameterGroup ID="Masomo_ArrayDirStrGhost">
<Parameter ID="Masomo_ArrayDirGhost" state="default">No</Parameter>
<Parameter ID="Masomo_ArrayDirStrDepth" state="default">0</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_ArrayDirdBRange" state="changed">60</Parameter>
<ParameterGroup ID="Masomo_ArrayDirAzim">
<Parameter ID="Masomo_ArrayDirAzimMin" state="default">-180</Parameter>
<Parameter ID="Masomo_ArrayDirAzimMax" state="default">180</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_ArrayDirFreq">
<Parameter ID="Masomo_ArrayDirFreqMin" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirFreqMax" state="changed">125</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_ArrayDirDip">
<Parameter ID="Masomo_ArrayDirDipMin" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirDipMax" state="default">45</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_ArrayDirMaxDip" state="default">45</Parameter>
<Parameter ID="Masomo_ArrayDirConstFreq" state="default">30</Parameter>
<Parameter ID="Masomo_ArrayDirConstAzim" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirConstVert" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirColorScale">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="ColorScale">
<Key name="name" state="changed">Nucleus30</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ArrayDirInterpolate" state="default">Yes</Parameter>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="changed">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="changed">600</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dir0</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_ReportGeneration">
<Page Expanded="yes" Enabled="yes" ID="Masomo_ReportTender">
<Parameter ID="Masomo_ReportGeneration_Author" state="changed">',$author,'</Parameter>
<Parameter ID="Masomo_ReportGeneration_Project">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_ArrayFile">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">array</Key>
<Key name="type" state="default">Array print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGenerationTender_FilterHydroscience">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">hyd</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGenerationTender_FilterSyntrak">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">S24</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGenerationTender_FilterDFS">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">dfs</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGenerationTender_FilterGeostreamer">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">GSLC</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_ArrayImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">array</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_HydTimeImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">Hyd24_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_HydFreqImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">Hyd24_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_STimeImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">S24_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_SFreqImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">S24_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_GSTimeImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">GSLC_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_GSFreqImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">GSLC_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DFSTimeImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dfs_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DFSFreqImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dfs_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Dir0Image">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dir0</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Dir90Image">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dir90</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Output">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$tendreportname,'</Key>
<Key name="type" state="default">Report</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
</Page>
</Page>
</Pages>
');
close(OUTPUT);
}


if ($processing eq "true"){
    $proreportname = ("PRO_".$jobnumber."_".$survey);
open(OUTPUT, ">ProcessingSignature.Marine\ Source\ Modelling.Null\ Page.J2X") or die("Error creating job file");
print("Created job file: ProcessingSignature.Marine Source Modelling.Null Page.J2X\n");
print OUTPUT ('<!DOCTYPE PGS_N2_JOB>
<Pages ID="MasomoRoot" ParentID="masomo">
<Page Expanded="yes" Enabled="yes" Description="Processing Signature" ID="MasomoRoot">
<Parameter ID="GlobalProject">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="GlobalOverwrite" state="default">Yes</Parameter>
<Page Expanded="yes" Enabled="yes" ID="DataMgrFullArray">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="FullArrayCopy">
<ParameterGroup ID="FullArrayInputGroup">
<Parameter ID="ProjectInputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$arraylib,'</Key>
</Entity>
</Parameter>
<Parameter ID="FullArrayInputSpec">
<Entity name="Project">
<Key name="name" state="default">',$arraylib,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<ParameterGroup ID="FullArrayOutputGroup">
<Parameter ID="ProjectOutputSpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="FullArrayOutputSpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Parameter ID="FullArrayCopyFlag" state="changed">Yes</Parameter>
<Parameter ID="FullArrayOverwriteRefsFlag" state="changed">Yes</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="DataMgrFullArray">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="FullArrayCheck">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FullArrayPlot">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<ParameterGroup ID="Masomo_plotBySubsource">
<Parameter ID="Masomo_subsourcePlotOpt" state="default">No</Parameter>
<Parameter ID="Masomo_subsourcePlotIndex" state="default">1</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">array</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Notional" ID="Masomo_Modelling">
<Notes>Common notional signature set used for all the farfield signature computations in this job</Notes>
<Page Expanded="yes" Enabled="yes" ID="Masomo_NotionalModelling">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">',$procsignlength,'</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">',$temperature,'</Parameter>
<Parameter state="default" ID="Masomo_SeaVelocity">1490.048</Parameter>
<Parameter state="changed" ID="Masomo_UseNewModellingOption">',$usenewmodel,'</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$recfilt,'</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_GSNotionalModelling">
<ParameterGroup ID="Masomo_delayOptionGroup">
<Parameter ID="Masomo_applyDelayOption" state="default">No</Parameter>
<Parameter ID="Masomo_applyDelayType" state="default">Manually</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="DFS filter" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" Description="DFS" ID="Masomo_FarfieldModelling">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfield" state="changed">-1</Parameter>
<Parameter ID="Masomo_FilterOptionFarfield" state="changed">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">DFS V_Out-128/72</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_GeometricalSpreading" state="default">2</Parameter>
<Parameter ID="Masomo_SpecificationSystem" state="default">Individual positions</Parameter>
<Parameter ID="Masomo_CoordinateSystem" state="default">Polar coordinates</Parameter>
<Parameter ID="Masomo_NoFarfieldPositions" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorGeosource" state="changed"></Parameter>
<Parameter ID="Masomo_WavefieldDecompositionOption" state="default">No</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_PressureOutputScale" state="default">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Farfield_Ind_Polar">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter ID="FarfieldPositionNumber" state="default">1</Parameter>
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="DFS No Ghost" ID="Masomo_Plotting">
<Notes>Plots DFS farfield signature in time and frequency. The pictures are also saved as png files. </Notes>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="default">Signatures</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="changed">Specify end time</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="changed">0</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="default">1000</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="changed">0</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dfs_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="changed">Absolute spectra</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="changed">250</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dfs_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" Description="Record filter" ID="Masomo_FarfieldModelling">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfield" state="changed">-1</Parameter>
<Parameter ID="Masomo_FilterOptionFarfield" state="changed">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$recfilt,'</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_GeometricalSpreading" state="default">2</Parameter>
<Parameter ID="Masomo_SpecificationSystem" state="default">Individual positions</Parameter>
<Parameter ID="Masomo_CoordinateSystem" state="default">Polar coordinates</Parameter>
<Parameter ID="Masomo_NoFarfieldPositions" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorGeosource" state="changed"></Parameter>
<Parameter ID="Masomo_WavefieldDecompositionOption" state="default">No</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_PressureOutputScale" state="default">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Farfield_Ind_Polar">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter ID="FarfieldPositionNumber" state="default">1</Parameter>
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Record Filter No Ghost" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="default">Signatures</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="changed">Specify end time</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="default">1000</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$filename,'_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="changed">Absolute spectra</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="changed">250</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$filename,'_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" Description="Full Sys Resp. " ID="Masomo_FarfieldModelling">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfield" state="changed">',$refcoeff,'</Parameter>
<Parameter ID="Masomo_FilterOptionFarfield" state="changed">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$fullsys,'</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_GeometricalSpreading" state="default">2</Parameter>
<Parameter ID="Masomo_SpecificationSystem" state="default">Individual positions</Parameter>
<Parameter ID="Masomo_CoordinateSystem" state="default">Polar coordinates</Parameter>
<Parameter ID="Masomo_NoFarfieldPositions" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorGeosource" state="changed"></Parameter>
<Parameter ID="Masomo_WavefieldDecompositionOption" state="default">No</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_PressureOutputScale" state="default">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Farfield_Ind_Polar">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter ID="FarfieldPositionNumber" state="default">1</Parameter>
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Full Sys Resp. No Ghost" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="default">Signatures</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="changed">Specify end time</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="default">1000</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">FullSys_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="changed">Absolute spectra</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="changed">250</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">FullSys_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Full Sys Resp. Ghost" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="default">Signatures</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="changed">Yes</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="changed">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="changed">Specify end time</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="default">1000</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="changed">15</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">FullSys_Gh_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="changed">Absolute spectra</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="changed">Yes</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="changed">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="changed">250</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">FullSys_Gh_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePrint">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePrint">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<ParameterGroup ID="Masomo_FarfieldTraces">
<Parameter ID="Masomo_FarfieldTracesStart" state="default">1</Parameter>
<Parameter ID="Masomo_FarfieldTracesEnd" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SampleIntervalPr" state="changed">2</Parameter>
<Parameter ID="Masomo_SeparatorBubbles" state="changed"></Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimaryPrint">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleModePrint" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubblePrint">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorStreamer" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">FullSys</Key>
<Key name="type" state="changed">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Full Sys Resp. Ghost" ID="Masomo_FarfieldSignaturePrint">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<ParameterGroup ID="Masomo_FarfieldTraces">
<Parameter ID="Masomo_FarfieldTracesStart" state="default">1</Parameter>
<Parameter ID="Masomo_FarfieldTracesEnd" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SampleIntervalPr" state="changed">2</Parameter>
<Parameter ID="Masomo_SeparatorBubbles" state="changed"></Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimaryPrint">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-56</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleModePrint" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubblePrint">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorStreamer" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="changed">Yes</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="changed">',$recdepth,'</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">FullSys_Gh</Key>
<Key name="type" state="changed">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FullArrayPrint">
<Parameter ID="Masomo_PlotFullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$jobnumber,'</Key>
<Key name="type" state="default">Array print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Directivity" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" Description="Az 90" ID="Masomo_ArrayDirectivityPlot">
<Parameter ID="Masomo_ArrayDirInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ArrayDirPlotMode" state="changed">Constant azimuth, polar plot</Parameter>
<Parameter ID="Masomo_ArrayDirSurfRefl" state="changed">-1</Parameter>
<ParameterGroup ID="Masomo_ArrayDirStrGhost">
<Parameter ID="Masomo_ArrayDirGhost" state="default">No</Parameter>
<Parameter ID="Masomo_ArrayDirStrDepth" state="default">0</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_ArrayDirdBRange" state="changed">60</Parameter>
<ParameterGroup ID="Masomo_ArrayDirAzim">
<Parameter ID="Masomo_ArrayDirAzimMin" state="default">-180</Parameter>
<Parameter ID="Masomo_ArrayDirAzimMax" state="default">180</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_ArrayDirFreq">
<Parameter ID="Masomo_ArrayDirFreqMin" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirFreqMax" state="changed">125</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_ArrayDirDip">
<Parameter ID="Masomo_ArrayDirDipMin" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirDipMax" state="default">45</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_ArrayDirMaxDip" state="default">45</Parameter>
<Parameter ID="Masomo_ArrayDirConstFreq" state="default">30</Parameter>
<Parameter ID="Masomo_ArrayDirConstAzim" state="changed">90</Parameter>
<Parameter ID="Masomo_ArrayDirConstVert" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirColorScale">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="ColorScale">
<Key name="name" state="changed">Nucleus30</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ArrayDirInterpolate" state="changed">Yes</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_GeosourceDirectivity">
<Parameter ID="Masomo_WavefieldDecompositionOption" state="default">No</Parameter>
<Parameter ID="Masomo_CrossLineErrorOption" state="default">No</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="changed">600</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dir90</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Az 0" ID="Masomo_ArrayDirectivityPlot">
<Parameter ID="Masomo_ArrayDirInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ArrayDirPlotMode" state="changed">Constant azimuth, polar plot</Parameter>
<Parameter ID="Masomo_ArrayDirSurfRefl" state="changed">-1</Parameter>
<ParameterGroup ID="Masomo_ArrayDirStrGhost">
<Parameter ID="Masomo_ArrayDirGhost" state="default">No</Parameter>
<Parameter ID="Masomo_ArrayDirStrDepth" state="default">0</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_ArrayDirdBRange" state="changed">60</Parameter>
<ParameterGroup ID="Masomo_ArrayDirAzim">
<Parameter ID="Masomo_ArrayDirAzimMin" state="default">-180</Parameter>
<Parameter ID="Masomo_ArrayDirAzimMax" state="default">180</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_ArrayDirFreq">
<Parameter ID="Masomo_ArrayDirFreqMin" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirFreqMax" state="changed">125</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_ArrayDirDip">
<Parameter ID="Masomo_ArrayDirDipMin" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirDipMax" state="default">45</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_ArrayDirMaxDip" state="default">45</Parameter>
<Parameter ID="Masomo_ArrayDirConstFreq" state="default">30</Parameter>
<Parameter ID="Masomo_ArrayDirConstAzim" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirConstVert" state="default">0</Parameter>
<Parameter ID="Masomo_ArrayDirColorScale">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="ColorScale">
<Key name="name" state="changed">Nucleus30</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ArrayDirInterpolate" state="default">Yes</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_GeosourceDirectivity">
<Parameter ID="Masomo_WavefieldDecompositionOption" state="default">No</Parameter>
<Parameter ID="Masomo_CrossLineErrorOption" state="default">No</Parameter>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="changed">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="changed">600</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">dir0</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
###
<Page Expanded="yes" Enabled="yes" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" Description="Full Sys Resp. No source ghost." ID="Masomo_FarfieldModelling">
<Notes>No source ghost</Notes>
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfield" state="changed">0</Parameter>
<Parameter ID="Masomo_FilterOptionFarfield" state="changed">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$fullsys,'</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_GeometricalSpreading" state="default">2</Parameter>
<Parameter ID="Masomo_SpecificationSystem" state="default">Individual positions</Parameter>
<Parameter ID="Masomo_CoordinateSystem" state="default">Polar coordinates</Parameter>
<Parameter ID="Masomo_NoFarfieldPositions" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorGeosource" state="changed"></Parameter>
<Parameter ID="Masomo_DeghostingOption" state="default">No</Parameter>
<Parameter ID="Masomo_ModelFarfields4EachSubsource" state="default">No</Parameter>
<Parameter ID="Masomo_SeparatorCorrelate" state="changed"></Parameter>
<Parameter ID="Masomo_CorrelateFarfield" state="default">None</Parameter>
<Parameter ID="Masomo_CorrelateFarfieldNotionals" state="default">1 x = 0 y = 8.4</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_PressureOutputScale" state="default">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Farfield_Ind_Polar">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter ID="FarfieldPositionNumber" state="default">1</Parameter>
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" Description="Full Sys Resp. no source or rec Ghost" ID="Masomo_Plotting">
<Notes>No source or rec ghost</Notes>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="default">Signatures</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="changed">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="changed">20</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">12.5</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="changed">Specify end time</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-68.5</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="default">1000</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FFSigSpecifyAmpRange">
<Parameter ID="Masomo_AmpRangeOption" state="default">No</Parameter>
<Parameter ID="Masomo_FFSigAmpRangeMin" state="default">-20</Parameter>
<Parameter ID="Masomo_FFSigAmpRangeMax" state="default">70</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-68.5</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="changed">15</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="changed">No</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="changed">No</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="changed">No</Parameter>
</Page>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">FullSys_noGh_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePlot">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePlot">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="changed">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_FarfieldInputSignature" state="changed">1 - dist: 9000 vert: 0 az: 0</Parameter>
<Parameter ID="Masomo_PlotOption" state="changed">Absolute spectra</Parameter>
<Parameter ID="Masomo_dbRange" state="default">60</Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="changed">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="changed">20</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">12.5</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_FarfieldCaption" state="default"></Parameter>
<ParameterGroup ID="Masomo_FarfieldTimeWindow">
<Parameter ID="Masomo_TimeWindowMode" state="default">Whole</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowStart" state="default">-68.5</Parameter>
<Parameter ID="Masomo_FarfieldTimeWindowEnd" state="changed">400</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FarfieldFreqBand">
<Parameter ID="Masomo_FarfieldFreqBandStart" state="default">0</Parameter>
<Parameter ID="Masomo_FarfieldFreqBandEnd" state="changed">250</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FFSigSpecifyAmpRange">
<Parameter ID="Masomo_AmpRangeOption" state="default">No</Parameter>
<Parameter ID="Masomo_FFSigAmpRangeMin" state="default">0</Parameter>
<Parameter ID="Masomo_FFSigAmpRangeMax" state="default">250</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_OverlayLinesOpt">
<Parameter ID="Masomo_OverlayLinesOption" state="default">No</Parameter>
<Parameter ID="Masomo_OverlayLinesNumber" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldSignCharSep" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldPrimaryOption" state="default">Yes</Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimary">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-68.5</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldBubbleMode" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubble">
<Parameter ID="Masomo_FarfieldBubbleStart" state="changed">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="default">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">FullSys_noGh_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_SignaturePrint">
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldSignaturePrint">
<Parameter ID="Masomo_FarfieldInput">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$arrayname,'</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<ParameterGroup ID="Masomo_FarfieldTraces">
<Parameter ID="Masomo_FarfieldTracesStart" state="default">1</Parameter>
<Parameter ID="Masomo_FarfieldTracesEnd" state="default">1</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SampleIntervalPr" state="changed">2</Parameter>
<Parameter ID="Masomo_SeparatorBubbles" state="changed"></Parameter>
<ParameterGroup ID="Masomo_FarfieldPrimaryPrint">
<Parameter ID="Masomo_FarfieldPrimaryStart" state="default">-68.5</Parameter>
<Parameter ID="Masomo_FarfieldPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_FarfieldBubbleModePrint" state="changed">Manual</Parameter>
<ParameterGroup ID="Masomo_FarfieldBubblePrint">
<Parameter ID="Masomo_FarfieldBubbleStart" state="default">50</Parameter>
<Parameter ID="Masomo_FarfieldBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorStreamer" state="changed"></Parameter>
<Parameter ID="Masomo_FarfieldStreamerGhost" state="default">No</Parameter>
<Parameter ID="Masomo_FarfieldStreamerDepth" state="default">8</Parameter>
<Parameter ID="Masomo_FarfieldGroupLength" state="default">12.5</Parameter>
<Parameter ID="Masomo_FarfieldNumHyd" state="default">16</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter ID="Masomo_ExternalPrintOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="Masomo_ExternalPrintOutputData">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">FullSys_noGh</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<Page Expanded="yes" Enabled="yes" ID="Masomo_FarfieldPlotSpec">
<Parameter ID="Masomo_FarfieldAnnotationDefault" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimary" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPeakToPeak" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPrimaryBubble" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationSourceDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationStreamerDepth" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationVolume" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationPressure" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGhostStrength" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterTemp" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationWaterVelocity" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationGeometricalSpreading" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationFilter" state="default">Yes</Parameter>
<Parameter ID="Masomo_FarfieldAnnotationBubblePeriod" state="default">Yes</Parameter>
</Page>
</Page>
</Page>
</Page>
###
<Page Expanded="yes" Enabled="yes" ID="Masomo_Printing">
<Page Expanded="yes" Enabled="yes" ID="Masomo_ReportGeneration">
<Page Expanded="yes" Enabled="yes" ID="Masomo_ReportProcessing">
<Parameter ID="Masomo_ReportGeneration_Author" state="changed">',$author,'</Parameter>
<Parameter ID="Masomo_ReportProcessing_Vessel" state="changed">',$vessel,'</Parameter>
<Parameter ID="Masomo_ReportProcessing_Survey" state="changed">',$survey,'</Parameter>
<Parameter ID="Masomo_ReportProcessing_SurveyArea" state="changed">',$survey,'</Parameter>
<Parameter ID="Masomo_ReportProcessing_HydrophoneGroupLength" state="default">',$grouplength,'</Parameter>
<Parameter ID="Masomo_ReportGeneration_Project">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_ArrayFile">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$jobnumber,'</Key>
<Key name="type" state="default">Array print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportProcessing_FullSystem">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">FullSys</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportProcessing_FullSystemGhost">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">FullSys_Gh</Key>
<Key name="type" state="default">Farfield print</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportProcessing_FilterRecording">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$recfilt,'</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportProcessing_FilterFullSystem">
<Entity name="Project">
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">',$fullsys,'</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportProcessing_ProjectNumber" state="changed">',$jobnumber,'</Parameter>
<Parameter ID="Masomo_ReportGeneration_ArrayImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">array</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_RecFilterTimeImg">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">recfilt_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_RecFilterFreqImg">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">recfilt_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DFSTimeImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">dfs_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_DFSFreqImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">dfs_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_FullSysTimeImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">FullSys_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_FullSysFreqImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">FullSys_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_FullSysGhTimeImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">FullSys_Gh_t</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_FullSysGhFreqImage">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">FullSys_Gh_f</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Dir0Image">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">dir0</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Dir90Image">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="default">dir90</Key>
<Key name="type" state="default">Png file</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_ReportGeneration_Output">
<Entity name="Project">
<Key name="name" state="default">',$project,'</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$proreportname,'</Key>
<Key name="type" state="default">Report</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
</Page>
</Page>
</Pages>
');
close(OUTPUT);
}

close(INPUT);

#Set nucDir variable from NUCLEUS_DIR environment variable or from hard coded directory.
##Remove below if ok
#if (defined $ENV{'NUCLEUS_DIR'})
#{
#$nucDir = $ENV{'NUCLEUS_DIR'};
#}
#else
#{
##Might have to change it according to the location (Oslo, London, Houston, ...) 
##$nucDir = '/data/Nucleus/release_2.6.0/com/pgs/research/NII';
#}
##remove above if ok
#$nucDir = '/pgsdev/Nucleus+GS/latest';

print("Verify that NUCLEUS_DIR is set to the correct N+ release path. \n");
print("NUCLEUS_DIR = $nucDir \n");

print("Do you want to execute of the Nucleus jobs now? (y/n)");
$execute = <STDIN>;
chomp($execute);

$jobdir = $projectdir.'/Jobs';

if (($execute eq "y") && ($autocreateproj eq "y")){
    print("Loading and executing project creating job in Nucleus+ ... \n");
    system("$nucDir/usr/bin/Nucleus+.sh", "mode=test", "projectName=Sourcemod", "jobName=CreateProject");
    if ( $? == -1 )
    {
        print "Automatic loading and/or execution of the CreateProject job failed: $!\n";
    }
    else
    {
        #system("cat", "nucleus.log");
	#system("mkdir", $jobdir); Commented out for Manuel bug
	mkdir $jobdir
    } 
}


if (($execute eq "y") && ($tender eq "true"))
{
    print("Loading and executing TenderSignature job in Masomo ... \n");
    system("mv", "TenderSignature.Marine\ Source\ Modelling.Null\ Page.J2X", $jobdir);
    system("$nucDir/usr/bin/masomo.sh", "mode=test", "projectName=$project", "jobName=TenderSignature");
    if ( $? == -1 )
    {
        print "Automatic loading and/or execution of the TenderSignature job failed: $!\n";
    }
    else
    {
        system("cat", "masomo.log");
    }
}


if (($execute eq "y") && ($processing eq "true"))
{
    print("Loading and executing ProcessingSignature job in Masomo ... \n");
    system("mv", "ProcessingSignature.Marine\ Source\ Modelling.Null\ Page.J2X", $jobdir);
    system("$nucDir/usr/bin/masomo.sh", "mode=test", "projectName=$project", "jobName=ProcessingSignature");
    if ( $? == -1 )
    {
        print "Automatic loading and/or execution of the ProcessingSignature job failed: $!\n";
    }
    else
    {
        system("cat", "masomo.log");
    }
}

if (($execute eq "y") && ($dropout eq "true"))
{
    print("Loading and executing Dropout job in Masomo ... \n");
    system("mv", "Dropout.Marine\ Source\ Modelling.Null\ Page.J2X", $jobdir);
    system("mv", "DropoutReModelling.Marine\ Source\ Modelling.Workspace.J2X", $jobdir);
    system("$nucDir/usr/bin/masomo.sh", "mode=test", "projectName=$project", "jobName=Dropout");
    if ( $? == -1 )
    {
        print "Automatic loading and/or execution of the Dropout job failed: $!\n";
    }
    else
    {
        system("cat", "masomo.log");
    }
}

print("And finally, last question, do you even want this script to make a tar-archive of the Nucleus+ project for you? (y/n):");
$archive = <STDIN>;
chomp($archive);
if ($archive eq "y"){
    $tarfile = $jobnumber."_".$vessel."_".$survey."_source_modeling.tar";
    $tarfile =~ s/ /_/g;
    print("Creating tar archive: ",$tarfile,"\n");
    system("tar", "cvf", $tarfile, $projectdir);
}else{
    print("No tar file created\n");
}
