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
packets <- c(unlist(input, recursive = FALSE), list(list(2)), list(list(6)))

N <- length(packets)
# bubble sort packets
for(i in 1:(N-1)){
    for(j in 1:(N-i)){
        if(compare(packets[[j]], packets[[j+1]]) == -1){
            temp <- packets[[j+1]]
            packets[[j+1]] <- packets[[j]]
            packets[[j]] <- temp
        }
    }
}

part2 <- 1
for(i in seq_along(packets)){
    pkt <- unlist(packets[[i]])
    if(length(pkt) == 1 && pkt %in% c(2, 6)){
        part2 = part2 * i
    }
}
part2

