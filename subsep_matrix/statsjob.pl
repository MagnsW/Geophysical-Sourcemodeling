#!/usr/bin/perl

$nucDir = '/data/Nucleus/release/com/pgs/research/NII';

@subarrayseparation12 = (4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12);
#@subarrayseparation12 = (5);
@subarrayseparation23 = (4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12);

$arraydepth = 3.5;
$depth3digits = sprintf("%03d", $arraydepth*10);
foreach $sep12 (@subarrayseparation12){
       foreach $sep23 (@subarrayseparation23){
	   $arrayname = "3150T__".($depth3digits)."_2000_".sprintf("%03d",$sep12*10)."_".sprintf("%03d",$sep23*10);	   
	   $filename = $arrayname.".G2X";
	   print("arrayname: ", $arrayname, "\n");
       }


open(OUTPUT, ">AutoPrintStats.Marine\ Source\ Modelling.Null\ Page.J2X") or die("Error creating job file");
print("Created job file: AutoPrintStats.Marine Source Modelling.Null Page.J2X\n"); 
print OUTPUT ('<!DOCTYPE PGS_N2_JOB>
<Pages ID="MasomoRoot" ParentID="masomo">
<Page Expanded="yes" ID="MasomoRoot" Enabled="yes">
<Parameter ID="GlobalProject">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
</Entity>
</Parameter>
<Parameter state="default" ID="GlobalOverwrite">Yes</Parameter>
<Page Expanded="yes" ID="Masomo_Modelling" Enabled="yes">
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_040</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_040</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_045</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_045</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_050</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_050</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_055</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_055</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_060</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_060</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_065</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_065</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_070</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_070</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_075</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_075</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_080</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_080</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_085</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_085</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_090</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_090</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_095</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_095</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_100</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_100</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_105</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_105</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_110</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_110</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_115</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_115</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_NotionalModelling" Enabled="yes">
<Parameter ID="Masomo_FullArraySpec">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="FullArray">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_120</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="changed" ID="Masomo_SignatureLength">400</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffNotionals">-1</Parameter>
<Parameter state="changed" ID="Masomo_SeaTemperature">25</Parameter>
<Parameter state="changed" ID="Masomo_SeaVelocity">1534.6</Parameter>
<Parameter state="default" ID="Masomo_UseNewModellingOption">No</Parameter>
<Parameter state="default" ID="Masomo_AntiAliasFilter">No</Parameter>
<Parameter state="changed" ID="Masomo_FilterOptionNotional">No</Parameter>
<Parameter ID="Masomo_InstrumentFilterNotional">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="default">*</Key>
<Key name="type" state="default">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter ID="Masomo_NotionalOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_120</Key>
<Key name="type" state="default">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_040</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_040</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_045</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_045</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_050</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_050</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_055</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_055</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_060</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_060</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_065</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_065</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_070</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_070</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_075</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_075</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_080</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_080</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_085</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_085</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_090</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_090</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_095</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_095</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_100</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_100</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_105</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_105</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_110</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_110</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_115</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_115</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_FarfieldModelling" Enabled="yes">
<Parameter ID="Masomo_NotionalInput">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_120</Key>
<Key name="type" state="changed">Notional Source Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorEmpty"></Parameter>
<Parameter state="default" ID="Masomo_SampleIntervalFF">0.5</Parameter>
<Parameter state="default" ID="Masomo_ReflectionCoeffFarfield">-1</Parameter>
<Parameter state="default" ID="Masomo_FilterOptionFarfield">Yes</Parameter>
<Parameter ID="Masomo_InstrumentFilterFarfield">
<Entity name="Project">
<Key name="name" state="default">Default</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">GeoStr LChyd_3/7-214/341</Key>
<Key name="type" state="changed">Instrument Filter</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_GeometricalSpreading">2</Parameter>
<Parameter state="default" ID="Masomo_TimeZeroRef">Closest gun</Parameter>
<Parameter state="default" ID="Masomo_SpecificationSystem">Individual positions</Parameter>
<Parameter state="default" ID="Masomo_CoordinateSystem">Spherical</Parameter>
<Parameter state="default" ID="Masomo_NoFarfieldPositions">1</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorGeosource"></Parameter>
<Parameter state="default" ID="Masomo_DeghostingOption">No</Parameter>
<Parameter state="default" ID="Masomo_ModelFarfields4EachSubsource">No</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorCorrelate"></Parameter>
<Parameter state="default" ID="Masomo_CorrelateFarfield">None</Parameter>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<Parameter state="default" ID="Masomo_PressureOutputScale">Bar-m</Parameter>
<Parameter ID="Masomo_FarfieldOutput">
<Entity name="Project">
<Key name="name" state="default">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="default">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_120</Key>
<Key name="type" state="default">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Page Expanded="yes" ID="Masomo_Farfield_Ind_Polar" Enabled="yes">
<ParameterGroup ID="Masomo_Farfield_IP_coordinates">
<Parameter state="default" ID="FarfieldPositionNumber">1</Parameter>
<Parameter state="default" ID="FarfieldPositionAngDip">0</Parameter>
<Parameter state="default" ID="FarfieldPositionAngAzi">0</Parameter>
<Parameter state="default" ID="FarfieldPositionDistance">9000</Parameter>
</ParameterGroup>
</Page>
</Page>
</Page>
<Page Expanded="yes" ID="Masomo_Analysis" Enabled="yes">
<Page Expanded="yes" ID="Masomo_FarfieldComparison" Enabled="yes">
<Parameter state="changed" ID="Masomo_FC_numberOfComparison">18</Parameter>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition1">
<Parameter ID="Masomo_ComparisonFarfieldInput1">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_080</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature1">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_040</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_045</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_050</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_055</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_060</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_065</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_070</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_075</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_080</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_085</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_090</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_095</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_100</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_105</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_110</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_115</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_FarfieldDefinition2">
<Parameter ID="Masomo_ComparisonFarfieldInput2">
<Entity name="Project">
<Key name="name" state="changed">2019_04_Kizomba_SepMat</Key>
<Entity name="Wavelet">
<Key name="name" state="changed">3150T__035_2000_'.sprintf("%03d",$sep12*10).'_120</Key>
<Key name="type" state="changed">Farfield Signature</Key>
</Entity>
</Entity>
</Parameter>
<Parameter state="default" ID="Masomo_ComparisonFarfieldInputSignature2">1 - dist: 9000.00 vert: 0.00 az: 0.00</Parameter>
</ParameterGroup>
<Parameter state="changed" ID="Masomo_SeparatorOutput"></Parameter>
<ParameterGroup ID="Masomo_ExternalPrintOutput">
<Parameter state="changed" ID="Masomo_ExternalPrintOutputSelector">File</Parameter>
<Parameter state="changed" ID="Masomo_ExternalPrintOutputFile">/research/sourcemod/NIIProjects/2019_04_Kizomba_SepMat/ExternalData/comp-sep12-'.sprintf("%03d",$sep12*10).'.txt</Parameter>
</ParameterGroup>
<Page Expanded="yes" ID="Masomo_FC_Parameters" Enabled="yes">
<Parameter state="default" ID="Masomo_ComputePrimaryOption">Yes</Parameter>
<ParameterGroup ID="Masomo_FC_timeWindow">
<Parameter state="default" ID="Masomo_FC_TWStart">-68.5</Parameter>
<Parameter state="default" ID="Masomo_FC_TWEnd">331.5</Parameter>
</ParameterGroup>
<ParameterGroup ID="Masomo_FC_Primary">
<Parameter state="default" ID="Masomo_FC_PrimaryStart">-68.5</Parameter>
<Parameter state="default" ID="Masomo_FC_PrimaryEnd">30</Parameter>
</ParameterGroup>
<Parameter state="default" ID="Masomo_FC_BubbleMode">Manual</Parameter>
<ParameterGroup ID="Masomo_FC_Bubble">
<Parameter state="default" ID="Masomo_FC_BubbleStart">50</Parameter>
<Parameter state="default" ID="Masomo_FC_BubbleEnd">200</Parameter>
</ParameterGroup>
<Parameter state="default" ID="Masomo_FrequencyAnalysisOption">Average absolute deviation</Parameter>
<ParameterGroup ID="Masomo_FC_Bandwidth">
<Parameter state="default" ID="FC_BandwidthStart">10</Parameter>
<Parameter state="default" ID="FC_BandwidthEnd">70</Parameter>
</ParameterGroup>
<Parameter state="default" ID="Masomo_FC_OptShift">No</Parameter>
</Page>
</Page>
</Page>
</Page>
</Pages>
');


close(OUTPUT);

sleep(3);
system("$nucDir/usr/bin/masomo.sh", "mode=test", "projectName=2019_04_Kizomba_SepMat", "jobName=AutoPrintStats");
if ( $? == -1 )
{
    print "Automatic loading and/or execution of the Dropout job failed: $!\n";
}
else
{
    system("cat", "masomo.log");
}


}


