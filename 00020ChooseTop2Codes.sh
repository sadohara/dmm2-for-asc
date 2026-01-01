#!/bin/bash

srcdir=00010Encodec.out
tagdir=00020ChooseTop2Codes.out
tag=encodec
topn=2
code_size=1024

/bin/rm -fr $tagdir
mkdir $tagdir

for f in `cd $srcdir; ls fold*.$tag.json`
do
	python ./choose_topn_code.py $srcdir/$f $tagdir/$f $topn $code_size
done



