setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(scipen = 999) # display all digits, no scientific mode

# file_name <- 'sample.txt'
file_name <- 'input.txt'

tbl <- read.table(file_name, sep = ":") |> 
  tidyr::separate_longer_delim(V2, ' ') |> 
  dplyr::filter(V2 != '')

library(igraph)

graph <- igraph::graph_from_data_frame(tbl, directed = FALSE) 


k <- igraph::min_cut(graph, value.only = FALSE)

stopifnot(k$value == 3)

# Answer
length(k$partition1) * length(k$partition2)


# edges that were cut:
k$cut
