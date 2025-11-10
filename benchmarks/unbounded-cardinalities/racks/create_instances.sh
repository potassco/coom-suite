#!/bin/bash

OUTDIR=instances

rm -rf $OUTDIR
mkdir $OUTDIR

INSTANCE=instance-simple.coom
USER=user-input-simple.coom
NAME=racks-simple

for max in 10 20 30; do
    OUTFILE=$OUTDIR/${NAME}_${max}.coom
    sed -e "s/MAX/${max}/g" $INSTANCE > $OUTFILE

    steps=10
    step=$((max / steps))
    for ((i = 0; i < steps; i++)); do
        numElements=$((1 + i*step))
        OUTFILE=$OUTDIR/user-input-${NAME}_${max}_${numElements}.coom
        sed -e "s/NUMELEMENTS/${numElements}/g" $USER > $OUTFILE
    done
done

INSTANCE=instance-complex.coom
USER=user-input-complex.coom
NAME=racks-complex

max=10
OUTFILE=$OUTDIR/${NAME}_${max}.coom
sed -e "s/MAX/${max}/g" $INSTANCE > $OUTFILE

for numElements in 1 2 3 4 5 6 7 8 9 10; do
    OUTFILE=$OUTDIR/user-input-${NAME}_${max}_${numElements}.coom
    sed -e "s/NUMELEMENTS/${numElements}/g" $USER > $OUTFILE
done
