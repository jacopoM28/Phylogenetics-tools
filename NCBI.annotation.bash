#!/bin/bash


for i in *.fasta; do
	
	varGene=$(echo "$i" | awk -F "." '{print$1}')
		
		while read line; do
		
			if [[ "$line" == ">"* ]]; then 
		
				varID=$( echo "$line" | sed 's/>//g')
				varName=$(echo "$varID" | sed 's/_/ /g')
				echo -e "$line\t$varName" >> NCBI.Annotation_"$varGene".txt
		
			fi;
			
		done < "$i"

done; 