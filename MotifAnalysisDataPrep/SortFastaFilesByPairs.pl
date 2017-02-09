use strict;
use Bio::SeqIO;


my $fastaFileA = $ARGV[0];
my $fastaFileB = $ARGV[1];
my $pairsFile = $ARGV[2];
my $outSortedFastaFileA = $ARGV[3];
my $outSortedFastaFileB = $ARGV[4];

my %aSeqs = ();
my %bSeqs = ();


my $fasta=Bio::SeqIO->new(-file=>"$fastaFileA",-format=>'fasta');
while(my $seq=$fasta->next_seq()){
    my $seqId = $seq->id;
    my @arrSeqId = split(/\.upstream/,$seqId);
    $seqId = $arrSeqId[0];

    $aSeqs{"$seqId"} = $seq
}
$fasta->close();

$fasta=Bio::SeqIO->new(-file=>"$fastaFileB",-format=>'fasta');
while(my $seq=$fasta->next_seq()){
    my $seqId = $seq->id;
    my @arrSeqId = split(/\.upstream/,$seqId);
    $seqId = $arrSeqId[0];
    $bSeqs{"$seqId"} = $seq
}
$fasta->close();


my $outFastaA = Bio::SeqIO->new(-file=>">$outSortedFastaFileA",-format=>'fasta');
my $outFastaB = Bio::SeqIO->new(-file=>">$outSortedFastaFileB",-format=>'fasta');

open(FTR,"<$pairsFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $aNam = $arrInp[0];
    my $bNam = $arrInp[1];
    my $seqA = $aSeqs{"$aNam"};
    my $seqB = $bSeqs{"$bNam"};

    print "Cr $seqA A\t$seqB\n";
    
    next if((not exists $aSeqs{"$aNam"}) || (not exists $bSeqs{"$bNam"}));
    
    if(exists $aSeqs{"$aNam"})
    {
	$outFastaA->write_seq($seqA);
    }
    
    if(exists $bSeqs{"$bNam"})
    {
	$outFastaB->write_seq($seqB);
    }
    
    
}


close(FTR);

$outFastaA->close();
$outFastaB->close();

