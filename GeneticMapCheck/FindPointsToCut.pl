use strict;
use Bio::SeqIO;

my $listFile = $ARGV[0];
my $refFile = $ARGV[1];
my $outRefFile = $ARGV[2];

my @arrIndividualsPosStr = ();
my @arrIndividualsHomoFlags = ();


open(FTR_1, "<$listFile") or die;
while (my $input = <FTR_1>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $fileName = $arrInp[0];
    my $outFileName = $arrInp[1];
    

    open(FTR,"<$fileName") or die;
    
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
	next if($scaffNam eq "");
	
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
    
    #open(FTW,">$outFileName") or die;
    my @scaffNamArr = keys %scaffPosHomoFlags;
    for(my $i = 0;$i <= $#scaffNamArr;$i++)
    {
	my $currScaffNam = $scaffNamArr[$i];
	my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
	my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
	my $prevHomoFlags = "";
	for(my $j = 0;$j <= $#arrPos;$j++)
	{
	    
	    my $currPos = $arrPos[$j];
	    my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
	    
	    if ($currHomoFlags eq "-") {
		my $k = $j+1;
		my $nextHomoFlags = "";
		for(;$k <= $#arrPos;$k++)
		{
		    my $currCurrPos = $arrPos[$k];
		    my $currCurrHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currCurrPos};
		    next if($currCurrHomoFlags eq "-");
		    $nextHomoFlags = $currCurrHomoFlags;
		    last;
		}
		
		my $startIndex = $j;
		my $endIndex = $j;
		if ($nextHomoFlags ne "") {
		    $endIndex = $k-1;
		}
		else
		{
		    $endIndex = $#arrPos;
		    $nextHomoFlags = $prevHomoFlags;
		}
		
		if ($prevHomoFlags eq "") {
		    $prevHomoFlags = $nextHomoFlags;
		}
		
		$j = $endIndex;
		for(my $m = $startIndex;$m <= $endIndex;$m++)
		{
		    my $currCurrPos = $arrPos[$m];
		    my $currCurrHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currCurrPos};
		    my $homoFlagToChange = "";
		    if (($nextHomoFlags eq "1") && ($prevHomoFlags eq "1")) {
			$scaffPosHomoFlags{"$currScaffNam"}->{$currCurrPos} = "1";
			next;
		    }
		    if (($nextHomoFlags eq "-1") && ($prevHomoFlags eq "-1")) {
			$scaffPosHomoFlags{"$currScaffNam"}->{$currCurrPos} = "-1";
			next;
		    }
		    if (($nextHomoFlags eq "0") || ($prevHomoFlags eq "0")) {
			$scaffPosHomoFlags{"$currScaffNam"}->{$currCurrPos} = "0";
			next;
		    }
		    
		    if(($nextHomoFlags eq "-1") && ($prevHomoFlags eq "1")) {
			$scaffPosHomoFlags{"$currScaffNam"}->{$currCurrPos} = "-1";
			next;
		    }
		    if(($nextHomoFlags eq "1") && ($prevHomoFlags eq "-1")) {
			$scaffPosHomoFlags{"$currScaffNam"}->{$currCurrPos} = "1";
			next;
		    }
		    
		    
		}
	    }

	    $prevHomoFlags = $currHomoFlags;
	}
    }
    
    
    push @arrIndividualsPosStr,\%scaffPosStr;
    push @arrIndividualsHomoFlags,\%scaffPosHomoFlags;
    
    
    
#    for(my $i = 0;$i <= $#scaffNamArr;$i++)
#    {
#	my $currScaffNam = $scaffNamArr[$i];
#	
#	my $ptrScaffPos = $scaffPosHomoFlags{"$currScaffNam"};
#	my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
#	for(my $j = 0;$j <= $#arrPos;$j++)
#	{
#	    my $currPos = $arrPos[$j];
#	    my $currHomoFlags = $scaffPosHomoFlags{"$currScaffNam"}->{$currPos};
#	    my $currStr = $scaffPosStr{"$currScaffNam"}->{$currPos};
#	    my @arrStr = split(/\t/,$currStr);
#	    
#	    my $scaffNam = $arrStr[0];
#	    my $pos = $arrStr[1];
#	    my $refVar = $arrStr[2];
#	    my $altVar = $arrStr[3];
#	    my $type = $arrStr[4];
#	    my $gNam = $arrStr[5];
#	    my $homoFlag = $arrStr[6];
#	    my $cov = int($arrStr[7]);
#	    if ($cov == 0) {
#		$cov = 2;
#	    }
#	    
#	    print FTW "$scaffNam\t$pos\t$refVar\t$altVar\t$type\t$gNam\t$currHomoFlags\t$cov\n";
#	    
#	}
#    }
#    close(FTW);
    

    
    
}

close(FTR_1);

my $ptrScaffHomoFlags = $arrIndividualsHomoFlags[0];
my $countCutPoints = 0;
my @scaffHomoFlags = keys %$ptrScaffHomoFlags;


my %startPosByScaffs = ();
my %endPosByScaffs = ();


for(my $i = 0;$i <= $#scaffHomoFlags;$i++)
{
    my $currScaffNam = $scaffHomoFlags[$i];
    my $ptrScaffPos = $ptrScaffHomoFlags->{"$currScaffNam"};
    my @arrPos = sort {$a <=> $b} keys %$ptrScaffPos;
    my @arrStartPos = ();
    my @arrEndPos = ();
    for(my $j = 0;$j <= $#arrPos;$j++)
    {
	my $startPos = $arrPos[$j];
	my $endPos = $arrPos[$j];
	my $startIndex = $j;
	my $endIndex = $j;
	
	my $startHomoFlag = $ptrScaffHomoFlags->{"$currScaffNam"}->{$startPos};
	next if($startHomoFlag eq "-");
	
	
	
	for(my $k=$j+1;$k <= $#arrPos;$k++)
	{
	    my $currPos = $arrPos[$k];
	    my $currHomoFlag = $ptrScaffHomoFlags->{"$currScaffNam"}->{$currPos};
	    next if($currHomoFlag eq "-");
	    if (($currPos - $startPos)> 10000) {
		last;
	    }
	    $endPos = $currPos;
	    $endIndex = $k;
	    
	}
	my $distance = 0;
	for(my $k = 0;$k <= $#arrIndividualsHomoFlags;$k++)
	{
	    my $ptrCurrScaffHomoFlags = $arrIndividualsHomoFlags[$k];
	    my $startFlag = $ptrCurrScaffHomoFlags->{"$currScaffNam"}->{$startPos};
	    my $endFlag = $ptrCurrScaffHomoFlags->{"$currScaffNam"}->{$endPos};
	    
	    if ($startFlag ne $endFlag) {
		if (($startFlag eq "0") || ($endFlag eq "0")) {
		    $distance += 1;
		}
		else
		{
		    $distance += 2;
		}
	    }
	}
	if ($distance > 2) {
	    $j = $endIndex;
	    $countCutPoints++;
	    push @arrStartPos,$startPos;
	    push @arrEndPos,$endPos;
	}
	
    
    }
    $startPosByScaffs{"$currScaffNam"} = \@arrStartPos;
    $endPosByScaffs{"$currScaffNam"} = \@arrEndPos;
}


my $inFastaFile=Bio::SeqIO->new(-file=>"$refFile",-format=>'fasta');
my $outFastaFile=Bio::SeqIO->new(-file=>">$outRefFile",-format=>'fasta');
my $countsDebug = 0;
my $countsDebug_1 = 0;
my $countsDebug_2 = 0;
while (my $seq = $inFastaFile->next_seq()) {
    my $seqId = $seq->id;
    my $seqTxt = $seq->seq;
    
    if (exists $startPosByScaffs{"$seqId"}) {
	
	my $ptrArrStartPos = $startPosByScaffs{"$seqId"};
	my $ptrArrEndPos = $endPosByScaffs{"$seqId"};
	$countsDebug++;
	if ($#$ptrArrStartPos != $#$ptrArrEndPos) {
	    die;
	}
	$countsDebug_1++;
	
	if ($#$ptrArrStartPos < 0) {
	    $outFastaFile->write_seq($seq);
	    next;
	}
	$countsDebug_2++;
	my $prevStartPos = 0;
	
	for(my $i = 0;$i <= $#$ptrArrStartPos;$i++)
	{
	    my $startPos = $ptrArrStartPos->[$i];
	    my $endPos = $ptrArrEndPos->[$i];
	    print "$seqId\t$startPos\t$endPos\t$prevStartPos\n";
	    if ($prevStartPos != $startPos) {
		
		my $seqTxtToWrite = substr($seqTxt,$prevStartPos,$startPos-$prevStartPos);
		my $seqIdToWrite = $seqId.".$prevStartPos.$startPos";
		my $seqObjToWrite = Bio::Seq->new( -id => $seqIdToWrite,
                        -seq => $seqTxtToWrite);
		$outFastaFile->write_seq($seqObjToWrite);
	    }
	    
	    $prevStartPos = $endPos + 1;
	}
	
    }
    else
    {
	#print "$seqId\n";
	$outFastaFile->write_seq($seq);
    }
    

}


$inFastaFile->close();
$outFastaFile->close();
print "$countCutPoints\n";
print "$countsDebug\t$countsDebug_1\t$countsDebug_2\n";
