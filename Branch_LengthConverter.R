######################################################################################################################################################
#Convert branch lengths of a set of trees in order to reflect Substitution rates rather than Evolutionary rates (calculated as Evolutionary Rate/My).#
#In order to properly convert the branch lengths all tips must be in the same order in all trees.                                                    #
#The script will check it, if it will not find a solution rotatin the branches it will print out an error message                                    #                                                       #
#Branch lengths in million years have to be provided from a Time tree.                                                                               #
#Arguments MUST be passed in the following order: 1. Tree to convert; 2. Time tree; 3. Output prefix, default "out"                                  # 
#                                                                                                                                                    #
#Example usage: Rscript Branch_LengthConverter.R input_tree.nwk time_tree.nwk out_prefix                                                             #
######################################################################################################################################################
#!/usr/bin/env Rscript

library(ape)

##########################################
#------------Argument parser-------------#
##########################################

args = commandArgs(trailingOnly=TRUE)

#Checking that all arguments have been parsed
if (length(args) <2 ) {
  stop("At least two argument must be supplied (1: Tree to convert; 2: Time tree).n", call.=FALSE)
} else if (length(args)==2) {
  # default output file
  args[3] = "out"
}

########################################
#------------Loading Files-------------#
########################################

#Loading input tree.
Tree <- read.tree(args[1])
#Loading the time tree
Time_Tree <- read.tree(args[2])

########################################
#-----------------Main-----------------#
########################################

#Checking that number of nodes between each tree and the time tree is matching...
if (Tree$Nnode != Time_Tree$Nnode) {
    print(paste0("WARNING : ", args[1]," has a different number of nodes than the supplied Time tree"))
    print("Branch lengths won't be converted.")
} else {  
  #Checking that tip labels are in the same order (=The trees are equal)
  if (all(Time_Tree$tip.label == Tree$tip.label)) { #if yes...
      Tree$edge.length <- Tree$edge.length/Time_Tree$edge.length
      #... converting branches with inf value - it happens when Time tree have some 0 branch lenghts - with 0 and write output file
      Tree$edge.length[!is.finite(Tree$edge.length)] <- 0
      write.tree(Tree,file = paste0(args[3],"_",args[1]))
 } else { #If not...
      #... try to rotate input tree 
      print(paste0("WARNING : tips label of ",args[1]," are not in the same order of the Time tree"))
      print("Trying rotating nodes ...")
      co <- Time_Tree$tip.label
      Tree_2 = rotateConstr(Tree, co)
      #Check again order of tip labels
      if (all(Time_Tree$tip.label == Tree_2$tip.label)) { #if yes...
          #... Continue
          print("-------> Conflicts resolved!")
          Tree$edge.length <- Tree$edge.length/Time_Tree$edge.length
          Tree$edge.length[!is.finite(Tree$edge.length)] <- 0
          write.tree(Tree,file = paste0(args[3],"_",i))
      } else { #if not...
          #Print error
          print(paste0("------>ERROR : ",args[1], " is in conflict with the Time tree....Branch lengths won't be converted!"))
    }
  }
}