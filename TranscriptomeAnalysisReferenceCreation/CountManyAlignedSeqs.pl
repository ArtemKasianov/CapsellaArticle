use strict;
use Bio::SeqIO;

my $minI = $ARGV[0];
my $maxI = $ARGV[1];



for(my $i = $minI;$i <= $maxI;$i++)
{
    system("perl GetAlignedSeqsWoIndelFromFastaAlign.pl align/seqs_$i.fasta align_split/seqs_fragments_1.fasta 120 >stdout/align_frags_$i.stdout 2>stderr/align_frags_$i.stderr");
    
}

