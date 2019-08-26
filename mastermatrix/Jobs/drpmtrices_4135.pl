#!/usr/bin/perl

$nucDir = '/data/Nucleus/release/com/pgs/research/NII';


@arraydepth = (4, 5, 6, 7, 8, 9);
@subarrayseparation = (8, 10);
@temp = (5, 10, 25);
#@arraydepth = (8);
#@subarrayseparation = (8);
#@temp = (5);

@reflcoeff_not = ("-1");
$reflcoeff_ff = 0;
@usenewmodel = ("No");

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

open(OUTPUT, ">AutoDropout".$temp.".Marine\ Source\ Modelling.Null\ Page.J2X") or die("Error creating job file");
print("Created job file: AutoDropout".$temp.".Marine Source Modelling.Null Page.J2X\n"); 
print OUTPUT ('<!DOCTYPE PGS_N2_JOB>
<Pages ID="MasomoRoot" ParentID="masomo">
<Page Expanded="yes" Enabled="yes" ID="MasomoRoot">
<Parameter ID="GlobalProject">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
</Entity>
</Parameter>
<Parameter ID="GlobalOverwrite" state="default">Yes</Parameter>
<Page Expanded="yes" Enabled="yes" ID="DataMgrFullArray">
<Parameter ID="FullArraySpec">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="FullArray">
<Key name="name" state="default">*</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" Enabled="yes" ID="FullArrayCopy">
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
<Page Expanded="yes" Enabled="yes" ID="Masomo_Modelling">
<Page Expanded="yes" Enabled="yes" ID="DropoutSetupCreate">
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
<Page Expanded="yes" Enabled="yes" ID="Masomo_DropoutModelling">
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
<Parameter ID="Masomo_ReflectionCoeffNotionalsDropout" state="changed">',$reflcoeff_not,'</Parameter>
<Parameter ID="Masomo_ReflectionCoeffFarfieldDropout" state="changed">',$reflcoeff_ff,'</Parameter>
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
<Parameter ID="Masomo_UseNewModellingOption" state="changed">',$usenewmodel,'</Parameter>
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
<Page Expanded="yes" Enabled="yes" ID="Masomo_Analysis">
<Page Expanded="yes" Enabled="yes" ID="Masomo_CompDropoutStatisticsGS">
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
<Page Expanded="yes" Enabled="yes" ID="Masomo_Plotting">
<Page Expanded="yes" Enabled="yes" ID="Masomo_DropoutMatrixPlot">
<Parameter ID="Masomo_DropoutStatisticsInput">
<Entity name="Project">
<Key name="name" state="changed">2018_06_MasterMatrix</Key>
<Entity name="DropoutStatistics">
<Key name="name" state="changed">12drop</Key>
</Entity>
</Entity>
</Parameter>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_UnaccDefSetOption" state="default">Spectral specifications</Parameter>
<ParameterGroup ID="Masomo_UnaccPrimaryOption">
<Parameter ID="Masomo_DropoutUnaccPrimaryOption" state="default">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccPrimaryMatch" state="default">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccPrimaryValue" state="default">10</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBchangeOption">
<Parameter ID="Masomo_DropoutUnaccPBchangeOption" state="default">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBchangeMatch" state="default">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBchangeValue" state="default">10</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccCombPrimPBchangeOption">
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeOption" state="default">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeMatch" state="default">Gt</Parameter>
<Parameter ID="Masomo_DropoutUnaccCombPrimPBchangeValue" state="default">15</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccPBvalueOption">
<Parameter ID="Masomo_DropoutUnaccPBvalueOption" state="default">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBvalueMatch" state="default">Le</Parameter>
<Parameter ID="Masomo_DropoutUnaccPBvalueValue" state="default">15</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccXcorrOption">
<Parameter ID="Masomo_DropoutUnaccXcorrOption" state="default">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccXcorrMatch" state="default">Le</Parameter>
<Parameter ID="Masomo_DropoutUnaccXcorrValue" state="default">0.998</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccAvedevOption">
<Parameter ID="Masomo_DropoutUnaccAvedevOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_DropoutUnaccAvedevMatch" state="default">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccAvedevValue" state="default">0.85</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxdevOption">
<Parameter ID="Masomo_DropoutUnaccMaxdevOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxdevMatch" state="default">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxdevValue" state="default">3</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccMaxPhaseDevOption">
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevMatch" state="default">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccMaxPhaseDevValue" state="default">20</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_UnaccVolumeOption">
<Parameter ID="Masomo_DropoutUnaccVolumeOption" state="default">No</Parameter>
<Parameter ID="Masomo_DropoutUnaccVolumeMatch" state="default">Ge</Parameter>
<Parameter ID="Masomo_DropoutUnaccVolumeValue" state="default">10</Parameter>
</ParameterGroup>
<Parameter ID="Masomo_SeparatorEmpty" state="changed"></Parameter>
<Parameter ID="Masomo_PositivePercentage" state="default">No</Parameter>
<Parameter ID="Masomo_UnaccClusterOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_UnaccTwoGunOption" state="default">Yes</Parameter>
<Parameter ID="Masomo_SourceMode" state="default">Dual</Parameter>
</Page>
<Page Expanded="yes" Enabled="yes" ID="ScreenDump">
<Parameter ID="ScreenDumpFormat" state="default">Png</Parameter>
<ParameterGroup ID="ScreenDumpSize">
<Parameter ID="ScreenDumpSizeX" state="default">1200</Parameter>
<Parameter ID="ScreenDumpSizeY" state="default">900</Parameter>
</ParameterGroup>
<Parameter ID="ScreenDumpOrientation" state="changed">No</Parameter>
<ParameterGroup ID="ScreenDumpExternalOutput">
<Parameter ID="ScreenDumpExternalOutputSelector" state="default">ExternalData</Parameter>
<Parameter ID="ScreenDumpExternalOutputData">
<Entity name="Project">
<Key name="name" state="default">2018_06_MasterMatrix</Key>
<Entity name="ExternalData">
<Key name="name" state="changed">',$matrixname,'</Key>
<Key name="type" state="default">Png file</Key>
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
    system("$nucDir/usr/bin/masomo.sh", "mode=test", "projectName=2018_06_MasterMatrix", "jobName=AutoDropout".$temp);
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
