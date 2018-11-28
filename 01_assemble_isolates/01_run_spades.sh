ps=/media/harddrive/tools/spades/SPAdes-3.12.0-Linux/bin/spades.py

gunzip in/*.gz


for isolate in in/*R1*fastq
do
        removePath=$(basename "$isolate")
        isolateName=${removePath%%_*}

	$ps --pe1-1 in/${isolateName}*R1*.fastq \
		--pe1-2 in/${isolateName}*R2*.fastq \
		-t 16 \
		-o out_spades/${isolateName}  \

done

gzip in/*.fastq

