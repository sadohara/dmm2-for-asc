#!/bin/sh

outroot=$1
classnum=$2
tpc0train=$3
tpc0test=$4
reffile=$5
labfile=$6
other=$7
opt=$8


echo "eval_activity_score.sh $outroot $classnum $tpc0train $tpc0test $reffile $labfile $other $opt"

avefile=$outroot/stat.txt
/bin/rm -f $avefile

(cd $outroot; ln -s $tpc0train tpc.train; ln -s $tpc0test tpc.test)

cat $outroot/tpc.train | perl ./compCorrespondence.pl $reffile -B $opt -a $outroot/act.train -c $outroot/class.train -t $outroot/tpc1.train > $outroot/cor
cat $outroot/tpc.test  | perl ./compCorrespondence.pl $reffile -B $opt -a $outroot/act.test  -c $outroot/class.test  -t $outroot/tpc1.test  > /dev/null
cat $outroot/tpc.test  | perl ./applyCorrespondence2.pl $outroot/cor -O $other >   $outroot/act.test

cat $outroot/act.test | perl ./evalTopic9.pl $labfile $outroot/cmat $outroot/class.test $opt >$outroot/purity
#python ./compMI.py $outroot/tpc1.train $outroot/class.train > $outroot/mi_scikit_train
#python ./compMI.py $outroot/tpc1.test $outroot/class.test > $outroot/mi_scikit
#python ./compNMI.py $outroot/tpc1.test $outroot/class.test > $outroot/nmi_scikit
#python ./compAMI.py $outroot/tpc1.test $outroot/class.test > $outroot/ami_scikit
#python ./compARS.py $outroot/tpc1.test $outroot/class.test > $outroot/ars_scikit
#python ./compTop1Accuracy.py $outroot/act.test $outroot/class.test $labfile > $outroot/acc_heareval
#python ./compMeanAveragePrecision.py $outroot/act.test $outroot/class.test $labfile > $outroot/map_heareval
#python ./compAUCROC.py $outroot/act.test $outroot/class.test $labfile > $outroot/auc_heareval
#python ./compDPrime.py $outroot/act.test $outroot/class.test $labfile > $outroot/dpr_heareval
purity=`tail -n 1 $outroot/purity | cut -f 1`
numtopics=`cut -f 3 $outroot/tpc.train $outroot/tpc.test | sort -u | wc -l`
stats=`tail -n 1 $outroot/cmat`
#mi_scikit_train=`tail -n 1 $outroot/mi_scikit_train | cut -f 1`
#mi_scikit=`tail -n 1 $outroot/mi_scikit | cut -f 1`
#nmi_scikit=`tail -n 1 $outroot/nmi_scikit | cut -f 1`
#ami_scikit=`tail -n 1 $outroot/ami_scikit | cut -f 1`
#ars_scikit=`tail -n 1 $outroot/ars_scikit | cut -f 1`
#acc_heareval=`tail -n 1 $outroot/acc_heareval | cut -f 1`
#map_heareval=`tail -n 1 $outroot/map_heareval | cut -f 1`
#auc_heareval=`tail -n 1 $outroot/auc_heareval | cut -f 1`
#dpr_heareval=`tail -n 1 $outroot/dpr_heareval | cut -f 1`
#echo "$classnum $numtopics $purity $stats $nmi_scikit $ami_scikit $ars_scikit $acc_heareval $map_heareval $auc_heareval $dpr_heareval $mi_scikit $mi_scikit_train" > $avefile
echo "$classnum $numtopics $purity $stats" > $avefile

