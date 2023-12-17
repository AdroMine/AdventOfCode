setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file_name <- 'sample.txt'
# file_name <- 'sample2.txt'
file_name <- 'input.txt'
W <- nchar(readLines(file_name, n = 1))
input <- as.matrix(read.fwf(file_name, widths = rep(1, W), colClasses = 'integer'))
mode(input) <- 'integer'

# generate the four possible new directions to move in along with the direction 
# the new movement would be in and consecutive steps
next_points <- function(curr, direction, consecutive_steps, min_steps, max_steps){
  # direction top right down left
  # directions + new steps + new_direction
  next_pts <- list(c(-1, 0, 1, 1), c(0, 1, 1, 2), c(1, 0, 1, 3), c(0, -1, 1, 4))
  next_pts[[direction]][3] <- consecutive_steps + 1
  
  # keep direction from 1 to 4 (north, east, south, west)
  
  # remove reverse direction
  to_remove <- (direction + 2 - 1) %% 4 + 1 
  
  # if less than 4 steps, only move in that direction
  if(consecutive_steps < min_steps){
    return(next_pts[direction])
  } 
  
  if(consecutive_steps == max_steps){
    to_remove <- c(direction, to_remove)
  }
  next_pts <- next_pts[-to_remove]
  
  next_pts
  
}


dijkstra <- function(graph, part2){
  
  N <- nrow(graph)
  C <- ncol(graph)
  goal <- c(N,C)
  start <- c(1,1)
  
  # directions north, east, south, west - 1, 2, 3, 4
  # coordinates, direction, consecutive steps
  openset <- collections::priority_queue()
  initial_d <- c(start, 2, 0) # start from top left, going right, no consecutive steps now
  openset$push(initial_d, priority = 0) 
  
  # score
  mindist <- collections::dict()
  mindist$set(initial_d, 0)
  
  while(openset$size() > 0){
    
    curr <- openset$pop()
    d <- mindist$get(curr, Inf)
    
    if(!part2){
      adjacent <- next_points(curr[1:2], curr[3], curr[4], 1, 3)
    } else {
      adjacent <- next_points(curr[1:2], curr[3], curr[4], 4, 10)
    }
    
    for(i in seq_along(adjacent)) {
      nbr  <- adjacent[[i]]
      nx   <- nbr[1] + curr[1]
      ny   <- nbr[2] + curr[2]
      if(nx > N || ny > C || nx < 1 || ny < 1){
        next
      } 
      
      alt <- d + graph[nx,ny]
      key <- c(nx, ny, nbr[4], nbr[3])
      
      if(alt < mindist$get(key, Inf)){
        mindist$set(key, alt)
        openset$push(key, priority = -alt)
      }
    }      
  }
  
  # get all dists for reaching end goal given the conditions
  keys <- mindist$keys()
  if(!part2){
    end_goal_keys <- vapply(keys, \(x) x[1] == goal[1] && x[2] == goal[2], TRUE)
  } else {
    end_goal_keys <- vapply(keys, \(x) x[1] == goal[1] && x[2] == goal[2] && x[4] >= 4, TRUE)
  }
  # for all ways of reaching end, find min dist
  end_goal_dists <- vapply(keys[end_goal_keys], \(k) mindist$get(k, Inf), 2)
  
  min(end_goal_dists)
}

# Part 1
dijkstra(input, part2 = FALSE)


# Part 2
dijkstra(input, part2 = TRUE)
