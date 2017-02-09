use strict;



my $contigsAList = $ARGV[0];
my $contigsBList = $ARGV[1];
my $badContigsAList = $ARGV[2];
my $badContigsBList = $ARGV[3];
my $outA = $ARGV[4];
my $outB = $ARGV[5];


my %badA = ();
my %badB = ();


open(FTR,"<$badContigsAList") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    $badA{"$input"} = 1;
}



close(FTR);


open(FTR,"<$badContigsBList") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    $badB{"$input"} = 1;
}



close(FTR);


open(FTW,">$outA") or die;
open(FTR,"<$contigsAList") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    next if (exists $badA{"$input"});
    
    
    print FTW "$input\n";
    
    
}


close(FTW);
close(FTR);


open(FTW,">$outB") or die;
open(FTR,"<$contigsBList") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    next if (exists $badB{"$input"});
    
    
    print FTW "$input\n";
    
    
}


close(FTW);
close(FTR);
