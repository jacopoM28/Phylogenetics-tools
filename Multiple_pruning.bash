#!/bin/bash

list=$1
mode=$2

if [[ "$mode" == "GENE" ]]; then

	for i in *.newick; do

	gene=$(ls | grep "$i" | awk -F "." '{print$1}')
	echo '***'"$gene"
		
		while read line; do
		
		results=$(grep "$line" "$i")
		
			if [[ -n "$results" ]]; then
				
				echo '>>>'"$line"' is pruning from '"$i";
				echo "$line" >> "$list"."$gene".tmp
			
			else
				
				echo '###'"$line"' is not present in '"$i";
			
			fi
		
		done < "$list"		
	
	pruned_species=$(cat "$list"."$gene".tmp | awk -v ORS=' ' '1')
	output=$(ls | grep -w "$i" | sed 's/newick/pruned/g')
	
	phyutility -pr -names "$pruned_species" -in "$i" -out "$output"	
	
	prefix=$(echo -e "$gene""\t")
	sed -i.old -e "s/^/$prefix/" "$list"."$gene".tmp

done;

echo -e "Tree\tPruned" >> output.summary.txt
cat *.tmp >> output.summary.txt
rm *.old
rm *.tmp

else 

	for i in *.newick; do
		
	pruned_species=$(cat "$list" | awk -v ORS=' ' '1')
	output=$(ls | grep -w "$i" | sed 's/newick/pruned/g')
	
	phyutility -pr -names "$pruned_species" -in "$i" -out "$output".newick
	
	done;
fi;
	