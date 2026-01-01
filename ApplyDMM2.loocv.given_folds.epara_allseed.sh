#!/bin/bash

ntopic=$1
alpha=$2
beta=$3
n1iters=$4
titers=$5
outstem=$6
datadir=$7
com=$8
target=$9
tagtrain=${10}
tagtest=${11}
streams=${12}
opt=${13}
topdir=`pwd`
savestep=`expr $n1iters / 10`
echo "> com=$com, ntopic=$ntopic, alpha=$alpha, beta=$beta, train1_iters=$n1iters($savestep) titers=$titers $outstem $target $datadir [$tagtrain] [$tagtest] [$streams] $opt"

all_exists () {
        prefix=$1
        shift
        suffix=$1
        shift
        for a in "$@"
        do
                f=$prefix.$a.$suffix
                echo ">> Checking $f ..."
                if [ ! -e $f ]; then
                        return 0
                fi
        done
        return 1
}

outdir="$outstem.$ntopic.out/$target"
if [ ! -e "$outdir" ]; then
   mkdir -p $outdir
fi

cd $outdir

num_streams=0
stream=""
for s in `echo $streams`
do
	stream=$s
	num_streams=$(($num_streams + 1))
done

p=0
for fold in `echo $tagtrain`
do
  echo "$topdir/$datadir/$target/$fold"
  for d in `cd $topdir/$datadir/$target; ls ${fold}*.$stream.idx`
  do
     prefix=`echo $d | sed "s/\.$stream\.idx$//"`
     p=$((p += 1))
     for s in `echo $streams`
     do
     	ln -sf ../../$datadir/$target/$prefix.$s.idx train.$s.$p.idx
     	ln -sf ../../$datadir/$target/$prefix.$s.idx .
     done
  done
done

for fold in `echo $tagtest`
do
  echo "$topdir/$datadir/$target/$fold"
  for d in `cd $topdir/$datadir/$target; ls ${fold}*.$stream.idx`
  do
     prefix=`echo $d | sed "s/\.$stream\.idx$//"`
     for s in `echo $streams`
     do
        ln -sf ../../$datadir/$target/$prefix.$s.idx .
     done
  done
done

for s in `echo $streams`
do
   cat train.$s.*.idx > seed.$s.idx
done


echo "Bluilding model-final..."
all_exists model-final tassign $streams
if [ $? -eq 1 ]; then
	echo "Skip learning"
else
	all_exists model-final tassign.gz $streams
	if [ $? -eq 1 ]; then
		gunzip model-final.*.tassign.gz
	else

		echo "Do learning with seed.dat"
		echo "NumStreams=$num_streams" > model.others
		echo "NumTopics=$ntopic" >> model.others
		for s in `echo $streams`
		do
			if [ -e ../../$datadir/$target/wordmap.$s.txt ]; then
				n=`head -n 1 ../../$datadir/$target/wordmap.$s.txt`
				n=$(($n + 1))
				echo "StreamTag=$s" > model.$s.others
				echo "NumWords=$n" >> model.$s.others
			else
				echo "Cannot find ../../$datadir/$target/wordmap.$s.txt"
				false
			fi
		done
				
		echo "$com -est -alpha $alpha -beta $beta -ntopics $ntopic -niters $n1iters -model model -dir . $opt seed"
		$com -est -alpha $alpha -beta $beta -ntopics $ntopic -niters $n1iters -model model -dir . $opt seed
   		ln -sf model-final.others training.1st.others
		for s in `echo $streams`
		do
      			ln -sf model-final.$s.tassign training.1st.$s.1.tassign
      			ln -sf model-final.$s.others training.1st.$s.others
		done
	fi
fi



numdata=0
for d in `ls fold*.$stream.idx`
do
     numdata=$(($numdata + 1))
     f=`echo $d | sed "s/\.$stream\.idx$//"`
     echo "Evaluating $f..."
     echo "$com -inf -dir . -model training.1st -niters $titers -twords 20 $opt $f"
     ($com -inf -dir . -model training.1st -niters $titers -twords 20 $opt $f > $f.log 2>&1) &
done

echo "Waiting $numdata results..."
n=0
while [ $n -ne $numdata ];
do
        echo "Waiting evaluation... (n=$n)"
        sleep 5
        n=`ls fold*.post 2>/dev/null | wc -l`
done


#/bin/rm -f training.1st.0.dat.tassign
#gzip *.{phi,theta,tassign,post}
#ln -sf model-final.tassign training.1st.0.dat.tassign  

cd $topdir



