use strict;


my $deabCSVFile = $ARGV[0];
my $pairsFile = $ARGV[1];
my $outDEABFile = $ARGV[2];
my $outNotDEABFile = $ARGV[3];


open(FTW_DEAB,">$outDEABFile") or die;
open(FTW_NOTDEAB,">$outNotDEABFile") or die;





<FTR>;



my %oldPairs = ();
my %deabPairs = ();



open(FTR,"<$deabCSVFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $paralogA = $arrInp[0];
    my $paralogB = $arrInp[1];
    
    $deabPairs{"$paralogA"} = $paralogB;
    
}



close(FTR);




open(FTR,"<$pairsFile") or die;
while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $paralogA = $arrInp[0];
    my $paralogB = $arrInp[1];
    
    if (exists $deabPairs{"$paralogA"}) {
	print FTW_DEAB "$paralogA\t$paralogB\n";
    }
    else
    {
	print FTW_NOTDEAB "$paralogA\t$paralogB\n";
    }
}


close(FTR);


close(FTW_DEAB);
close(FTW_NOTDEAB);



