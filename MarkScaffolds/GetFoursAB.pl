use strict;


my $CbpACbpBCrFile = $ARGV[0];
my $CbpACoFile = $ARGV[1];
my $CbpBCoFile = $ARGV[2];
my $CoCrFile = $ARGV[3];
my $foursFile = $ARGV[4];



my %cbpAcbpBPairs = ();
my %cbpAcoPairs = ();
my %cbpBcoPairs = ();
my %crcoPairs = ();

open(FTW,">$foursFile") or die;

open(FTR,"<$CbpACoFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpANam = $arrInp[0];
    my $coNam = $arrInp[1];
    
    $cbpAcoPairs{"$cbpANam"}=$coNam;
    
    
}

close(FTR);


open(FTR,"<$CbpBCoFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpBNam = $arrInp[0];
    my $coNam = $arrInp[1];
    
    $cbpBcoPairs{"$cbpBNam"}=$coNam;
    
    
}

close(FTR);


open(FTR,"<$CoCrFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $coNam = $arrInp[0];
    my $crNam = $arrInp[1];
    
    $crcoPairs{"$crNam"}=$coNam;
    
    
}

close(FTR);



open(FTR,"<$CbpACbpBCrFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    my $cbpA = $arrInp[0];
    my $cbpB = $arrInp[1];
    my $cr = $arrInp[2];
    
    next if(not exists $cbpAcoPairs{"$cbpA"});
    next if(not exists $cbpBcoPairs{"$cbpB"});
    next if(not exists $crcoPairs{"$cr"});
    
    my $coA = $cbpAcoPairs{"$cbpA"};
    my $coB = $cbpBcoPairs{"$cbpB"};
    my $coCr = $crcoPairs{"$cr"};
    print "$coA\t$coB\t$coCr\n";
    if (($coA eq $coB) && ($coA eq $coCr) && ($coCr eq $coB)) {
	print FTW "$cbpA\t$cbpB\t$cr\t$coA\n";
    }
}


close(FTR);

close(FTW);
