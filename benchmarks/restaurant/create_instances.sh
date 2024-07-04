#!/bin/bash

TEMPLATE=instance.coom
OUTDIR=instances
NAME=restaurant

rm -rf $OUTDIR
mkdir $OUTDIR

for numtable in 100 500 1000 1500 2000
do
    maxplaces=$(($numtable*7))
    init=$(($numtable*2))
    # for totalplaces in $(seq $init 100 $maxplaces)
    for ratio in 2 4 6
    do
        totalplaces=$((numtable*ratio))
        OUTFILE=$OUTDIR/${NAME}${numtable}_${totalplaces}.coom
        sed -e "s/NUMTABLE/${numtable}/g" -e "s/TOTALPLACES/${totalplaces}/g" $TEMPLATE > $OUTFILE
    done
done
