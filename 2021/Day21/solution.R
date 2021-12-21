setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read and Transform input ------------------------------------------------
file_name <- "input.txt"
input <- readLines(file_name)

# sample
p1 <- 4 ; p2 <- 8

p1 <- as.integer(strsplit(input[1], ": ")[[1]][2])
p2 <- as.integer(strsplit(input[2], ": ")[[1]][2])

s1 <- 0
s2 <- 0
rolled <- 0
dice <- 1
turn <- 1

while( s1 < 1000 && s2 < 1000){
    
    rolls <- sum(seq(dice, by = 1, length.out = 3))
    dice <- dice + 3
    rolled <- rolled + 3
    
    if(turn == 1){
        turn <- 2
        p1 <- ((p1 - 1) + rolls) %% 10 + 1
        s1 <- s1 + p1
    } else {
        turn <- 1
        p2 <- ((p2 - 1) + rolls) %% 10 + 1
        s2 <- s2 + p2
    }
}

if(s1 >= 1000) s2 * rolled else s1 * rolled


# Part 2 ----

# sample
p1 <- 4 ; p2 <- 8
p1 <- as.integer(strsplit(input[1], ": ")[[1]][2])
p2 <- as.integer(strsplit(input[2], ": ")[[1]][2])

# memoise fails to do anything, maybe using it incorrectly? even after setting
# cachem manually to Inf, it still failed to run in proper time
cache <- collections::dict()

die_sums <- rowSums(expand.grid(1:3, 1:3, 1:3))
die_rolls <- table(die_sums)
die_sums <- unique(die_sums)

game <- function(p1, p2, s1, s2){
    
    if(s1 >= 21){
        return(c(1,0))
    } 
    if(s2 >= 21){
        return(c(0,1))
    }
    key <- paste(p1, p2, s1, s2, sep = ":")
    if(cache$has(key)){
        return(cache$get(key))
    }
    
    res <- c(0, 0)
    
    for(die in die_sums){
        
        new_pos <- ((p1 - 1) + die) %% 10 + 1
        new_sc <- s1 + new_pos
        k <-  rev(game(p2, new_pos, s2, new_sc)) * die_rolls[as.character(die)]
        res <- res + k
    }
    cache$set(key, res)
    res
}

as.character(max(game(p1, p2, 0, 0)))
