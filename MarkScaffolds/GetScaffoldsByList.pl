use strict;
use Bio::SeqIO;


my $scaffoldsFile = $ARGV[0];
my $listFile = $ARGV[1];
my $outFile = $ARGV[2];




my %scaffsList = ();


open(FTR,"<$listFile") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    $scaffsList{"$input"} = 1;
    print "$input\xxxxx\n";
}

close(FTR);

my $fasta=Bio::SeqIO->new(-file=>"$scaffoldsFile",-format=>'fasta');
my $fastaOut=Bio::SeqIO->new(-file=>">$outFile",-format=>'fasta');

while(my $seq=$fasta->next_seq()){
    my $seqId = $seq->id;
    if (exists $scaffsList{"$seqId"}) {
	$fastaOut->write_seq($seq);
    }
    
}


$fasta->close();
$fastaOut->close();
