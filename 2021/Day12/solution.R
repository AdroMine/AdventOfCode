setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(dplyr)

# Read in input
# file_name <- "sample1.txt"
file_name <- "input.txt"

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

generate_graph <- function(st = 'start', prev = NULL, part1 = TRUE){
    e2 <- to[which(from == st)]
    
    small <- grep("[[:lower:]]", c(prev, st), value = TRUE, perl = TRUE)
    
    if(length(small) > 0){
        
        if(part1){
            e2 <- setdiff(e2, small)
        } else {
            
            if(anyDuplicated(small)){
                e2 <- setdiff(e2, small)
            }
        }
    }
    
    for(p in e2){
        
        if(p == 'end'){
            count <<- count + 1
            next
        } else {
            Recall(p, c(prev, st), part1 = part1)
        }
    }
}

count <- 0
generate_graph(st = 'start', prev = NULL, part1 = TRUE)
count

count <- 0
generate_graph(st = 'start', prev = NULL, part1 = FALSE)
count

