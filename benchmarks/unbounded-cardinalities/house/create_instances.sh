#!/bin/bash

OUTDIR=instances

rm -rf $OUTDIR

numInstances=10
things=10
roomsPerPerson=5

for persons in 1 2 3 4 5; do
    maxRooms=$((roomsPerPerson * persons))
    python generate.py --maxrooms ${maxRooms} --maxthings ${things} --persons ${persons} --instances ${numInstances} --out $OUTDIR
done
