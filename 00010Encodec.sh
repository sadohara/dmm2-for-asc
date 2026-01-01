#!/bin/bash

echo "Require Encodec!"
exit

data=00001SimulateHEARtask.out
task=DCASE2018Task5-FixEvalT3V1
tagstm=00010Encodec
tagdir=$tagstm.out
tag=encodec

/bin/rm -fr $tagdir
#mkdir $tagdir

for f in `cd $data/$task/16000; ls -d fold*`
do
	if [ ! -e $tagdir/$f ]; then
		mkdir -p $tagdir/$f
	fi
done

export CUDA_VISIBLE_DEVICES=0
python ./soundstream_encode2_aux.py $data/$task $tagdir $tag "fold01,fold02"


