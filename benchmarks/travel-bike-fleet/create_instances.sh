#!/bin/bash

TEMPLATE=instance.coom
OUTDIR=instances
NAME=travelbike

rm -rf $OUTDIR
mkdir $OUTDIR

MAX_PER_BIKE=500

for numbikes in $(seq 1 1 15); do
    # for maxprice in 300 500; do
    MAXPRICE_TOTAL=$((200*numbikes))
    OUTFILE=$OUTDIR/${NAME}${numbikes}.coom
    sed -e "s/NUMBIKES/${numbikes}/g" -e "s/MAXPRICE/${MAXPRICE_TOTAL}/g" $TEMPLATE > $OUTFILE
    # done
done
