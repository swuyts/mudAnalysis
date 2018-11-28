#!/bin/bash

# Species names insipired by "expanding the biotechnology" paper and output from Phylophlan

genomes="
Lactobacillus\splantarum
Lactobacillus\sparaplantarum
Lactobacillus\splantarum\splantarum
Lactobacillus\splantarum\sargentoratensis
Lactobacillus\spentosus
Lactobacillus\sxiangfangensis
Lactobacillus\sfabifermentans
Lactobacillus\sherbarum
Lactobacillus\mudanjiangensis
"

pin=/media/harddrive/sander/mudan/02_download_ncbi_genomes/
pout=/media/harddrive/sander/mudan/02_download_ncbi_genomes/out

cd ${pin}

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt

cp /dev/null assembly_summary_plantarumgroup.txt

for genome in $genomes; do
        grep ${genome} assembly_summary.txt >assembly_summary_${genome#*\\s}.txt
        cat assembly_summary_${genome#*\\s}.txt >>assembly_summary_plantarumgroup.txt
done

cd ${pout}

for next in $(cat ${pin}assembly_summary_plantarumgroup.txt | cut -f20); do
        wget ${next}/${next##*\/}_genomic.fna.gz
done

rename 's/\..*\.fna/.fna/' *.fna.gz
