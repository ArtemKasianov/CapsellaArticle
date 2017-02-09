use strict;


my $pileupFile = $ARGV[0];
my $parentSNPsFile = $ARGV[1];
my $outFile = $ARGV[2];

my %fatherSNPByScaffPos = ();
my %motherSNPByScaffPos = ();

my @scaffPosList = ();


my %pileupIndScaffPos = ();
my %covIndScaffPos = ();




open(FTR,"<$parentSNPsFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $scaffNam = $arrInp[0];
    my $pos = $arrInp[1];
    my $fatherSnp = $arrInp[2];
    my $motherSnp = $arrInp[3];
    
    $fatherSNPByScaffPos{"$scaffNam\t$pos"} = $fatherSnp;
    $motherSNPByScaffPos{"$scaffNam\t$pos"} = $motherSnp;
    
    push @scaffPosList,"$scaffNam\t$pos";
    
}

close(FTR);


open(FTR,"<$pileupFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $scaffNam = $arrInp[0];
    my $pos = $arrInp[1];
    my $cov = $arrInp[3];
    
    my $pileupStr = uc($arrInp[4]);
    
    next if(not exists $fatherSNPByScaffPos{"$scaffNam\t$pos"});
    
    my $isIndel = 0;
    my @currListOfSNPs = ();
    
    for(my $i = 0;$i < length($pileupStr);$i++)
    {
	my $currLetter = substr($pileupStr,$i,1);
	if (($currLetter eq "+") || ($currLetter eq "-")) {
	    $isIndel = 1;
	    last;
	}
	
	if (($currLetter eq "A") || ($currLetter eq "G") || ($currLetter eq "C") || ($currLetter eq "T") ) {
	    push @currListOfSNPs,$currLetter;
	}
    }
    
    next if($isIndel == 1);
    
    my $isFather = 0;
    my $isMother = 0;
    my $covMother = 0;
    my $covFather = 0;
    
    for(my $i = 0;$i <= $#currListOfSNPs;$i++)
    {
	my $currLetter = $currListOfSNPs[$i];
	if ($fatherSNPByScaffPos{"$scaffNam\t$pos"} eq $currLetter) {
	    $isFather = 1;
	    $covFather++;
	}
	
	if ($motherSNPByScaffPos{"$scaffNam\t$pos"} eq $currLetter) {
	    $isMother = 1;
	    $covMother++;
	}
    }
    
    if ($isFather == 1) {
	if ($covFather < 2) {
	    next;
	}
    }
    
    if ($isMother == 1) {
	if ($covMother < 2) {
	    next;
	}
    }
    
    
    if (($isFather == 0) && ($isMother == 0)) {
	next;
    }
    
    $covIndScaffPos{"$scaffNam\t$pos"} = $cov;
    
    if (($isFather == 1) && ($isMother == 1)) {
	$pileupIndScaffPos{"$scaffNam\t$pos"} = 0;
    }
    
    if (($isFather == 1) && ($isMother == 0)) {
	$pileupIndScaffPos{"$scaffNam\t$pos"} = -1;
    }
    
    if (($isFather == 0) && ($isMother == 1)) {
	$pileupIndScaffPos{"$scaffNam\t$pos"} = 1;
    }
}


close(FTR);



open(FTW,">$outFile") or die;

for(my $i = 0;$i <= $#scaffPosList;$i++)
{
    my $currScaffPos = $scaffPosList[$i];
    my $fatherVariant = $fatherSNPByScaffPos{"$currScaffPos"};
    my $motherVariant = $motherSNPByScaffPos{"$currScaffPos"};
    if (not exists $pileupIndScaffPos{"$currScaffPos"}) {
	print FTW "$currScaffPos\t$fatherVariant\t$motherVariant\t\t\t0\t0\n";
	next;
    }
    
    my $cov = $covIndScaffPos{"$currScaffPos"};
    
    my $flag = $pileupIndScaffPos{"$currScaffPos"};
    
   
    
    if ($flag == 0) {
	print FTW "$currScaffPos\t$fatherVariant\t$motherVariant\t\t\t0\t$cov\n";
    }
    else
    {
	if ($flag == 1) {
	    print FTW "$currScaffPos\t$fatherVariant\t$motherVariant\t\t\t1\t$cov\n";
	}
	else
	{
	    if ($flag == -1) {
		print FTW "$currScaffPos\t$fatherVariant\t$fatherVariant\t\t\t-1\t$cov\n";
	    }
	}
    }
    
    
    
}


close(FTW);

