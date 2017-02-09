use strict;
use Bio::SeqIO;



my $aFile = $ARGV[0];
my $bFile = $ARGV[1];
my $outFile = $ARGV[2];

open(FTW,">$outFile") or die;

my $fastaAFile = Bio::SeqIO->new(-file=>"$aFile",-format=>'fasta');
my $fastaBFile = Bio::SeqIO->new(-file=>"$bFile",-format=>'fasta');


while(my $seqA=$fastaAFile->next_seq()){
    my $seqB=$fastaBFile->next_seq();
    
    my $seqAId = substr($seqA->id,0,length($seqA->id)-13);
    my $seqBId = substr($seqB->id,0,length($seqB->id)-13);
    
    
    print FTW "$seqAId\t$seqBId\n";
    
    
    
}



close(FTW);
$fastaAFile->close();
$fastaBFile->close();

