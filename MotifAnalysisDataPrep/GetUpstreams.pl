use strict;
use Bio::SeqIO;


sub reverse_complement_IUPAC {
        my $dna = shift;

	# reverse the DNA sequence
        my $revcomp = reverse($dna);

	# complement the reversed DNA sequence
        $revcomp =~ tr/ABCDGHMNRSTUVWXYabcdghmnrstuvwxy/TVGHCDKNYSAABWXRtvghcdknysaabwxr/;
        return $revcomp;
}



my $gffFile = $ARGV[0];
my $fastaFile = $ARGV[1];
my $regionLen = $ARGV[2];
my $deabPairsList = $ARGV[3];
my $notDeabPairsList = $ARGV[4];
my $outFileADeab = $ARGV[5];
my $outFileBDeab = $ARGV[6];
my $outFileANotDeab = $ARGV[7];
my $outFileBNotDeab = $ARGV[8];


my %deabAList = ();
my %deabBList = ();
my %notDeabAList = ();
my %notDeabBList = ();

my %allGenesToAnalyze = ();


open(FTR,"<$deabPairsList") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $aNam = $arrInp[0];
    my $bNam = $arrInp[1];
    
    $deabAList{"$aNam"} = 1;
    $deabBList{"$bNam"} = 1;
    $allGenesToAnalyze{"$aNam"} = 1;
    $allGenesToAnalyze{"$bNam"} = 1;
    
}


close(FTR);

open(FTR,"<$notDeabPairsList") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $aNam = $arrInp[0];
    my $bNam = $arrInp[1];
    
    $notDeabAList{"$aNam"} = 1;
    $notDeabBList{"$bNam"} = 1;
    $allGenesToAnalyze{"$aNam"} = 1;
    $allGenesToAnalyze{"$bNam"} = 1;
    
}


close(FTR);


my $fastaAUpDeab = Bio::SeqIO->new(-file=>">$outFileADeab",-format=>'fasta');
my $fastaBUpDeab = Bio::SeqIO->new(-file=>">$outFileBDeab",-format=>'fasta');
my $fastaAUpNotDeab = Bio::SeqIO->new(-file=>">$outFileANotDeab",-format=>'fasta');
my $fastaBUpNotDeab = Bio::SeqIO->new(-file=>">$outFileBNotDeab",-format=>'fasta');


my %seqsTxts = ();

my $fasta=Bio::SeqIO->new(-file=>"$fastaFile",-format=>'fasta');

while(my $seq=$fasta->next_seq()){
    my $seqId = $seq->id;
    my $seqTxt = $seq->seq;
    $seqsTxts{"$seqId"} = $seqTxt;
}

$fasta->close();


open(FTR,"<$gffFile") or die;

my $last_gene_end = 0;
my $lastScaffNam = "";
while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $scaffName = $arrInp[0];
    my $featType = $arrInp[2];
    my $startCoor = $arrInp[3]-1;
    my $endCoor = $arrInp[4]-1;
    my $strand = $arrInp[6];
    my $geneNam = substr($arrInp[8],5,length($arrInp[8])-6);
    my $currSeqText = $seqsTxts{"$scaffName"};
    my $revCurrSeqText = reverse_complement_IUPAC($currSeqText);
    
    next if(not exists $allGenesToAnalyze{"$geneNam"});
    next if ($startCoor == 0);
	
    if ($scaffName ne $lastScaffNam) {
	$last_gene_end = 0;
	$lastScaffNam = $scaffName;
    }
    
    
#    if ($strand eq "-") {
#	my $revCurrSeqText = reverse_complement_IUPAC($currSeqText);
#	$currSeqText = $revCurrSeqText;
#    }
    
    if ($featType eq "gene") {
	my $currRegionLen = $regionLen;
	#if (($endCoor - $last_gene_end) < 1000) {
	#    $currRegionLen = $endCoor - $last_gene_end - 1;
	#}
	my $upstreamStr = "";
	my $startCoorToGet = 0;
	my $lenToGet = 0;
	if ($strand eq "-") {
	    $startCoor-=1;
	    $startCoorToGet = $endCoor+1;
	    $lenToGet = $currRegionLen;
	}
	else
	{
	    if (($startCoor - $currRegionLen)>0) {
		$startCoorToGet = $startCoor - $currRegionLen;
		$lenToGet = $currRegionLen;
	    }
	    else
	    {
		$startCoorToGet = 0;
		$lenToGet = $startCoor;
	    }
	}
	$upstreamStr = substr($currSeqText,$startCoorToGet,$lenToGet);
	if ($strand eq "-") {
	    $upstreamStr = reverse_complement_IUPAC($upstreamStr);
	}
	
	my $seqTitle = "$geneNam.upstream.$currRegionLen";
	
	my $upstreamSeq = Bio::Seq->new( -id => $seqTitle,
			     -seq => $upstreamStr);
	
	
	if (exists $deabAList{"$geneNam"}) {
	    $fastaAUpDeab->write_seq($upstreamSeq);
	}
	else
	{
	    if (exists $deabBList{"$geneNam"}) {
	       $fastaBUpDeab->write_seq($upstreamSeq);
	    }
	    else
	    {
		if (exists $notDeabAList{"$geneNam"}) {
		  $fastaAUpNotDeab->write_seq($upstreamSeq);
		}
		else
		{
		    if (exists $notDeabBList{"$geneNam"}) {
			$fastaBUpNotDeab->write_seq($upstreamSeq);
		    }
		}
	    }
	}
	
	
	$last_gene_end = $endCoor;
    }
    
    
}

$fastaAUpDeab->close();
$fastaBUpDeab->close();
$fastaAUpNotDeab->close();
$fastaBUpNotDeab->close();
close(FTR);
