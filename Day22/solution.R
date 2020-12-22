setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(purrr)
library(dequer)
input <- scan("input.txt", "character", sep = "\n")
player <- grep("^Player", input)

deck1 <- as.integer(input[(player[1] + 1) : (player[2]-1)])
deck2 <- as.integer(input[(player[2] + 1) : length(input)])

game <- 0

recursive_combat <- function(deck1, deck2, part2 = TRUE){
    decks <- list()
    round <- 1
    
    d1 <- as.queue(as.list(deck1))
    d2 <- as.queue(as.list(deck2))
    
    game <<- game + 1
    
    while(!is_empty(d1) && !is_empty(d2)){
        nd1 <- unlist(as.list(d1))
        nd2 <- unlist(as.list(d2))
        key <- paste(c(paste(nd1, collapse = ","), paste(nd2, collapse = ",")), sep = "|") 
        if(key %in% decks && part2)
            return(list("p1", d1))
        
        decks <- c(decks, key)
        
        p1 <- pop(d1)
        p2 <- pop(d2)
        
        if( (p1 <= length(d1)) && (p2 <= length(d2)) && part2){   # can recurse
            
            nd1 <- nd1[2:(p1+1)]
            nd2 <- nd2[2:(p2+1)]
            if(max(nd1) > max(nd2)){     # If deck1's max is greatest then deck 1 can't lose
                winner <- "p1"           # if any repeats then P1 wins, if P1 has greatest, then again he will win
            } else{                      
                winner <- recursive_combat(nd1, nd2, TRUE)[[1]]
            }
            
        } else {
            winner <- ifelse(p1 > p2, "p1","p2")
        }
        if(winner == "p1"){
            pushback(d1, p1)
            pushback(d1, p2)
        } else{
            pushback(d2, p2)
            pushback(d2, p1)
        }
    }
    if(is_empty(d1)){
        return(list("p2", d2))
    } else{
        return(list("p1", d1))
    }
}

res <- recursive_combat(deck1, deck2, T)

sum(unlist(as.list(res[[2]])) * length(res[[2]]):1)
