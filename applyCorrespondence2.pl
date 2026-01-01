#!/usr/local/bin/perl

use strict;

my $corfile = shift;
my $version = "1.0";
my $other = 0;
while($_ = shift @ARGV){
	if(/^\-O$/){
		$other = shift @ARGV;
	}
}

printf(STDERR ">>applyCorrespondence2.pl ver.%s other=%s\n", $version, $other);

#my $labfile = shift;

my %e2t = ();
open(COR, "<$corfile") || die("Cannot open $corfile!\n");
while(<COR>){
    chomp;
    my ($e, $t) = split(/\t/);
    if(!defined($e2t{$e})){
	$e2t{$e} = $t;
    }else{
	die("$e appears more than once!\n");
    }
}
close(COR);

# my %t2i = ();
# open(LAB, "<$labfile") || die("Cannot open $labfile!\n");
# while(<LAB>){
#     chomp;
#     my ($i, $t) = split(/\t/);
#     if(!defined($t2i{$t})){
# 	$t2i{$t} = $i;
#     }else{
# 	die("$t appears more than once!\n");
#     }
# }
# close(LAB);


while(<STDIN>){
    chomp;
    my $org = $_;
    my @cols = split(/\t/);
#    if(defined($e2t{$cols[2]}) && defined($t2i{$e2t{$cols[2]}})){
#	printf("%s\t%s\t%s\n", $cols[0], $cols[1], $t2i{$e2t{$cols[2]}});
    my $mapped;
    if(defined($e2t{$cols[2]})){
	$mapped = $e2t{$cols[2]};
    }else{
        printf(STDERR "Warning! Cannot found any mapping for %s.\n", $cols[2]);
	$mapped = $other;
    }
    printf("%s\t%s\t%s\n", $cols[0], $cols[1], $mapped);
}


