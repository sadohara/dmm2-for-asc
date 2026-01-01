#!/bin/bash

cv=T1V1Ex
labfile=00001living_no_absence.labs
outdir=00061StatLabelfiles.$cv.out
datadir=00060RemoveAbsence.out
suffix=Node1.labels.json
dataset=
for file in `cd $datadir; ls *.$suffix`
do
	f=`echo $file | sed "s/\.$suffix//"`
	dataset="$dataset $f"
done

echo $dataset

/bin/rm -fr $outdir
mkdir $outdir

python get_data_splits.py $outdir/cv. $cv $dataset 

for x in `cd $outdir; ls -d cv.*`
do
	echo "Processing $x..."
	train=`head -n 1 $outdir/$x/data_splits.txt`
	valid=`head -n 2 $outdir/$x/data_splits.txt | tail -n 1`
	testfold=`head -n 3 $outdir/$x/data_splits.txt | tail -n 1`
	trainfold="$train $valid"

	for f in `echo $trainfold`
	do
		ln -s ../../$datadir/$f.$suffix $outdir/$x/$f.json
	done
	
	python ./stat_labelfiles.py $labfile $outdir/$x json > $outdir/$x/stat.txt 2> $outdir/$x/stat.log
done


ls $outdir/cv.*/stat.txt | perl ./summarize_labelfiles_log.pl
