use strict;


my $CbpACbpBCrCoFile = $ARGV[0];
my $CbpAAthFile = $ARGV[1];
my $CbpBAthFile = $ARGV[2];
my $CrAthFile = $ARGV[3];
my $CoAthFile = $ARGV[4];
my $fivesFile = $ARGV[5];



my %cbpAathPairs = ();
my %cbpBathPairs = ();
my %crathPairs = ();
my %coathPairs = ();

open(FTW,">$fivesFile") or die;

open(FTR,"<$CbpAAthFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpANam = $arrInp[0];
    my $athNam = $arrInp[1];
    
    $cbpAathPairs{"$cbpANam"}=$athNam;
    
    
}

close(FTR);

open(FTR,"<$CbpBAthFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $cbpBNam = $arrInp[0];
    my $athNam = $arrInp[1];
    
    $cbpBathPairs{"$cbpBNam"}=$athNam;
    
    
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





open(FTR,"<$CbpACbpBCrCoFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    my $cbpA = $arrInp[0];
    my $cbpB = $arrInp[1];
    my $cr = $arrInp[2];
    my $co = $arrInp[3];
    
    next if(not exists $cbpAathPairs{"$cbpA"});
    next if(not exists $cbpBathPairs{"$cbpB"});
    next if(not exists $crathPairs{"$cr"});
    next if(not exists $coathPairs{"$co"});
    
    my $athA = $cbpAathPairs{"$cbpA"};
    my $athB = $cbpBathPairs{"$cbpB"};
    my $athCr = $crathPairs{"$cr"};
    my $athCo = $coathPairs{"$co"};
    
    if (($athA eq $athB) && ($athB eq $athCr) && ($athCr eq $athA) && ($athA eq $athCo) && ($athCo eq $athCr) && ($athCo eq $athB)) {
	print FTW "$cbpA\t$cbpB\t$cr\t$co\t$athA\n";
    }
}


close(FTR);

close(FTW);
