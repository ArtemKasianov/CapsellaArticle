use strict;


my $CbpCbpPairs = $ARGV[0];
my $outPairsFile = $ARGV[1];


open(FTR,"<$CbpCbpPairs") or die;
open(FTW,">$outPairsFile") or die;


my %pairs1_2 = ();





while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $ident = $arrInp[2];
    
    if (exists $pairs1_2{"$firstId"}) {
	if ($pairs1_2{"$firstId"} ne $secondId) {
	    die("$input\n");
	}
	next;
	
    }
    
    if (exists $pairs1_2{"$secondId"}) {
	if ($pairs1_2{"$secondId"} ne $firstId) {
	    die("$input\n");
	}
	next;
	
    }
    
    
    
    $pairs1_2{"$firstId"} = $secondId;
    
    
    print FTW "$input\n";
    
    
    
    
}

close(FTR);

close(FTW);


