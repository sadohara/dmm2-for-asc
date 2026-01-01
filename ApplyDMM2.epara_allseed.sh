#!/bin/bash


ntopics=$1
alpha=$2
beta=$3
t1iters=$4
titers=$5
outstem=$6
datadir=$7
com=$8
streams=$9
opt=${10}
#data="fold01 fold02 fold03 fold04"
data=
for d in `cd $datadir; ls -d fold??`
do
	data="$data $d"
done

echo "ApplyDMM2.epara_allseed.sh $ntopics $alpha $beta $t1iters/$titers $outstem $datadir $com [$data] [$streams] $opt"

outdir=$outstem.$ntopics.out
#/bin/rm -fr $outdir
if [ ! -e $outdir ]; then
   mkdir $outdir
fi

for d in `echo $data`
do
        echo "Processing $d..."
	mkdir -p $outdir/$d
	testfold=$d
        #trainfold=`echo $data | sed "s/$d//" | sed 's/ +/ /'`
	trainfold=$data
        echo "($testfold) ($trainfold)"
	(./ApplyDMM2.loocv.given_folds.epara_allseed.sh $ntopics $alpha $beta $t1iters $titers $outstem $datadir $com $d "$trainfold" "$testfold" "$streams" "$opt" >> $outdir.$d.log 2>&1) &
	break
done



