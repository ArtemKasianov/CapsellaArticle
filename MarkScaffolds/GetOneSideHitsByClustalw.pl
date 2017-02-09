use strict;


my $clustalwFile = $ARGV[0];
my $minIdent = $ARGV[1];
my $outPairsFile = $ARGV[2];



my %align1_2 = ();
my %align2_1 = ();
my %secondUsed = ();

open(FTW_PAIRS,">$outPairsFile") or die;

open(FTR,"<$clustalwFile") or die;


while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $percIdent = $arrInp[2];
    
    next if($firstId eq $secondId);
    
    if (exists $align1_2{"$firstId"}) {
	if (exists $align1_2{"$firstId"}->{"$secondId"}) {
	    if ($align1_2{"$firstId"}->{"$secondId"} != $percIdent) {
		if ($align1_2{"$firstId"}->{"$secondId"} < $percIdent) {
		    $align1_2{"$firstId"}->{"$secondId"} = $percIdent
		}
	    }
	}
	else
	{
	    $align1_2{"$firstId"}->{"$secondId"} = $percIdent;
	}
    }
    else
    {
	my %mapSecond = ();
	$mapSecond{"$secondId"} = $percIdent;
	$align1_2{"$firstId"} = \%mapSecond;
    }
    if (exists $align2_1{"$secondId"}) {
	
	if (exists $align2_1{"$secondId"}->{"$firstId"}) {
	    if ($align2_1{"$secondId"}->{"$firstId"} != $percIdent) {
		if ($align2_1{"$secondId"}->{"$firstId"} < $percIdent) {
		    $align2_1{"$secondId"}->{"$firstId"} = $percIdent
		}
	    }
	}
	else
	{
	    $align2_1{"$secondId"}->{"$firstId"} = $percIdent;
	}
	
    }
    else
    {
	my %mapFirst = ();
	$mapFirst{"$firstId"} = $percIdent;
	$align2_1{"$secondId"} = \%mapFirst;
    }
}

close(FTR);

my @firstIds = keys %align1_2;

my %pairs = ();


for(my $i = 0;$i <= $#firstIds;$i++)
{
    my $currFirstId = $firstIds[$i];
    #print "$currFirstId\n";
    my $ptrMapSecondIds = $align1_2{"$currFirstId"};
    my @arrSecondIds = keys %$ptrMapSecondIds;
    
    my $maxId = "";
    my $maxVal = -1;
    
    for(my $j = 0;$j<=$#arrSecondIds;$j++)
    {
	my $currSecondId = $arrSecondIds[$j];
	my $currPercIdent = $align1_2{"$currFirstId"}->{"$currSecondId"};
	if ($currPercIdent>$maxVal) {
	    $maxVal = $currPercIdent;
	    $maxId = $currSecondId;
	}
    }
    my $maxSecondId = "";
    
    if ($maxVal > $minIdent) {
	$maxSecondId = $maxId;
    }
    next if($maxSecondId eq "");
    print FTW_PAIRS "$currFirstId\t$maxSecondId\t$maxVal\n";
    
}

close(FTW_PAIRS);

