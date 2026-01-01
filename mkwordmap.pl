#!/usr/bin/perl
#

use strict;

my $null;
my $force0null = 0;
while($_ = shift @ARGV){
	if(/^\-n$/){
		$null = shift @ARGV;
	}elsif(/^\-N$/){
		$force0null = 1;
	}
}

my %ws = ();
my $i = 1;
while(<STDIN>){
	chomp;
	my ($bt, $et, $ev) = split(/\t/);
	foreach my $w (split(/\s+/, $ev)){
		if(!defined($ws{$w})){
			if(defined($null) && $w eq $null){
				$ws{$w} = 0;
			}else{
				$ws{$w} = $i;
				$i++;
			}
		}
	}
}

if(defined($null) && $force0null == 1 && !defined($ws{$null})){
	$ws{$null} = 0;
}

my $wlen = keys(%ws);
printf("%u\n", $wlen);

if(defined($null) && ($force0null == 1 || defined($ws{$null}))){
	printf("%s\t%d\n", $null, 0);
}

foreach my $w (sort {$ws{$a} <=> $ws{$b}} keys(%ws)){
	if($w ne $null){
		printf("%s\t%d\n", $w, $ws{$w});
	}
}


