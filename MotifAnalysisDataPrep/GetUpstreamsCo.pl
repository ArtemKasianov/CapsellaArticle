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




my $gffCoFile = $ARGV[0];
my $fastaFileCo = $ARGV[1];
my $regionLen = $ARGV[2];
my $pairsFile = $ARGV[3];
my $outFile = $ARGV[4];






my $fastaOut = Bio::SeqIO->new(-file=>">$outFile",-format=>'fasta');


my %seqsTxts = ();


my $fasta=Bio::SeqIO->new(-file=>"$fastaFileCo",-format=>'fasta');

while(my $seq=$fasta->next_seq()){
    my $seqId = $seq->id;
    my $seqTxt = $seq->seq;
    $seqsTxts{"$seqId"} = $seqTxt;
}

$fasta->close();

my %quartetsList = ();
my %fullGeneNamByShortGeneNam = ();


open(FTR,"<$pairsFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    

    my $crNam = $arrInp[0];
    my $coNam = $arrInp[1];
    
    my @arrTemp = split(/\./,$coNam);
    
    my $gNam = $arrTemp[$#arrTemp-1];
    
    
    $quartetsList{"$gNam"} = 1;
    $fullGeneNamByShortGeneNam{"$gNam"} = $coNam;
}


close(FTR);


open(FTR,"<$gffCoFile") or die;


my %upstreamCoSeqs = ();


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
    
    my $featuresStr = $arrInp[8];
    
    
    my $currSeqText = $seqsTxts{"$scaffName"};
    my $revCurrSeqText = reverse_complement_IUPAC($currSeqText);
    
    
    if ($featType eq "gene") {
	my $currRegionLen = $regionLen;
	
	my $geneNam = $featuresStr;
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
		
		$featuresStr =~ /gene_id "(g[0-9]+)"/;
		
		
		
		
		my $geneNam = $1;
		
		print "ID=$geneNam\n";
		next if(not exists $geneStarts{"$geneNam"});
		
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
	
	
	my $fullGeneNam = $fullGeneNamByShortGeneNam{"$geneNam"};
	
	my $seqTitle = "$fullGeneNam.upstream.$currRegionLen";
	
	my $upstreamSeq = Bio::Seq->new( -id => $seqTitle,
			     -seq => $upstreamStr);
	if (exists $quartetsList{"$geneNam"}) {
		$fastaOut->write_seq($upstreamSeq);
	}
	
}





$fastaOut->close();








