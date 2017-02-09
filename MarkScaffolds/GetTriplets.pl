use strict;


my $CbpCbpFile = $ARGV[0];
my $CbpCrFile = $ARGV[1];
my $tripletsFile = $ARGV[2];



my %cbpcbpPairs = ();
my %cbpcrPairs = ();

open(FTW,">$tripletsFile") or die;

open(FTR,"<$CbpCbpFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbp1Nam = $arrInp[0];
    my $cbp2Nam = $arrInp[1];
    
    $cbpcbpPairs{"$cbp1Nam"}=$cbp2Nam;
    
    
}

close(FTR);

open(FTR,"<$CbpCrFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpNam = $arrInp[0];
    my $crNam = $arrInp[1];
    
    $cbpcrPairs{"$cbpNam"}=$crNam;
    
    
}

close(FTR);


my @arrCbp = keys %cbpcbpPairs;


for(my $i = 0;$i <= $#arrCbp;$i++)
{
    my $cbp1 = $arrCbp[$i];
    my $cbp2 = $cbpcbpPairs{"$cbp1"};
    
    if (not exists $cbpcrPairs{"$cbp1"}) {
	next;
    }
    
    if (not exists $cbpcrPairs{"$cbp2"}) {
	next;
    }
    
    
    my $cr1 = $cbpcrPairs{"$cbp1"};
    my $cr2 = $cbpcrPairs{"$cbp2"};
    
    if ($cr1 ne $cr2) {
	next;
    }
    
    print FTW "$cbp1\t$cbp2\t$cr1\n";
    
}

close(FTW);
