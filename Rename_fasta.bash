#!/bin/bash

annotation=$1
fasta=$2

sed -e 's/^/>/' "$annotation" > "$annotation".tmp
mkdir output

while read line; do

	if [[ "$line" ==  ">"* ]]; then
	
		echo "$line"	
		varID=$(echo "$line")
		echo "$varID"
		result=$(grep "$varID" "$annotation".tmp)
		echo "$result"
	
		if [[ -n "$result" ]]; then
		
			varNEWID=$(grep "$varID" "$annotation".tmp | awk -F "\t" '{print$2}')
			echo ">$varNEWID" >> "$fasta".renamed
			varSEQ=$(grep -A1 "$line" "$fasta" | grep -v "$line")
			echo "$varSEQ" >> "$fasta".renamed
			
		else
			cd ./output
			echo "$varID" >> "$fasta".delated.txt
			cd ..
			
		fi;
	fi;
done< "$fasta"
mv "$fasta".renamed output
rm "$annotation".tmp