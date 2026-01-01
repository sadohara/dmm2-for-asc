#!/bin/bash

classnum=$1       #50
outdir=$2         #1123EvalEvalDM_t1w1.50.out/fold02
modeldir=$3       #1120ApplyDM_t1w1.50.out/fold02
trainfolds=$4     # fold01 fold03 fold04
testfolds=$5      # fold02
modelext=$6       #dat.post.gz
datadir=$7        #1102MakeRefs.out/fold01
reffile=$8        #1102MakeRefs.out/fold01.ref
labfile=$9        #0000living.labs
other=${10}       #0
cmatidxs=${11}    #1,11-
opt=${12}

echo  "eval_activity_with_mapped_clusters.sh: $classnum $outdir $modeldir $modelext trainfolds=($trainfolds) testfolds=($testfolds) $datadir $refdfile $labfile $other $cmatidxs $opt"

outroot=$outdir
/bin/rm -fr $outroot
mkdir $outroot
if [ ! -e $outroot ]; then
	mkdir -p $outroot;
fi


for f in `echo $trainfolds`
do
	for d in `(cd $modeldir; ls ${f}.$modelext)`
	do
		s=`echo $d | sed "s/.$modelext$//"`
		if [ ! -e $outroot/$s.train0 ]; then
			echo "Creating $outroot/$s.train0"
			eval ls $modeldir/$d | perl ./alpha2topics6.pl $datadir None .$modelext > $outroot/$s.train0
		else
			echo "Skip creating $outroot/$s.train0"
		fi
	done
done

if [ ! -e 00tpc1.trains ]; then
        echo "Creating 00tpc1.trains"
        cat $outroot/*.train0 | sort -k 1,1n > $outroot/00tpc1.trains
fi



selected=""
for t in `cut -f 3 $outroot/00tpc1.trains | sort -u -n`
do
	selected="$selected,$t"
done
selected=`echo $selected | sed 's/^,//'`



for f in `echo $testfolds`
do
	for d in `(cd $modeldir; ls ${f}.$modelext)`
        do
                s=`echo $d | sed "s/.$modelext$//"`
                if [ ! -e $outroot/$s.test0 ]; then
                        echo "Creating $outroot/$s.test0"
                        eval ls $modeldir/$d | perl ./alpha2topics6.pl $datadir None .$modelext -T $selected > $outroot/$s.test0
                else
                        echo "Skip creating $outroot/$s.test0"
                fi
        done
done


if [ ! -e 00tpc1.tests ]; then
        echo "Creating 00tpc1.tests"
        cat $outroot/*.test0 | sort -k 1,1n > $outroot/00tpc1.tests
fi

./eval_activity_score.sh $outroot $classnum 00tpc1.trains 00tpc1.tests $reffile $labfile $other "$opt"

cut -f $cmatidxs $outroot/stat.txt |sed 's/ *FMS//' > $outroot/stat.mod.txt


