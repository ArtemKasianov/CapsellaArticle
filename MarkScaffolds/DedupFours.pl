use strict;

my $ABCrCoFile = $ARGV[0];
my $outFoursFile = $ARGV[1];


open(FTR,"<$ABCrCoFile") or die;
open(FTW,">$outFoursFile") or die;


my %idUsed = ();
my %idsNotWrite = ();




while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $thirdId = $arrInp[2];
    my $fourId = $arrInp[3];
    
    
    if ((exists $idUsed{"$firstId"}) || (exists $idUsed{"$secondId"}) || (exists $idUsed{"$thirdId"}) || (exists $idUsed{"$fourId"})) {
	$idsNotWrite{"$firstId"} = 1;
	$idsNotWrite{"$secondId"} = 1;
	$idsNotWrite{"$thirdId"} = 1;
	$idsNotWrite{"$fourId"} = 1;
    }
    
    
    $idUsed{"$firstId"} = 1;
    $idUsed{"$secondId"} = 1;
    $idUsed{"$thirdId"} = 1;
    $idUsed{"$fourId"} = 1;
    
    
}

close(FTR);

open(FTR,"<$ABCrCoFile") or die;


while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $thirdId = $arrInp[2];
    my $fourId = $arrInp[3];
    
    
    if ((not exists $idsNotWrite{"$firstId"}) && (not exists $idsNotWrite{"$secondId"}) && (not exists $idsNotWrite{"$thirdId"}) && (not exists $idsNotWrite{"$fourId"})) {
	print FTW "$input\n";
    }
    
}

close(FTR);


close(FTW);


