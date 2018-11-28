#!/bin/bash

pplasmids=/media/harddrive/sander/mudan/13_plasmids/out_recycler/
pin=/media/harddrive/sander/mudan/13_plasmids/in/
pout=/media/harddrive/sander/mudan/13_plasmids/out_prokka/

export PATH=$PATH:/media/harddrive/tools/prokka/bin/
export PATH=$PATH:/media/harddrive/tools/barrnap/bin/

mkdir $pin
mkdir $pout

cd $pin

# Copy plasmids
for isolate in ${pplasmids}*/assembly_graph.cycs.fasta
do
	# Copy plasmids
        isolateName=$(basename $(dirname $isolate))
        cp $isolate ${pin}${isolateName}.fna

	# Run prokka
	prokka ${isolateName}.fna --outdir ${pout}${isolateName}_plasmid --prefix ${isolateName}_plasmid --compliant --genus Lactobacillus --usegenus --cpus 16

done



