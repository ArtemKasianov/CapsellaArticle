use strict;

my $ABCrCoAthFile = $ARGV[0];
my $outFivesFile = $ARGV[1];


open(FTR,"<$ABCrCoAthFile") or die;
open(FTW,">$outFivesFile") or die;


my %idUsed = ();
my %idsNotWrite = ();




while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $thirdId = $arrInp[2];
    my $fourId = $arrInp[3];
    my $fiveId = $arrInp[4];
    
    
    if ((exists $idUsed{"$firstId"}) || (exists $idUsed{"$secondId"}) || (exists $idUsed{"$thirdId"}) || (exists $idUsed{"$fourId"}) || (exists $idUsed{"$fiveId"})) {
	$idsNotWrite{"$firstId"} = 1;
	$idsNotWrite{"$secondId"} = 1;
	$idsNotWrite{"$thirdId"} = 1;
	$idsNotWrite{"$fourId"} = 1;
	$idsNotWrite{"$fiveId"} = 1;
    }
    
    
    $idUsed{"$firstId"} = 1;
    $idUsed{"$secondId"} = 1;
    $idUsed{"$thirdId"} = 1;
    $idUsed{"$fourId"} = 1;
    $idUsed{"$fiveId"} = 1;
    
    
}

close(FTR);

open(FTR,"<$ABCrCoAthFile") or die;


while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $thirdId = $arrInp[2];
    my $fourId = $arrInp[3];
    my $fiveId = $arrInp[4];
    
    
    if ((not exists $idsNotWrite{"$firstId"}) && (not exists $idsNotWrite{"$secondId"}) && (not exists $idsNotWrite{"$thirdId"}) && (not exists $idsNotWrite{"$fourId"}) && (not exists $idsNotWrite{"$fiveId"})) {
	print FTW "$input\n";
    }
    
}

close(FTR);


close(FTW);


