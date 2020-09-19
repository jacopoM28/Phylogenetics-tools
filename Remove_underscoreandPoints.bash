#!/bin/bash

fasta=$1
mkdir output

while read line; do

	if [[ "$line" ==  ">"* ]]; then
	
	echo "$line"
	var1=$(echo "$line" | sed 's/-/_/g' | sed 's/\./_/g')
	echo "$var1" >> "$fasta".modified
	
	else
	
	echo "$line" >> "$fasta".modified
	
	fi;

done< "$fasta"
mv "$fasta".modified output