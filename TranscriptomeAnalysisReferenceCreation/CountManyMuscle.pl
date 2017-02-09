use strict;
use Bio::SeqIO;

my $minI = $ARGV[0];
my $maxI = $ARGV[1];



for(my $i = $minI;$i <= $maxI;$i++)
{
    system("/home/artem/soft/muscle3.8.31_i86linux64 -in seqs/seqs_$i.fasta -out align/seqs_$i.fasta >stdout/muscle_seqs_$i.stdout 2>stderr/muscle_seqs_$i.stderr");
}
