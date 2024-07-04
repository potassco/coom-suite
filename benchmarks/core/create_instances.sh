#!/bin/bash

OUTDIR=instances
NAME=randomcore

rm -rf $OUTDIR

for numfeat in 25 50 100 200 400; do
    for numopt in 50 150 250; do
        for consize in 2 3 4; do
            python generate.py -f $numfeat -o $numopt -c $consize --name $NAME --out $OUTDIR
        done
    done
done
