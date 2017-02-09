use strict;

my $variantsFile = $ARGV[0];
my $outVariantsFile = $ARGV[1];

open(FTW,">$outVariantsFile") or die;
open(FTR,"<$variantsFile") or die;

my %scaffPosHomoFlags = ();
my %scaffPosStr = ();

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $scaffNam = $arrInp[0];
    my $pos = int($arrInp[1]);
    my $homoFlag = $arrInp[6];
    my $cov = int($arrInp[7]);
    if ($cov == 0) {
	$homoFlag = "-";
    }
    
    
    if (exists $scaffPosHomoFlags{"$scaffNam"}) {
	
	$scaffPosHomoFlags{"$scaffNam"}->{$pos} = $homoFlag;
	$scaffPosStr{"$scaffNam"}->{$pos} = $input;
	
    }
    else
    {
	my %posHash = ();
	my %posHashStr = ();
	$posHash{$pos} = $homoFlag;
	$posHashStr{$pos} = $input;
	$scaffPosHomoFlags{"$scaffNam"} = \%posHash;
	$scaffPosStr{"$scaffNam"} = \%posHashStr;
    }
}

close(FTR);


my @scaffNamArr = keys %scaffPosHomoFlags;

my $countSingleZeroesPlus = 0;
my $countSingleZeroesMinus = 0;
for(my $i = 0;$i <= $#scaffNamArr;$i++)
{
    my $currScaffNam = $scaffNamArr[$i];
    
    my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
    my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
    for(my $j = 0;$j <= $#arrPos;$j++)
    {
	
	my $currPos = $arrPos[$j];
	my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	
	my $startPlus1 = 0;
	my $startMinus1 = 0;
	my $zeroCount = 0;
	my $endPlus1 = 0;
	my $endMinus1 = 0;
	my $endZeroIndex = $j;
	my $isStartReach = 1;
	my $isEndReach = 1;
	if ($currHomoFlags eq "0") {
	    
	    
	    
	    for(my $m = $j - 1; $m >= 0;$m--)
	    {
		my $prevPos = $arrPos[$m];
		my $prevHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$prevPos};
		
		next if($prevHomoFlags eq "-");
		
		if ($prevHomoFlags eq "1") {
		    if ($startMinus1 > 0) {
			$isStartReach = 0;
			last;
		    }
		    if ($startPlus1 > 4) {
			$isStartReach = 0;
			last;
		    }
		    $startPlus1++;
		}
		else
		{
		    if ($prevHomoFlags eq "-1") {
			if ($startPlus1 > 0) {
			    $isStartReach = 0;
			    last;
			}
			if ($startMinus1 > 4) {
			    $isStartReach = 0;
			    last;
			}
			$startMinus1++;
		    }
		    else
		    {
			if ($prevHomoFlags eq "0") {
			    $isStartReach = 0;
			    last;
			}
		    }
		}
		
		
	    }
	    
	    
	    
	    
	    for(my $m = $j+1;$m <= ($j+2);$m++)
	    {
		my $nextPos = $arrPos[$m];
		my $nextHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$nextPos};
		next if($nextHomoFlags eq "-");
		last if(($nextHomoFlags eq "1") || ($nextHomoFlags eq "-1"));
		$zeroCount++;
		$endZeroIndex = $m;
	    }
	    
	    
	    for(my $m = $endZeroIndex + 1; $m <= $#arrPos;$m++)
	    {
		my $nextPos = $arrPos[$m];
		my $nextHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$nextPos};
		next if($nextHomoFlags eq "-");
		
		if ($nextHomoFlags eq "1") {
		    if ($endMinus1 > 0) {
			$isEndReach = 0;
			last;
		    }
		    if ($endPlus1 > 4) {
			$isEndReach = 0;
			last;
		    }
		    $endPlus1++;
		}
		else
		{
		    if ($nextHomoFlags eq "-1") {
			if ($endPlus1 > 0) {
			    $isEndReach = 0;
			    last;
			}
			if ($endMinus1 > 4) {
			    $isEndReach = 0;
			    last;
			}
			$endMinus1++;
		    }
		    else
		    {
			if ($nextHomoFlags eq "0") {
			    $isEndReach = 0;
			    last;
			}
		    }
		}
		
		
	    }
	    
	    
	    
	}
	
	
	
	
	my $valToFill = 0;
	
	if ((($startPlus1 > 4) && ($startMinus1 == 0) && ($zeroCount < 4) && ($endPlus1 > 4) && ($endMinus1 == 0))
	    || (($startPlus1 > 1) && ($startMinus1 == 0) && ($zeroCount < 4) && ($endPlus1 > 4) && ($endMinus1 == 0) && ($isStartReach == 1))
	    || (($startPlus1 > 4) && ($startMinus1 == 0) && ($zeroCount < 4) && ($endPlus1 > 1) && ($endMinus1 == 0) && ($isEndReach == 1))) {
	    $valToFill = 1;
	}
	if (($startMinus1 > 4) && ($startPlus1 == 0) && ($zeroCount < 4) && ($endMinus1 > 4) && ($endPlus1 == 0)
	    || (($startMinus1 > 1) && ($startPlus1 == 0) && ($zeroCount < 4) && ($endMinus1 > 4) && ($endPlus1 == 0) && ($isStartReach == 1))
	    || (($startMinus1 > 4) && ($startPlus1 == 0) && ($zeroCount < 4) && ($endMinus1 > 1) && ($endPlus1 == 0) && ($isEndReach == 1))) {
	    $valToFill = -1;
	}
	
	if ($valToFill != 0) {
	    for(my $m = $j; $m <= $endZeroIndex;$m++)
	    {
		my $currPos = $arrPos[$m];
		my $currFlag = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
		next if($currFlag eq "-");
		$scaffPosHomoFlags{"$currScaffNam"}->{$currPos} = $valToFill;
	    }
	}
    }
}






for(my $i = 0;$i <= $#scaffNamArr;$i++)
{
    my $currScaffNam = $scaffNamArr[$i];
    
    my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
    my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
    
    
    
    
    for(my $j = 0;$j <= $#arrPos;$j++)
    {
        
	my $startZeroIndex = -1;
	my $endZeroIndex = -1;
	my $startPos = $arrPos[$j];
	my $prevChar = "";
	for(my $k = $j;$k <= $#arrPos;$k++)
	{
	    my $currPos = $arrPos[$k];
	    if (($currPos - $startPos) > 150000) {
	        last;
	    }
	    if (($currPos - $startPos) < 0) {
	        die;
	    }
	    my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	    
	    next if($currHomoFlags eq "-");
	    
	    if ($currHomoFlags eq "0") {
		if ($startZeroIndex > -1) {
		    $endZeroIndex = $k;
		}
		else
		{
		    $startZeroIndex = $k;
		}
		$prevChar = "";
	    
	    }
	    if (($currHomoFlags eq "1") || ($currHomoFlags eq "-1")) {
		
		if ($prevChar eq "") {
		    $prevChar = $currHomoFlags;
		}
		else
		{
		    if ($prevChar ne $currHomoFlags) {
			$endZeroIndex = $k-1;
			$prevChar = $currHomoFlags;
		    }
		    
		}
		
	    }
	    

	    
	}
	next if($startZeroIndex == -1);
	next if($endZeroIndex == -1);
	for(my $k = $startZeroIndex;$k <= $endZeroIndex;$k++)
	{
	    
	    
	    my $currPos = $arrPos[$k];
	    my $currFlag = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	    next if($currFlag eq "-");
	    $scaffPosHomoFlags{"$currScaffNam"}->{$currPos} = "0";
	}
	
    }
    
    
}



for(my $i = 0;$i <= $#scaffNamArr;$i++)
{
    my $currScaffNam = $scaffNamArr[$i];
    
    my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
    my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
    
    
    
    
    for(my $j = $#arrPos;$j >= 0;$j--)
    {
        
	my $startZeroIndex = -1;
	my $endZeroIndex = -1;
	my $startPos = $arrPos[$j];
	my $prevChar = "";
	for(my $k = $j;$k >= 0;$k--)
	{
	    my $currPos = $arrPos[$k];
	    if (($startPos - $currPos ) > 150000) {
	        last;
	    }
	    if (($startPos - $currPos) < 0) {
	        die;
	    }
	    my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	    
	    next if($currHomoFlags eq "-");
	    
	    if ($currHomoFlags eq "0") {
		if ($endZeroIndex > -1) {
		    $startZeroIndex = $k
		}
		else
		{
		    $endZeroIndex = $k;
		}
		$prevChar = "";
	    
	    }
	    if (($currHomoFlags eq "1") || ($currHomoFlags eq "-1")) {
		
		if ($prevChar eq "") {
		    $prevChar = $currHomoFlags;
		}
		else
		{
		    if ($prevChar ne $currHomoFlags) {
			$startZeroIndex = $k+1;
			$prevChar = $currHomoFlags;
		    }
		    
		}
		
	    }
	    

	    
	}
	next if($startZeroIndex == -1);
	next if($endZeroIndex == -1);
	for(my $k = $endZeroIndex;$k >= $startZeroIndex;$k--)
	{
	    
	    
	    my $currPos = $arrPos[$k];
	    my $currFlag = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	    next if($currFlag eq "-");
	    $scaffPosHomoFlags{"$currScaffNam"}->{$currPos} = "0";
	}
	
    }
    
    
}



for(my $i = 0;$i <= $#scaffNamArr;$i++)
{
    my $currScaffNam = $scaffNamArr[$i];
    
    my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
    my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
    
    
    my $lastZeroIndex = -1;
    my $startSignSeriesIndex = -1;
    
    my $countCurrType = 0;
    my $currType = "-2";
    
    my $countPrevType = 0;
    my $prevType = "-2";
    for(my $j = 0;$j <= $#arrPos;$j++)
    {
        
	my $currPos = $arrPos[$j];
	my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	
	
	if ($currHomoFlags eq "0") {
	    my $m = $j+1;
	    for(;$m<=$#arrPos;$m++)
	    {
		my $nextPos = $arrPos[$m];
		my $nextHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$nextPos};
		if ($nextHomoFlags eq "-") {
		    next;
		}
		if (($nextHomoFlags eq "1") || ($nextHomoFlags eq "-1")) {
		    $lastZeroIndex = $m-1;
		    $currType = $nextHomoFlags;
		    $startSignSeriesIndex = $m;
		    last;
		}
	    }
	    
	    for(;$m<=$#arrPos;$m++)
	    {
		my $nextPos = $arrPos[$m];
		my $nextHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$nextPos};
		if ($nextHomoFlags eq "-") {
		    next;
		}
		if ($currType ne $nextHomoFlags) {
		    $startSignSeriesIndex = $m;
		    $countCurrType = 1;
		    $currType = $nextHomoFlags;
		}
		else
		{
		    $countCurrType++;
		    if ($countCurrType > 5) {
			last;
		    }
		}
	    }
	    
	    
	    $j = $m;
	    for(my $m = ($lastZeroIndex+1);$m <= ($startSignSeriesIndex-1);$m++)
	    {
		my $currPos = $arrPos[$m];
		if ($scaffPosHomoFlags{"$currScaffNam"}->{$currPos} eq "-") {
		    next;
		}
		
		$scaffPosHomoFlags{"$currScaffNam"}->{$currPos} = "0";
		
	    }
	    
	}
	
	
	
	
	
    }
    
    
}







for(my $i = 0;$i <= $#scaffNamArr;$i++)
{
    my $currScaffNam = $scaffNamArr[$i];
    
    my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
    my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
    my $endPos = -1;
    
    my $countPlus1 = 0;
    my $countMinus1 = 0;
    my $countSignificantNumbers = 0;
    my $countZeroes = 0;
    my $j = 0;
    for(;$j <= $#arrPos;$j++)
    {
        
	my $currPos = $arrPos[$j];
	my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	next if ($currHomoFlags eq "-");
	if ($currHomoFlags eq "1") {
	    if ($countZeroes > 0) {
		last;
	    }
	    $countPlus1++;
	    
	}
	
	if ($currHomoFlags eq "-1") {
	    if ($countZeroes > 0) {
		last;
	    }
	    $countMinus1++;
	}
	
	if ($currHomoFlags eq "0") {
	    if ($countZeroes > 4) {
		
		last;
		
	    }
	    $countZeroes++;
	}
    }
    
#    if ($currScaffNam eq "key_scaffold_7_len3554402_cov0") {
#	print "$countZeroes\t$countMinus1\t$countPlus1\t$j\n";
#    }
    
    
    if ((($countZeroes > 4) && ($countMinus1 < 6) && ($countPlus1 == 0))
	|| (($countZeroes > 4) && ($countMinus1 == 0) && ($countPlus1 < 6))
	|| (($countZeroes > 4) && ($countMinus1 != 0) && ($countPlus1 != 0))) {
	
	
	if (($countZeroes > 4) && ($countMinus1 > 4) && ($countPlus1 != 0)) {
	    next;
	}
	
	if (($countZeroes > 4) && ($countMinus1 != 0) && ($countPlus1 > 4)) {
	    next;
	}
	
	for(my $m = 0;$m <= ($j-1);$m++)
	{
	    my $currPos = $arrPos[$m];
	    if ($scaffPosHomoFlags{"$currScaffNam"}->{$currPos} eq "-") {
		next;
	    }
	    
	    $scaffPosHomoFlags{"$currScaffNam"}->{$currPos} = "0";
	    
	}
    
    }
    
    
    
}



for(my $i = 0;$i <= $#scaffNamArr;$i++)
{
    my $currScaffNam = $scaffNamArr[$i];
    
    my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
    my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
    my $endPos = -1;
    my $countPlus1 = 0;
    my $countMinus1 = 0;
    my $countSignificantNumbers = 0;
    my $countZeroes = 0;
    my $j = $#arrPos;
    for(;$j >= 0;$j--)
    {
        
	my $currPos = $arrPos[$j];
	my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	next if ($currHomoFlags eq "-");
	if ($currHomoFlags eq "1") {
	    if ($countZeroes > 0) {
		last;
	    }
	    $countPlus1++;
	    
	}
	
	if ($currHomoFlags eq "-1") {
	    if ($countZeroes > 0) {
		last;
	    }
	    $countMinus1++;
	}
	
	if ($currHomoFlags eq "0") {
	    if ($countZeroes > 4) {
		
		last;
		
	    }
	    $countZeroes++;
	}
    }
    if ((($countZeroes > 4) && ($countMinus1 < 6) && ($countPlus1 == 0))
	|| (($countZeroes > 4) && ($countMinus1 == 0) && ($countPlus1 < 6))
	|| (($countZeroes > 4) && ($countMinus1 != 0) && ($countPlus1 != 0))) {
	
	if (($countZeroes > 4) && ($countMinus1 > 4) && ($countPlus1 != 0)) {
	    next;
	}
	
	if (($countZeroes > 4) && ($countMinus1 != 0) && ($countPlus1 > 4)) {
	    next;
	}
	
	
	
	for(my $m = ($j+1);$m <= $#arrPos;$m++)
	{
	    my $currPos = $arrPos[$m];
	    if ($scaffPosHomoFlags{"$currScaffNam"}->{$currPos} eq "-") {
		next;
	    }
	    
	    $scaffPosHomoFlags{"$currScaffNam"}->{$currPos} = "0";
	    
	}
    }
    
    
}



for(my $i = 0;$i <= $#scaffNamArr;$i++)
{
    my $currScaffNam = $scaffNamArr[$i];
    
    my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
    my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
    
    
    
    
    for(my $j = 0;$j <= $#arrPos;$j++)
    {
        
	my $startZeroCount = 0;
	my $endZeroCount = 0;
	my $notZeroCount = 0;
	my $endZeroIndex = 0;
	my $startPos = $arrPos[$j];
	my $endPos = $startPos;
	for(my $k = $j;$k <= $#arrPos;$k++)
	{
	    my $currPos = $arrPos[$k];
	    if (($startPos - $currPos ) > 500000) {
		$endPos = $k-1;
	        last;
	    }
	    if (($currPos - $startPos) < 0) {
	        die;
	    }
	    my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	    
	    next if($currHomoFlags eq "-");
	    
	    if ($currHomoFlags eq "0") {
		if ($notZeroCount > 0) {
		    $endZeroCount++;
		}
		else
		{
		    $startZeroCount++;
		}
		
	    }
	    else
	    {
		$notZeroCount++;
		$endZeroCount=0;
		
	    }
	    
	    
	    

	    
	}
	
	if (($startZeroCount > 9) && ($endZeroCount>9)) {
	    for(my $k = $startPos;$k <= $endPos;$k++)
	    {
	        
	        
	        my $currPos = $arrPos[$k];
	        my $currFlag = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	        next if($currFlag eq "-");
	        $scaffPosHomoFlags{"$currScaffNam"}->{$currPos} = "0";
	    }
	}
	
	
	
	
    }
    
    
}






for(my $i = 0;$i <= $#scaffNamArr;$i++)
{
    my $currScaffNam = $scaffNamArr[$i];
    
    my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
    my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
    for(my $j = 0;$j <= $#arrPos;$j++)
    {
	my $currPos = $arrPos[$j];
	my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	my $currStr = $scaffPosStr{"$currScaffNam"}->{$currPos};
	my @arrStr = split(/\t/,$currStr);
	
	my $scaffNam = $arrStr[0];
	my $pos = $arrStr[1];
	my $refVar = $arrStr[2];
	my $altVar = $arrStr[3];
	my $type = $arrStr[4];
	my $gNam = $arrStr[5];
	my $homoFlag = $arrStr[6];
	my $cov = int($arrStr[7]);
	if ($cov == 0) {
	    print FTW "$currStr\n";
	    next;
	}
	
	print FTW "$scaffNam\t$pos\t$refVar\t$altVar\t$type\t$gNam\t$currHomoFlags\t$cov\n";
	
    }
}




close(FTW);
