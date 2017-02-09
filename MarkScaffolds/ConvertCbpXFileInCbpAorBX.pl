use strict;

my $cbpXFile = $ARGV[0];
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


open(FTR,"<$cbpXFile") or die;


while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $cbpNam = $arrInp[0];
    my $xNam = $arrInp[1];
    my $ident = $arrInp[2];
    
    
    
    if (exists $genesList{"$cbpNam"}) {
	
	print FTW "$cbpNam\t$xNam\t$ident\n";
    }
}


close(FTR);


close(FTW);