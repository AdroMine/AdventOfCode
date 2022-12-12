setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file <- 'sample.txt'
file <- 'input.txt'
width <- nchar(readLines(file, n = 1))
input <- as.matrix(read.fwf(file, widths = rep(1, width)))



dijkstra <- function(graph, start = which(graph == 'S', arr.ind = TRUE)){
    
    N <- nrow(graph)
    C <- ncol(graph)
    goal <- which(graph == 'E', arr.ind = TRUE)
    # start <- which(graph == 'S', arr.ind = TRUE)
    
    graph[start] <- 'a'
    graph[goal] <- 'z'
    
    openset <- collections::priority_queue()
    openset$push(start, priority = 0)
    
    visited <- matrix(FALSE, N, C)
    
    # gscore
    mindist <- matrix(Inf, N, C)
    mindist[start[1], start[2]] <- 0
    neighbours <- function(xy){
        x <- xy[1]
        y <- xy[2]
        cur <- utf8ToInt(graph[x, y])
        nbrs <- list(
            c(x , y - 1),  # left
            c(x , y + 1),  # right
            c(x + 1, y ),  # down
            c(x - 1, y)    # up
        )
        possible <- sapply(nbrs, function(cord){
            nx <- cord[1]
            ny <- cord[2]
            if(nx > N || ny > C || nx < 1 || ny < 1){
                FALSE
            } else {
                pt <- utf8ToInt(graph[nx, ny])
                (pt - cur) <= 1
            }
        })
        nbrs[possible]
        
    }   
       
    
    while(openset$size() > 0){
        
        curr <- openset$pop()
        cx <- curr[1]
        cy <- curr[2]
        d <- mindist[cx,cy]
        
        if(all(curr == goal))
            break
        
        visited[cx, cy] <- TRUE
        
        adjacent <- neighbours(curr)
        
        for(nbr in adjacent){
            nx <- nbr[1]
            ny <- nbr[2]
            
            alt <- d + 1 #graph[nx,ny]
            
            if(alt < mindist[nx,ny]){
                mindist[nx,ny] <- alt
                openset$push(nbr, priority = -alt)
            }
        }      
    }
    
    mindist[goal[1], goal[2]]
}

# Part 1
dijkstra(input)

# Part 2 

# points that start with 'a'
a_starts <- which(input == 'a', arr.ind = TRUE)
N <- nrow(a_starts)
res <- vector('double', N)

# for each start point, perform dijkstra, (takes around 1 min)
# quite fast after the first 100 starting points
for(i in seq_along(res)){
    start <- a_starts[i,]
    print(sprintf("%d / %d", i, N))
    res[i] <- dijkstra(input, start)
}
min(res)


