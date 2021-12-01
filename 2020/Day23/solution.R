input <- as.integer(c(3, 8, 9, 1, 2, 5, 4, 6, 7))
input <- as.integer(strsplit("562893147", "")[[1]])

print_list <- function(x, from = '1'){
    output <- rep(NA, length(x))
    output[1] <- as.integer(from)
    for(i in 2:length(x)){
        output[i] <- x[output[i-1]]
    }
    output
}


play_crab_game <- function(input, rounds, part2 = TRUE){
    if(part2) 
        input <- c(input, seq.int(10, 1e6))
    
    n <- length(input)
    
    nxt <- vector("integer", n)
    nxt[input[1:(n-1)]] <- input[-1]
    nxt[input[n]] <- input[1]
    
    cur <- input[[1]]
    for(i in seq.int(1, rounds)){
        
        # Pick out next three
        pick1 <- nxt[ cur ]
        pick2 <- nxt[pick1]
        pick3 <- nxt[pick2]
        
        if(cur == 1L){
            target <- n
        } else 
            target <- cur - 1L
        
        # target <- ifelse(cur == 1L, n, cur-1L)
        while(target %in% c(pick1, pick2, pick3)){
            if(target == 1L) {
                target <- n
            } else 
                target <- target - 1L
        }
        
        tmp           <- nxt[pick3]
        nxt[cur]      <- tmp
        nxt[pick3]    <- nxt[target]
        nxt[target]   <- pick1
        cur <- tmp
    }
    
    if(part2){
        prod(nxt[1], nxt[nxt[1]])
    }
    else {
        paste(print_list(nxt, '1')[-1], collapse = "")
    }
}

# Part 1
play_crab_game(input, 100, FALSE)

# Part 2
print(play_crab_game(input, 1e7, TRUE), digits = 22)











