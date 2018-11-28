#!/bin/bash

# Based on this https://github.com/gem-pasteur/Macsyfinder_models/tree/master/models/Conjugation

p_in=/media/harddrive/sander/mudan/04_annotation/out/*/*.faa*
p_CONJScan=/media/harddrive/sander/mudan/10_pili/in/CONJScan/
p_out=/media/harddrive/sander/mudan/10_pili/out/CONJScan/


cd $p_CONJScan

for fastaFile in $p_in; do
	bunzip2 $fastaFile
	fastaFile=${fastaFile%.bz2}

        genome=${fastaFile##*/}
        genome=${genome%%.*}

	for conj_type in typeF typeB typeC typeFATA typeFA typeG typeI typeT; do
		macsyfinder "$conj_type" -w 16 -d definitions -p profiles -o ${p_out}${genome}_$conj_type --db-type ordered_replicon --sequence-db $fastaFile
	done

	rm -rf ${fastaFile}.idx ${fastaFile}.phr ${fastaFile}.pin ${fastaFile}.pog ${fastaFile}.psd ${fastaFile}.psi ${fastaFile}.psq /media/harddrive/sander/mudan/04_annotation/out/$genome/formatdb.err
	bzip2 $fastaFile

done


