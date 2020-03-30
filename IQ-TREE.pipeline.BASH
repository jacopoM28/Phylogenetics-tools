#!/bin/bash
while getopts ":i:t:n:h" o; do
    case "${o}" in

        i) input=${OPTARG}
            ;;
		t) code=${OPTARG}
            ;;
        n) core=${OPTARG}
        	;;
        h) echo "Runs 100 IQ-TREE ML trees searches, computes the RF distances between the ML trees, compares the LogL and finds the one(s) with the highest one, finally it computes a consensus tree between all the ML trees and calculates the RF distances.
    
    IMPORTANT: IQ-tree path and/or version must be specified by the users modifing lines 55, 57, 72, 98, 99, 106, 113, 114.
    input file:	
			-i .fasta alignment.
			-t a priori partitioning scheme.
			-n numbers of cores
	all output files are stored in the output directory:
			all.ML.trees = collection of ML trees. 
			ML.tree = best ML tree(s).
			LogL.comparison.txt = LogL references.
			ML.contree = consensus tree.
			MLtrees.rfdist = RF distances between ML trees.
			MLvsContree.rfdist = RF distances between ML and consensus tree.
			consensus.constrained.treefile = Constrained tree on the consensus topology.
			MLandConsensus.txt = ML and Constrained tree.
			topology.test.iqtree = Results of the topology test.
			consensus.contree.suptree = ML trees with mapped the consensus support values
			
*****IMPORTANT NOTES*****
		1) IQ-tree tree search parameters can be adjusted modifing lines 55 and 57.
		2) By default a semi-random number between 0.1 and 1 is extracted and used as perturbation strength value.
		      To disable this option comments line 39, 40 and modifies the respectively -pers option in IQ-tree parameters.	
		3) In the output of topology test tree 1 = ML tree, while tree 2 = Consensus tree      
				
				"
               exit
           ;;
         esac
     done

##make 100 iq-tree run and save ML trees in all.ML.trees file

	mkdir output
	
	echo "*** performing 100 IQ-TREE tree searches ***"

	for run in {1..100}; 
do 
	(( n = 1 + RANDOM % 100 )); 	
	pers=$(printf '%s.%s\n' $(( n / 100 )) $(( n % 100 )));
	
	if [[ "$run" == "1" ]]; 
then 
	iqtree -s $input -m TEST -spp "$code" -pre run"$run" -bb 1000 -pers "$pers" -nt "$core" -quiet -nstop 500 -nm 5000
else
	iqtree -s $input -spp run1.best_scheme.nex -pre run"$run" -bb 1000 -pers "$pers" -nt "$core" -quiet -nstop 500 -nm 5000
fi;
	if grep -q 'Consensus tree has higher likelihood than ML tree found!' run"$run".iqtree;
then 
	cat run"$run".contree >> all.ML.trees;
else
	cat run"$run".treefile >> all.ML.trees;
fi;

	echo "*** run ${run}...done ***"

done;

##Make consensus tree from obtained ML trees
	
	iqtree -t all.ML.trees -con -pre consensus -nt "$core" -quiet
	echo "*** IQ-TREE consensus tree...done ***"
	
###Compare LogL of the ML trees, finds the best one and compare it with consensus

for i in *.iqtree; 
do 
if grep -q 'Consensus tree has higher likelihood than ML tree found!' "$i";
then
	LogL=$( grep "Log-likelihood of consensus tree:" "$i" | awk -F " " '{print$5}');
	RunName1=$( echo "$i" | awk -F "." '{print$1}');
	RunName2=$(echo "$RunName1".contree)
	echo "$RunName2 $LogL" >> LogL.comparison.txt;
else
	LogL=$( grep "Log-likelihood of the tree:" "$i" | awk -F " " '{print$5}');
	RunName1=$( echo "$i" | awk -F "." '{print$1}');
	RunName2=$(echo "$RunName1".treefile)
	echo "$RunName2 $LogL" >> LogL.comparison.txt;
fi;
done;

	bestLogL=$(awk -F " " 'BEGIN { max = -inf } { if ($2 < max) { max = $2; line = $0 } } END { print line }' LogL.comparison.txt);
	bestree=$(echo "$bestLogL" | awk -F " " '{print$1}');
	echo "*** ${bestree} IS THE ML TREE ***"
	cat "$bestree" >> ML.tree
	
 	iqtree -t ML.tree -rf consensus.contree -pre MLvsContree -quiet
 	iqtree -t all.ML.trees -rf_all -pre MLtrees -quiet
 	
 	echo "*** IQ-TREEx tree comparison...done ***"
 	
###Constrained tree search on the topology of the consensus tree and topology test between the result and the ML tree
###Nodal support values represents "Consensus support"/ "UltrafastBootstrap"

	iqtree -s "$input" -spp run1.best_scheme.nex -g consensus.contree -pre ML.consensus -nt "$core" -quiet
	
	echo "*** IQ-TREE Constrained tree search...done ***"
	
	cat ML.tree >> MLandConsensus.txt
	cat ML.consensus.treefile >> MLandConsensus.txt
	
	iqtree -s "$input" -spp run1.best_scheme.nex -z MLandConsensus.txt -n 0 -zb 10000 -zw -au -pre topology.test -te ML.tree -quiet
	iqtree -sup ML.tree -t consensus.contree
	
	echo "*** all analyses are finished....collecting results ***"
	 
 	mv topology.test.iqtree ./output
 	mv ML.consensus.treefile ./output
 	mv consensus.contree ./output
	mv all.ML.trees ./output
	mv ML.tree ./output
	mv MLtrees.rfdist ./output
	mv MLvsContree.rfdist ./output
	mv MLandConsensus.txt ./output
	mv consensus.contree.suptree ./output
	
	echo " *** lunching R script ****"
	
Rscript ./script.R
	
	mv LogL.comparison.txt ./output
	mv ML.comparison.pdf ./output
	rm Rplots.pdf
