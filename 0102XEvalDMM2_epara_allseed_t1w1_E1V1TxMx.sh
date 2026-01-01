#!/bin/sh

outstem=0102XEvalDMM2_epara_allseed_t1w1_E1V1TxMx
modelstem=01020ApplyDMM2_epara_allseed_t1w1
datadir=00125MakeRefs.out/fold01
modelext=post
reffile=00125MakeRefs.out/common.ref
labfile=00001living_no_absence.labs
idxs="1,10-"    
other=0
opt=""
prefix="cv."


#n=8;   (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=9;   (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=10;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=11;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=12;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=13;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=14;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=15;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=16;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=17;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=18;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=19;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=20;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=21;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=22;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=23;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=24;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=25;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=26;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=27;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=28;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=29;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=30;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=31;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=32;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=33;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=34;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=35;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=36;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=37;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=38;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=39;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=40;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=50;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=60;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=70;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=100;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=200;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=400;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  
#n=600;  (./eval_activity_cv.E1V1TxMx.sh $n $outstem.$n.out $prefix $modelstem.$n.out $datadir $modelext $reffile $labfile $other $idxs "$opt" > $outstem.$n.log 2>&1) &  


#exit

for d in `ls -d $outstem.*.out`
do
	cat $d/cv.fold??/stat.mod.txt | perl ./stat2.pl 0 > $d.x.stat.txt
done

sort -k 1,1n $outstem.*.out.x.stat.txt > $outstem.x.out.stat.txt

