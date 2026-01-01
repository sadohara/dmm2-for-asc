#!/bin/bash

src=$1
tag=$2
file=$3

stem=`echo $file |sed 's/\.wav//'`

batchflow hark/Separation/demoOfflineFix0_30_-30DS-WN-ND.n $src/$file hark/config/tf_circle5.zip $tag/${stem}_

