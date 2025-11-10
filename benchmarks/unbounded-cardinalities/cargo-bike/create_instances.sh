#!/bin/bash

OUTDIR=instances

rm -rf $OUTDIR

for template in simple complex; do
    for range in 100 200 300 400 500; do
        python generate.py --range $range --instances 20 --out $OUTDIR --template $template
    done
done
