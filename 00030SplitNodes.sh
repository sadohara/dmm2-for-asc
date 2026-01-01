#!/bin/bash

srcdir=00020ChooseTop2Codes.out
folds="fold01 fold02 fold03 fold04"
nodes="Node1 Node2 Node3 Node4"
tag=encodec
tagdir=00030SplitNodes.out

/bin/rm -fr $tagdir
mkdir $tagdir

for f in `echo $folds`
do
	srcfile=$f.$tag.json
	for node in `echo $nodes`
	do
		tagfile=$f.$node.json
		echo "Creating $tagdir/$tagfile by selecting $n in $srcdir/$srcfile"
		python ./filter_json_by_node.py $srcdir/$srcfile $tagdir/$tagfile $node
	done
done


