use ExtUtils::testlib;
use Statistics::Descriptive::Discrete;
my $aleResult = $ARGV[0];
my $outFile = $ARGV[1];




open(FTR,"<$aleResult") or die;
open(FTW,">$outFile") or die;




my %statsDepth = ();
my %statsDepthLike = ();
my %statsPlaceLike = ();
my %statsInsertLike = ();
my %statsKmerLike = ();
my %lenOfSeq = ();

while (my $input = <FTR>) {
    next if(substr($input,0,1) eq "#");
    my @arrInp = split(/\s+/,$input);
    my $currName = $arrInp[0];
    #print "$currName\n";
    my $currPos = $arrInp[1];
    my $currDepth = $arrInp[2];
    my $currDepthLike = $arrInp[3];
    my $currPlaceLike = $arrInp[4];
    my $currInsertLike = $arrInp[5];
    my $currKmerLike = $arrInp[6];
    
    if (not exists $statsDepth{"$currName"})
    {
        $statsDepth{"$currName"} = Statistics::Descriptive::Discrete->new();
        $statsDepthLike{"$currName"} = Statistics::Descriptive::Discrete->new();
        $statsPlaceLike{"$currName"} = Statistics::Descriptive::Discrete->new();
        $statsInsertLike{"$currName"} = Statistics::Descriptive::Discrete->new();
        $statsKmerLike{"$currName"} = Statistics::Descriptive::Discrete->new();
        $lenOfSeq{"$currName"} = 0;
    }
    
    $statsDepth{"$currName"}->add_data($currDepth);
    $statsDepthLike{"$currName"}->add_data($currDepthLike);
    $statsPlaceLike{"$currName"}->add_data($currPlaceLike);
    $statsInsertLike{"$currName"}->add_data($currInsertLike);
    $statsKmerLike{"$currName"}->add_data($currKmerLike);
    $lenOfSeq{"$currName"} += 1;
}

my @conNames = keys %statsDepth;
my $sizeOfConNames = $#conNames+1;
print "$sizeOfConNames\n";
for(my $i = 0;$i <=$#conNames;$i++)
{
    my $currConNam = $conNames[$i];
    print "$currConNam\n";
    my $len = $lenOfSeq{"$currConNam"};
    print FTW ">$currConNam\t$len\n";
    my $minDepth = $statsDepth{"$currConNam"}->min();
    my $maxDepth = $statsDepth{"$currConNam"}->max();
    my $meanDepth = $statsDepth{"$currConNam"}->mean();
    my $medianDepth = $statsDepth{"$currConNam"}->median();
    my $varianceDepth = $statsDepth{"$currConNam"}->variance();
    my $sdDepth = $statsDepth{"$currConNam"}->standard_deviation();
    
    print FTW "Depth\t$minDepth\t$maxDepth\t$meanDepth\t$medianDepth\t$varianceDepth\t$sdDepth\n";
    my $minDepthLike = $statsDepthLike{"$currConNam"}->min();
    my $maxDepthLike = $statsDepthLike{"$currConNam"}->max();
    my $meanDepthLike = $statsDepthLike{"$currConNam"}->mean();
    my $medianDepthLike = $statsDepthLike{"$currConNam"}->median();
    my $varianceDepthLike = $statsDepthLike{"$currConNam"}->variance();
    my $sdDepthLike = $statsDepthLike{"$currConNam"}->standard_deviation();
    print FTW "DepthLike\t$minDepthLike\t$maxDepthLike\t$meanDepthLike\t$medianDepthLike\t$varianceDepthLike\t$sdDepthLike\n";
    my $minPlaceLike = $statsPlaceLike{"$currConNam"}->min();
    my $maxPlaceLike = $statsPlaceLike{"$currConNam"}->max();
    my $meanPlaceLike = $statsPlaceLike{"$currConNam"}->mean();
    my $medianPlaceLike = $statsPlaceLike{"$currConNam"}->median();
    my $variancePlaceLike = $statsPlaceLike{"$currConNam"}->variance();
    my $sdPlaceLike = $statsPlaceLike{"$currConNam"}->standard_deviation();
    print FTW "PlaceLike\t$minPlaceLike\t$maxPlaceLike\t$meanPlaceLike\t$medianPlaceLike\t$variancePlaceLike\t$sdPlaceLike\n";
    my $minInsertLike = $statsInsertLike{"$currConNam"}->min();
    my $maxInsertLike = $statsInsertLike{"$currConNam"}->max();
    my $meanInsertLike = $statsInsertLike{"$currConNam"}->mean();
    my $medianInsertLike = $statsInsertLike{"$currConNam"}->median();
    my $varianceInsertLike = $statsInsertLike{"$currConNam"}->variance();
    my $sdInsertLike = $statsInsertLike{"$currConNam"}->standard_deviation();
    print FTW "InsertLike\t$minInsertLike\t$maxInsertLike\t$meanInsertLike\t$medianInsertLike\t$varianceInsertLike\t$sdInsertLike\n";
    my $minKmerLike = $statsKmerLike{"$currConNam"}->min();
    my $maxKmerLike = $statsKmerLike{"$currConNam"}->max();
    my $meanKmerLike = $statsKmerLike{"$currConNam"}->mean();
    my $medianKmerLike = $statsKmerLike{"$currConNam"}->median();
    my $varianceKmerLike = $statsKmerLike{"$currConNam"}->variance();
    my $sdKmerLike = $statsKmerLike{"$currConNam"}->standard_deviation();
    print FTW "KmerLike\t$minKmerLike\t$maxKmerLike\t$meanKmerLike\t$medianKmerLike\t$varianceKmerLike\t$sdKmerLike\n";

}



close(FTR);
close(FTW);

