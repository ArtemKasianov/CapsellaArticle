use strict;
use Bio::SeqIO;



my $fastaAlign = $ARGV[0];
my $outFile = $ARGV[1];
my $minLen = $ARGV[2];


my @arrIds = ();
my @arrTxt = ();

my $in=Bio::SeqIO->new(-file=>"$fastaAlign",-format=>'fasta');
while(my $seq=$in->next_seq()){
    my $id = $seq->id;
    my $seqTxt = $seq->seq;
    
    push @arrIds,$id;
    push @arrTxt,$seqTxt;
    
}

$in->close();

my $currSeq1 = "";
my $currSeq2 = "";
my $index1 = 0;
my $index2 = 0;

my $strToWrite1 = "";
my $strToWrite2 = "";

for(my $i = 0;$i <= length($arrTxt[0]);$i++)
{
    my $currLetter1 = substr($arrTxt[0],$i,1);
    my $currLetter2 = substr($arrTxt[1],$i,1);
   
    if (($currLetter1 eq "-") || ($currLetter2 eq "-")) {
	my $debugLen = length($currSeq1);
	print "$debugLen\n";
	if (length($currSeq1) > $minLen) {
	    my $newId1 = $arrIds[0];
	    my $newId2 = $arrIds[1];
	    $strToWrite1 = $strToWrite1.">$newId1\$$index1\n";
	    $strToWrite1 = $strToWrite1."$currSeq1\n";
	    $strToWrite2 = $strToWrite2.">$newId2\$$index2\n";
	    $strToWrite2 = $strToWrite2."$currSeq2\n";
	    $index1++;
	    $index2++;
	}
	$currSeq1 = "";
	$currSeq2 = "";
	
    }
    else
    {
	$currSeq1 = $currSeq1.$currLetter1;
	$currSeq2 = $currSeq2.$currLetter2;
    }
}
if (length($currSeq1) > $minLen) {
     print "here\n";
    my $newId1 = $arrIds[0];
    my $newId2 = $arrIds[1];
    $strToWrite1 = $strToWrite1.">$newId1\$$index1\n";
    $strToWrite1 = $strToWrite1."$currSeq1\n";
    $strToWrite2 = $strToWrite2.">$newId2\$$index2\n";
    $strToWrite2 = $strToWrite2."$currSeq2\n";
    $index1++;
    $index2++;
}

open(FTW,">>$outFile") or die;

print FTW "$strToWrite1";
print FTW "$strToWrite2";

close(FTW);

