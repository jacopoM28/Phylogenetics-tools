README
================

## Set of Bash script which can be usefull during Phylogenetics analyses, make them quicker and easier

> All the scripts work with oneliner fasta, use option -h to display
> help

#### \* Binary\_MSA\_recoder:

By default it recoded a nucleotide MSA into RY sequences, following the
IUPAC ambiguity codes. It is possible to change default setting to
recoded the sequences as a binary 0 - 1 sequences.

**Usefull for decrease impact of heterogeneity in nucleotide composition
and substitution saturation**

#### \* GC\_calculator

Calculates %GC content for each sequence of a multi-fasta. Results are
stored in a tab separated .txt

#### \* Length\_filter

It filters a multi-fasta based on a user-defined treshold values of
number of pb. The excluded sequences are annotated in a .txt file

\*\*Also MSA are accepted with gaps ignored
