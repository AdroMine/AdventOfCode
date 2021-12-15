setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)


# Read and Transform input ------------------------------------------------

# Read in input
# file_name <- "sample.txt"
file_name <- "input.txt"

width <- nchar(readLines(file_name, n = 1))

input <- as.matrix(read.fwf(file_name, widths = rep(1, width)))
dijkstra <- function(graph){
    
    N <- nrow(graph)
    goal <- c(N, N)
    
    openset <- collections::priority_queue()
    openset$push(c(1,1), priority = 0)
    
    visited <- matrix(FALSE, N, N)
    
    # gscore
    mindist <- matrix(Inf, N, N)
    mindist[1,1] <- 0
    
    neighbours <- function(xy){
        x <- xy[1]
        y <- xy[2]
        
        list(
            c(x , y - 1),  # left
            c(x , y + 1),  # right
            c(x + 1, y ),  # down
            c(x - 1, y)    # up
        )
    }   
    
    while(openset$size() > 0){
        
        curr <- openset$pop()
        cx <- curr[1]
        cy <- curr[2]
        d <- mindist[cx,cy]
        
        if(all(curr == goal))
            break
        
        # if(visited[cx, cy])
        #     next
        
        visited[cx, cy] <- TRUE
        
        adjacent <- neighbours(curr)
        
        for(nbr in adjacent){
            nx <- nbr[1]
            ny <- nbr[2]
            
            if(nx > N || ny > N || nx < 1 || ny < 1)
                next
            
            alt <- d + graph[nx,ny]
            
            if(alt < mindist[nx,ny]){
                mindist[nx,ny] <- alt
                openset$push(nbr, priority = -alt)
            }
        }      
    }
    
    mindist[N, N]
}

# Part 1
dijkstra(input)

# Part 2

# Expand horizontally
resx <- input
mat <- input
for(i in 1:4){
    mat <- mat + 1
    mat[mat > 9] <- 1
    resx <- cbind(resx, mat)
}
# Expand vertically
mat <- resx
for(i in 1:4){
    mat <- mat + 1
    mat[mat > 9] <- 1
    resx <- rbind(resx, mat)
    
}

dijkstra(resx)
