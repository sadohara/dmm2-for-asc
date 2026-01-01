#!/bin/bash

srclab=00001SimulateHEARtask.out/DCASE2018Task5-FixEvalT3V1
srcemb=00040SplitStreams.out
srcjson=00040SplitStreams.out
tagdir=00050DivideData.out
folds="fold01 fold02 fold03 fold04"
nodes="Node1 Node2 Node3 Node4"
channels="NodeFRT NodeLFT NodeRIT"
suffix="embedding.npy"

/bin/rm -fr $tagdir
mkdir $tagdir

for c in `echo $channels`
do
	if [ ! -e $tagdir/$c ]; then
		mkdir $tagdir/$c
	fi

	i=0
	for f in `echo $folds`
	do
		#mkdir $tagdir/$c/$f
		for n in `echo $nodes`
		do
			srcfile=$srcjson/$f.$n.$c.json
			labfile=$srclab/$f.json
			embdir=$srcemb/$c/$f
			json_infix=$n.$c
			lab_infix=$n.labels
			echo "Divide data via the command: python ./divide_data.py $srcfile $embdir $srclab/$f.json $i $tagdir $tagdir/$c $json_infix $lab_infix $suffix -perl_label -divide2 4" 
			python ./divide_data.py $srcfile $embdir $srclab/$f.json $i $tagdir $tagdir/$c $json_infix $lab_infix $suffix -per_label -divide2 4 
		done
		((i+=16))
	done
done

#python ./stat_labelfiles.py 0000living.labs $tagdir labels.json
