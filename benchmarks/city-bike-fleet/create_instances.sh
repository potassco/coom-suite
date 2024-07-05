#!/bin/bash

TEMPLATE=instance.coom
OUTDIR=instances
NAME=citybike

rm -rf $OUTDIR
mkdir $OUTDIR

for numbikes in $(seq 10 10 150)
do
    OUTFILE=$OUTDIR/${NAME}-n${numbikes}.coom
    sed -e "s/NUMBIKES/${numbikes}/g" $TEMPLATE > $OUTFILE
done
