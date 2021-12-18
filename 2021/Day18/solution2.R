# based on 1vader's solution https://github.com/benediktwerner/AdventOfCode/blob/master/2021/day18/sol.py

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)
library(stringr)
library(collections)
library(jsonlite)

# Read and Transform input ------------------------------------------------
file_name <- "input.txt"
input <- readLines(file_name)
N <- length(input)

input <- lapply(input, jsonlite::parse_json)

#' Function to add number to the first left number
#' Need to search the right side of trees for the first left number
#' @return list of lists, with the first number available to the left 
#'  increased by n
add_to_left <- function(num, n){
    if(n == 0)
        return(num)
    
    if(is.numeric(num))
        return(num + n)
    
    return(
        list(
            num[[1]], 
            add_to_left(num[[2]], n)
        )
    )
}

#' Function to add number to the first left number
#' Keep searching to the left side of the tree for the first available number
#' @return list of lists, with the first number available to the left increased
#'   by n
add_to_right <- function(num, n){
    if(n == 0)
        return(num)
    
    if(is.numeric(num))
        return(num + n)
    
    return(
        list(
            add_to_right(num[[1]], n), 
            num[[2]] 
        )
    )
}

explode <- function(num, depth = 1){
    
    if(is.numeric(num)){
        return(list(num = num, change = FALSE, left = 0, right = 0))
    }
    
    if(depth == 5){
        return(list(num = 0, change = TRUE, left = num[[1]], right = num[[2]]))
    }
    
    
    if(is.list(num)){
        
        left_part <- num[[1]]
        right_part <- num[[2]]
        
        res <- Recall(left_part, depth + 1)
        if(res$change){
            return(
                list(
                    num = list(res$num,
                               add_to_right(right_part, res$right)), 
                    change = TRUE, left = res$left, right = 0
                ))
        }
        
        res <- Recall(right_part, depth + 1)
        if(res$change){
            return(
                list(
                    num =  list(add_to_left(left_part, res$left),
                                res$num), 
                    change = TRUE, left = 0, right = res$right
                ))
        }
    }
    return(
        list(
            change = FALSE, num = num, 
            left = 0, right = 0
        )
    )
} 


# Recursive function to split numbers
# returns a list containing boolean change (on whether any split happened)
# and the resulting snail number
num_split <- function(num){
    
    if(is.numeric(num)){
        if(num >= 10){
            return(list(
                change = TRUE, 
                num = list(floor(num/2), ceiling(num/2))
            ))
        } else {
            return(list(change = FALSE, num = num))
        }
    }
    
    left_part <- num[[1]]
    right_part <- num[[2]]
    
    res <- num_split(left_part)
    if(res$change){
        return(list(change = TRUE, num = list(res$num, right_part)))
    }
    
    res <- num_split(right_part)
    if(res$change){
        return(list(change = TRUE, num = list(left_part, res$num)))
    }
    
    return(list(change = FALSE, num = num))
}

reduce_number <- function(num){
    while(TRUE){
        res <- explode(num)
        if(res$change){
            num <- res$num
            next
        }
        res <- num_split(num)
        if(res$change){
            num <- res$num
            next
        }
        break
    }
    return(num)
}

magnitude <- function(num){
    if(is.numeric(num))
        return(num)
    
    return(
        3 * magnitude(num[[1]]) + 2*magnitude(num[[2]])
    )
}

# Solution
res <- input[[1]]

for(i in 2:N){
    res <- list(res, input[[i]])
    res <- reduce_number(res)
}
magnitude(res)


all_combos <- expand.grid(x = 1:N, 
                          y = 1:N) %>% 
    dplyr::filter(x != y)

best <- 0

for(i in 1:nrow(all_combos)){
    
    print(i)
    x <- all_combos$x[i]
    y <- all_combos$y[i]
    
    combo1 <- input[[x]]
    combo2 <- input[[y]]
    res <- list(combo1, combo2)
    res <- reduce_number(res)
    mg <- magnitude(res)
    if(mg > best){
        best <- mg
    }
}
best
