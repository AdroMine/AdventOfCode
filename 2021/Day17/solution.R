setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)


# Read and Transform input ------------------------------------------------
# sample
# input <- stringr::str_match("target area: x=20..30, y=-10..-5", "target area: x=(\\d+)\\.\\.(\\d+), y=([\\-0-9]*)\\.\\.([\\-0-9]*)")[1,][-1]

input <- stringr::str_match(readLines("input.txt"),
                            "target area: x=(\\d+)\\.\\.(\\d+), y=([\\-0-9]*)\\.\\.([\\-0-9]*)")[1,][-1]

x_range <- as.numeric(c(input[1], input[2]))
y_range <- as.numeric(c(input[3], input[4]))

x_poss <- c()
# find possible x velocities
for(i in 1:x_range[2]){
    dist_x <- cumsum(seq(i, 0))
    if(any(dist_x %in% x_range[1]:x_range[2])){
        x_poss <- union(x_poss, i)
    }
}

# find possible y velocities
y_poss <- c()
for(i in y_range[1]:-y_range[1]){
    dist_y <- 0
    vel <- i
    reaches <- FALSE
    while(dist_y > y_range[2]){
        dist_y <- dist_y + vel
        vel <- vel - 1
        if(dplyr::between(dist_y, y_range[1], y_range[2])){
            y_poss <- union(y_poss, i)
            break
        }
    }
}

# all  combination of (x,y) velocities
possibilities <- expand.grid(x = x_poss, y = y_poss) %>% 
    dplyr::mutate(possible = FALSE)


# find possible combinations
for(i in 1:nrow(possibilities)){
    
    x <- possibilities$x[i]
    y <- possibilities$y[i]
    
    xr <- seq(x, 0)
    # at which steps does x reach range
    x_idx <- which(cumsum(xr) %in% x_range[1]:x_range[2])
    
    yr <- seq(y, -1000)
    # at which steps does y reach range
    y_idx <- which(cumsum(yr) %in% y_range[1]:y_range[2])
    
    stopifnot(length(y_idx) > 0)
    
    # any commonalities between two
    common <- length(intersect(x_idx, y_idx)) > 0
    
    # possible to reach with this (x,y) combo if 
    # either there is a common step between two
    # or any y reaches after x vel becomes 0
    if(common || (length(xr) %in% x_idx && any(y_idx >= length(xr)))){
        possibilities$possible[i] <- TRUE
    } 
}

# part 1
k <- max(possibilities$y)
k * (k + 1) / 2


# part 2 
sum(possibilities$possible)



