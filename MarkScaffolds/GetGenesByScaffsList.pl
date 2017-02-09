use strict;


my $cdsFile = $ARGV[0];
my $orderFile = $ARGV[1];
my $listFile = $ARGV[2];
my $outFile = $ARGV[3];


open(FTW,">$outFile") or die;

my %scaffsList = ();
my %genesList = ();

open(FTR,"<$listFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    $scaffsList{"$input"} = 1;
}

close(FTR);


open(FTR,"<$orderFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $scaffNam = $arrInp[0];
    my $gNam = $arrInp[1];
    
    if (exists $scaffsList{"$scaffNam"}) {
	$genesList{"$gNam"} = 1;
    }
}

close(FTR);






open(FTR,"<$cdsFile") or die;

my $toPrint = 0;
while (my $input = <FTR>) {
    chomp($input);
    if (substr($input,0,1) eq ">") {
	my $gNam = substr($input,1,length($input) - 1);
	if (exists $genesList{"$gNam"}) {
	    print FTW "$input\n";
	    $toPrint = 1;
	}
	else
	{
	    $toPrint = 0;
	}
	
    }
    else
    {
	if ($toPrint == 1) {
	    print FTW "$input\n";
	}
    }
    
}



close(FTR);
close(FTW);