#!/bin/bash

pin=/media/harddrive/sander/mudan/01_assemble_isolates/out_spades/
preads=/media/harddrive/sander/mudan/01_assemble_isolates/in/
pinter=/media/harddrive/sander/mudan/13_plasmids/out_recycler/intermediate/
pout=/media/harddrive/sander/mudan/13_plasmids/out_recycler/

mkdir $pout

# Prepare the BAM input
for isolate in ${preads}*R1*fastq*
do
        removePath=$(basename "$isolate")
        isolateName=${removePath%%_*}

	echo $isolateName

	mkdir $pinter
	make_fasta_from_fastg.py -g ${pin}${isolateName}/assembly_graph.fastg -o ${pinter}assembly_graph.nodes.fasta
	bwa index ${pinter}assembly_graph.nodes.fasta

	R1=${preads}${isolateName}*R1*.fastq.gz
	R2=${preads}${isolateName}*R2*.fastq.gz

	bwa mem -t 16 ${pinter}assembly_graph.nodes.fasta ${R1} ${R2} | samtools view -buS - > ${pinter}reads_pe.bam
	samtools view -bF 0x0800 ${pinter}reads_pe.bam > ${pinter}reads_pe_primary.bam
	samtools sort ${pinter}reads_pe_primary.bam -o ${pinter}reads_pe_primary.sort.bam
	samtools index ${pinter}reads_pe_primary.sort.bam

# Run recycler
	recycle.py -g ${pin}${isolateName}/assembly_graph.fastg \
		-k 127 \
		-b ${pinter}reads_pe_primary.sort.bam \
		-i True \
		-o ${pout}${isolateName}

	rm -r $pinter
done
