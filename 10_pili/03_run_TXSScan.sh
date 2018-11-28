#!/bin/bash

p_in=/media/harddrive/sander/mudan/04_annotation/out/*/*.faa*
p_TXSScan=/media/harddrive/sander/mudan/10_pili/in/TXSScan/
p_out=/media/harddrive/sander/mudan/10_pili/out/TXSScan/

cd $p_TXSScan

for fastaFile in $p_in; do
	bunzip2 $fastaFile
	fastaFile=${fastaFile%.bz2}

        genome=${fastaFile##*/}
        genome=${genome%%.*}

	macsyfinder -w 16 -d DEF_TXSS/ -p profiles_TXSS/ -o ${p_out}$genome --db-type ordered_replicon --sequence-db $fastaFile all

	rm -rf ${fastaFile}.idx ${fastaFile}.phr ${fastaFile}.pin ${fastaFile}.pog ${fastaFile}.psd ${fastaFile}.psi ${fastaFile}.psq /media/harddrive/sander/mudan/04_annotation/out/$genome/formatdb.err
	bzip2 $fastaFile

done



