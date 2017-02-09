use strict;

my $ABCrFile = $ARGV[0];
my $outFoursFile = $ARGV[1];


open(FTR,"<$ABCrFile") or die;
open(FTW,">$outFoursFile") or die;


my %idUsed = ();
my %idsNotWrite = ();




while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $thirdId = $arrInp[2];
    
    
    if ((exists $idUsed{"$firstId"}) || (exists $idUsed{"$secondId"}) || (exists $idUsed{"$thirdId"})) {
	$idsNotWrite{"$firstId"} = 1;
	$idsNotWrite{"$secondId"} = 1;
	$idsNotWrite{"$thirdId"} = 1;
    }
    
    
    $idUsed{"$firstId"} = 1;
    $idUsed{"$secondId"} = 1;
    $idUsed{"$thirdId"} = 1;
    
    
}

close(FTR);

open(FTR,"<$ABCrFile") or die;


while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $thirdId = $arrInp[2];
    
    
    if ((not exists $idsNotWrite{"$firstId"}) && (not exists $idsNotWrite{"$secondId"}) && (not exists $idsNotWrite{"$thirdId"})) {
	print FTW "$input\n";
    }
    
}

close(FTR);


close(FTW);


