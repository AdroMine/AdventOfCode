setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)


# Read and Transform input ------------------------------------------------

# Read in input
# file_name <- "sample.txt"
file_name <- "input.txt"

width <- nchar(readLines(file_name, n = 1))

input <- as.matrix(read.fwf(file_name, widths = rep(1, width)))


djikstra <- function(graph){
    
    width <- nrow(graph)
    dist <- matrix(Inf, width, width)
    dist[1,1] <- 0
    
    visited <- matrix(FALSE, width, width)
    
    nxt_possible <- function(xy){
        x <- xy[1]
        y <- xy[2]
        
        res <- list(
            c(x , y - 1),  # left
            c(x , y + 1),  # right
            c(x + 1, y ),  # down
            c(x - 1, y)    # up
        )
        # unique(lapply(res,\(x) pmin(width, pmax(1, x))))
        res
        
    }
    N <- width * width
    while(!visited[width, width]){
        
        # print(sum(visited)/N * 100)
        
        not_visited <- which(!visited)
        curr <- arrayInd(not_visited[which.min(dist[not_visited])], .dim = c(width, width))[1,]
        
        cx <- curr[1]
        cy <- curr[2]
        
        visited[cx, cy] <- TRUE
        
        adjacent <- nxt_possible(curr)
        
        # for(nbr in adjacent){
        for(i in seq_along(adjacent)){
            
            nbr <- adjacent[[i]]
            
            nx <- nbr[1]
            ny <- nbr[2]
            if(nx > width || ny > width || nx < 1 || ny < 1)
                next
            alt <- dist[cx,cy] + graph[nx,ny]
            
            if(alt < dist[nx,ny]){
                dist[nx,ny] <- alt
            }
            # nxt_dist[i] <- dist[nx, ny]
        }
        
    }   
    dist[width, width]
    
}


# Part 1
djikstra(input)



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

djikstra(resx)
