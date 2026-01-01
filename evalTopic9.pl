#!/usr/local/x86_64/bin/perl


use strict;

my %cm = ();
my $labfile = shift;
my $cmatfile = shift;
my $classfile = shift;
my $other;
my $comp_duration = 0;
while($_ = shift @ARGV){
    if(/^\-d$/){
	$comp_duration = 1;
    }elsif(/^\-o$/){
	$other = shift;
    }
}

printf(STDERR "evalTopic9.pl> lab:%s cmat:%s class:%s", $labfile, $cmatfile, $classfile);
if(defined($other)){
    printf(STDERR " other:%s", $other);
}
if($comp_duration == 1){
    printf(STDERR " compute duration based statistics\n");
}else{
    printf(STDERR "\n");
}

my %lab = ();
my %dur = ();
open(LAB, "<$labfile") || die("Cannot read $labfile!\n");
while(<LAB>){
    chomp;
    my ($i, $l) = split(/\s+/, $_, 2);
    if(! defined($other) || $other ne $i){
	$lab{$i} = $l;
        $dur{$i} = 0.0;
    }
}
close(LAB);
my $llen = keys(%lab);


my @class = ();
open(CLS, "<$classfile") || die("Cannot read $classfile!\n");
while(<CLS>){
	chomp;
	my @cols = split(/\s+/);
	push @class, {BT=>$cols[0], ET=>$cols[1], RT=>$cols[2]};
}
close(CLS);

my $num = 0;
my $cor = 0;
my $n = 0;
while(<STDIN>){
    chomp;
    my $org = $_;
    my @cols = split(/\s+/);
    my $bt = $cols[0];
    my $et = $cols[1];
    my $ac = $cols[2];

    if(!defined($cm{$ac})){
	$cm{$ac} = {};
    }
    my $h = $cm{$ac};

    if($bt != $class[$n]->{BT} || $et != $class[$n]->{ET}){
	die("Unexpected line $org found!\n");
    }
    my $c = $class[$n]->{RT}; 
    $n++;

    if(!defined($h->{$c})){
	$h->{$c} = 0;
    }
    if($comp_duration == 1){
        $h->{$c} += $et - $bt;
    }else{
        $h->{$c} ++;
    }
    if($c == $ac){
        if($comp_duration == 1){
             $cor += $et - $bt;
        }else{
	     $cor++;
        }
    }
    if($comp_duration == 1){
        $num += $et - $bt;
    }else{
        $num++;
    }
}
printf("%f\t:Purity = %u / %u\n", $cor/$num, $cor, $num);


open(CMAT, ">$cmatfile") || die("Cannot create $cmatfile!\n");
my @idxs = sort keys(%lab);
my @pre = ();
my @rec = ();
my @fms = ();
my $avpre = 0.0;
my $avrec = 0.0;
my $numrow = 0;
my $numcol = 0;
my @isum = ();
my @jsum = ();
printf(CMAT "%s", "CM");
foreach my $i (@idxs){
    printf(CMAT "\t%7s", $lab{$i});
}
printf(CMAT "\tPrecision\n");
foreach my $i (@idxs){
    printf(CMAT "%s", $lab{$i});
    $isum[$i] = 0;
    foreach my $j (@idxs){
	if(!defined($jsum[$j])){
	    $jsum[$j] = 0;
	}
	$jsum[$j] += $cm{$i}->{$j};
	$isum[$i] += $cm{$i}->{$j};
	printf(CMAT "\t%7u", $cm{$i}->{$j});
    }
    if($isum[$i] == 0){
	$pre[$i] = 0.0;
    }else{
	$pre[$i] = $cm{$i}->{$i}/$isum[$i];
    }
    $avpre += $pre[$i];
    $numrow++;
    printf(CMAT "\t%7.5f\n", $pre[$i]);
}
#$avpre /= $numrow;

my $total = 0;
my $cnum = 0;
printf(CMAT "Recall");
foreach my $j (@idxs){
    if(defined($other) && defined($cm{$other}->{$j}) && $cm{$other}->{$j} > 0){
	printf(STDERR "Found %.1f data labeled as %s and misclassified as %s\n", $cm{$other}->{$j}, $j, $other); 
	$jsum[$j] += $cm{$other}->{$j};
    }
    $total += $jsum[$j];
    $cnum += $cm{$j}->{$j};
    if($jsum[$j] == 0){
	$rec[$j] = -1;
        if($isum[$j] == 0){
            # ignore $j$-th label
	    $numrow--;
	}
    }else{
	$rec[$j] = $cm{$j}->{$j} / $jsum[$j];
        $avrec += $rec[$j];
        $numcol++;
    }
    if($isum[$j] + $jsum[$j] == 0){
        # ignore $j$-th label
	$fms[$j] = -1;
    }else{
	$fms[$j] = 2 * $cm{$j}->{$j} / ($isum[$j] + $jsum[$j]);
    }    
    
    printf(CMAT "\t%7.5f", $rec[$j]);
}
my $acc = $cnum/$total;
printf(CMAT "\t%7.5f\t%u\t%u\n", $acc, $cnum, $total);
$avrec /= $numcol;
$avpre /= $numrow;

$total = 0.0;
$cnum = 0;
printf(CMAT "FMS");
foreach my $j (@idxs){
    if($fms[$j] >= 0){
       $total += $fms[$j];
       $cnum++;
    }
    printf(CMAT "\t%7.5f", $fms[$j]);
}
my $avfms = $total / $cnum;


printf(CMAT "\t%f\t%f\t%f\t%f\n", $avpre, $avrec, $avfms, $acc);
close(CMAT);

    

