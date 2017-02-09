use strict;

my $cbpCbpFile = $ARGV[0];
my $orderFileA = $ARGV[1];
my $listFileA = $ARGV[2];
my $orderFileB = $ARGV[3];
my $listFileB = $ARGV[4];
my $outFile = $ARGV[5];


open(FTW,">$outFile") or die;

my %scaffsListA = ();
my %genesListA = ();
my %scaffsListB = ();
my %genesListB = ();

open(FTR,"<$listFileA") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    $scaffsListA{"$input"} = 1;
}

close(FTR);


open(FTR,"<$orderFileA") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $scaffNam = $arrInp[0];
    my $gNam = $arrInp[1];
    
    if (exists $scaffsListA{"$scaffNam"}) {
	$genesListA{"$gNam"} = 1;
    }
}

close(FTR);


open(FTR,"<$listFileB") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    $scaffsListB{"$input"} = 1;
}

close(FTR);


open(FTR,"<$orderFileB") or die;

while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    my $scaffNam = $arrInp[0];
    my $gNam = $arrInp[1];
    
    if (exists $scaffsListB{"$scaffNam"}) {
	$genesListB{"$gNam"} = 1;
    }
}

close(FTR);


my %writedList = ();
open(FTR,"<$cbpCbpFile") or die;


while (my $input = <FTR>) {
    chomp($input);
    
    my @arrInp = split(/\t/,$input);
    
    my $cbp1Nam = $arrInp[0];
    my $cbp2Nam = $arrInp[1];
    my $ident = $arrInp[2];
    
    next if($cbp1Nam eq $cbp2Nam);
    
    if ((exists $genesListA{"$cbp1Nam"}) && (exists $genesListB{"$cbp2Nam"})) {
	next if(exists $writedList{"$cbp1Nam\t$cbp2Nam\t$ident"});
	$writedList{"$cbp1Nam\t$cbp2Nam\t$ident"} = 1;
	print FTW "$cbp1Nam\t$cbp2Nam\t$ident\n";
    }
    else
    {
	if ((exists $genesListB{"$cbp1Nam"}) && (exists $genesListA{"$cbp2Nam"})) {
	    next if(exists $writedList{"$cbp2Nam\t$cbp1Nam\t$ident"});
	    $writedList{"$cbp2Nam\t$cbp1Nam\t$ident"} = 1;
	    print FTW "$cbp2Nam\t$cbp1Nam\t$ident\n";
	}
	else
	{
	    next;
	}
    }
}


close(FTR);


close(FTW);