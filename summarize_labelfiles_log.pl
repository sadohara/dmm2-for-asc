#!/usr/bin/perl
#
#


my @tbl = ();
my @ks = ();
while(<STDIN>){
	chomp;
	open(LOG, "<$_") || die("Cannot open $_");
	push @tbl, {};
	@ks = ();
	while(<LOG>){
		chomp;
		if($_ =~ /^(\d+)\s+(\S+)\:\s+(\d+)\/.*min =\s+(\d+)\.0.*max =\s+(\d+)\.0.*$/){
		
			my $h = $tbl[$#tbl]; 
			push @ks, $2;
		        $h->{$2} = {CTR=>$3, MIN=>$4, MAX=>$5};
			#printf("%s\t%u\t%u\t%u\n", $2, $3, $4, $5);
			#printf("%s\t%u\t%u\t%u\n", $2, $h->{$2}->{CTR}, $h->{$2}->{MIN}, $h->{$2}->{MAX});
		}
	}
	close(LOG);
}


my $t = 0;
my $num = 0;
foreach my $k (@ks){
	my $sum = 0;
	my $min = -1;
	my $max = 0;
	$num = @tbl; 
	foreach my $h (@tbl){
		my $c = $h->{$k}->{CTR};
		$sum += $c;
		if($min < 0 || $c < $min){
			$min = $c;
		}
		if($c > $max){
			$max = $c;
		}
	}
	printf("%s & %.1f & %u & %u & %u\n", $k, $sum/$num, $min, $max, $sum);
	$t += $sum;
}

my $t2 = 0;
my $tmin = -1;
my $tmax = 0;
foreach my $h (@tbl){
	my $sum = 0;
	foreach my $k (@ks){
		my $c = $h->{$k}->{CTR};
		$sum += $c;
	}
	printf(STDERR "%u ", $sum);
	$t2 += $sum;
	if($tmin < 0 || $sum < $tmin){
		$tmin = $sum;
	}
	if($sum > $tmax){
		$tmax = $sum;
	}
}
if($t != $t2){
	die("$t !+ $t2!");
}
printf(STDERR "\n");
printf("%u / %u = & %.1f & %u & %u\n", $t, $num, $t/$num, $tmin, $tmax);


