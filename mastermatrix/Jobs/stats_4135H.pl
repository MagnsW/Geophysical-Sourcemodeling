#!/usr/bin/perl

$nucDir = '/data/Nucleus/release/com/pgs/research/NII';


@arraydepth = (4, 5, 6, 7, 8, 9);
@subarrayseparation = (8, 10);
@temp = (5, 10, 15, 20, 25);

#@arraydepth = (7);
#@subarrayseparation = (10);
#@temp = (15);

foreach $arraydepth (@arraydepth){
    foreach $subarrayseparation (@subarrayseparation){
	$depth3digits = sprintf("%03d", $arraydepth*10);
	if ($subarrayseparation<10){
	    $arrayname = "4135H__".$depth3digits."_2000_0".($subarrayseparation*10);
	}else{
	    $arrayname = "4135H__".$depth3digits."_2000_".($subarrayseparation*10);
        }
	print("arrayname: ", $arrayname, "\n");
	foreach $temp (@temp){		    

		$matrixname = $arrayname."_".$temp;

open(OUTPUT, ">AutoPrintStats.Marine\ Source\ Modelling.Null\ Page.J2X") or die("Error creating job file");
print("Created job file: AutoPrintStats.Marine Source Modelling.Null Page.J2X\n"); 
print OUTPUT ('<!DOCTYPE PGS_N2_JOB>
<Pages ID="MasomoRoot" ParentID="masomo">
<Page Expanded="yes" ID="MasomoRoot" Enabled="yes">
<Parameter ID="GlobalProject">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
</Entity>
</Parameter>
<Parameter ID="GlobalOverwrite" state="default">Yes</Parameter>
<Page Expanded="yes" ID="DataMgrFullArray" Enabled="yes">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="FullArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="FullArrayCopy" Enabled="yes">
<ParameterGroup ID="FullArrayInputGroup">
<Parameter ID="ProjectInputSpec">
<Entity name="Project">
<Key name="name" state="changed">Sourcemod</Key>
</Entity>
</Parameter>
<Parameter ID="FullArrayInputSpec">
<Entity name="Project">
<Key name="name" state="default">Sourcemod</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
<ParameterGroup ID="FullArrayOutputGroup">
<Parameter ID="FullArrayOverwriteFlag" state="default">Yes</Parameter>
<Parameter ID="ProjectOutputSpec">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
</Entity>
</Parameter>
<Parameter ID="FullArrayOutputSpec">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
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
<Page Expanded="yes" ID="Masomo_Modelling" Enabled="yes">
<Page Expanded="yes" ID="DropoutSetupCreate" Enabled="yes">
<Parameter ID="Masomo_DropoutArray">
<Entity name="Project">
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="FullArray">
<Key name="name" state="changed">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutReferenceArray">
<Entity name="Project">
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="FullArray">
<Key name="name" state="default">',$arrayname,'</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutOption" state="changed">1 and 2 gun dropouts with sparesub</Parameter>
<Parameter ID="Masomo_DropoutNoCombinations" state="default">1</Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutSetupSpec">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="DropoutSetup">
<Key name="name" state="changed">12drop</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_DropoutModelling" Enabled="yes">
<Parameter ID="Masomo_DropoutSetupInput">
<Entity name="Project">
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="DropoutSetup">
<Key name="name" state="changed">12drop</Key>
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
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
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
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">12drop</Key>
<Key name="type" state="default">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_Analysis" Enabled="yes">
<Page Expanded="yes" ID="Masomo_CompDropoutStatisticsGS" Enabled="yes">
<Parameter ID="Masomo_DropoutInput">
<Entity name="Project">
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">12drop</Key>
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
<Parameter ID="Masomo_DropoutFrequencyOption" state="default">Absolute deviation</Parameter>
<Parameter ID="Masomo_DropoutReferenceText" state="default"></Parameter>
<Parameter ID="Masomo_SeparatorOutput" state="changed"></Parameter>
<Parameter ID="Masomo_DropoutStatisticsOutput">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutColumnDataOption" state="default">No</Parameter>
<Parameter ID="Masomo_Dropout_ColumnData">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="ColumnData">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_Printing" Enabled="yes">
<Page Expanded="yes" ID="Masomo_DropoutStatisticsPrint" Enabled="yes">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop</Key>
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
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">bb_',$arrayname,'_',$temp,'</Key>
<Key name="type" state="default">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_Modelling" Enabled="yes">
<Page Expanded="yes" ID="Masomo_DropoutModelling" Enabled="yes">
<Parameter ID="Masomo_DropoutSetupInput">
<Entity name="Project">
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="DropoutSetup">
<Key name="name" state="changed">12drop</Key>
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
<Key name="name" state="changed">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
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
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">12drop_cc</Key>
<Key name="type" state="default">Dropout Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_Analysis" Enabled="yes">
<Page Expanded="yes" ID="Masomo_CompDropoutStatisticsXC" Enabled="yes">
<Parameter ID="Masomo_DropoutInput">
<Entity name="Project">
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">12drop_cc</Key>
<Key name="type" state="changed">Dropout Signature</Key>
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
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop_cc</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_DropoutColumnDataOption" state="default">No</Parameter>
<Parameter ID="Masomo_Dropout_ColumnData">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="ColumnData">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_Printing" Enabled="yes">
<Page Expanded="yes" ID="Masomo_DropoutStatisticsPrint" Enabled="yes">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop_cc</Key>
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
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">cc_',$arrayname,'_',$temp,'</Key>
<Key name="type" state="changed">Dropout statistics</Key>
</Entity>
</Entity>
</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
</Pages>
');
	    close(OUTPUT);

    sleep(3);
    system("$nucDir/usr/bin/masomo.sh", "mode=test", "projectName=2018_06_MasterMatrix", "jobName=AutoPrintStats");
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
