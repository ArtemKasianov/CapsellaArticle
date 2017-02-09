use strict;
use Bio::SeqIO;



my $aFile = $ARGV[0];
my $bFile = $ARGV[1];
my $minCountN = $ARGV[2];
my $outFileA = $ARGV[3];
my $outFileB = $ARGV[4];





my $fastaA = Bio::SeqIO->new(-file=>"$aFile",-format=>'fasta');
my $fastaB = Bio::SeqIO->new(-file=>"$bFile",-format=>'fasta');

my $outFastaA = Bio::SeqIO->new(-file=>">$outFileA",-format=>'fasta');
my $outFastaB = Bio::SeqIO->new(-file=>">$outFileB",-format=>'fasta');

while(my $seqA=$fastaA->next_seq()){
    my $seqB=$fastaB->next_seq();
    
    my $seqAId = substr($seqA->id,0,length($seqA->id)-13);
    my $seqBId = substr($seqB->id,0,length($seqB->id)-13);
    my $seqATxt = $seqA->seq;
    my $seqBTxt = $seqB->seq;
    
    next if(length($seqATxt) != length($seqBTxt));
    next if(length($seqATxt) == 0);
    next if(length($seqBTxt) == 0);
    
    my $countN_A = 0;
    my $countN_B = 0;
    
    for(my $i = 0;$i < length($seqATxt);$i++)
    {
	my $currA = uc(substr($seqATxt,$i,1));
	if ($currA eq "N") {
		$countN_A++;
	}
    }
    for(my $i = 0;$i < length($seqBTxt);$i++)
    {
	my $currB = uc(substr($seqBTxt,$i,1));
	if ($currB eq "N") {
		$countN_B++;
	}
    }
    
    next if($countN_A > $minCountN);
    next if($countN_B > $minCountN);
    
    $outFastaA->write_seq($seqA);
    $outFastaB->write_seq($seqB);
    #my $fractionA = $countN_A/length($seqATxt);
    #my $fractionB = $countN_B/length($seqBTxt);
    #
    #next if($fractionA > $minFraction);
    #next if($fractionB > $minFraction);
    
}



$fastaA->close();
$fastaB->close();

$outFastaA->close();
$outFastaB->close();
