use strict;
use Bio::SeqIO;




my $AFile = $ARGV[0];
my $BFile = $ARGV[1];
my $CrFile = $ARGV[2];
my $CoFile = $ARGV[3];
my $quadsFile = $ARGV[4];
my $outFileA = $ARGV[5];
my $outFileB = $ARGV[6];
my $outFileCr = $ARGV[7];
my $outFileCo = $ARGV[8];


my %Aseq = ();
my %Bseq = ();
my %Crseq = ();
my %Coseq = ();





my $fastaAFile = Bio::SeqIO->new(-file=>"$AFile",-format=>'fasta');
my $fastaBFile = Bio::SeqIO->new(-file=>"$BFile",-format=>'fasta');
my $fastaCrFile = Bio::SeqIO->new(-file=>"$CrFile",-format=>'fasta');
my $fastaCoFile = Bio::SeqIO->new(-file=>"$CoFile",-format=>'fasta');
my $outFastaAFile = Bio::SeqIO->new(-file=>">$outFileA",-format=>'fasta');
my $outFastaBFile = Bio::SeqIO->new(-file=>">$outFileB",-format=>'fasta');
my $outFastaCrFile = Bio::SeqIO->new(-file=>">$outFileCr",-format=>'fasta');
my $outFastaCoFile = Bio::SeqIO->new(-file=>">$outFileCo",-format=>'fasta');





while(my $seq=$fastaAFile->next_seq()){
    my $seqId = $seq->id;
    my $seqTxt = $seq->seq;
    $Aseq{"$seqId"} = $seq;
}

while(my $seq=$fastaBFile->next_seq()){
    my $seqId = $seq->id;
    my $seqTxt = $seq->seq;
    $Bseq{"$seqId"} = $seq;
}

while(my $seq=$fastaCrFile->next_seq()){
    my $seqId = $seq->id;
    my $seqTxt = $seq->seq;
    $Crseq{"$seqId"} = $seq;
}

while(my $seq=$fastaCoFile->next_seq()){
    my $seqId = $seq->id;
    my $seqTxt = $seq->seq;
    $Coseq{"$seqId"} = $seq;
}


open(FTR,"<$quadsFile") or die;

while (my $input = <FTR>) {
	chomp($input);
	my @arrInp = split(/\t/,$input);
	
	my $aName = $arrInp[1];
	my $bName = $arrInp[0];
	my $crName = $arrInp[2];
	my $coName = $arrInp[3];
	
	
	if (not exists $Aseq{"$aName".".upstream.500"}) {
		next;
	}
	
	if (not exists $Bseq{"$bName".".upstream.500"}) {
		next;
	}
	if (not exists $Crseq{"$crName".".upstream.500"}) {
		next;
	}
	if (not exists $Coseq{"$coName".".upstream.500"}) {
		next;
	}
	print "here\n";
	my $aSeq = $Aseq{"$aName".".upstream.500"};
	my $bSeq = $Bseq{"$bName".".upstream.500"};
	my $crSeq = $Crseq{"$crName".".upstream.500"};
	my $coSeq = $Coseq{"$coName".".upstream.500"};
	
	$outFastaAFile->write_seq($aSeq);
	$outFastaBFile->write_seq($bSeq);
	$outFastaCrFile->write_seq($crSeq);
	$outFastaCoFile->write_seq($coSeq);
	
	
}


close(FTR);


$fastaAFile->close();
$fastaBFile->close();
$fastaCrFile->close();
$fastaCoFile->close();
$outFastaAFile->close();
$outFastaBFile->close();
$outFastaCrFile->close();
$outFastaCoFile->close();

