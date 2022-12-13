setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

file <- 'sample.txt'
# file <- 'input.txt'
input <- readr::read_file(file) |>
    gsub("\r", "", x = _) |>
    # divide into pairs
    strsplit('\n\n') %>% 
    `[[`(1) |> 
    # separate pairs
    lapply(function(x) strsplit(x, '\n')) %>% 
    
    # parse_json fails without this eval somehow
    lapply(function(x) eval(parse(text = x))) %>% 
    # convert to list of lists
    lapply(function(l) lapply(l, jsonlite::parse_json))


min_len <- function(a, b) min(length(a), length(b))

compare <- function(left, right){
    
    # -1 left is not in correct order
    #  0 check next part of input
    #  1 left is in correct order
    
    good <- 0 
    length_lr <- min_len(left, right)
    
    if(is(left, 'numeric') && is(right, 'numeric')){
        for(k in seq_len(length_lr)){
            lk <- left[k]
            rk <- right[k]
            if (lk == rk) next 
            if(lk < rk) return(1)
            if(lk > rk) return(-1)
        }
        len_l <- length(left)
        len_r <- length(right)
        if(len_l == len_r) return(0)
        if(len_l <  len_r) return(1)
        return(-1)
    } else if(is(left, 'list') && is(right, 'list')){
        # compare each list item
        for(k in seq_len(length_lr)){
            
            good <- compare(left[[k]], right[[k]])
            if(good == 0) next
            return(good)
        }
        len_l <- length(left)
        len_r <- length(right)
        if(len_l == len_r) return(0)
        if(len_l <  len_r) return(1)
        return(-1)
        
    } else if(is(left, 'numeric') && is(right, 'list')){
        
        good <- compare(list(left), right)
        
    } else if(is(left, 'list') && is(right, 'numeric')){
        
        good <- compare(left, list(right))
        
    }
    
    good
    
}

right_order <- vector(length = length(input))
new_input <- input
for(i in seq_along(input)){
    
    pair <- input[[i]]
    
    res <- compare(pair[1], pair[2]) 
    if(res == 1){
        right_order[i] <- TRUE
    } else if(res == -1){
        new_input[[i]] <- c(pair[2], pair[1])
        
    } else {
        stop("This shouldn't have happened?")
    }
    
}

sum(which(right_order))


# Part 2 
new_input <- c(unlist(input, recursive = FALSE), list(list(2)), list(list(6)))


# essentially we need to sort this list, but we have custom rules for deciding
# where any item goes
# let's just use bubble sort
bubble_sort <- function(packets){
    
    N <- length(packets)
    
    for(i in 1:(N - 1)){
        for(j in 1:(N - i)){
            p1 <- packets[[j]]
            p2 <- packets[[j+1]]
            if(compare(p1, p2) == -1){
                temp <- packets[[j+1]]
                packets[[j+1]] <- packets[[j]]
                packets[[j]] <- temp
            }
        }
    }
    packets
}

packets <- bubble_sort(new_input)
