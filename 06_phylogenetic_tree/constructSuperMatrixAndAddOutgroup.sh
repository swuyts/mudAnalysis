#!/bin/bash
# Possible updates:
# - Use DNA instead of Proteins

pout=/media/harddrive/sander/mudan/06_phylogenetic_tree/supermatrix_out/

url_outgroup=ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/001/434/695/GCA_001434695.1_ASM143469v1/GCA_001434695.1_ASM143469v1_genomic.fna.gz

pin_OrthoFinder=/media/harddrive/sander/mudan/05_pangenome/Results_Sep03/
pin_OrthoFinderSeqs=/media/harddrive/sander/mudan/05_pangenome/Results_Sep03/Orthologues_Sep05/Sequences/

threads=16

mkdir $pout
cd $pout

parallel --jobs $threads --no-notice --verbose 'bunzip2' ::: ${pin_OrthoFinderSeqs}*bz2

#echo DOWNLOADING OUTGROUP GENOME
#echo
#wget $url_outgroup
#rename 's/\..*\.fna/.fna/' *.fna.gz
#echo

#echo ANNOTATING OUTGROUP GENOME
#echo
#export PATH=$PATH:/media/harddrive/tools/prokka/bin/
#export PATH=$PATH:/media/harddrive/tools/barrnap/bin/
#gunzip *.fna.gz
#prokka *.fna --outdir outgroup_annotated --prefix outgroup --compliant --cpus $threads
#echo

echo MAKING BLAST DATABASE OF OUTGROUP GENOME PROTEINS
echo
makeblastdb -in outgroup_annotated/*.faa -dbtype prot -title outgroup -out outgroup \
-parse_seqids
echo

echo EXTRACTING REFERENCE SEQUENCES FROM SINGLE COPY CORE ORTHOGROUPS
echo
while IFS='' read -r line || [[ -n "$line" ]]; do
        python ../scripts/extract_firstSeq_fromFasta.py ${pin_OrthoFinderSeqs}${line}.fa >> CoreOrthogroupsRefSeqs.faa
done < ${pin_OrthoFinder}SingleCopyOrthogroups.txt
echo

echo QUERYING BLAST DATABASE OF OUTGROUP GENOME WITH CORE GENES
echo
blastp -task blastp -db outgroup -query CoreOrthogroupsRefSeqs.faa -out core_genes_hits.tsv \
-max_target_seqs 1 -num_threads $threads -outfmt '6 qseqid sseqid pident length qcovs'
rm outgroup.p*
echo

echo GENERATING BLAST LENGTH-SCORE PLOT
echo
Rscript ../scripts/createplot_addOutgroup.R $pout
echo

echo MATCHING BLAST HITS WITH ORTHOGROUPS
echo
Rscript ../scripts/matchBlastHitsWithOrthogroup.R ${pin_OrthoFinder}Orthogroups.csv ${pout}core_genes_hits.tsv ${pout}OrthogroupsWithOutgroup.csv ${pout}outgroupSeq_and_Orthogroup.csv

echo ADDING OUTGROUP SEQUENCES TO THE GENE GROUP ALIGNMENTS
echo
mkdir ${pout}alignments
for line in $(cat ${pin_OrthoFinder}SingleCopyOrthogroups.txt);do
	cp ${pin_OrthoFinderSeqs}${line}.fa ${pout}alignments
done
for line in $(cat outgroupSeq_and_Orthogroup.csv); do
        orthogroup=${line%%","*}
        sequence=${line##*","}
        ../scripts/extract_seq.py outgroup_annotated/*.faa ${sequence} > outgroup.fasta
	awk '/>/{sub(">","&"FILENAME"_");sub(/\.fasta/,x)}1' outgroup.fasta > outgroup.fasta_temp
        cat ${pout}alignments/${orthogroup}.fa  outgroup.fasta_temp > OG_and_outgroup.fa
	mafft --quiet OG_and_outgroup.fa > ${pout}alignments/${orthogroup}.fa.aln
        rm outgroup.fasta outgroup.fasta_temp ${pout}alignments/${orthogroup}.fa OG_and_outgroup.fa
done
echo

echo MAKING SUPERALIGNMENT
echo
sed -i 's/GCA_/GCA-/g' ${pout}alignments/*.fa.aln
python ../scripts/geneStitcher.py -d _ -in ${pout}alignments/*.fa.aln
echo

parallel --jobs $threads --no-notice --verbose 'bzip2' ::: ${pin_OrthoFinderSeqs}*fa
