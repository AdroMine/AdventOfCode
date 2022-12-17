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
move_rock <- function(dx, dy, rock){
    # remove rock from grid
    grid[cy, cx] <<- xor(grid[cy, cx], rock)
    
    # if nothing in way, move to new position
    if(!any(grid[cy+dy, cx+dx] & rock)){
        grid[cy+dy, cx+dx] <<- grid[cy+dy, cx+dx] | rock
        cy <<- cy + dy;  cx <<- cx + dx
        return(TRUE)
    } else {
        # else restore to original pos
        grid[cy, cx] <<- grid[cy, cx] | rock
        return(FALSE)
    }
}

top_N <- function(n = 30) as.vector(grid[last_h:pmin(total_h, last_h+n),]) 

grid <- matrix(FALSE, nrow = 1e5, ncol = 7)
cx <- cy <- 0

last_h <- total_h <- 1e5 
r <- i <- jid <- rid <- 0 #counters for rock and jet
NI <- length(instr) # length of instructions
additional <- max_h <- 0

cache <- collections::dict()
# we need 3 things, structure at top (this can be a 2D boolean grid un-winded to
# vector of length N*7) rock id and jet id

while(r <= 1e12){
    if(r == 2022) print(max_h)
    # rotate between 5 rocks
    r <- r + 1; rid <- (r-1L) %% 5L + 1L
    srock <- rocks[[rid]]
    W <- ncol(srock); H <- nrow(srock)
    
    key <- list(rid, jid, top_N(30))
    if(cache$has(key)){
        tmp <- cache$get(key)
        nr <- tmp[1] # at which round was this last seen
        nh <- tmp[2] # what was the max height then
        d <- (1e12 - r) %/% (r - nr)
        m <- (1e12 - r) %%  (r - nr)
        r <- r + (r-nr) * d
        additional <- additional + d  * (max_h - nh)
        cache$clear()
    }
    cache$set(key, c(r, max_h))
    
    # note rock coordinates
    cx <<- 3:(3+W-1)
    cy <<- (last_h - 3 - H):(last_h - 4)
    
    # since we don't count grid bottom as floor, move one up
    if(r == 1) cy <<- cy + 1
    
    # place rock
    grid[cy, cx] <- grid[cy, cx] | srock
    
    # go through instructions until rock settles
    while(TRUE){
        i <- i + 1; jid <- (i-1L) %% NI + 1L
        wind <- instr[jid]
        
        if(wind == '>' & cx[W] < 7){
            move_rock(1L, 0L, srock)
        } else if(wind == '<' & cx[1] > 1){
            move_rock(-1L, 0L, srock)
        } 
        
        # move down if no obstructions
        if(move <- cy[H] < total_h) 
            move <- move_rock(0L, 1L, srock)
        
        if(!move) break
        
    }
    last_h <- min(cy[1], last_h)
    max_h <- total_h - last_h + 1
}   

# Part 2
print(max_h - 1 + additional, digits = 22)

# grid_print(tetris(10, instr)[[1]], 20)