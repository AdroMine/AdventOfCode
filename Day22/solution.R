setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(purrr)
library(dequer)
input <- scan("input.txt", "character", sep = "\n")
player <- grep("^Player", input)
p1 <- as.integer(input[(player[1] + 1) : (player[2]-1)])
p2 <- as.integer(input[(player[2] + 1) : length(input)])
nc <- length(p1)
d1 <- queue()
d2 <- queue()
for(i in 1:nc){
    pushback(d1, p1[i])
    pushback(d2, p2[i])
}


recursive_combat <- function(d1, d2, part2 = TRUE){
    p1_decks <- vector("list", 1000)
    p2_decks <- vector("list", 1000)
    round <- 1
    # print(paste(rep("=", 80), collapse = ""))
    print("New Game!")
    while(!is_empty(d1) && !is_empty(d2)){
        # print(paste("Round:", round))
        if(round > 1){
            c1 <- unlist(as.list(d1))
            c2 <- unlist(as.list(d2))
            p1_m <- sapply(p1_decks[1:(round-1)], function(x) 
                length(c1) == length(x) && all(c1 == x))
            p2_m <- sapply(p2_decks[1:(round-1)], function(x) 
                length(c2) == length(x) && all(c2 == x))
            
            if(any(p1_m) || any(p2_m) && part2)
                return("p1")
        }
        p1_decks[[round]] <- unlist(as.list(d1))
        p2_decks[[round]] <- unlist(as.list(d2))
        round <- round + 1
        if(round > 1000)
            stop("We need to increase allocation")
        p1 <- pop(d1)
        p2 <- pop(d2)
        
        p1_left <- length(d1)
        p2_left <- length(d2)
        if( (p1 <= p1_left) && (p2 <= p2_left) && part2){   # can recurse
            
            nd1 <- as.queue(as.list(d1)[1:p1])
            nd2 <- as.queue(as.list(d2)[1:p2])
            winner <- recursive_combat(nd1, nd2, TRUE)
            if(winner == "p1"){
                pushback(d1, p1)
                pushback(d1, p2)
            } else{
                pushback(d2, p2)
                pushback(d2, p1)
            }
            
        } else {
            
            if(p1 > p2){
                
                pushback(d1, p1)
                pushback(d1, p2)
                
            } else{
                
                pushback(d2, p2)
                pushback(d2, p1)
                
            }
        }

    }
    if(is_empty(d1)){
        return("p2")
    } else{
        return("p1")
    }
}

winner <- recursive_combat(d1, d2, TRUE) #False for part1 but reinitialise d1 d2
if(is_empty(d1)){
    sum(unlist(as.list(d2)) * (2*nc):1)
} else{
    sum(unlist(as.list(d1)) * (2*nc):1)
}
