package ContigCoveredRegions;

#use strict;

use Region;

sub new {
    
    my $class = shift;
    my $self = bless {} , $class;
    my @arrCovRegions = ();
    
    $self->{"CovRegions"} = \@arrCovRegions;
    $self->{"CountRegions"} = 0;
    $self->{"LenOfContig"} = 0;
    
    
    
    return $self;
}

sub SetLenOfContig{
    my($self) = @_;
    $self->{"LenOfContig"} = $_[1];
}

sub GetLenOfContig{
    my($self) = @_;
    return $self->{"LenOfContig"};
}

sub GetCovRegions{
    my($self) = @_;
    return $self->{"CovRegions"};
}

sub GetCountRegions{
    my($self) = @_;
    return $self->{"CountRegions"};
}



sub AddRegion
{
    my($self) = @_;
    my $region = $_[1];
    
    my $countRegions = $self->{"CountRegions"};
    my $ptrAllRegions = $self->{"CovRegions"};
    
    
    if ($countRegions == 0) {
        $ptrAllRegions->[0] = $region;
        $self->{"CountRegions"} += 1;
        return;
    }
    my $startRegion = $region->Region::GetStartCoor();
    my $endRegion = $region->Region::GetEndCoor();
    #print "$startRegion $endRegion\n";
    if (($startRegion == 2096) && ($endRegion == 3393)) {
        print "Check equal\n";
    }
    my $isAdded = 0;
    for(my $i = 0; $i < $countRegions;$i++)
    {
        my $currRegion = $ptrAllRegions->[$i];
        if ($currRegion->Region::CheckInclusion($region->Region::GetStartCoor(),$region->Region::GetEndCoor()) == 1) {
            if (($startRegion == 2096) && ($endRegion == 3393)) {
                print "Check inclusion\n";
            }
            
            $isAdded = 1;
            last;
        }
        
        if (($currRegion->Region::CheckIntersection($region->Region::GetStartCoor(),$region->Region::GetEndCoor()) == 1)
            || ($currRegion->Region::CheckIfRangesGoesSequential($region->Region::GetStartCoor(),$region->Region::GetEndCoor()) == 1)) {
            if (($startRegion == 2096) && ($endRegion == 3393)) {
                print "Check intersection\n";
            }
            $currRegion->Region::MergeRegions($region->Region::GetStartCoor(),$region->Region::GetEndCoor());
            $isAdded = 1;
            last;
        }
        
        if ($currRegion->Region::CheckLessThen($region->Region::GetStartCoor(),$region->Region::GetEndCoor()) == 1) {
            if (($startRegion == 2096) && ($endRegion == 3393)) {
                print "Check less\n";
            }
            next;
        }
        
        if ($currRegion->Region::CheckGreaterThen($region->Region::GetStartCoor(),$region->Region::GetEndCoor()) == 1) {
            if (($startRegion == 2096) && ($endRegion == 3393)) {
                print "Check greater\n";
            }
            my @arrNewCovRegion = ();
            
            for(my $j = 0; $j<$i;$j++)
            {
                $arrNewCovRegion[$j] = $ptrAllRegions->[$j];
                
            
            }
            $arrNewCovRegion[$#arrNewCovRegion+1] = $region;
            for(my $j = $i; $j < $countRegions;$j++)
            {
                $arrNewCovRegion[$#arrNewCovRegion+1] = $ptrAllRegions->[$j];
            }
            $self->{"CovRegions"} = \@arrNewCovRegion;
            $self->{"CountRegions"} = $#arrNewCovRegion+1;
            $isAdded = 1;
            last;
        }
    }
    if ($isAdded == 0) {
        $ptrAllRegions->[$countRegions] = $region;
        $self->{"CountRegions"} += 1;
    }
    
    
    
}


sub MergeIntersectedRegions
{
    my($self) = @_;
    
    my @arrNew = ();
    my $ptrAllRegions = $self->{"CovRegions"};
    my $countRegions = $self->{"CountRegions"};
    $self->{"CovRegions"} = \@arrNew;
    $self->{"CountRegions"} = 0;
    
    
    for(my $i = 0; $i < $countRegions;$i++)
    {
        my $currRegion = $ptrAllRegions->[$i];
        $self->ContigCoveredRegions::AddRegion($currRegion);
    
    }
    
}

sub GetUncovRegions
{
    my($self) = @_;
    my $ptrAllRegions = $self->{"CovRegions"};
    my $countRegions = $self->{"CountRegions"};
    my $lenOfContig = $self->{"LenOfContig"};
    my @retVal = ();
    #print "$countRegions\n";
    if ($countRegions == 0) {
        my $currRegion = Region->new();
        $currRegion->Region::SetStartCoor(0);
        $currRegion->Region::SetEndCoor($lenOfContig-1);
        #$startCoorTemp = $currRegion->Region::GetStartCoor();
        #$endCoorTemp = $currRegion->Region::GetEndCoor();
        #print "$startCoorTemp $endCoorTemp\n";
        $retVal[0] = $currRegion;
        #print "countRegions == 0 $currRegion\n";
        return \@retVal;
    }
    
    my $startCoorTemp = 0;
    my $endCoorTemp = 0;
    if ($ptrAllRegions->[0]->Region::GetStartCoor() > 0) {
        my $currRegion = Region->new();
        $currRegion->Region::SetStartCoor(0);
        $currRegion->Region::SetEndCoor($ptrAllRegions->[0]->Region::GetStartCoor()-1);
        #$startCoorTemp = $currRegion->Region::GetStartCoor();
        #$endCoorTemp = $currRegion->Region::GetEndCoor();
        #print "$startCoorTemp $endCoorTemp\n";
        $retVal[0] = $currRegion;
        #print "ptrAllRegions->[0]->Region::GetStartCoor() > 0 $currRegion\n";
    }
    if ($countRegions > 1) {
        for(my $i = 0;$i < ($countRegions-1); $i++)
        {
            my $currRegion = Region->new();
            $currRegion->Region::SetStartCoor($ptrAllRegions->[$i]->Region::GetEndCoor()+1);
            $currRegion->Region::SetEndCoor($ptrAllRegions->[$i+1]->Region::GetStartCoor()-1);
            $startCoorTemp = $currRegion->Region::GetStartCoor();
            $endCoorTemp = $currRegion->Region::GetEndCoor();
            if ($startCoorTemp > $endCoorTemp) {
                my $startTemp = $ptrAllRegions->[$i]->Region::GetStartCoor();
                my $endTemp = $ptrAllRegions->[$i+1]->Region::GetEndCoor();
                #print "$startTemp $startCoorTemp $endCoorTemp $endTemp $i $countRegions\n";
            }
            
            #print "$startCoorTemp $endCoorTemp\n";
            $retVal[$#retVal+1] = $currRegion;
        }
        #print "countRegions > 1 $currRegion\n";
    }
    
    if ($ptrAllRegions->[$countRegions-1]->Region::GetEndCoor() < ($lenOfContig-1)) {
        my $currRegion = Region->new();
        $currRegion->Region::SetStartCoor($ptrAllRegions->[$countRegions-1]->Region::GetEndCoor()+1);
        $currRegion->Region::SetEndCoor($lenOfContig-1);
        #$startCoorTemp = $currRegion->Region::GetStartCoor();
        #$endCoorTemp = $currRegion->Region::GetEndCoor();
        #print "$startCoorTemp $endCoorTemp\n";
        $retVal[$#retVal+1] = $currRegion;
        #print "ptrAllRegions->[countRegions-1]->Region::GetEndCoor() < (lenOfContig-1) $currRegion\n";
    }
    return \@retVal;
}

sub AddCovRegions
{
    my($self) = @_;
    my $ptrArrCovRegions = $_[1]->ContigCoveredRegions::GetCovRegions();
    my @arrCovRegions = @$ptrArrCovRegions;
    for(my $i = 0;$i <= $#arrCovRegions;$i++)
    {
        $self->ContigCoveredRegions::AddRegion($arrCovRegions[$i]);
        
    }
    $self->ContigCoveredRegions::MergeIntersectedRegions();
}

sub CheckInclusionRegion
{
    my($self) = @_;
    my $regionToCheck = $_[1];
    my $startCoorToCheck = $regionToCheck->GetStartCoor();
    my $endCoorToCheck = $regionToCheck->GetEndCoor();
    
    my $ptrArrCovRegions = $self->{"CovRegions"};
    my @arrCovRegions = @$ptrArrCovRegions;
    
    
    
    for(my $i = 0;$i <= $#arrCovRegions;$i++)
    {
        if ($arrCovRegions[$i]->Region::CheckInclusion($startCoorToCheck,$endCoorToCheck) == 1) {
            return 1;
        }
    }
    
    return 0;
    
}

sub CheckInclusionIntersectionRegion
{
    my($self) = @_;
    my $regionToCheck = $_[1];
    my $startCoorToCheck = $regionToCheck->GetStartCoor();
    my $endCoorToCheck = $regionToCheck->GetEndCoor();
    
    my $ptrArrCovRegions = $self->{"CovRegions"};
    my @arrCovRegions = @$ptrArrCovRegions;
    
    
    
    for(my $i = 0;$i <= $#arrCovRegions;$i++)
    {
        my $currRegion = $arrCovRegions[$i];
        
        if ($currRegion->Region::CheckInclusion($startCoorToCheck,$endCoorToCheck) == 1) {
            #print "currRegion - $currRegion\n";
            return $currRegion;
        }
        
        if ($currRegion->Region::CheckIntersection($startCoorToCheck,$endCoorToCheck) == 1) {
            my $newRegion = Region->new;
            $newRegion->SetStartCoor($currRegion->GetStartCoor());
            $newRegion->SetEndCoor($currRegion->GetEndCoor());
            
            $newRegion->MergeRegions($newRegion);
            return $newRegion;
        }
        
        
    }
    
    my $notRegion = Region->new();
    $notRegion->SetStartCoor(-1);
    $notRegion->SetEndCoor(-1);
    
    return $notRegion;
    
}



sub CheckInclusionCovRegions
{
    my($self) = @_;
    my $covRegionsCheck = $_[1];
    
    my $ptrArrCovRegions = $self->{"CovRegions"};
    my @arrCovRegions = @$ptrArrCovRegions;
    
    my $covRegionStart = $arrCovRegions[0]->Region::GetStartCoor();
    my $covRegionEnd = $arrCovRegions[$#arrCovRegions]->Region::GetEndCoor();
    
    
    my $ptrArrCovRegionsCheck = $covRegionsCheck->ContigCoveredRegions::GetCovRegions();
    my @arrCovRegionsCheck = @$ptrArrCovRegionsCheck;
    
    my $covRegionCheckStart = $arrCovRegionsCheck[0]->Region::GetStartCoor();
    my $covRegionCheckEnd = $arrCovRegionsCheck[$#arrCovRegionsCheck]->Region::GetEndCoor();
    
    if (($covRegionEnd < $covRegionCheckStart) || ($covRegionCheckEnd < $covRegionStart)) {
        return 0;
    }
    
    
    my $isAllInclude = 0;
    
    
    
    for(my $i = 0;$i <= $#arrCovRegionsCheck;$i++)
    {
        my $isIncludeFound = 0;
        for(my $j = 0;$j <= $#arrCovRegions;$j++)
        {
            if ($arrCovRegions[$i]->ContigCoveredRegions::CheckInclusionRegion($arrCovRegionsCheck[$i]) == 1) {
                $isIncludeFound = 1;
            }
            
        }
        if ($isIncludeFound == 0) {
            return 0;
        }
        
        
    }
    
    return 1;
    
}

sub CountIntersectionAndSubstraction
{
    my($self) = @_;
    my $secondCovRegions = $_[1];
    
    my $firstSubstractCovRegions = ContigCoveredRegions->new();
    my $secondSubstractCovRegions = ContigCoveredRegions->new();
    my $intersectionCovRegions = ContigCoveredRegions->new();
    
    my $ptrArrCovRegionsFirst = $self->{"CovRegions"};
    my $ptrArrCovRegionsSecond = $secondCovRegions->GetCovRegions();
    my $isIntersectionFound = 0;
    
    
    
    
    for(my $i = 0; $i <= $#$ptrArrCovRegionsFirst;$i++)
    {
        my $firstRegion = $ptrArrCovRegionsFirst->[$i];
        
        my $startCoorFirst = $firstRegion->GetStartCoor();
        my $endCoorFirst = $firstRegion->GetEndCoor();
        $isIntersectionFound = 0;
        for(my $j = 0;$j <= $#$ptrArrCovRegionsSecond;$j++)
        {
            my $secondRegion = $ptrArrCovRegionsSecond->[$i];
            my $startCoorSecond = $secondRegion->GetStartCoor();
            my $endCoorSecond = $secondRegion->GetEndCoor();
            if ($firstRegion->CheckIntersection($startCoorSecond,$endCoorSecond) == 1) {
                $isIntersectionFound = 1;
                last;
            }
        }
        if ($isIntersectionFound == 0) {
            $firstSubstractCovRegions->AddRegion($firstRegion);
        }
    }
    
    $isIntersectionFound = 0;
    for(my $i = 0; $i <= $#$ptrArrCovRegionsSecond;$i++)
    {
        my $secondRegion = $ptrArrCovRegionsSecond->[$i];
        
        my $startCoorSecond = $secondRegion->GetStartCoor();
        my $endCoorSecond = $secondRegion->GetEndCoor();
        $isIntersectionFound = 0;
        for(my $j = 0;$j <= $#$ptrArrCovRegionsFirst;$j++)
        {
            my $firstRegion = $ptrArrCovRegionsFirst->[$i];
            my $startCoorFirst = $firstRegion->GetStartCoor();
            my $endCoorFirst = $firstRegion->GetEndCoor();
            if ($secondRegion->CheckIntersection($startCoorFirst,$endCoorFirst) == 1) {
                $isIntersectionFound = 1;
                last;
            }
        }
        if ($isIntersectionFound == 0) {
            $secondSubstractCovRegions->AddRegion($secondRegion);
        }
    }
    
    for(my $i = 0; $i <= $#$ptrArrCovRegionsFirst;$i++)
    {
        my $firstRegion = $ptrArrCovRegionsFirst->[$i];
        
        my $startCoorFirst = $firstRegion->GetStartCoor();
        my $endCoorFirst = $firstRegion->GetEndCoor();
        $isIntersectionFound = 0;
        for(my $j = 0;$j <= $#$ptrArrCovRegionsSecond;$j++)
        {
            my $secondRegion = $ptrArrCovRegionsSecond->[$i];
            my $startCoorSecond = $secondRegion->GetStartCoor();
            my $endCoorSecond = $secondRegion->GetEndCoor();
            if ($firstRegion->CheckIntersection($startCoorSecond,$endCoorSecond) == 1) {
                
                (my $firstUncovRegion,my $secondUncovRegion,my $intersectRegion) = $firstRegion->GetIntersectionRegion();
                $firstSubstractCovRegions->AddRegion($firstUncovRegion);
                $secondSubstractCovRegions->AddRegion($secondUncovRegion);
                $intersectionCovRegions->AddRegion($intersectRegion);
                last;
            }
        }
    }
    return ($firstSubstractCovRegions,$secondSubstractCovRegions,$intersectionCovRegions);
    
}


sub GetCovRegionsSize
{
    my($self) = @_;
    
    my $ptrArrCovRegions = $self->{"CovRegions"};
    my $covSize = 0;
    for(my $i = 0; $i <= $#$ptrArrCovRegions;$i++)
    {
        $covSize += ($ptrArrCovRegions->[$i]->GetEndCoor() - $ptrArrCovRegions->[$i]->GetStartCoor())
    }
    return $covSize;
    
}



return true;