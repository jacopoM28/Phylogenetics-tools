#!/bin/bash

tree=$1
annotation=$2

varFirstLine=$(head -1 "$annotation")
while read line; do
		
	varID=$(echo "$line" | awk -F "\t" '{print$1}');
	varTaxon=$(echo "$line" | awk -F "\t" '{print$2}');

if [[ "$line" == "$varFirstLine" ]]; then

sed -e "s/,${varID}:/,${varTaxon}:/g" -e "s/(${varID}:/(${varTaxon}:/g" $tree > "$tree".renamed.newick

else

sed -i '' -e "s/,${varID}:/,${varTaxon}:/g" -e "s/(${varID}:/(${varTaxon}:/g" "$tree".renamed.newick

fi;
done < "$annotation"

sed -i '' -e 's/,0917/,Diapherodes dominicae/g' -e 's/(0917/(Diapherodes dominicae/g' "$tree".renamed.newick