#Calculates the GC content of each sequence contained in a MSA. As output is returned a .txt file where is listed the
#number of G, of C, of G + C, the total number of nucleotides and the GC ratio. The GC content is rounded at the first decimal
#directly through Bash

for j in *.fasta; 
	do varS=$(echo "$j" | awk -F '.' '{print $1 "." $2}');# echo 
	echo "header G C sites GC" >> $varS"_GCcontent.txt"
for i in $(grep ">" $j | sed 's/>//g'); 
	do
		varG=$(grep -A1 "$i" $j | tail -1 | tr '[:lower:]' '[:upper:]' | tr -cd 'G' | wc -c)
		varC=$(grep -A1 "$i" $j | tail -1 | tr '[:lower:]' '[:upper:]' | tr -cd 'C' | wc -c)				
		varGC=$(($varG+$varC)) 
		sites=$(grep -A1 "$i" $j | tail -1 | sed 's/-//g' | wc -c);
		GCproportion=$(bc -l <<< "$varGC / $sites *100" | rev | cut -c 19- | rev)		
		last=$(echo "$GCproportion" | head -c 5 | tail -c 1); 
if [[ "$last" -ge 5 ]];
	 then GCproportion=$(bc -l <<< "$GCproportion + 0.1"); 
fi;
	GC=$(echo "$GCproportion" | head -c 4)
	echo "$i $varG $varC $sites $GC" >> $varS"_GCcontent.txt" 
done;
done;


