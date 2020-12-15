find_n_num <- function(starting_nums, n){
    starting_nums <- as.integer(starting_nums)
    s <- length(starting_nums)
    
    last_seen <- rep(0L, n)
    
    # 0 saved at 1
    last_seen[starting_nums[-s] + 1L] <- 1L:(s-1L)
    
    num <- starting_nums[s] 
    for(turn in (s+1L):n){
        tmp <- num
        if(last_seen[num+1L]!=0L){ 
            num <- turn - 1L - last_seen[num + 1L]
        } else{                
            num <- 0L
        }
        last_seen[tmp + 1L] <- turn - 1L
    }
    num
}
# Part 1
find_n_num(c(8,11,0,19,1,2), 2020)

# Part 2
find_n_num(c(8,11,0,19,1,2), 3e7)
