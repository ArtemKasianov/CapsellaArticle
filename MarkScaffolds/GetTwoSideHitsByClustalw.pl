use strict;

my $clustalwFile = $ARGV[0];
my $minIdent = $ARGV[1];
my $outPairsFile = $ARGV[2];
my $outSinglets1File = $ARGV[3];
my $outSinglets1NoHitFile = $ARGV[4];
my $outSinglets2File = $ARGV[5];
my $outSinglets2NoHitFile = $ARGV[6];


my %align1_2 = ();
my %align2_1 = ();
my %secondUsed = ();

open(FTW_PAIRS,">$outPairsFile") or die;
open(FTW_SINGLETS_1,">$outSinglets1File") or die;
open(FTW_SINGLETS_NOHIT_1,">$outSinglets1NoHitFile") or die;
open(FTW_SINGLETS_2,">$outSinglets2File") or die;
open(FTW_SINGLETS_NOHIT_2,">$outSinglets2NoHitFile") or die;

open(FTR,"<$clustalwFile") or die;


while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $firstId = $arrInp[0];
    my $secondId = $arrInp[1];
    my $percIdent = $arrInp[2];
    
    next if($firstId eq $secondId);
    
    if (exists $align1_2{"$firstId"}) {
	$align1_2{"$firstId"}->{"$secondId"} = $percIdent;
    }
    else
    {
	my %mapSecond = ();
	$mapSecond{"$secondId"} = $percIdent;
	$align1_2{"$firstId"} = \%mapSecond;
    }
    if (exists $align2_1{"$secondId"}) {
	$align2_1{"$secondId"}->{"$firstId"} = $percIdent;
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

for(my $i = 0;$i <= $#firstIds;$i++)
{
    my $currFirstId = $firstIds[$i];
    print "$currFirstId\n";
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
    else
    {
	print FTW_SINGLETS_NOHIT_1 "$currFirstId\n";
	next;
    }
    
    
    
    
    
    my $ptrMapFirstIds = $align2_1{"$maxSecondId"};
    my @arrFirstIds = keys %$ptrMapFirstIds;
    
    my $maxId = "";
    my $maxVal = -1;
    
    for(my $j = 0;$j<=$#arrFirstIds;$j++)
    {
	my $currFirstId = $arrFirstIds[$j];
	my $currPercIdent = $align2_1{"$maxSecondId"}->{"$currFirstId"};
	if ($currPercIdent>$maxVal) {
	    $maxVal = $currPercIdent;
	    $maxId = $currFirstId;
	}
    }
    
    
    my $maxFirstId = "";
    if ($maxVal > $minIdent) {
	$maxFirstId = $maxId;
    }
    else
    {
	print FTW_SINGLETS_NOHIT_2 "$maxSecondId\n";
	$secondUsed{"$maxSecondId"} = 1;
	print FTW_SINGLETS_1 "$currFirstId\n";
	next;
	
    }
    
    if ($maxFirstId eq $currFirstId) {
	print FTW_PAIRS "$currFirstId\t$maxSecondId\t$maxVal\n";
	$secondUsed{"$maxSecondId"} = 1;
    }
    else
    {
	print FTW_SINGLETS_1 "$currFirstId\n";
    }
}

my @secondIds = keys %align2_1;

for(my $i = 0;$i <= $#secondIds;$i++)
{
    my $currSecondId = $secondIds[$i];
    if (not exists $secondUsed{"$currSecondId"}) {
	my $ptrMapFirsts = $align2_1{"$currSecondId"};
	my @arrFirstsList = keys %$ptrMapFirsts;
	my $maxId = "";
	my $maxVal = -1;
	for(my $j = 0;$j <= $#arrFirstsList;$j++)
	{
	    my $currFirstId = $arrFirstsList[$j];
	    my $percIdent = $align2_1{"$currSecondId"}->{"$currFirstId"};
	    if ($percIdent > $maxVal) {
		$maxVal = $percIdent;
	    }
	}
	
	if ($maxVal > $minIdent) {
	    print FTW_SINGLETS_2 "$currSecondId\n";
	}
	else
	{
	    print FTW_SINGLETS_NOHIT_2 "$currSecondId\n";
	}
	
    }
    
}

close(FTW_PAIRS);
close(FTW_SINGLETS_1);
close(FTW_SINGLETS_NOHIT_1);
close(FTW_SINGLETS_2);
close(FTW_SINGLETS_NOHIT_2);

