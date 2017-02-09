use Bio::SeqIO;
use strict;
use Region;
use ContigCoveredRegions;

my $covRegionsFile = $ARGV[0];
my $contigsFile = $ARGV[1];
my $rangesFile = $ARGV[2];
my $outFile = $ARGV[3];


open(FTR_COV,"<$covRegionsFile") or die;
open(FTW_RANGES,">$rangesFile") or die;
open(FTW,">$outFile") or die;

my $inNewFile = Bio::SeqIO->new(-file => "$contigsFile" , '-format' => 'Fasta');
my $index = 0;

my @seqNams = ();
my %seqText = ();
my %seqLens = ();
my $conNum = 0;
while ( my $seq = $inNewFile->next_seq() ) {
    my $seqId = $seq->id;
    my $seqText = $seq->seq;
    
    $seqLens{"$seqId"} = length($seqText);
    $seqText{"$seqId"} = $seqText;
    
    $conNum++;
    push @seqNams,$seqId;
    
    
    
    
    
}
print "$conNum\n";
$inNewFile->close();

my %covRanges = ();


while (my $input = <FTR_COV>) {
    
    my @arrInp = split(/\t/,$input);
    
    my $seqIndex = $arrInp[0];
    my $seqStart = $arrInp[1];
    my $seqEnd = $arrInp[2];
    
    if (($seqEnd - $seqStart) < 0) {
        next;
    }
    
    my $seqNam = $seqNams[$seqIndex];
    my $region = Region->new();
    $region->SetStartCoor($seqStart);
    $region->SetEndCoor($seqEnd);
    
    my $seqStartCoor = $region->GetStartCoor();
    my $seqEndCoor = $region->GetEndCoor();
    
    print FTW_RANGES "$seqNam\t$seqStartCoor\t$seqEndCoor";
    
    
    if(not exists $covRanges{"$seqNam"})
    {
        $covRanges{"$seqNam"} = ContigCoveredRegions->new();
    }
    $covRanges{"$seqNam"}->AddRegion($region);
    
}






my @seqNames = keys %covRanges;



my $overallSize = 0;
for(my $i = 0;$i <= $#seqNames;$i++)
{
    my $currNam = $seqNames[$i];

    $covRanges{"$currNam"}->MergeIntersectedRegions();
    my $sizeCurrRegion = $covRanges{"$currNam"}->GetCovRegionsSize();
    
    $overallSize +=$sizeCurrRegion;
    
    
    
    my $ptrCurrRegions = $covRanges{"$currNam"}->GetCovRegions();
    my @currRegions = @$ptrCurrRegions;
    
    print "sizeCurrRegions - $#currRegions\n";
    
    my $startContigCoor = 0;
    my $endContigCoor = 0;
    
    if ($currRegions[0]->GetStartCoor() > 0) {
        $startContigCoor = 0;
        $endContigCoor = $currRegions[0]->GetStartCoor()-1;
        my $strToWrite = substr($seqText{"$currNam"},$startContigCoor,$endContigCoor-$startContigCoor+1);
        #if(length($strToWrite) >=1000)
        #{
            print FTW ">$currNam\@$startContigCoor\@$endContigCoor\n";
            print FTW "$strToWrite\n";
        #}
    }
    
    
    for(my $i=0;$i < $#currRegions;$i++)
    {
        my $regionAtIndex = $currRegions[$i];
        my $regionAtIndexPlusOne = $currRegions[$i+1];
        $startContigCoor = $regionAtIndex->GetEndCoor()+1;
        $endContigCoor = $regionAtIndexPlusOne->GetStartCoor()-1;
        
        my $strToWrite = substr($seqText{"$currNam"},$startContigCoor,$endContigCoor-$startContigCoor+1);
        #next if(length($strToWrite) <1000);
        print FTW ">$currNam\@$startContigCoor\@$endContigCoor\n";
        print FTW "$strToWrite\n";
    }
    
    $startContigCoor = $currRegions[$#currRegions]->GetEndCoor()+1;
    $endContigCoor = $seqLens{"$currNam"}-1;
    my $strToWrite = substr($seqText{"$currNam"},$startContigCoor,$endContigCoor-$startContigCoor+1);
    #next if(length($strToWrite) <1000);
    if ($startContigCoor < $endContigCoor) {
        print FTW ">$currNam\@$startContigCoor\@$endContigCoor\n";
        print FTW "$strToWrite\n";
    }
    
    
}





print "$overallSize\n";


my @seqNamesNew = keys %seqText;

for(my $i = 0;$i <= $#seqNamesNew;$i++)
{
    my $currSeqNam = $seqNamesNew[$i];
    my $currSeqText = $seqText{"$currSeqNam"};
    #next if(length($currSeqText) <1000);
    if (not exists $covRanges{"$currSeqNam"}) {
        print FTW ">$currSeqNam\n";
        print FTW "$currSeqText\n";
    }
    
    
    


}


close(FTR_COV);
close(FTW_RANGES);
close(FTW);




