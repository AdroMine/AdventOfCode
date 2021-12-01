setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# input <- readLines("sample.txt")
input <- readLines("input.txt")

adjacents <- list(
    'nw' = c(-1, -1), 
    'ne' = c( 1, -1), 
    'sw' = c(-1,  1),
    'se' = c( 1,  1),
    'e'  = c( 2,  0), 
    'w'  = c(-2,  0) 
)

get_dir <- function(tile, dir){
    for(i in seq_along(dir)){
        tile <- gsub(names(dir)[[i]], 
                     sprintf("c(%d, %d) +",
                             dir[[i]][1], 
                             dir[[i]][2]), 
                     tile)    
    }
    tile <- gsub("\\+$", "", tile)
    eval(parse(text = tile))
}

# Part 1
coords <- unname(lapply(input, get_dir, adjacents))


### ---  make a grid ----

X <- sum( abs( range(sapply(coords, function(x) x[1]) ) ) ) + 1
Y <- sum( abs( range(sapply(coords, function(x) x[2]) ) ) ) + 1

# Black represented by 1,  white represented by 0

gS <- 2*(100 + 5) + max(X,Y)

start <- as.integer(gS / 2 - max(X, Y)/2)

floor <- matrix(0, nrow = gS, ncol = gS)

# put tiles somewhere in center
for(cd in coords){
    x <- cd[1] + ceiling(X/2) + start 
    y <- cd[2] + ceiling(Y/2) + start
    if(floor[x,y] == 0){
        floor[x,y] = 1
    } else{
        floor[x,y] = 0
    }
}
# Part 1 Answer
sum(floor)

# Part 2
# Hex doubled coordinates have criteria that sum of coordinates must be even, 
# we have added start to everything which has changed this criteria

N <- unique(apply(which(floor == 1, arr.ind = TRUE), 1 , function(x) sum(x) %% 2))


# make a grid, already have coordinates
for(day in 1:100){
    ind <- seq(start - day-2, start + max(X,Y) + day + 1)
    new <- floor
    for(x in ind){
        for(y in ind)
            if((x + y) %% 2 == N){
                tot = 0L
                
                for(adj in adjacents){
                    if(floor[x + adj[1], y + adj[2]] == 1L)
                        tot <- tot + 1
                }
                
                if(floor[x,y] == 0L && tot == 2L){
                    new[x,y] <- 1L
                }
                if(floor[x,y] == 1L && !(tot %in% c(1L, 2L))){
                    new[x,y] <- 0L
                }
                
            }
        
    }
    floor <- new
    # print(paste(day, sum(floor), sep = ":"))
}
sum(floor)
