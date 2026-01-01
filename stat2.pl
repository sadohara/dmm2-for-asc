#!/usr/bin/perl

my $unbiased = 1;  # unbiased variance
my $idx = shift;
while($_ = shift @ARGV){
	if(/^\-u$/){
		$unbiased = 0;
	}
}

my @fix = ();
my @sum = ();
my @sum2 = ();
my $n=0;
my $nc;
while(<STDIN>){
    chomp;
    my $org = $_;
    my @cols = split(/\s+/);
    if(!defined($nc)){
	$nc = @cols;
    }else{
	if($nc != @cols){
	    die("The number of columns is wrong! $org");
	}
    }

    if(! defined($fix[$idx])){
	for(my $i=0; $i<=$idx; $i++){
	    push @fix, $cols[$i];
	}
    }else{
	for(my $i=0; $i<=$idx; $i++){
	    if($cols[$i] ne $fix[$i]){
		$fix[$i] = "*";
	    }
	}
    }

    for(my $i=$idx+1; $i<$nc; $i++){
	my $j = $i - $idx - 1;
	if(!defined($sum[$j])){
	    $sum[$j] = 0.0;
	    $sum2[$j] = 0.0;
	}
	$sum[$j] += $cols[$i];
	$sum2[$j] += $cols[$i] * $cols[$i];
    }
    $n++;
}

for(my $i=0; $i<=$idx; $i++){
    printf("%s\t", $fix[$i]);
}
printf("%u", $n);
for(my $i=$idx+1; $i<$nc; $i++){
    my $j = $i - $idx - 1;
    my $ave = $sum[$j] / $n;
    if($unbiased == 1 && $n > 1){
    	my $v2 = $sum2[$j] / ($n-1) - $ave * $ave * $n / ($n-1);
	if($v2 < 0){
		$v2 = 0;
	}else{
		$v2 = sqrt($v2);
	}
    	printf("\t%e\t%e", $ave, $v2);
    }else{
	my $v2 = $sum2[$j] / $n - $ave * $ave;
	if($v2 < 0){
		$v2 = 0;
	}else{
		$v2 = sqrt($v2);
	}
    	printf("\t%e\t%e", $ave, $v2);
    }
}
printf("\n");

	    
		

