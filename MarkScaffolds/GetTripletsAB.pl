use strict;


my $CbpACbpBFile = $ARGV[0];
my $CbpACrFile = $ARGV[1];
my $CbpBCrFile = $ARGV[2];
my $tripletsFile = $ARGV[3];



my %cbpAcbpBPairs = ();
my %cbpAcrPairs = ();
my %cbpBcrPairs = ();

open(FTW,">$tripletsFile") or die;

open(FTR,"<$CbpACbpBFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpANam = $arrInp[0];
    my $cbpBNam = $arrInp[1];
    
    $cbpAcbpBPairs{"$cbpANam"}=$cbpBNam;
    
    
}

close(FTR);

open(FTR,"<$CbpACrFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpANam = $arrInp[0];
    my $crNam = $arrInp[1];
    
    $cbpAcrPairs{"$cbpANam"}=$crNam;
    
    
}

close(FTR);


open(FTR,"<$CbpBCrFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpBNam = $arrInp[0];
    my $crNam = $arrInp[1];
    
    $cbpBcrPairs{"$cbpBNam"}=$crNam;
    
    
}

close(FTR);



my @arrCbpA = keys %cbpAcbpBPairs;


for(my $i = 0;$i <= $#arrCbpA;$i++)
{
    my $cbpA = $arrCbpA[$i];
    my $cbpB = $cbpAcbpBPairs{"$cbpA"};
    
    if (not exists $cbpAcrPairs{"$cbpA"}) {
	next;
    }
    
    if (not exists $cbpBcrPairs{"$cbpB"}) {
	next;
    }
    
    
    my $crA = $cbpAcrPairs{"$cbpA"};
    my $crB = $cbpBcrPairs{"$cbpB"};
    
    if ($crA ne $crB) {
	next;
    }
    
    print FTW "$cbpA\t$cbpB\t$crA\n";
    
}

close(FTW);
