#/bin/bash

pin=/media/harddrive/sander/mudan/13_plasmids/out_prokka/
pout=/media/harddrive/sander/mudan/13_plasmids/out_eggnogmapping/
eggnogmapper=/media/harddrive/tools/eggnog-mapper-1.0.3/emapper.py

export PATH=$PATH:/media/harddrive/tools/diamond-0.9.13

mkdir -p $pout
cd $pout

for isolate in ${pin}*/*.faa*
do
	# Copy plasmids
        isolateName=$(basename $(dirname $isolate))

	bunzip2 $isolate

	# Run eggnogmapper
	python $eggnogmapper -i ${isolate%.*} --output ${pout}${isolateName} --cpu 16 -m diamond

	bzip2 ${isolate%.*}
done

