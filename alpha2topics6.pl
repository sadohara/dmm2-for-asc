#!/usr/bin/perl


use strict;

my $numdir = shift;
my $prefix = shift;
my $suffix = shift;
my %topics = ();
while(($_ = shift @ARGV) ne ""){
	if(/^-T$/){
		$_ = shift @ARGV;
		foreach my $t (split(/,/)){
			$topics{$t} = 1;
		}
	}
}
my @selected = keys(%topics);
my $num_selected = @selected;
printf(STDERR "alpha2topics6.pl: numdir=%s, prefix=%s, suffix=%s, selected=%s(%u)\n", $numdir, $prefix, $suffix, join(',', @selected), $num_selected);

my %ts = ();
while($_ = glob("$numdir/*.num")){
    my $numfile = $_;
    my @ps = split(/\//);
    $_ = pop @ps;
    s/\.num//;
    my $key = $_;
    $ts{$key} = [];
    my $r = $ts{$key};
    open(NUM, "<$numfile") || die("Cannot open $numfile!\n");
    while(<NUM>){
	    chomp;
	    my @cols = split(/\t/);
	    push @$r, {BT=>$cols[0], ET=>$cols[1]};
    }
    close(NUM);
}

while(<STDIN>){
    chomp;
    my $filename = $_;
    my @ps = split(/\//);
    $_ = pop @ps;
    if($prefix ne "None"){
    	s/^$prefix//;
    }
    if($suffix ne "None"){
    	s/$suffix$//;
    }
    my $key = $_;
    #printf(STDERR "key=%s (%s)\n", $key, $filename);
    if(!defined($ts{$key})){
	    die("Cannot find any numfile for $key\n");
    }
    my $tstamps = $ts{$key};
    my @tpcs = ();
    if($filename =~ m/.*\.gz$/){
    	open(POST, "zcat $filename |") || die("Cannot open $filename!\n");
    }else{
        open(POST, "<$filename") || die("Cannot open $filename!\n");
    }
    printf(STDERR "Processing %s with %s/%s.num...\n", $filename, $numdir, $key);
    while(<POST>){
    	chomp;
	my @cols = split(/\s+/);
    	my $sum = 0.0;
    	my $num = 0;
    	my $maxp;
    	my $maxt;
	my $t=0;
	my @ps = ();
    	foreach my $p (@cols){
		push @ps, {T=>$t, P=>$p};
		$num++;
		$sum += $p;
		if(!defined($maxt) || $p > $maxp){
		    $maxp = $p;
		    $maxt = $t;
		}
		$t++;
    	}
	#printf(STDERR "maxt=%s, maxp=%e, sum=%e\n", $maxt, $maxp, $sum);
	if($num_selected > 0){
		my @sorted = sort {$b->{P} <=> $a->{P} || $a->{T} cmp $b->{T}} @ps;
		foreach my $e (@sorted){
			if(defined($topics{$e->{T}})){
				if($maxt ne $e->{T}){
					printf(STDERR "%s is not defined, so it is replaced with (%s, %e)\n", $maxt, $e->{T}, $e->{P});
				}
				$maxt = $e->{T};
				$maxp = $e->{P};
				last;
			}
		}
	}

	push @tpcs, {MAXT=>$maxt, MAXA=>$maxp, SUM=>$sum};
    }
    my $len1 = @$tstamps;
    my $len2 = @tpcs;
    #printf(STDERR "%u ? %u\n", $len1, $len2);
    if($len1 != $len2){
	    die("Wrong number of line for $key!\n");
    }
    my $i = 0;
    foreach my $t (@$tstamps){
    	printf("%f\t%f\t%u\t%f\t%f / %f\n", $t->{BT}, $t->{ET}, $tpcs[$i]->{MAXT}, $tpcs[$i]->{MAXA}/$tpcs[$i]->{SUM}, $tpcs[$i]->{MAXA}, $tpcs[$i]->{SUM});
	$i++;
    }
}

