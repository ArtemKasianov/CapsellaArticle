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




my $gffRubellaFile = $ARGV[0];
my $fastaFileRubella = $ARGV[1];
my $regionLen = $ARGV[2];
my $DEABListFile = $ARGV[3];
my $notDEABListFile = $ARGV[4];
my $outFileDEAB = $ARGV[5];
my $outFilenotDEAB = $ARGV[6];





my $fastaDEABOut = Bio::SeqIO->new(-file=>">$outFileDEAB",-format=>'fasta');
my $fastanotDEABOut = Bio::SeqIO->new(-file=>">$outFilenotDEAB",-format=>'fasta');

my %seqsTxts = ();


my $fasta=Bio::SeqIO->new(-file=>"$fastaFileRubella",-format=>'fasta');

while(my $seq=$fasta->next_seq()){
    my $seqId = $seq->id;
    my $seqTxt = $seq->seq;
    $seqsTxts{"$seqId"} = $seqTxt;
}

$fasta->close();

my %deabList = ();
my %notDeabList = ();


my %allGenesToAnalyze = ();


open(FTR,"<$DEABListFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $crNam = $arrInp[0];
    my $coNam = $arrInp[1];
    
    $deabList{"$crNam"} = 1;
    $allGenesToAnalyze{"$crNam"} = 1;
    
}


close(FTR);

open(FTR,"<$notDEABListFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $crNam = $arrInp[0];
    my $coNam = $arrInp[1];
    
    $notDeabList{"$crNam"} = 1;
    $allGenesToAnalyze{"$crNam"} = 1;
    
}


close(FTR);

open(FTR,"<$gffRubellaFile") or die;

my $last_gene_end = 0;
my $lastScaffNam = "";

my %upstreamRubSeqs = ();


my %geneStarts = ();
my %geneEnds = ();
my %geneStrand = ();
my %geneScaff = ();


while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    
    my $scaffName = $arrInp[0];
    my $featType = $arrInp[2];
    my $startCoor = $arrInp[3]-1;
    my $endCoor = $arrInp[4]-1;
    my $strand = $arrInp[6];
    
    
    
    
    my $currSeqText = $seqsTxts{"$scaffName"};
    my $revCurrSeqText = reverse_complement_IUPAC($currSeqText);
    
    
    if ($featType eq "mRNA") {
	my $currRegionLen = $regionLen;
	$input =~ /Name=(Carubv[0-9]+m)/;
	
	my $geneNam = $1;
	print "Name=$geneNam\n";
	$geneStarts{"$geneNam"} = $endCoor;
	$geneEnds{"$geneNam"} = $startCoor;
	$geneStrand{"$geneNam"} = $strand;
	$geneScaff{"$geneNam"} = $scaffName;
    }
    else
    {
	if ($featType eq "CDS") {
		my $currRegionLen = $regionLen;
		$input =~ /ID=(Carubv[0-9]+m).v1/;
		
		my $geneNam = $1;
		
		next if(not exists $geneStarts{"$geneNam"});
		print "ID=$geneNam\n";
		
		if ($geneEnds{"$geneNam"} < $endCoor ) {
			$geneEnds{"$geneNam"} = $endCoor;
		}
		if ($geneStarts{"$geneNam"} > $startCoor ) {
			$geneStarts{"$geneNam"} = $startCoor;
		}
	}
    }
}
close(FTR);

my @arrGenes = keys %geneStarts;

for(my $i = 0;$i <= $#arrGenes;$i++)
{
	my $geneNam = $arrGenes[$i];
	my $scaffName = $geneScaff{"$geneNam"};
	my $startCoor = $geneStarts{"$geneNam"};
	my $endCoor = $geneEnds{"$geneNam"};
	my $strand = $geneStrand{"$geneNam"};
	
	my $currSeqText = $seqsTxts{"$scaffName"};
	my $revCurrSeqText = reverse_complement_IUPAC($currSeqText);
	
	
	
	my $currRegionLen = $regionLen;
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
	if (exists $deabList{"$geneNam"}) {
		$fastaDEABOut->write_seq($upstreamSeq);
	}
	else
	{
		if (exists $notDeabList{"$geneNam"}) {
			$fastanotDEABOut->write_seq($upstreamSeq);
		}
	}
}





$fastaDEABOut->close();
$fastanotDEABOut->close();







