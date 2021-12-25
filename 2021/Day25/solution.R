setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# day 24
file_name <- "input.txt"

W <- nchar(readLines(file_name, n = 1))
grid <- as.matrix(read.fwf(file_name, widths = rep(1, W)))

R <- nrow(grid)
C <- ncol(grid)

# function to generate r,c pairs in the format required by matrices for
# vectorised access with further r argument to subset rows
gidx <- function(idx, r = TRUE) cbind(idx[r,1], idx[r,2])

step <- 1
repeat {
    
    east <- FALSE
    south <- FALSE
    
    new_grid <- grid
    # move east
    cur <- which(grid == ">", arr.ind = TRUE)
    nxt <- cur
    nxt[,2] <- nxt[,2] %% C + 1               
    poss <- which(grid[gidx(nxt)] == ".", arr.ind = TRUE) # which steps are possible
    if(length(poss) > 0){
        east <- TRUE
        new_grid[gidx(nxt, poss)] <- ">"
        new_grid[gidx(cur, poss)] <- "."
    }
    
    
    # move south
    grid <- new_grid
    
    cur <- which(grid == "v", arr.ind = TRUE)
    nxt <- cur
    nxt[,1] <- nxt[,1] %% R + 1
    poss <- which(grid[gidx(nxt)] == ".")
    if(length(poss) > 0){
        south <- TRUE
        new_grid[gidx(nxt,poss)] <- "v"
        new_grid[gidx(cur,poss)] <- "."
    }
    
    if(!east && !south)
        break
    
    step <- step + 1
    grid <- new_grid
}

step








# Non Vectorised approach


step <- 1
repeat {
    
    new_grid <- grid
    east <- FALSE
    south <- FALSE
    # move east
    for(i in 1:R){
        for(j in 1:C){
            
            # first only look for >
            if(grid[i,j] == "." || grid[i,j] == "v"){
                next
            }
                
            
            dest <- (j %% W) + 1
            if(grid[i, dest] == "."){
                east <- TRUE
                new_grid[i, dest] = ">"
                new_grid[i,j] = "."
            }
        }
    }
    gridc <- new_grid
    # move south
    for(i in 1:R){
        for(j in 1:C){
            
            # first only look for >
            if(gridc[i,j] == "." || gridc[i,j] == ">"){
                next
            }
                
            
            dest <- (i %% R) + 1
            if(gridc[dest, j] == "."){
                south <- TRUE
                new_grid[dest, j] = "v"
                new_grid[i,j] = "."
            }
        }
    }
    if(!south && !east)
        break
    
    step <- step + 1
    grid <- new_grid
}
step

