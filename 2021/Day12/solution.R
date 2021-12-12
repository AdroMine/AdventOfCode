setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(dplyr)

# Read in input
file_name <- "sample3.txt"
# file_name <- "input.txt"

input <- read.table(file_name, sep = "-")

# generate graph from and to edges
parse_input <- function(input){
    non_start <- which(input$V1 != "start")
    non_end <- which(input$V2 != "end")
    two_way_paths <- intersect(non_start, non_end)
    
    from <- c(input$V1, input$V2[two_way_paths])
    to <- c(input$V2, input$V1[two_way_paths])
    
    input <- data.frame(from, to) %>% 
        filter(from != "end", 
               to   != "start")
    
    from <- input$from
    to   <- input$to
    list(from = from, 
         to   = to)
    
}


res <- parse_input(input)
from <- res$from
to   <- res$to

# faster solution, takes around 3 seconds for part2
generate_graph <- function(st = 'start', cant = NULL, part2 = FALSE){
    if(st == "end")
        return(1)
    
    paths <- 0
    e2 <- to[which(from == st)]
    
    for(p in e2){
        
        if(!(p %in% cant)){
            nxt_cant <- if(tolower(p) == p) p else NULL
            paths <- paths + Recall(p, c(cant, nxt_cant), part2)
        } else if(part2){
            paths <- paths + Recall(p, cant, FALSE)
        }
        
        
    }
    paths
}

generate_graph(st = 'start', cant = NULL, part2 = FALSE)
generate_graph(st = 'start', cant = NULL, part2 = TRUE)


