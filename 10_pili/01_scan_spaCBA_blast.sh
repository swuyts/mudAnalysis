#!/bin/bash

query=/media/harddrive/sander/mudan/10_pili/in/spaCBA.faa
p_in=/media/harddrive/sander/mudan/04_annotation/out/*/*.faa*
p_out=/media/harddrive/sander/mudan/10_pili/out/spaCBA/


mkdir $p_out

for fastaFile in $p_in; do
	bunzip2 $fastaFile
	fastaFile=${fastaFile%.bz2}


        genome=${fastaFile##*/}
        genome=${genome%%.*}

	echo MAKING BLAST DATABASE $genome
	echo
	makeblastdb -in $fastaFile -dbtype prot -title target -out target -parse_seqids
	echo

	echo QUERYING BLAST DATABASE 
	echo
	blastp -task blastp -db target -query $query -out ${p_out}${genome}.genes_hits.tsv -num_threads 8 -outfmt '6 qseqid sseqid pident length qcovs'
	echo

	rm -f target.faa target.p*

	bzip2 $fastaFile

done



