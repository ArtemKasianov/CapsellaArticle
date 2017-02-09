package Region;

#use strict;


sub new {
    
    my $class = shift;
    my $self = bless {} , $class;
    $self->{"StartCoor"} = 0;
    $self->{"EndCoor"} = 0;
    return $self;
}

sub SetStartCoor{
    my($self) = @_;
    $self->{"StartCoor"} = $_[1];
}

sub SetEndCoor{
    my($self) = @_;
    $self->{"EndCoor"} = $_[1];
}

sub GetStartCoor{
    my($self) = @_;
    return $self->{"StartCoor"};
}

sub GetEndCoor{
    my($self) = @_;
    return $self->{"EndCoor"};
}

sub CheckInclusion
{
    my($self) = @_;
    my $startNewVal = $_[1];
    my $endNewVal = $_[2];
    
    my $startCoor = $self->{"StartCoor"};
    my $endCoor = $self->{"EndCoor"};
    
    if (($startCoor <= $startNewVal) && ($endCoor >= $endNewVal)) {
        return 1;
    }
    else
    {
        return 0
    }
}

sub GetIntersectionRegion
{
    my($self) = @_;
    my $secondRegion = $_[1];
    
    my $startCoorFirst = $self->{"StartCoor"};
    my $endCoorFirst = $self->{"EndCoor"};
    
    my $startCoorSecond = $secondRegion->GetStartCoor();
    my $endCoorSecond = $secondRegion->GetEndCoor();
    
    my $firstUncovRegion = Region->new();
    my $intersectRegion = Region->new();
    my $secondUncovRegion = Region->new();
    
    if ($startCoorFirst >= $startCoorSecond) {
        
        
        $firstUncovRegion->SetStartCoor($endCoorSecond+1);
        $firstUncovRegion->SetEndCoor($endCoorFirst);
        $secondUncovRegion->SetStartCoor($startCoorSecond);
        $secondUncovRegion->SetEndCoor($startCoorFirst-1);
        $intersectRegion->SetStartCoor($startCoorFirst);
        $intersectRegion->SetEndCoor($endCoorSecond);
        
    }
    else
    {
        $firstUncovRegion->SetStartCoor($startCoorFirst);
        $firstUncovRegion->SetEndCoor($startCoorSecond - 1);
        $secondUncovRegion->SetStartCoor($endCoorFirst + 1);
        $secondUncovRegion->SetEndCoor($endCoorSecond);
        $intersectRegion->SetStartCoor($startCoorSecond);
        $intersectRegion->SetEndCoor($endCoorFirst);
    }
    
    
    
    return ($firstUncovRegion,$secondUncovRegion,$intersectRegion);
    
    
    
}

sub CheckIntersection
{
    my($self) = @_;
    my $startNewVal = $_[1];
    my $endNewVal = $_[2];
    
    my $startCoor = $self->{"StartCoor"};
    my $endCoor = $self->{"EndCoor"};
    
    if ((($startCoor >= $startNewVal) && ($startCoor <= $endNewVal)) || (($endCoor >= $startNewVal) && ($endCoor <= $endNewVal))
        || (($startCoor >= $startNewVal) && ($endCoor <= $endNewVal))) {
        return 1;
    }
    else
    {
        
        return 0;
    }
}

sub CheckIfRangesGoesSequential
{
    my($self) = @_;
    my $startNewVal = $_[1];
    my $endNewVal = $_[2];
    
    my $startCoor = $self->{"StartCoor"};
    my $endCoor = $self->{"EndCoor"};
    #print "endCoor - $endCoor startNewVal - $startNewVal\n";
    if (($endCoor+1) == ($startNewVal) || ($startCoor-1) == ($endNewVal)) {
        #print "here\n";
        return 1;
    }
    else
    {
        
        return 0;
    }
}


sub CheckGreaterThen
{
    my($self) = @_;
    my $startNewVal = $_[1];
    my $endNewVal = $_[2];
    
    my $startCoor = $self->{"StartCoor"};
    my $endCoor = $self->{"EndCoor"};
    
    if (($startCoor > $endNewVal)) {
        return 1;
    }
    else
    {
        return 0;
    }
}

sub CheckLessThen
{
    my($self) = @_;
    my $startNewVal = $_[1];
    my $endNewVal = $_[2];
    
    my $startCoor = $self->{"StartCoor"};
    my $endCoor = $self->{"EndCoor"};
    
    if (($endCoor < $startNewVal)) {
        return 1;
    }
    else
    {
        return 0;
    }
}

sub MergeRegions
{
    my($self) = @_;
    my $startNewVal = $_[1];
    my $endNewVal = $_[2];
    
    my $startCoor = $self->{"StartCoor"};
    my $endCoor = $self->{"EndCoor"};
    
    if ($startCoor > $startNewVal) {
        $self->{"StartCoor"} = $startNewVal;
    }
    
    if ($endCoor < $endNewVal) {
        $self->{"EndCoor"} = $endNewVal;
    }
    
    
}



sub GetStrToPrint
{
    my($self) = @_;
    my $startCoor = $self->{"StartCoor"};
    my $endCoor = $self->{"EndCoor"};
    my $strToPrint = "$startCoor\t$endCoor";
}

sub CheckEqual
{
    my($self) = @_;
    my $regionIn = $_[1];
    
    my $startCoorIn = $regionIn->GetStartCoor();
    my $endCoorIn = $regionIn->GetEndCoor();
    
    my $startCoor = $self->{"StartCoor"};
    my $endCoor = $self->{"EndCoor"};
    
    if (($startCoorIn == $startCoor) && ($endCoor == $endCoorIn)) {
        return 1;
    }
    
    return 0;
    
    
    
}

return true;