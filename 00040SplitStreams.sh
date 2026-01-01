#!/bin/bash

embdir=00010Encodec.out
srcdir=00030SplitNodes.out
folds="fold01 fold02 fold03 fold04"
nodes="Node1 Node2 Node3 Node4"
tagdir=00040SplitStreams.out
channels="NodeFRT NodeLFT NodeRIT"

/bin/rm -fr $tagdir
mkdir $tagdir

i=0
for c in `echo $channels`
do
	if [ ! -e $tagdir/$c ]; then
		mkdir $tagdir/$c
	fi

	for f in `echo $folds`
	do
		mkdir $tagdir/$c/$f
		for n in `echo $nodes`
		do
			srcfile=$f.$n.json
			tagfile=$f.$n.$c.json
			echo "Creating $tagdir/$tagfile by selecting id=$i($c) in $srcdir/$srcfile"
			python ./filter_json_by_streams.py ../../../$embdir/$f $tagdir/$c/$f $srcdir/$srcfile $tagdir/$tagfile $i $c
		done
	done
	((i++))
done


