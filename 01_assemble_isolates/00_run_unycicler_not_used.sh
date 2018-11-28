#!/bin/bash

gunzip in/*.gz

for isolate in in/*R1*fastq
do
        removePath=$(basename "$isolate")
        isolateName=${removePath%%_*}
	unicycler -1 in/${isolateName}*R1*.fastq \
		-2 in/${isolateName}*R2*.fastq \
		-o out/$isolateName \
		-t 8 \
		--spades_path /media/harddrive/tools/spades/SPAdes-3.12.0-Linux/bin/spades.py \
		--pilon_path /media/harddrive/tools/pilon-1.22.jar
done

gzip in/*.fastq
