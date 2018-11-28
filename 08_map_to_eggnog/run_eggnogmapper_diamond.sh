#/bin/bash

porthofinderseqs=/media/harddrive/sander/mudan/05_pangenome/Results_Sep03/Orthologues_Sep05/Sequences/
pout=/media/harddrive/sander/mudan/08_map_to_eggnog/out
eggnogmapper=/media/harddrive/tools/eggnog-mapper-1.0.3/emapper.py

export PATH=$PATH:/media/harddrive/tools/diamond-0.9.13

mkdir -p $pout
cd $pout


echo MAKE REPRESENTATIVE SEQUENCES FASTA WITH GROUP NAMES, FROM ORTHOFINDER
echo
parallel --jobs 16 --no-notice 'bunzip2' ::: ${porthofinderseqs}*bz2

# First seq
#for fastaFile in $(ls ${porthofinderseqs}*.fa); do
#	python ../scripts/extract_firstSeq_fromFasta.py ${fastaFile} >> pan_genome_reference.fasta
#done

# Use the sequence with median length
Rscript ../scripts/extract_medianLength_seq.R --indir ${porthofinderseqs} --outfile pan_genome_reference.faa --clade mudan

parallel --jobs 16 --no-notice 'bzip2' ::: ${porthofinderseqs}*fa
echo

echo RUNNING EGGNOGMAPPER ON REPRESENTATIVE SEQUENCES
echo
python $eggnogmapper -i pan_genome_reference.faa --output mudan_pan_genome --cpu 16 -m diamond
echo

