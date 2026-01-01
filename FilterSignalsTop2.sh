#!/bin/bash

tagdir=$1  # C121FilterSignalsTop2.out
srcdir=$2  # B000DivideData.out
labdir=$3  # B000DivideData.out
node=$4    # Node2
tfthr=$5   # 0.6
ignore=absence
idfthr=1.0
streams="NodeFRT NodeLFT NodeRIT"

/bin/rm -fr $tagdir
mkdir $tagdir

folds=
for file in `cd $labdir; ls fold??.$node.labels.json`
do
        f=`echo $file |sed "s/\.$node\.labels\.json.*$//"`
        folds="$folds $f"
	ln -s ../$labdir/$file $tagdir/$f.json
done
echo ">> $folds"

for fold in `echo $folds`
do
	mkdir $tagdir/$fold
	for s in `echo $streams`
	do
		d=$tagdir/$fold/$s
		mkdir $d 
		for f in `echo $folds`
		do
			(cd $d; ln -s ../../../$srcdir/$f.$node.$s.json $f.json)
		done
		#Use all data to collect codes in absence
		#for f in `echo $folds | sed "s/$fold//"`
		for f in `echo $folds`
		do
			(cd $d; ln -s $f.json $f.train0.json)
		done
		#Remove absence-codes from each json file
		#python ./filter_signals_by_labels.py $tagdir/$fold/$s $tagdir $tagdir/$fold/$s train0 all $fold $ignore
		python ./filter_signals_by_labels.py $tagdir/$fold/$s $tagdir $tagdir/$fold/$s train0 all fold00 $ignore

		#Remove wav-files and corresponding data labeled as absence
		for f in `echo $folds`
		do
			python ./filter_json_by_labels.py $tagdir/$fold/$s/$f.all.json $tagdir/$fold/$s/$f.noabs.json $tagdir/$f.json $tagdir/$fold/$s/$f.labels.json $ignore
		done
		# filter codes by using all data
		#for f in `echo $folds | sed "s/$fold//"`
		for f in `echo $folds`
		do
			(cd $d; ln -s $f.noabs.json $f.train_noabs.json)
		done
		echo "Filter codes via the command: python ./FilterSignalsFromJSON2SrcDirs2Tag_DFRatioAndTFRatio.py train_noabs noabs $tagdir/$fold/$s $idfthr $tfthr $tagdir/$fold/$s"
		python ./FilterSignalsFromJSON2SrcDirs2Tag_DFRatioAndTFRatio.py train_noabs noabs $tagdir/$fold/$s $idfthr $tfthr $tagdir/$fold/$s
	done
	# data is same for each test fold, so it suffice to create data once
	break
done

for f in `echo $folds`
do
	if [ $f != $fold ]; then
		(cd $tagdir; ln -s $fold $f)
	fi
done


