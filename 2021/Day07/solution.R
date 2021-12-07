setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in input
input <- as.integer(strsplit(readLines("input.txt", n = 1), ",")[[1]])

# sample <- c(16,1,2,0,4,2,7,1,2,14)


# Part 1 
dist1 <- Inf
dist2 <- Inf

fuel <- function(n) n * (n+1) / 2

for(i in min(input):max(input)){
    dif <- abs(input - i)
    d1 <- sum(dif)
    d2 <- sum(fuel(dif))
    dist1 <- min(d1, dist1)
    dist2 <- min(d2, dist2)
}

dist1
dist2
