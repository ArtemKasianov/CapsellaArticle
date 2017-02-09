use strict;


my $CbpCbpCrCoFile = $ARGV[0];
my $CbpAthFile = $ARGV[1];
my $CrAthFile = $ARGV[2];
my $CoAthFile = $ARGV[3];
my $fivesFile = $ARGV[4];



my %cbpathPairs = ();
my %crathPairs = ();
my %coathPairs = ();

open(FTW,">$fivesFile") or die;

open(FTR,"<$CbpAthFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpNam = $arrInp[0];
    my $athNam = $arrInp[1];
    
    $cbpathPairs{"$cbpNam"}=$athNam;
    
    
}

close(FTR);

open(FTR,"<$CrAthFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $crNam = $arrInp[0];
    my $athNam = $arrInp[1];
    
    $crathPairs{"$crNam"}=$athNam;
    
    
}

close(FTR);

open(FTR,"<$CoAthFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $coNam = $arrInp[0];
    my $athNam = $arrInp[1];
    
    $coathPairs{"$coNam"}=$athNam;
    
    
}

close(FTR);





open(FTR,"<$CbpCbpCrCoFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    my $cbp1 = $arrInp[0];
    my $cbp2 = $arrInp[1];
    my $cr = $arrInp[2];
    my $co = $arrInp[3];
    
    next if(not exists $cbpathPairs{"$cbp1"});
    next if(not exists $cbpathPairs{"$cbp2"});
    next if(not exists $crathPairs{"$cr"});
    next if(not exists $coathPairs{"$co"});
    
    my $ath1 = $cbpathPairs{"$cbp1"};
    my $ath2 = $cbpathPairs{"$cbp2"};
    my $ath3 = $crathPairs{"$cr"};
    my $ath4 = $coathPairs{"$co"};
    
    if (($ath1 eq $ath2) && ($ath2 eq $ath3) && ($ath3 eq $ath1) && ($ath1 eq $ath4) && ($ath4 eq $ath3) && ($ath4 eq $ath2)) {
	print FTW "$cbp1\t$cbp2\t$cr\t$co\t$ath1\n";
    }
}


close(FTR);

close(FTW);
