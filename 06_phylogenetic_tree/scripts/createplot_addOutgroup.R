library(ggplot2)

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("Please provide the output folder of addOutgroup.sh", call.=FALSE)
} else if (length(args)==1) {
  table <- read.table('core_genes_hits.tsv', col.names= c("qseqid","sacc","pident","lengt","qcovs"))
  
  plot <- ggplot(table)
  plot + geom_point(aes(x=qcovs,y=pident),alpha=0.5,size=1) + xlim(0,100) + ylim(0,100)
  
  ggsave("QC_plot.png",width=9,height=9,units='cm')
}


