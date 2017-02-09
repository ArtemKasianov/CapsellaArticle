use strict;
use Bio::SeqIO;

my $listOf2Sets = $ARGV[0];
my $CbpFile = $ARGV[1];

my %seqsList = ();

my $fasta=Bio::SeqIO->new(-file=>"$CbpFile",-format=>'fasta');

while(my $seq=$fasta->next_seq()){
    my $seqId = $seq->id;
    $seqsList{"$seqId"} = $seq;
    

}


$fasta->close();




open(FTR,"<$listOf2Sets") or die;

my $index = 0;
while (my $input = <FTR>) {
    chomp($input);
    my @arrInp = split(/\t/,$input);
    my $cbp1Id = $arrInp[0];
    my $cbp2Id = $arrInp[1];
    
    print "$cbp1Id $cbp2Id\n";
    my $out = Bio::SeqIO->new(-file=>">seqs/seqs_$index.fasta",-format=>'fasta');
    
    
    my $cbp1Seq = $seqsList{"$cbp1Id"};
    my $cbp2Seq = $seqsList{"$cbp2Id"};
    
    
    $out->write_seq($cbp1Seq);
    $out->write_seq($cbp2Seq);
    
    $out->close();
    $index++;
}




close(FTR);
