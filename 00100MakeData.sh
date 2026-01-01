#!/bin/sh

prefix=0010
tfthr=0.6
node=Node2
./FilterSignalsTop2.sh ${prefix}1FilterSignalsTop2.out 00050DivideData.out 00050DivideData.out $node $tfthr 


nodes="NodeFRT NodeLFT NodeRIT"
one_node=NodeFRT
null="null"
labfile=00001living_no_absence.labs
labdir=00060RemoveAbsence.out
srcdir=${prefix}1FilterSignalsTop2.out
folds=
for file in `cd $srcdir; ls fold??.json`
do
        f=`echo $file |sed "s/\.json.*$//"`
        folds="$folds $f"
done
echo ">> $folds"


tagdir=${prefix}2MakeNumsTop2.out
tag=noabs
srcdir=${prefix}1FilterSignalsTop2.out
/bin/rm -fr $tagdir
mkdir $tagdir
for fold in `echo $folds`
do
	mkdir $tagdir/$fold
	for n in `echo $nodes`
	do
		mkdir $tagdir/$fold/$n

		for f in `echo $folds`
		do
			j=$srcdir/$fold/$n/$n.$f.$tag.json
			echo "Processing $j ..."
			python json2num_posonly_with_null2.py $labdir/$f.$node.labels.json $j $null > $tagdir/$fold/$n/$f.$n.num
		done
	done
	break
done


srcdir=${prefix}2MakeNumsTop2.out
tagdir=${prefix}3MakeData.out
/bin/rm -fr $tagdir
mkdir $tagdir
for fold in `echo $folds`
do
	mkdir $tagdir/$fold
	for n in `cd $srcdir/$fold; ls -d Node*`
	do
		for fn in `cd $srcdir/$fold/$n; ls fold*.num`
		do
			s=`echo $fn | sed 's/\.num$//'`
			echo "Processing $srcdir/$fold/$n/$fn and creating $tagdir/$fold/$s.dat"
			wc -l $srcdir/$fold/$n/$fn | cut -d ' ' -f 1 > $tagdir/$fold/$s.dat
			cut -f 3 $srcdir/$fold/$n/$fn >> $tagdir/$fold/$s.dat
			(cd $tagdir/$fold; ln -s ../../$srcdir/$fold/$n/$fn .)
		done
		cat $tagdir/$fold/*.$n.num | perl ./mkwordmap.pl -n null -N > $tagdir/$fold/wordmap.$n.txt
	done
	break
done

for f in `echo $folds`
do
	if [ $f != $fold ]; then
		(cd $tagdir; ln -sf $fold $f)
	else
		(cd $tagdir/$f; ln -sf $f.$one_node.num $f.num)
	fi
done


srcdir=${prefix}3MakeData.out
tagdir=${prefix}3MakeData.out
for fold in `echo $folds`
do
	for n in `echo $nodes`
	do
		mapfile=wordmap.$n.txt
		for d in `cd $srcdir/$fold; ls fold*.$n.dat`
		do
			s=`echo $d | sed 's/\.dat$//'`
			i=$s.idx
			echo "Creating $tagdir/$fold/$i from $srcdir/$fold/$d and $srcdir/$fold/$mapfile"
			tail -n +2  $srcdir/$fold/$d | perl ./word2idx.pl $srcdir/$fold/$mapfile > $tagdir/$fold/$i 2> $tagdir/$fold/$s.words 
		done
	done
	break
done


srcdir=${prefix}2MakeNumsTop2.out
tagdir=${prefix}5MakeRefs.out
/bin/rm -fr $tagdir
mkdir $tagdir
for fold in `echo $folds`
do
	mkdir $tagdir/$fold
	/bin/rm -f $tagdir/$fold/common.ref
	offset=0
	folds=""
	for num in `cd $srcdir/$fold/$one_node; ls fold*.num`
	do
		d=`echo $num | sed 's/\..*$//'`
		#folds="$folds $d"
		echo "$num ($d) $offset"
		python ./make_ref.py $labfile $srcdir/$fold/$one_node/$num $offset > $tagdir/$fold/$d.num
		cat $tagdir/$fold/$d.num >> $tagdir/$fold/common.ref 
		n=`cat $srcdir/$fold/$one_node/$num | wc -l | sed 's/./0/g'` 
		m="1${n}0"
		offset=$(($offset+$m))
	done
	break
done

for fold in `echo $folds`
do
	for f in `echo $folds`
	do
		(cd $tagdir/$fold; ln -s common.ref $f.ref)
	done
	break
done

for f in `echo $folds`
do
	if [ $f != $fold ]; then
		(cd $tagdir; ln -s $fold $f)
	fi
done

(cd $tagdir; ln -s fold01/common.ref .)


