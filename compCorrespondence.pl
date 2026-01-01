#!/usr/local/bin/perl


use strict;

my $reffile = shift;
my $verbose = 0;
my $corresp_method = 0;  ##max coverage
my $fastmode = 1;   # fastmode=1 runs fast assuming that each line in tpcfile is sorted by the timestamp
my $other;
my $actfile;
my $classfile;
my $tpcfile;
my $given_beg_and_end = 0;
my $RemoveTPC = 0;
while($_ = shift @ARGV){
    if(/^\-v$/){
	$verbose = 1;
    }elsif(/^\-f$/){
        $fastmode = 1;
    }elsif(/^\-o$/){
	$other = shift @ARGV;
    }elsif(/^\-a$/){
	$actfile = shift @ARGV;
    }elsif(/^\-c$/){
	$classfile = shift @ARGV;
    }elsif(/^\-t$/){
	$tpcfile = shift @ARGV;
    }elsif(/^\-B$/){
	$given_beg_and_end = 1;
    }elsif(/^\-R$/){
	    $RemoveTPC = 1;
    }
}

printf(STDERR ">compCorrespondence.pl: verbose=%d, method=%d, givenBE=%d", $verbose, $corresp_method, $given_beg_and_end);
if(defined($actfile)){
    printf(STDERR " actfile=%s", $actfile);
}
if(defined($classfile)){
    printf(STDERR " classfile=%s", $classfile);
}
if(defined($tpcfile)){
    printf(STDERR " tpc=%s", $tpcfile);
}
if(defined($other)){
    printf(STDERR " other=%s\n", $other);
}else{
    printf(STDERR "\n");
}


my @ref = ();
my $prev = 0;
open(REF, "<$reffile") || die("Cannot open $reffile!\n");
while(<REF>){
    chomp;
    my @cols = split(/\s+/);
    my $b;
    my $e;
    my $l;
    if($given_beg_and_end == 1){
	    $b = $cols[0];
	    $e = $cols[1];
	    $l = $cols[2];
    }else{
	    $b = $prev;
	    $e = $cols[0];
	    $l = $cols[1];
    }

    if($l >= 0){
	push @ref, {BT => $b, ET => $e, LABEL => $l};
	$prev = $e;
    }
}
close(REF);

my %tbl = ();
my $m = -1;
my @segs = ();
while(<STDIN>){
    chomp;
    my @cols = split(/\s+/);
    my $bt = $cols[0];
    my $et = $cols[1];
    my $pt = $cols[2];

    if(! defined($tbl{$pt})){
	$tbl{$pt} = {};
    }

    my ($t, $d) = update_coverage($bt, $et, \@ref, $tbl{$pt});
    if($RemoveTPC == 0 || $d > 0.0){
        push @segs, {BT=>$bt, ET=>$et, PT=>$pt, RT=>$t, RD=>$d};
    }
}

my %corresp = ();
foreach my $k (sort {$a <=> $b} keys(%tbl)){
    my $h = $tbl{$k};
    my $c = 0;   ### default corresponds to '0', i.e. the other activity

    if($corresp_method == 0){ ##max coverage
       my $maxt;
       my $maxd;
       printf(STDERR "%s", $k);
       foreach my $t (sort {$h->{$b} <=> $h->{$a} || $b cmp $a} keys(%$h)){
          printf(STDERR "\t%s:%f", $t, $h->{$t});
	  if(! defined($maxt) || $h->{$t} > $maxd){
	       $maxt = $t;
	       $maxd = $h->{$t};
          }
       }
       printf(STDERR "\n");
       if(! defined($maxt)){
           printf(STDERR "Warning! %s does not correspond to any label! Force its label as 0\n", $k);
           $c = 0;
       }else{
           $c = $maxt;
       }
    }else{
	    die("Not implemened!\n");
    }
    printf("%s\t%s\n", $k, $c);
    $corresp{$k} = $c;
}

if(defined($actfile)){
   open(ACT, ">$actfile") || die("Cannot create $actfile!\n");
   foreach my $e (@segs){
      if(! defined($other) || $e->{RT} ne $other){
          printf(ACT "%f\t%f\t%s\n", $e->{BT}, $e->{ET}, $corresp{$e->{PT}});
      } 
   }
   close(ACT);
}

if(defined($tpcfile)){
   open(TPC, ">$tpcfile") || die("Cannot create $tpcfile!\n");
   foreach my $e (@segs){
      if(! defined($other) || $e->{RT} ne $other){
          printf(TPC "%f\t%f\t%s\n", $e->{BT}, $e->{ET}, $e->{PT});
      }
   }
   close(TPC);
}

if(defined($classfile)){
   open(CLASS, ">$classfile") || die("Cannot create $classfile!\n");
   foreach my $e (@segs){
      if(! defined($other) || $e->{RT} ne $other){
          printf(CLASS "%f\t%f\t%s\n", $e->{BT}, $e->{ET}, $e->{RT});
      }
   }
   close(CLASS);
}
	
    
sub update_coverage{
    my $bt = shift;
    my $et = shift;
    my $r = shift;
    my $h = shift;
    my $len = @$r;
    my %lh = ();
    my $rt;
    my $rd;
    my $maxi;

    my $d = 0.0;
    for(my $i=0; $i<$len; $i++){
	my $rb = $r->[$i]->{BT};
	my $re = $r->[$i]->{ET};
	my $ra = $r->[$i]->{LABEL};
	#printf(STDERR " (%f, %f) -> %u[%f, %f]%f\n", $bt, $et, $i, $rb, $re, $d);
	if($bt > $re){
	    #Do nothing
	    if($fastmode==1){
                $maxi = $i;
            }
	}elsif($et < $rb){
	    last;
	}else{
	    my $ob;  # begining of the overwrap
	    my $oe;  # end of the overwrap
	    my $finish = 0;
	    if($bt >= $rb){
		$ob = $bt;
	    }else{
		$ob = $rb;
	    }
	    if($et <= $re){
		$oe = $et;
	    }else{
		$oe = $re;
	    }
	    if(! defined($h->{$ra})){
		$h->{$ra} = 0.0;
	    }
	    $h->{$ra} += $oe - $ob;
            if(! defined($lh{$ra})){
                $lh{$ra} = 0.0;
            }
            $lh{$ra} += $oe - $ob;
	    #printf(STDERR "  ra=%s, ob=%f, oe=%f, %f, %f\n", $ra, $ob, $oe, $oe - $ob, $lh{$ra});
	}
    }
    foreach my $t (sort {$lh{$b} <=> $lh{$a} || $b cmp $a} keys(%lh)){
        $rt = $t;
        $rd = $lh{$t};
	#	printf(STDERR "  t=%s, rt=%s, %f\n", $t, $rt, $rd);
        last;
    }	
    if($fastmode==1 && defined($maxi) && $maxi >= 0){
       splice(@$r, 0, $maxi + 1);
    }
    #printf(STDERR "  rt=%s, rd=%f\n", $rt, $rd);
    return(($rt, $rd));
}
