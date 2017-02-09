use strict;

my $ABFile = $ARGV[0];
my $outPairsFile = $ARGV[1];


open(FTR,"<$ABFile") or die;
open(FTW,">$outPairsFile") or die;


my %idUsed = ();
my %idsNotWrite = ();




while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $ident = $arrInp[2];
    
    if ((exists $idUsed{"$firstId"}) || (exists $idUsed{"$secondId"})) {
	$idsNotWrite{"$firstId"} = 1;
	$idsNotWrite{"$secondId"} = 1;
    }
    
    
    $idUsed{"$firstId"} = 1;
    $idUsed{"$secondId"} = 1;
    
    
}

close(FTR);

open(FTR,"<$ABFile") or die;


while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $ident = $arrInp[2];
    
    if ((not exists $idsNotWrite{"$firstId"}) && (not exists $idsNotWrite{"$secondId"})) {
	print FTW "$input\n";
    }
    
}

close(FTR);


close(FTW);


