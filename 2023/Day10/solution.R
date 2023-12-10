setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
W <- readLines(file_name, n = 1) |> nchar()
input <- read.fwf(file_name, widths = rep(1, W))

start <- which(input == 'S', arr.ind = TRUE)[1,]

graph <- input
graph[start[1], start[2]] <- '|'


dijkstra <- function(graph, start){
  
  R <- nrow(graph)
  C <- ncol(graph)
  
  openset <- collections::priority_queue()
  openset$push(start, priority = 0)
  
  visited <- matrix(FALSE, nrow = R, ncol = C)
  
  # gscore
  mindist <- matrix(Inf, nrow = R, ncol = C)
  mindist[start[1], start[2]] <- 0
  
  neighbours <- function(graph, xy){
    x <- xy[1]
    y <- xy[2]
    
    # | is a vertical pipe connecting north and south.
    # - is a horizontal pipe connecting east and west.
    # L is a 90-degree bend connecting north and east.
    # J is a 90-degree bend connecting north and west.
    # 7 is a 90-degree bend connecting south and west.
    # F is a 90-degree bend connecting south and east.
    # . is ground; there is no pipe in this tile.
    # S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
    # 
    list(
      if(graph[x,y] %in% c('-', 'J', '7')) c(x , y - 1),  # left
      if(graph[x,y] %in% c('-', 'L', 'F')) c(x , y + 1),  # right
      
      if(graph[x,y] %in% c('|', '7', 'F')) c(x + 1, y),  # down
      if(graph[x,y] %in% c('|', 'L', 'J')) c(x - 1, y)  # up
    ) |> 
      base::Filter(\(x) length(x) > 0, x = _)
  }   
  
  while(openset$size() > 0){
    
    curr <- openset$pop()
    cx <- curr[1]
    cy <- curr[2]
    d <- mindist[cx,cy]
    
    # if(all(curr == goal))
    #   break
    
    # if(visited[cx, cy])
    #     next
    
    visited[cx, cy] <- TRUE
    
    adjacent <- neighbours(graph, curr)
    
    for(nbr in adjacent){
      nx <- nbr[1]
      ny <- nbr[2]
      
      if(nx > R || ny > C || nx < 1 || ny < 1)
        next
      
      alt <- d + 1
      
      if(alt < mindist[nx,ny]){
        mindist[nx,ny] <- alt
        openset$push(nbr, priority = -alt)
      }
    }      
  }
  mindist
}

dist_mat <- dijkstra(graph, start)


# Part 2
p2 <- 0

graph2 <- graph

# replace non-loop part with '.'
graph2[dist_mat == Inf] <- '.'


# scan the whole grid, if loop component goes upward, switch inside boolean
# then count every . on that row until inside TRUE
for(x in 1:nrow(graph2)){
  inside <- FALSE
  for(y in 1:ncol(graph2)){
    
    if(graph2[x,y] %in% c('|', 'L', 'J')) {
      inside <- !inside
    } else if (graph2[x,y] == '.' && inside) {
      p2 <- p2 + 1
    }
  }
}

p2


