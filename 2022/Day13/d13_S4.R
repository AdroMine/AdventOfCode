setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# file <- 'sample.txt'
file <- 'input.txt'
input <- readr::read_file(file) |>
    gsub("\r", "", x = _) |>
    # divide into pairs
    strsplit('\n\n') %>% 
    `[[`(1) |> 
    # separate pairs
    lapply(function(x) strsplit(x, '\n')) |>
    
    unlist(recursive = FALSE) %>% 

    # convert to list of lists
    lapply(function(l) lapply(l, jsonlite::parse_json))


# Compare methods using S4 dispatch to avoid if/else
compare <- function(left, right)  UseMethod('compare')
# number and number
setMethod('compare', signature(left = 'numeric', right = 'numeric'), 
          function(left, right) (left < right) - (left > right))

# list and list
setMethod('compare', signature(left = 'list', right = 'list'), 
          function(left, right){
              len_l <- length(left)
              len_r <- length(right)
              for(k in seq_len(min(len_l, len_r))){
                  good <- compare(left[[k]], right[[k]])
                  if(good == 0) next
                  return(good)
              }
              compare(len_l, len_r)
          })
# list and number
setMethod('compare', signature(left = 'list', right = 'numeric'), 
          function(left, right) callGeneric(left, list(right)) )
# number and list
setMethod('compare', signature(left = 'numeric', right = 'list'), 
          function(left, right) callGeneric(list(left), right) )


# Part 1
right_order <- sapply(input, function(pair){
    compare(pair[1], pair[2]) == 1
})

sum(which(right_order))


# Part 2 

p2 <- list(list(2))
p6 <- list(list(6))
l2 <- 1 # min can be 1
l6 <- 2 # min can be 2
packets <- unlist(input, recursive = FALSE)
for(i in seq_along(packets)){
    if(compare(p2, packets[[i]]) == -1) l2 <- l2 + 1
    if(compare(p6, packets[[i]]) == -1) l6 <- l6 + 1
}

l2*l6

