#!/bin/bash

classnum=$1       #50
outdir=$2         #1123EvalDM_t1w1.50.out
modeldir=$3       #1120ApplyDM_t1w1.50.out
datadir=$4        #1102MakeRefs.out/fold01
modelext=$5       #dat.post.gz
reffile=$6        #1102MakeRefs.out/fold01.ref
labfile=$7        #0000living.labs
other=$8          #0
cmatidxs=$9       #1,11-
opt=${10}

#dataset="fold01 fold02 fold03 fold04"
dataset=
for file in `cd $datadir; ls fold??.num`
do
	f=`echo $file | sed 's/\.num//'`
	dataset="$dataset $f"
done

echo  "eval_activity_cv.T1V1ExM2.sh: $classnum $outdir $modeldir $datadir $modelext $reffile $labfile $other $cmatidxs ($opt) ($dataset)"


outroot=$outdir
/bin/rm -fr $outroot
mkdir $outroot
#if [ ! -e $outroot ]; then
#	mkdir -p $outroot;
#fi


python get_data_splits.py $outroot/cv. T1V1Ex $dataset 

for x in `cd $outroot; ls -d cv.*`
do
	echo "Processing $x..."
	train=`head -n 1 $outroot/$x/data_splits.txt`
	valid=`head -n 2 $outroot/$x/data_splits.txt | tail -n 1`
	testfold=`head -n 3 $outroot/$x/data_splits.txt | tail -n 1`
	trainfold="$train $valid"
	echo "($trainfold) ($testfold)"
	(./eval_activity_with_mapped_clusters.sh $classnum $outdir/$x $modeldir/fold01 "$trainfold" "$testfold" $modelext $datadir $reffile $labfile $other "$cmatidxs" "$opt" > $outdir/$x.log 2>&1) 
done

#cat $outdir/${prefix}*/stat.mod.txt | perl ./stat2.pl 0 > $outdir.x.stat.txt


