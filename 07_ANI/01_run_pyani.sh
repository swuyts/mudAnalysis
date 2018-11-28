#!/bin/bash

pin=/media/harddrive/sander/mudan/07_ANI/pyani_input/
pout=/media/harddrive/sander/mudan/07_ANI/pyani_output/

mkdir $pin
cp ../04_annotation/out/*/*fna* $pin

parallel --jobs 16 --no-notice --verbose 'bunzip2' ::: ${pin}*bz2

python3 /usr/local/bin/average_nucleotide_identity.py -i $pin -o $pout/ANIb -m ANIb --workers 16 -v
python3 /usr/local/bin/average_nucleotide_identity.py -i $pin -o $pout/TETRA -m TETRA --workers 16 -v

rm -rf $pin
