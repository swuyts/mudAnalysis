#!/usr/bin/Rscript

# set-up

sinkfile <- file("sinkfile", open = "wt")
sink(sinkfile, type = "message")

library(tidyverse)
library(stringr)
library(Biostrings)

# expected args: --indir, --outfile and --clade
args <- matrix(commandArgs()[-1], ncol = 2, byrow = T)
for (i in 1:nrow(args)) assign(gsub("--", "", args[i, 1]), args[i, 2])

# actual code

repr_aastringset <- AAStringSet()

for (file in list.files(indir, full.names = T)) {
  
  og_name <- str_match(file, "([^/]+)\\.fa$")[1, 2]
 
  og_aastringset <- readAAStringSet(filepath = file)
  
  og_lengths <- tibble(length = width(og_aastringset)) %>%
    mutate(index = 1:n()) %>%
    arrange(length) 

  repr_index <- og_lengths %>%
    pull(index) %>%
    .[((length(.) + 1 ) / 2) %>% ceiling()]

  repr_aastring <- og_aastringset[repr_index] %>%
    `names<-`(str_c(clade, og_name, sep = "_"))
  
  repr_aastringset <- c(repr_aastringset, repr_aastring)
  
}

writeXStringSet(repr_aastringset, filepath = outfile)

# closing down

sink <- file.remove("sinkfile")




