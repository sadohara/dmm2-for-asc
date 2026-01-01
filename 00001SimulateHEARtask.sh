#!/bin/sh

echo "Require DCASE2018 Challenge Taks5 dataset, and HARK!"
exit

devdir=datadir/DCASE18-Task5-development
evldir=datadir/DCASE18-Task5-evaluation
task=DCASE2018Task5-FixEvalT3V1
topdir=00001SimulateHEARtask.out
tagdir=$topdir/$task
audiodir=16000

/bin/rm -fr $topdir
mkdir -p $tagdir

(cd $tagdir; ln -s ../../00001task_metadata.json task_metadata.json)
(cd $tagdir; ln -s ../../00001labelvocabulary.csv labelvocabulary.csv)

folds="fold01 fold02 fold03 fold04"

for fold in $folds
do
	echo "Making a data split $fold for training ..."
	metafile=$devdir/evaluation_setup/${fold}_evaluate.txt
	tagaudiodir=$tagdir/$audiodir/$fold
	mkdir -p $tagaudiodir
	(python ./setup_fold_4ch2hark_fix3waybeam30.py $metafile $devdir/audio $tagaudiodir $tagdir/$fold.json > $topdir.$fold.log 2>&1) &
done


#fold=fold00
#echo "Making a data split $fold for evaluation..."
#metafile=$devdir/eval_mapped_file_info.evalonly.with_labels.txt
#tagaudiodir=$tagdir/$audiodir/$fold
#mkdir -p $tagaudiodir
#(python ./setup_fold_4ch2hark_fix3waybeam30.py $metafile $evldir/audio $tagaudiodir $tagdir/$fold.json > $topdir.$fold.log 2>&1) &
#
