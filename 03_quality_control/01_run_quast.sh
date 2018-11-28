#!/bin/bash

mkdir /media/harddrive/sander/mudan/03_quality_control/in

# Copy own isolates to in folder
for isolate in /media/harddrive/sander/mudan/01_assemble_isolates/out_spades/*/contigs.fasta
do
	isolateName=$(basename $(dirname $isolate))
	cp $isolate in/${isolateName}.fna
done

# Copy other assemblies to in folder
cp /media/harddrive/sander/mudan/02_download_ncbi_genomes/out/*.fna* in/
parallel --jobs 16 --no-notice --verbose 'gunzip' ::: in/*fna.gz

# Run quast
quast.py -o out --threads 16 in/*.fna*

# Remove in folder to save space
rm -rf /media/harddrive/sander/mudan/03_quality_control/in

