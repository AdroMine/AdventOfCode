setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file <- 'sample.txt'
file <- 'input.txt'
width <- nchar(readLines(file, n = 1))
input <- as.matrix(read.fwf(file, widths = rep(1, width)))

dijkstra <- function(graph, start = 'S', goal = 'E', part2 = FALSE){
    
    N <- nrow(graph)
    C <- ncol(graph)
    goal <- which(graph == goal, arr.ind = TRUE)
    start <- which(graph == start, arr.ind = TRUE)
   
    if(!part2){
        graph[start] <- 'a'
        graph[goal] <- 'z'
    } else {
        graph[start] <- 'z'
    }
    
    openset <- collections::priority_queue()
    openset$push(start, priority = 0)
    
    # score
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
                if(!part2) (pt - cur) <= 1 else (pt - cur) >= -1
            }
        })
        nbrs[possible]
    }   
    
    while(openset$size() > 0){
        
        curr <- openset$pop()
        cx <- curr[1]
        cy <- curr[2]
        d <- mindist[cx,cy]
        
        if(part2){
            if(graph[cx, cy] == 'a') return(d)
        } else if(all(curr == goal)) break
        
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
# find shortest path from E to any 'a'
dijkstra(input, 'E', 'a', part2 = TRUE)


# BFS

next_points <- function(curr){
    next_pts <- list(
        c(0, 1), c(0, -1), c(-1, 0), c(1, 0)
    )
    lapply(next_pts, \(x) x + curr)
}


bfs <- function(graph, part2){
    
    N <- nrow(graph)
    C <- ncol(graph)
    goal <- which(graph == 'E', arr.ind = TRUE)
    start <- which(graph == 'S', arr.ind = TRUE)
    graph[start] <- 'a'
    graph[goal] <- 'z'
    
    visited <- matrix(FALSE, N, C)
    
    Q <- collections::deque()
    if(!part2){
        Q$push(c(start, 0))
        
    } else {
        starting_points <- which(graph == 'a', arr.ind = TRUE)
        for(i in 1:nrow(starting_points)){
            Q$push(c(starting_points[i,1], starting_points[i, 2], 0))
        }
    }
    
    while(Q$size()){
        
        curr <- Q$popleft()
        rx <- curr[1]
        cy <- curr[2]
        d  <- curr[3]
        
        if(visited[rx, cy]) next 
        visited[rx, cy] <- TRUE
        
        if(all(curr[-3] == goal)) {
            return(d)
        }
        
        cur_pt <- utf8ToInt(graph[rx, cy])
        
        for(adj in next_points(c(rx, cy))){
            nx <- adj[1]
            ny <- adj[2]
            if(nx > N || ny > C || nx < 1 || ny < 1){
                next
            } 
            pt <- utf8ToInt(graph[nx, ny])
            if((pt - cur_pt) <= 1){
                Q$push(c(nx, ny, d + 1))
            }
        }
    }
}

# Part 1
bfs(input, FALSE)

# Part 2
bfs(input, TRUE)
