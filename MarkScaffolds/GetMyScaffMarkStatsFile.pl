use strict;


my $lisaScaffMarkStats = $ARGV[0];
my $geneOrderFile = $ARGV[1];
my $outFile = $ARGV[2];

open(FTW,">$outFile") or die;
my %scaffGeneCount = ();
open(FTR,"<$geneOrderFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $scaffNam = $arrInp[0];
    if (exists $scaffGeneCount{"$scaffNam"}) {
	$scaffGeneCount{"$scaffNam"} += 1;
    }
    else
    {
	$scaffGeneCount{"$scaffNam"} = 1;
    }
    
    
    
}


close(FTR);


open(FTR,"<$lisaScaffMarkStats") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $scaffNam = $arrInp[0];
    
    my $aCount = $arrInp[1];
    my $bCount = $arrInp[2];
    my $allCount = -1;
    
    die if (not exists $scaffGeneCount{"$scaffNam"});
    
    $allCount = $scaffGeneCount{"$scaffNam"};
    
    print FTW "$scaffNam\t$allCount\t$aCount\t$bCount\n";
}



close(FTR);
close(FTW);

