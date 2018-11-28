#!/bin/bash

# We will be using a custom Lactobacillus database based on all complete genomes
grep "Lactobacillus" ../02_download_ncbi_genomes/assembly_summary.txt | grep "Complete Genome" > complete_genomes.txt

cd /media/harddrive/data/ncbi_lactobacillus_complete_faa

for next in $(cat /media/harddrive/sander/mudan/04_annotation/complete_genomes.txt | cut -f20); do
	wget ${next}/${next##*\/}_protein.faa.gz
done

rename 's/\..*\.faa/.faa/' *.faa.gz

cd /media/harddrive/data/ncbi_lactobacillus_complete_faa

parallel --jobs 8 --no-notice --verbose 'gunzip' ::: *faa.gz

cat *faa > Lactobacillus.faa
cd-hit -i Lactobacillus.faa -o Lactobacillus -T 0 -M 0 -g 1 -s 0.8 -c 0.9
rm -fv Lactobacillus.faa Lactobacillus.bak.clstr Lactobacillus.clstr
makeblastdb -dbtype prot -in Lactobacillus
mv Lactobacillus.p* /media/harddrive/tools/prokka/db/genus

parallel --jobs 8 --no-notice --verbose 'gzip' ::: *faa

rm -fv /media/harddrive/sander/mudan/04_annotation/complete_genomes.txt
