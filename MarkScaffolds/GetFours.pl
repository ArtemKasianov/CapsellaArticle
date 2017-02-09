use strict;


my $CbpCbpCrFile = $ARGV[0];
my $CbpCoFile = $ARGV[1];
my $CoCrFile = $ARGV[2];
my $foursFile = $ARGV[3];



my %cbpcbpPairs = ();
my %cbpcoPairs = ();
my %crcoPairs = ();

open(FTW,">$foursFile") or die;

open(FTR,"<$CbpCoFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpNam = $arrInp[0];
    my $coNam = $arrInp[1];
    
    $cbpcoPairs{"$cbpNam"}=$coNam;
    
    
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



open(FTR,"<$CbpCbpCrFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    my $cbp1 = $arrInp[0];
    my $cbp2 = $arrInp[1];
    my $cr = $arrInp[2];
    
    next if(not exists $cbpcoPairs{"$cbp1"});
    next if(not exists $cbpcoPairs{"$cbp2"});
    next if(not exists $crcoPairs{"$cr"});
    
    my $co1 = $cbpcoPairs{"$cbp1"};
    my $co2 = $cbpcoPairs{"$cbp2"};
    my $co3 = $crcoPairs{"$cr"};
    print "$co1\t$co2\t$co3\n";
    if (($co1 eq $co2) && ($co2 eq $co3) && ($co3 eq $co1)) {
	print FTW "$cbp1\t$cbp2\t$cr\t$co1\n";
    }
}


close(FTR);

close(FTW);
