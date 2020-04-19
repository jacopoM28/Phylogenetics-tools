#!/bin/bash
while getopts ":i:l:h" o; do
    case "${o}" in

        i) input=${OPTARG}
            ;;
		l) lenght=${OPTARG}
            ;;
        h) echo "Filters a MSA based on a user-supplied threshold representing the minimum number of nucleotides. MSA must be in fasta format
        
        			-i .fasta MSA
        			-l nucleotide threshold
        			
As output is returned a .filtered fasta with the filtered MSA and a .txt with the deleted sequences
        		"
                      exit
           ;;
         esac
     done

while read line; do if [[ $line == ">"* ]]; then header=$line;
	else
sites=$( echo "$line" | sed 's/-//g' | wc -c);
	if (( "$sites" >= "$lenght" )); then echo -e "$header\n$line" >> "$input".filtered
fi;
fi;
done < "$input"
grep ">" "$input" >> "$input".tmp
grep ">" *.filtered >> filtered.header.tmp
diff=$(grep -v -f filtered.header.tmp "$input".tmp | sed 's/>//g')
	echo "$diff" >> "$input".deleted.txt
rm *.tmp
