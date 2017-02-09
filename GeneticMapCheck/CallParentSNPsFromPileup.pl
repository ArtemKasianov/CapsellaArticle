use strict;


my $pileupFile = $ARGV[0];
my $outFile = $ARGV[1];


open(FTW,">$outFile") or die;
open(FTR,"<$pileupFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $scaffNam = $arrInp[0];
    my $pos = $arrInp[1];
    
    my $refVal = uc($arrInp[2]);
    
    next if($refVal eq "N");
    
    my $cov = $arrInp[3];
    
    next if($cov < 4);
    
    my $rValStr = uc($arrInp[4]);
    
    
    $rValStr = uc($rValStr);
    
    my $isIndel = 0;
    my $countRefs = 0;
    
    my %altValues = ();
    for(my $i = 0; $i < length($rValStr);$i++)
    {
	my $currVal = substr($rValStr,$i,1);
	
	if(($currVal eq "+") || ($currVal eq "-"))
	{
	    $isIndel = 1;
	    last;
	}
	
	if (($currVal eq ".") || ($currVal eq ",")) {
	    $countRefs++;
	}
	
	
	next if(($currVal ne "A") && ($currVal ne "G") && ($currVal ne "C") && ($currVal ne "T"));
	
	$altValues{"$currVal"} = 1;
    }
    
    my @arrVals = keys %altValues;
    
    my $countAlts = $#arrVals+1;
    
    next if (($countRefs > 0) || ($countAlts > 1) || ($countAlts == 0));
    
    my $currAlt = $arrVals[0];
    
    print FTW "$scaffNam\t$pos\t$refVal\t$currAlt\n";
    
    
}


close(FTR);
close(FTW);
