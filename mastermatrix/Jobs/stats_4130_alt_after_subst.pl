#!/usr/bin/perl

$nucDir = '/data/Nucleus/release/com/pgs/research/NII';


@arraydepth = (4, 5, 6, 7, 8, 9);
@subarrayseparation = (8, 10);
@temp = (5, 10, 15, 20, 25);
@subst = ('00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17');
#@subst = ('15', '16', '17');
$postfix = "";

#@arraydepth = (7);
#@subarrayseparation = (10);
#@temp = (15);
#@subst = ('01');
$i=1;
foreach $subst (@subst){
    foreach $arraydepth (@arraydepth){
	foreach $subarrayseparation (@subarrayseparation){
	    $depth3digits = sprintf("%03d", $arraydepth*10);
	    if ($subarrayseparation<10){
		$arrayname = "4130T__".$depth3digits."_2000_0".($subarrayseparation*10)."_".$subst;
		$arraynameref = "4130T__".$depth3digits."_2000_0".($subarrayseparation*10)."_alt2";
	    }else{
		$arrayname = "4130T__".$depth3digits."_2000_".($subarrayseparation*10)."_".$subst;
		$arraynameref = "4130T__".$depth3digits."_2000_".($subarrayseparation*10)."_alt2";
	    }
	    print("arrayname: ", $arrayname, "\n");


open(OUTPUT, ">AutoPrintStats_substit.Marine\ Source\ Modelling.Null\ Page.J2X") or die("Error creating job file");
print("Created job file: AutoPrintStats_substit.Marine Source Modelling.Null Page.J2X\n"); 
print OUTPUT ('<!DOCTYPE PGS_N2_JOB>
<Pages ID="MasomoRoot" ParentID="masomo">
<Page ID="MasomoRoot" Expanded="yes" Enabled="yes">
<Parameter ID="GlobalProject">
<Entity name="Project">
<Key state="default" name="name">2018_06_MasterMatrix</Key>
</Entity>
</Parameter>
<Parameter ID="GlobalOverwrite" state="default">Yes</Parameter>
');
	    foreach $temp (@temp){
		if ($subarrayseparation<10){
		$statfilename = "4130T__".$depth3digits."_0".($subarrayseparation*10)."_".$subst."_".$temp;
	    }else{
		$statfilename = "4130T__".$depth3digits."_".($subarrayseparation*10)."_".$subst."_".$temp;
	    }
print OUTPUT ('<Page ID="Masomo_Modelling" Description="Temp ',$temp,' deg" Expanded="yes" Enabled="yes">
<Page ID="DropoutSetupCreate" Expanded="yes" Enabled="yes">
<Parameter ID="Masomo_DropoutArray">
<Entity name="Project">
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="FullArray">
<Key state="changed" name="name">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutReferenceArray">
<Entity name="Project">
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="FullArray">
<Key state="changed" name="name">',$arraynameref,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutOption" state="changed">1 gun dropouts with sparesub</Parameter>
<Parameter ID="Masomo_DropoutNoCombinations" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutSetupSpec">
<Entity name="Project">
<Key state="default" name="name">2018_06_MasterMatrix</Key>
<Entity name="DropoutSetup">
<Key state="changed" name="name">1drop_sparesub</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page ID="Masomo_DropoutModelling" Expanded="yes" Enabled="yes">
<Parameter ID="Masomo_DropoutSetupInput">
<Entity name="Project">
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="DropoutSetup">
<Key state="changed" name="name">1drop_sparesub</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_SignatureLength" state="changed">1000</Parameter>
<Parameter ID="Masomo_ReflectionCoeffNotionalsDropout" state="default">-1</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfieldDropout" state="changed">0</Parameter>
<Parameter ID="Masomo_SeaTemperature" state="changed">',$temp,'</Parameter>
<Parameter ID="Masomo_SeaVelocity" state="default">1534.5605</Parameter>
<Parameter ID="Masomo_InstrumentFilterDropout">
<Entity name="Project">
<Key state="changed" name="name">Default</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">GeoStr LChyd_3/7-214/341</Key>
<Key state="changed" name="type">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_UseNewModellingOption" state="default">No</Parameter>
<Parameter ID="Masomo_SeparatorGeosource" state="changed"></Parameter>
<Parameter ID="Masomo_DeghostingOption" state="default">No</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<ParameterGroup ID="Masomo_DropoutCoordinates">
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutOutput">
<Entity name="Project">
<Key state="default" name="name">2018_06_MasterMatrix</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">1drop_sparesub</Key>
<Key state="default" name="type">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page ID="Masomo_Analysis" Expanded="yes" Enabled="yes">
<Page ID="Masomo_CompDropoutStatisticsGS" Expanded="yes" Enabled="yes">
<Parameter ID="Masomo_DropoutInput">
<Entity name="Project">
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">1drop_sparesub</Key>
<Key state="changed" name="type">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<ParameterGroup ID="Masomo_DropoutBandwidth">
<Parameter ID="DropoutBandwidthStart" state="changed">5</Parameter>
<Parameter ID="DropoutBandwidthEnd" state="changed">200</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_DropoutWeighting" state="default">None</Parameter>
<Parameter ID="Masomo_DropoutFrequencyOption" state="default">Absolute deviation</Parameter>
<Parameter ID="Masomo_DropoutReferenceText" state="default"></Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutStatisticsOutput">
<Entity name="Project">
<Key state="default" name="name">2018_06_MasterMatrix</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">1drop_sparesub</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutColumnDataOption" state="default">No</Parameter>
<Parameter ID="Masomo_Dropout_ColumnData">
<Entity name="Project">
<Key state="default" name="name">2018_06_MasterMatrix</Key>
<Entity name="ColumnData">
<Key state="default" name="name">*</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page ID="Masomo_Printing" Expanded="yes" Enabled="yes">
<Page ID="Masomo_DropoutStatisticsPrint" Expanded="yes" Enabled="yes">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">1drop_sparesub</Key>
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
<Key state="default" name="name">2018_06_MasterMatrix</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">bb_',$statfilename,'</Key>
<Key state="default" name="type">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page ID="Masomo_Modelling" Expanded="yes" Enabled="yes">
<Page ID="Masomo_DropoutModelling" Expanded="yes" Enabled="yes">
<Parameter ID="Masomo_DropoutSetupInput">
<Entity name="Project">
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="DropoutSetup">
<Key state="changed" name="name">1drop_sparesub</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_SampleIntervalFF" state="default">0.5</Parameter>
<Parameter ID="Masomo_SignatureLength" state="changed">1000</Parameter>
<Parameter ID="Masomo_ReflectionCoeffNotionalsDropout" state="default">-1</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfieldDropout" state="default">-1</Parameter>
<Parameter ID="Masomo_SeaTemperature" state="changed">',$temp,'</Parameter>
<Parameter ID="Masomo_SeaVelocity" state="default">1534.5605</Parameter>
<Parameter ID="Masomo_InstrumentFilterDropout">
<Entity name="Project">
<Key state="changed" name="name">Default</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">GeoStr LChyd_3/7-214/341</Key>
<Key state="changed" name="type">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_UseNewModellingOption" state="default">No</Parameter>
<Parameter ID="Masomo_SeparatorGeosource" state="changed"></Parameter>
<Parameter ID="Masomo_DeghostingOption" state="default">No</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<ParameterGroup ID="Masomo_DropoutCoordinates">
<Parameter ID="FarfieldPositionAngDip" state="default">0</Parameter>
<Parameter ID="FarfieldPositionAngAzi" state="default">0</Parameter>
<Parameter ID="FarfieldPositionDistance" state="default">9000</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutOutput">
<Entity name="Project">
<Key state="default" name="name">2018_06_MasterMatrix</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">1drop_sparesub_cc</Key>
<Key state="default" name="type">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page ID="Masomo_Analysis" Expanded="yes" Enabled="yes">
<Page ID="Masomo_CompDropoutStatisticsXC" Expanded="yes" Enabled="yes">
<Parameter ID="Masomo_DropoutInput">
<Entity name="Project">
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="Wavelet">
<Key state="changed" name="name">1drop_sparesub_cc</Key>
<Key state="changed" name="type">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<ParameterGroup ID="Masomo_DropoutPrimary">
<Parameter ID="Masomo_DropoutPrimaryStart" state="default">-68.5</Parameter>
<Parameter ID="Masomo_DropoutPrimaryEnd" state="default">30</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_DropoutBubbleMode" state="default">Manual</Parameter>
<ParameterGroup ID="Masomo_DropoutBubble">
<Parameter ID="Masomo_DropoutBubbleStart" state="default">50</Parameter>
<Parameter ID="Masomo_DropoutBubbleEnd" state="default">200</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_DropoutBandwidth">
<Parameter ID="DropoutBandwidthStart" state="default">10</Parameter>
<Parameter ID="DropoutBandwidthEnd" state="default">70</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_DropoutFrequencyOption" state="default">Absolute deviation</Parameter>
<Parameter ID="Masomo_AmplitudePeakOption" state="default">Primary positive peak</Parameter>
<Parameter ID="Masomo_DropoutReferenceText" state="default"></Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutStatisticsOutput">
<Entity name="Project">
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">1drop_sparesub_cc</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutColumnDataOption" state="default">No</Parameter>
<Parameter ID="Masomo_Dropout_ColumnData">
<Entity name="Project">
<Key state="default" name="name">2018_06_MasterMatrix</Key>
<Entity name="ColumnData">
<Key state="default" name="name">*</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page ID="Masomo_Printing" Expanded="yes" Enabled="yes">
<Page ID="Masomo_DropoutStatisticsPrint" Expanded="yes" Enabled="yes">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="DropoutStatistics">
<Key state="changed" name="name">1drop_sparesub_cc</Key>
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
<Key state="changed" name="name">2018_06_MasterMatrix</Key>
<Entity name="ExternalData">
<Key state="changed" name="name">cc_',$statfilename,'</Key>
<Key state="changed" name="type">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
');
}
print OUTPUT ('</Page>
</Pages>
');

close(OUTPUT);

sleep(3);
system("$nucDir/usr/bin/masomo.sh", "mode=test", "projectName=2018_06_MasterMatrix", "jobName=AutoPrintStats_substit");
if ( $? == -1 )
{
    print "Automatic loading and/or execution of the Dropout job failed: $!\n";
}
else
{
    system("cat", "masomo.log");
}


	}
    }
}


