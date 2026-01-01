#!/bin/bash

labdir=00050DivideData.out
srcdir=00050DivideData.out
tagdir=00060RemoveAbsence.out
folds=
for file in `cd $labdir; ls fold??.Node1.labels.json`
do
        f=`echo $file |sed 's/\.Node1\.labels\.json.*$//'`
        folds="$folds $f"
done
echo ">> $folds"
nodes="Node1 Node2 Node3 Node4"
streams="NodeFRT NodeLFT NodeRIT"

/bin/rm -fr $tagdir
mkdir $tagdir

for f in `echo $folds`
do
	for n in `echo $nodes`
	do
		for c in `echo $streams`
		do
			j=$f.$n.$c.json
			python ./filter_json_by_labels.py $srcdir/$j $tagdir/$j $labdir/$f.$n.labels.json $tagdir/$f.$n.labels.json absence
		done
	done
done

#python ./stat_labelfiles.py 0000living_no_absence.labs $tagdir labels.json
