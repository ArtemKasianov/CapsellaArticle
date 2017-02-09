use strict;



my $quadsFile = $ARGV[0];
my $listFile = $ARGV[1];
my $pairsCrCoFiles = $ARGV[2];


my %genesList = ();


open(FTR,"<$listFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $cbpA =  $arrInp[1];
    my $cbpB =  $arrInp[0];
    my $cr =  $arrInp[2];
    my $co =  $arrInp[3];
    
    $genesList{"$cbpA"} = $cbpB;
    
    
}




close(FTR);




open(FTW,">$pairsCrCoFiles") or die;




open(FTR,"<$quadsFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $aNam = $arrInp[0];
    
    my $bNam = $arrInp[1];
    
    next if(not exists $genesList{"$aNam"});
    
    
    my $crNam = $arrInp[2];
    my $coNam = $arrInp[3];
    
    
    print FTW "$crNam\t$coNam\n";
    
}




close(FTR);
close(FTW);
