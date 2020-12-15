find_n_num <- function(starting_nums, n){
    starting_nums <- as.integer(starting_nums)
    s <- length(starting_nums)
    
    last_seen <- rep(0L, n)
    
    # 0 saved at 1
    last_seen[starting_nums[-s] + 1L] <- 1L:(s-1)
    
    num <- starting_nums[s] 
    for(turn in (s+1):n){
        # if(turn %% 100000L == 0L)
        # print(turn)
        
        # seen before?
        if(last_seen[num+1L]){ # yes
            tmp <- num
            num <- turn - 1L - last_seen[num + 1L]
            last_seen[tmp + 1L] <- turn - 1L
        } else{                     # yes
            last_seen[num + 1L] <- turn - 1L
            num <- 0L
        }
    }
    num
}
# Part 1
find_n_num(c(8,11,0,19,1,2), 2020)

# Part 2
find_n_num(c(8,11,0,19,1,2), 3e7)
