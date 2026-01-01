#!/usr/bin/perl

my $mapfile = shift;
my $numwords = 0;
if(@ARGV > 0){
    $numwords = shift;
}
printf(STDERR "%s (%u)\n", $mapfile, $numwords);

   

my %map = ();
open(MAP, "<$mapfile") || die("Cannot open $mapfile!\n");
while(<MAP>){
    chomp;
    my @cols = split(/\t/);
    if(@cols == 2){
	$map{$cols[0]} = $cols[1];
    }
}
close(MAP);

while(<STDIN>){
    chomp;
    my @ws = split(/\s+/);
    my @idxs = ();
    my @new = ();
    foreach my $w (@ws){
	if($numwords == 0 || $map{$w} < $numwords){
	    push @idxs, $map{$w};
	    push @new, $w;
	}
    }
    if(@idxs == 0){
	next;
    }
    my $l = pop @idxs;
    foreach my $i (@idxs){
	printf("%u ", $i);
    }
    printf("%u\n", $l);
    my $l = pop @new;
    foreach my $w (@new){
	printf(STDERR "%s ", $w);
    }
    printf(STDERR "%s\n", $l);

}

	
