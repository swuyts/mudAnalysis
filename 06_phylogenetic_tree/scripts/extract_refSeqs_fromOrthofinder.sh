#!/bin/bash


echo MAKE REPRESENTATIVE SEQUENCES FASTA WITH GROUP NAMES, FROM ORTHOFINDER
echo

while IFS='' read -r line || [[ -n "$line" ]]; do
	python ../scripts/extract_firstSeq_fromFasta.py ${2}${line}.fa >> CoreOrthogroupsRefSeqs.faa
done < "$1"

echo


