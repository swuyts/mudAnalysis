#!/bin/bash

pout=/media/harddrive/sander/mudan/04_annotation/out/

export PATH=$PATH:/media/harddrive/tools/prokka/bin/
export PATH=$PATH:/media/harddrive/tools/barrnap/bin/

mkdir /media/harddrive/sander/mudan/04_annotation/in

# Copy own isolates to in folder
for isolate in /media/harddrive/sander/mudan/01_assemble_isolates/out_spades/*/contigs.fasta
do
        isolateName=$(basename $(dirname $isolate))
        cp $isolate in/${isolateName}.fna
done

# Copy other assemblies to in folder
cp /media/harddrive/sander/mudan/02_download_ncbi_genomes/out/*.fna* in/
parallel --jobs 16 --no-notice --verbose 'gunzip' ::: in/*fna.gz

cd in/

# Run Prokka
while read genome; do
	prokka ${genome}.fna --outdir ${pout}${genome} --prefix ${genome} --compliant --genus Lactobacillus --usegenus --cpus 16
done < /media/harddrive/sander/mudan/03_quality_control/genomesToUse.txt


