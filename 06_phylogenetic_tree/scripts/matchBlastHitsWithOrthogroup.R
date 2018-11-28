library(tidyverse)

args = commandArgs(trailingOnly=T)

# Following files are required as input:
# - first argument: Orthogroups.csv
# - second argument: core_genes_hits.tsv
# Following output files need to be specified: 
# - third argument: Orhtogroups_withOutgroup.csv
# - fourth argument: output file 2 (gene names and outgroup sequences of gene groups present in outgroup)

# read in the tables
presenceTable = read_tsv(args[1]) %>%
  rename(Orthogroup = X1)
outgroupHits = read_tsv(args[2], col_names = F) %>%
  setNames(c("query", "hit", "identity", "length", "coverage"))

# put cut-off on blastp hits
outgroupHits = outgroupHits %>%
  filter(identity > 50, coverage > 75)

# match hits from outgroup genes to Orthogroup
nrow = nrow(presenceTable)
ncol = ncol(presenceTable)
outgroupHits$presenceRow = match(outgroupHits$query, c(as.matrix(presenceTable)))%%nrow
presenceTable$outgroup = character(nrow)
presenceTable[outgroupHits$presenceRow, "outgroup"] = outgroupHits$hit

# write updated presence absence table 
write.table(presenceTable, file=args[3], 
            row.names=F, quote=T, sep=",")

# write table with gene name and sequence name of gene groups present in outgroup
write.table(presenceTable[presenceTable$outgroup!="",c("Orthogroup", "outgroup")], file=args[4], 
            row.names=F, col.names=F, quote=F, sep=",")
