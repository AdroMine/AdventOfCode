setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(tictoc)

input <- scan("input.txt", "character", sep = "\n")
player <- grep("^Player", input)

deck1 <- as.integer(input[(player[1] + 1) : (player[2]-1)])
deck2 <- as.integer(input[(player[2] + 1) : length(input)])

game <- 0
recursive_combat <- function(deck1, deck2, part2 = TRUE){
    keys <- list()
    game <<- game + 1L
    n1 <- length(deck1)
    n2 <- length(deck2)
    
    d1 <- d2 <- rep(NA, n1 + n2)
    
    d1[1:n1] <- deck1
    d2[1:n2] <- deck2
    while(n1 && n2){
        key <- paste(paste(d1[1:n1], collapse = ","), 
                     paste(d2[1:n2], collapse = ","), 
                     sep = "|")
        
        if(key %in% keys && part2){
            return(list("p1", d1))
        }
        
        keys <- c(keys, key)
        
        p1 <- d1[1]                ; 
        n1 <- n1 - 1L 
        if(n1)  d1[1:n1] <- d1[2:(n1 + 1L)] ; 
        d1[n1 + 1L] <- NA
        
        p2 <- d2[1]                
        n2 <- n2 - 1  
        if(n2) d2[1:n2] <- d2[2:(n2 + 1L)] 
        d2[n2 + 1L] <- NA
        
        
        if( (p1 <= n1) && (p2 <= n2) && part2){   # can recurse
            if(max(d1[1:p1]) > max(d2[1:p2])){
                winner <- "p1"
            } else{
                winner <- recursive_combat(d1[1:p1], d2[1:p2], TRUE)[[1]]
            }
        } else {
            winner <- ifelse(p1 > p2, "p1", "p2")
        }
        if(winner == "p1"){
            # nums go into d1
            d1[(n1+1):(n1+2)] <- c(p1, p2)
            n1 <- n1 + 2
            
        } else {
            d2[(n2+1):(n2+2)] <- c(p2, p1)
            n2 <- n2 + 2
        }
    }
    if(n2){
        return(list("p2", d2))
    } else{
        return(list("p1", d1))
    }
}

tic()
res <- recursive_combat(deck1, deck2, T)
toc()

sum(unlist(as.list(res[[2]])) * length(res[[2]]):1)
