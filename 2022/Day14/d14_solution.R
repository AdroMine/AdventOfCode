setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# input <- readLines('sample.txt')
input <- readLines('input.txt')

grid <- matrix(FALSE, 1000, 1000)

for(line in input){
    paths <- strsplit(line, " -> ")[[1]]
    paths <- lapply(paths, function(x) as.integer(strsplit(x, ",")[[1]]))
    n <- length(paths)
    for(i in seq_len(n-1)){
        pt1 <- paths[[i]] + 1
        pt2 <- paths[[i+1]] + 1
        grid[pt1[2]:pt2[2], pt1[1]:pt2[1]] <- TRUE
    }
}

steps_pos <- list(
    c(+1L, 0),  # down
    c(+1L,-1L), # down-left
    c(+1L,+1L)  # down right
)

simulate_sand <- function(grid, part2 = FALSE){
    
    count <- 0
    
    # find extremes of grid
    ymax <- max(which(grid, arr.ind = TRUE)[,1])
    
    # set floor for part 2
    if(part2) {
        ymax <- ymax + 2
        grid[ymax, ] <- TRUE
    }
    # horizontal extremes
    # rocksx <- which(grid, arr.ind = TRUE)[,2]
    # xmin <- min(rocksx) ; xmax <- max(rocksx)
    
    abyss_fall <- FALSE
    while(TRUE){
        sand <- c(1L, 501L)
        
        # assume sand can move
        move <- TRUE
        while(move){
            move <- FALSE
            
            # check if sand has fallen down the abyss, no more sand can collect
            # if sand goes left or right of last rock, will fall into abyss
            # similarly if goes below last rock, will again fall down abyss
            
            # can only check if sand has gone below as well
            # if ((sand[2L] > xmax)  ||  (sand[2L] < xmin) ||  (sand[1L] > ymax)){
            if ((sand[1L] > ymax)){
                abyss_fall <- TRUE
                break
            }
            
            
            # if not fallen in abyss, sand keeps falling until rest
            for(step in steps_pos){
                new_step <- sand + step 
                
                # if step is possible 
                if(!grid[new_step[1L], new_step[2L]]) {
                    sand <- new_step
                    move <- TRUE
                    break
                }
            }    
        }
        
        # sand comes to rest
        if(!move && !abyss_fall){
            grid[sand[1L], sand[2L]] <- TRUE
            count <- count + 1L
            # print(sprintf("sand at c(x = %d, y = %d)", sand[1], sand[2]))
        }
        
        # stop simulation
        if(abyss_fall || all(sand == c(1L, 501L))) break
    }
    
    count
}

# Part 1
simulate_sand(grid, FALSE)

# this takes around 3 seconds
simulate_sand(grid, TRUE)
