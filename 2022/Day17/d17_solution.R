setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# Parse Inputs ------------------------------------------------------------
# instr <- strsplit(">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>", "")[[1]]
instr <- strsplit(readLines('input.txt'), "")[[1]]
rocks5 <- readr::read_file('rocks.txt') %>%
    gsub("\r", "", .) %>% 
    strsplit("\n\n") %>%
    purrr::pluck(1) %>%
    lapply(\(x) gsub("\n", "", x))

bool_rock <- function(rock_str, R, C){
    r <- strsplit(rock_str, "")[[1]] == '#'
    matrix(r, R, C, byrow = TRUE)
}
rocks <- list(
    # ---
    bool_rock(rocks5[[1]], 1, 4),
    
    # + symbol
    bool_rock(rocks5[[2]], 3, 3),
    
    # horizontal flipped L
    bool_rock(rocks5[[3]], 3, 3),
    
    # I
    bool_rock(rocks5[[4]], 4, 1),
    
    # square
    bool_rock(rocks5[[5]], 2, 2)
)

# Play tetris -------------------------------------------------------------


tetris <- function(rounds, instr){
    grid <- matrix(FALSE, nrow = 1e5, ncol = 7)
    last_h <- 1e5 
    total_h <- 1e5
    
    i <- 0 # counter for instructions
    NI <- length(instr) # length of instructions
    
    for(r in 1:rounds){
        # rotate between 5 rocks
        rt <- (r - 1) %% 5 + 1
        
        srock <- rocks[[rt]]
        W <- ncol(srock)
        H <- nrow(srock)
        
        # note rock coordinates
        xl <- 3
        xr <- xl + W - 1
        
        yt <- last_h - 3 - H
        if(r == 1) yt <- yt+1
        yb <- yt + H - 1
        
        # place rock
        grid[yt:yb, xl:xr] <- grid[yt:yb, xl:xr] | srock
        
        while(TRUE){
            i <- i + 1
            i <- (i-1) %% NI + 1
            wind <- instr[i]
            move <- FALSE
            
            if(wind == '>'){
                # can it move right?
                if(xr < 7){
                    # can move right
                    
                    # remove rock temporarily
                    grid[yt:yb, xl:xr] <- xor(grid[yt:yb, xl:xr], srock)
                    
                    # new x coords after moving
                    x_l <- xl + 1
                    x_r <- xr + 1
                    
                    # check if no rock is present in place to move
                    if(any(grid[yt:yb, x_l:x_r] & srock)){
                        # restore original
                        grid[yt:yb, xl:xr] <- grid[yt:yb, xl:xr] | srock
                    } else {
                        # no obstructions, move
                        grid[yt:yb, x_l:x_r] <- grid[yt:yb, x_l:x_r] | srock
                        xl <- x_l
                        xr <- x_r
                    } 
                }
            } else if(wind == '<'){
                # can it move left?
                if(xl > 1){
                    # it can move left
                    grid[yt:yb, xl:xr] <- xor(grid[yt:yb, xl:xr], srock)
                    x_l <- xl - 1
                    x_r <- xr - 1
                    
                    # check if no rock is present in place to move
                    if(any(grid[yt:yb, x_l:x_r] & srock)){
                        # restore original
                        grid[yt:yb, xl:xr] <- grid[yt:yb, xl:xr] | srock
                    } else {
                        # no obstructions, move
                        grid[yt:yb, x_l:x_r] <- grid[yt:yb, x_l:x_r] | srock
                        xl <- x_l
                        xr <- x_r
                    } 
                }
            } 
            
            # move down if no obstructions
            if(yb < total_h){
                y_t <- yt + 1
                y_b <- yb + 1
                # temporarily remove rock while checking boundaries
                grid[yt:yb, xl:xr] <- xor(grid[yt:yb, xl:xr], srock)
                
                # can it move down? no other obstructions?
                if(!any(grid[y_t:y_b, xl:xr] & srock)){
                    move <- TRUE
                    grid[y_t:y_b, xl:xr] <- grid[y_t:y_b, xl:xr] | srock
                    yt <- y_t
                    yb <- y_b
                } else {
                    # restore original
                    grid[yt:yb, xl:xr] <- grid[yt:yb, xl:xr] | srock
                }
            }
            
            if(!move) break
        }
        last_h <- min(yt, last_h)
        # print(total_h - last_h + 1)
    }   
    list(
        grid, 
        total_h - last_h + 1
    )
}


grid_print <- function(mat, last_N){
    mat <- tail(mat, last_N)
    mat[mat] <- '#'
    mat[mat == "FALSE"] <- '.'
    for(i in seq_len(nrow(mat))){
        cat('|', paste0(mat[i,], collapse = ""), '|')
        cat('\n')
    }
    cat('+', paste(rep('-', 7),collapse = ""), '+', '\n')
}

# Part 1 
tetris(2022, instr)[[2]]

grid_print(tetris(10, instr)[[1]], 20)


# Part 2 look for pattern
k <- capture.output(tetris(20000, instr)[[2]]) %>% 
    gsub("\\[1\\] ", "", .) %>% 
    as.integer()


(k - dplyr::lag(k, 10091))[-c(1:10091)]

for(i in 1:10091){
    x <- k - dplyr::lag(k, i)
    length(unique(k))
}

res <- lapply(seq_along(instr), function(i){
    x <- k - dplyr::lag(k, i)
    length(unique(na.omit(x)))
})

# Using trial and error pattern seems to repeat itself after the first 633 rocks!

# Pattern of the form (each number denotes the increase in height with each rock)
# length is 1705
# sum of above is equal to 2649


k2 <- k[-c(1:633)]
head(na.exclude(k2 - dplyr::lag(k2, 1705)), 100)

pattern <- c(1, 3, 3, 0, 0, 1, 3, 2, 1, 2, 1, 3, 2, 4, 0, 1, 3, 0, 3, 0, 1, 3, 0, 3, 2, 0,
             2, 3, 2, 2, 1, 3, 3, 2, 0, 1, 3, 0, 0, 2, 1, 3, 3, 0, 2, 0, 0, 3, 4, 0, 1, 3, 0, 3, 0, 1, 3, 2, 1, 2, 0, 1, 2, 1, 2, 1, 1, 2, 2, 2, 0, 2, 3, 0, 2, 1, 2, 3, 2, 0, 0, 2, 3, 4, 2, 1, 2, 1, 2, 0, 1, 2, 3, 0, 0, 0, 3, 3, 2, 2, 1, 3, 2, 0, 1, 1, 3, 3, 2, 2, 1, 3, 0, 0, 2, 0, 2, 3, 0, 2, 1, 3, 0, 2, 2, 0, 3, 3, 2, 0, 0, 3, 0, 3, 0, 1, 3, 3, 2, 2, 1, 3, 0, 1, 1, 1, 3, 2, 2, 0, 1, 3, 2, 0, 0, 1, 2, 1, 2, 0, 1, 3, 3, 2, 0, 1, 2, 3, 0, 0, 1, 2, 3, 0, 0, 0, 2, 2, 0, 0, 1, 3, 2, 0, 2, 1, 1, 2, 1, 1, 1, 3, 2, 2, 0, 1, 3, 3, 0, 2, 1, 3, 2, 2, 0, 1, 3, 2, 1, 0, 0, 3, 3, 0, 2, 1, 3, 2, 4, 0, 0, 0, 2, 0, 0, 1, 3, 0, 4, 0, 1, 3, 0, 4, 0, 1, 3, 3, 0, 2, 0, 2, 2, 0, 0, 1, 3, 2, 0, 2, 1, 3, 2, 2, 0, 1, 3, 2, 2, 2, 1, 3, 3, 0, 0, 1, 3, 2, 1, 2, 1, 3, 3, 0, 0, 1, 0, 3, 2, 0, 1, 3, 3, 2, 2, 1, 3, 2, 2, 0, 0, 2, 2, 2, 2, 1, 3, 0, 3, 0, 0, 2, 3, 4, 0, 1, 2, 2, 2, 2, 1, 3, 2, 2, 2, 1, 3, 0, 2, 2, 1, 3, 0, 2, 2, 1, 2, 1, 0, 1, 1, 2, 1, 3, 0, 0, 3, 2, 0, 0, 1, 2, 1, 2, 2, 1, 3, 3, 2, 0, 1, 2, 3, 0, 0, 1, 2, 3, 4, 0, 1, 3, 3, 4, 0, 1, 2, 3, 0, 0, 1, 3, 2, 1, 1, 1, 1, 2, 1, 0, 0, 3, 0, 2, 0, 1, 3, 3, 2, 2, 1, 3, 3, 0, 0, 1, 3, 0, 4, 0, 1, 3, 2, 2, 2, 1, 3, 3, 2, 0, 1, 3, 2, 2, 0, 1, 2, 3, 2, 0, 0, 2, 3, 4, 0, 0, 0, 3, 4, 0, 0, 0, 3, 0, 0, 0, 3, 3, 0, 0, 1, 3, 0, 4, 0, 1, 3, 3, 2, 2, 1, 3, 3, 0, 2, 1, 3, 3, 0, 0, 1, 3, 0, 2, 2, 0, 0, 3, 2, 0, 0, 3, 3, 2, 0, 1, 3, 3, 0, 0, 1, 2, 2, 2, 2, 1, 3, 3, 2, 0, 1, 2, 3, 0, 0, 0, 2, 2, 2, 2, 1, 3, 0, 4, 2, 1, 3, 2, 0, 0, 0, 3, 0, 4, 0, 1, 3, 3, 4, 0, 0, 0, 3, 0, 0, 1, 3, 0, 0, 2, 1, 2, 1, 3, 0, 0, 2, 3, 4, 0, 1, 3, 0, 3, 2, 1, 3, 3, 2, 2, 1, 3, 3, 0, 2, 1, 3, 3, 2, 0, 1, 0, 3, 2, 2, 1, 2, 1, 2, 0, 0, 3, 3, 0, 2, 0, 0, 3, 1, 2, 1, 3, 3, 2, 2, 0, 0, 3, 2, 0, 1, 3, 3, 0, 0, 1, 2, 2, 4, 0, 1, 2, 3, 0, 0, 0, 1, 2, 4, 0, 1, 3, 2, 2, 0, 0, 2, 2, 2, 2, 0, 0, 3, 1,
             1, 1, 3, 0, 2, 2, 1, 2, 3, 0, 0, 1, 2, 3, 0, 2, 1, 3, 2, 4, 0, 0, 2, 2, 2, 2, 1, 3, 2, 2, 0, 1, 3, 0, 1, 1, 0, 3, 3, 4, 0, 1, 3, 3, 2, 2, 1, 2, 1, 2, 0, 0, 2, 2, 2, 2, 1, 3, 0, 3, 0, 1, 3, 2, 2, 2, 1, 3, 3, 2, 0, 1, 3, 0, 4, 0, 0, 0, 3, 0, 0, 0, 2, 1, 3, 0, 0, 3, 0, 0, 2, 0, 2, 2, 2, 2, 1, 0, 3, 4, 0, 1, 2, 3, 4, 0, 0, 0, 3, 2, 0, 1, 2, 1, 3, 0, 1, 3, 3, 4, 2, 1, 0, 0, 0, 2, 1, 3, 3, 0, 0, 0, 2, 3, 0, 0, 1, 3, 2, 0, 0, 1, 2, 1, 2, 2, 1, 3, 3, 2, 0, 1, 2, 1, 0, 1, 1, 3, 3, 0, 0, 1, 3, 3, 4, 2, 1, 3, 2, 2, 0, 1, 3, 3, 4, 0, 1, 3, 2, 2, 0, 1, 3, 2, 1, 2, 1, 3, 3, 0, 2, 1, 2, 1, 3, 0, 1, 2, 1, 0, 1, 1, 3, 3, 0, 0, 1, 3, 3, 2, 0, 1, 3, 2, 0, 0, 1, 1, 2, 4, 0, 1, 3, 3, 2, 2, 1, 3, 3, 2, 2, 1, 2, 3, 2, 0, 1, 3, 2, 1, 1, 1, 0, 3, 1, 0, 1, 2, 3, 0, 0, 1, 2, 1, 2, 2, 1, 3, 3, 2, 2, 0, 2, 2, 1, 0, 1, 3, 0, 2, 2, 1, 3, 0, 4, 2, 1, 2, 3, 0, 0, 1, 2, 1, 3, 0, 0, 3, 2, 4, 0, 1, 2, 1, 1, 0, 1, 2, 2, 0, 2, 0, 2, 2, 2, 0, 1, 2, 2, 2, 0, 1, 3, 3, 0, 0, 0, 2, 3, 0, 0, 1, 3, 3, 0, 0, 1, 3, 3, 0, 0, 1, 3, 3, 2, 0, 1, 3, 3, 2, 0, 1, 3, 2, 0, 0, 1, 3, 2, 0, 2, 0, 2, 2, 1, 2, 1, 2, 3, 2, 2, 1, 3, 2,
             2, 2, 0, 3, 3, 2, 0, 0, 2, 3, 0, 2, 1, 3, 3, 2, 0, 1, 3, 2, 4, 0, 1, 3, 3, 2, 2, 1, 3, 2, 0, 0, 1, 2, 3, 2, 0, 1, 3, 3, 0, 0, 1, 3, 2, 2, 2, 1, 0, 3, 1, 2, 0, 1, 3, 0, 0, 1, 2, 3, 2, 2, 1, 3, 3, 2, 2, 0, 2, 2, 0, 2, 1, 0, 3, 2, 2, 1, 3, 3, 2, 0, 1, 2, 3, 0, 1, 0, 3, 3, 0, 0, 1, 2, 2, 2, 2, 1, 3, 2, 1, 1, 1, 3, 3, 2, 2, 1, 2, 1, 2, 2, 1, 3, 3, 0, 0, 1, 3, 2, 0, 2, 1, 3, 3, 0, 0, 1, 3, 3, 0, 0, 1, 3, 3, 2, 0, 1, 3, 3, 2, 2, 1, 3, 3, 4, 0, 1, 3, 3, 0, 2, 0, 0, 3, 2, 0, 1, 3, 3, 0, 2, 1, 3, 3, 0, 2, 1, 2, 2, 4, 0, 1, 3, 3, 0, 0, 1, 3, 2, 1, 2, 1, 3, 3, 4, 2, 1, 3, 2, 2, 0, 1, 3, 0, 2, 0, 1, 3, 3, 2, 2, 1, 1, 2, 4, 2, 1, 3, 0, 3, 0, 1, 3, 2, 0, 0, 1, 3, 3, 0, 0, 0, 0, 3, 1, 0, 1, 3, 3, 4, 0, 0, 0, 3, 4, 0, 1, 3, 3, 0, 0, 1, 3, 0, 3, 0, 1, 2, 3, 2, 0, 0, 1, 1, 2, 0, 1, 2, 1, 0, 0, 1, 2, 3, 0, 1, 0, 3, 3, 2, 0, 1, 3, 3, 0, 2, 1, 3, 0, 3, 0, 0, 2, 2, 4, 2, 1, 3, 3, 4, 2, 1, 3, 3, 0, 0, 1, 2, 3, 2, 0, 0, 2, 2, 1, 2, 1, 3, 3, 0, 0, 1, 3, 2, 1, 1, 0, 3, 3, 0, 0, 0, 2, 3, 2, 2, 1, 1, 2, 2, 0, 1, 3, 0, 3, 2, 1, 2, 3, 4, 0, 1, 2, 1, 2, 0, 1, 3, 0, 2, 0, 1, 3, 3, 2, 2, 1, 2, 2, 4, 2, 0, 3,
             3, 2, 2, 1, 3, 2, 2, 2, 1, 3, 2, 0, 0, 0, 2, 3, 0, 2, 0, 0, 3, 0, 2, 1, 1, 2, 1, 0, 1, 0, 3, 0, 2, 1, 3, 2, 2, 2, 1, 3, 2, 4, 2, 1, 3, 3, 2, 0, 1, 3, 2, 0, 0, 1, 2, 1, 4, 0, 1, 3, 2, 4, 2, 0, 3, 0, 0, 0, 1, 3, 3, 4, 0, 0, 2, 2, 2, 0, 1, 2, 2, 1, 1, 1, 3, 0, 2, 0, 1, 2, 3, 2, 0, 0, 2, 0, 4, 2, 0, 0, 1, 4, 0, 1, 3, 2, 4, 2, 1, 3, 3, 0, 0, 1, 3, 3, 0, 2, 1, 3, 0, 0, 1, 1, 3, 3, 2, 0, 1, 3, 2, 2, 0, 1, 3, 3, 4, 2, 1, 3, 3, 4, 0, 1, 3, 0, 0, 0, 1, 3, 3, 2, 0, 1, 3, 3, 2, 0, 1, 2, 2, 2, 2, 1, 0, 3, 2, 0, 1, 2, 3, 0, 1, 0, 3, 2, 0, 0, 0, 3, 3, 2, 0, 1, 3, 2, 2, 0, 1, 3, 0, 3, 2, 1, 3, 2, 1, 0, 1, 3, 0, 2, 0, 1, 2, 2, 1, 0, 1, 3, 3, 0, 2, 1, 3, 3, 2, 0, 1, 3, 3, 0, 0, 1, 3, 3, 0, 0, 1, 2, 2, 2, 2, 1, 3, 3, 0, 0, 1, 2, 1, 3, 0, 0, 3, 0, 0, 2, 1, 2, 1, 4, 0, 0, 2, 2, 0, 0, 0, 2, 3, 0, 2, 1, 3, 3, 4, 0, 1, 2, 3, 0, 0, 0, 2, 1, 4, 2, 1, 3, 3, 0, 0, 1, 3, 3, 2, 0, 1, 3, 2, 2, 0, 1, 3, 3, 4, 0, 0, 2, 3, 0, 0, 1, 2, 3, 0, 0, 1, 2, 3, 0, 1, 1, 2, 3, 0, 0, 0, 2, 3, 0, 1, 1, 3, 2, 0, 2, 1, 3, 3, 4, 2, 0, 3, 0, 0, 0, 1, 2, 3, 0, 0, 1, 3, 3, 4, 0, 1, 2, 1, 2, 2)



# height till 633
p1 <- tetris(633, instr)[[2]] # 1009

m1 <- (1e12-633) %/% length(pattern)
m2 <- (1e12-633) %% length(pattern)

p2 <- m1 * sum(pattern)
p3 <- sum(pattern[1:(m2)]) 

as.character(p1 + p2 + p3)

             