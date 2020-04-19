#!/bin/bash

while getopts ":i:c:h" o; do
    case "${o}" in

        i) input=${OPTARG}
            ;;
		c) code=${OPTARG}
            ;;
        h) echo "*** Recodes a nucleotide MSA in fasta format in a RY one, following the IUPAC ambiguity codes
Alternatively is possible to change the coding scheme to 01, with 0 = R and 1 = Y through the -c option
        
        			-i fasta MSA
        			-c coding scheme. bn = 01 coding; RY = RY coding
        
As output is given a translated MSA ***"
                      exit
           ;;
         esac
     done

while read line; do
	
if [[ "$line" = ">"* ]]; 

	then 

echo "$line" >> "$input".recoded.fasta;
	
	else
	
if [[ "$code" = bn ]];
	
	then 

RY=$(echo "$line" | tr '[:lower:]' '[:upper:]' | sed 's/A/0/g' | sed 's/G/0/g' | sed 's/T/1/g' | sed 's/C/1/g') 
echo "$RY" | sed 's/B/-/g' | sed 's/N/-/g' | sed 's/W/-/g' | sed 's/M/-/g' | sed 's/K/-/g'| sed 's/W/-/g' | sed 's/S/-/g' >> "$input".recoded.fasta 	
		
	else
	
if [[ "$code" = RY ]];

	then
	
RY=$(echo "$line" | tr '[:lower:]' '[:upper:]' | sed 's/A/R/g' | sed 's/G/R/g' | sed 's/T/Y/g' | sed 's/C/Y/g') 
echo "$RY" | sed 's/B/-/g' | sed 's/N/-/g' | sed 's/W/-/g' | sed 's/M/-/g' | sed 's/K/-/g'| sed 's/W/-/g' | sed 's/S/-/g' >> "$input".recoded.fasta 

	fi;
	fi;
	fi;
done < "$input"
