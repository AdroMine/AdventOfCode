setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file_name <- 'sample.txt'
# file_name <- 'sample2.txt'
file_name <- 'input.txt'
W <- nchar(readLines(file_name, n = 1))
input <- as.matrix(read.fwf(file_name, widths = rep(1, W), colClasses = 'integer'))
mode(input) <- 'integer'


# next_points <- function(curr, direction, consecutive_steps){
#   next_pts <- list(
#     'right' = c(0, 1, 1),  # right coordinates movement + consecutive step
#     'left'  = c(0, -1, 1), # left
#     'up'    = c(-1, 0, 1), # up
#     'down'  = c(1, 0, 1) # down
#   )
#   nxt_pts <- switch(
#     direction, 
#     'right' = next_pts[-2], 
#     'left'  = next_pts[-1], 
#     'up'    = next_pts[-4], 
#     'down'  = next_pts[-3]
#   )
#   if(consecutive_steps == 3){
#     nxt_pts <- nxt_pts[-which(names(nxt_pts) == direction)] # can't go in same direction
#   }
#   
#   # increment step taken in current direction, all else set to 1
#   if(direction %in% names(nxt_pts)){
#     nxt_pts[[which(names(nxt_pts) == direction)]][3] <- consecutive_steps + 1
#   }
#   
#   lapply(nxt_pts, \(x) c(x[-3] + curr, x[3]))
# }

next_points <- function(curr, direction, consecutive_steps, min_steps, max_steps){
  next_pts <- list(
    'right' = c(0, 1, 1),  # right coordinates movement + consecutive step
    'left'  = c(0, -1, 1), # left
    'up'    = c(-1, 0, 1), # up
    'down'  = c(1, 0, 1) # down
  )
  # can't move back
  nxt_pts <- switch(
    direction, 
    'right' = next_pts[-2], 
    'left'  = next_pts[-1], 
    'up'    = next_pts[-4], 
    'down'  = next_pts[-3]
  )
  # if less than 4 steps, only move in that direction
  if(consecutive_steps < min_steps){
    nxt_pts <- nxt_pts[which(names(nxt_pts) == direction)]
  }
  if(consecutive_steps == max_steps){
    nxt_pts <- nxt_pts[-which(names(nxt_pts) == direction)] # can't go in same direction anymore
  }
  
  # increment step taken in current direction, all else set to 1
  if(direction %in% names(nxt_pts)){
    nxt_pts[[which(names(nxt_pts) == direction)]][3] <- consecutive_steps + 1
  }
  
  lapply(nxt_pts, \(x) c(x[-3] + curr, x[3]))
}

directions <- c('up', 'down', 'left', 'right')
dir_name_to_idx <- c('up' = 1, 'down' = 2, 'left' = 3, 'right' = 4)


dijkstra <- function(graph, part2){
  
  N <- nrow(graph)
  C <- ncol(graph)
  goal <- c(N,C)
  start <- c(1,1)
  
  # directions up down left right - 1 2 3 4
  # coordinates, direction, consecutive steps
  openset <- collections::priority_queue()
  initial_d <- c(start, 4, 0)
  openset$push(initial_d, priority = 0) 
  
  # score
  mindist <- collections::dict()
  mindist$set(initial_d, 0)
  
  while(openset$size() > 0){
    
    curr <- openset$pop()
    cx  <- curr[1]
    cy  <- curr[2]
    dir <- directions[curr[3]] # direction
    cs  <- curr[4] # consecutive steps
    
    d <- mindist$get(curr, Inf)
    
    if(!part2){
      adjacent <- next_points(curr[1:2], dir, cs, 1, 3)
    } else {
      adjacent <- next_points(curr[1:2], dir, cs, 4, 10)
    }
    
    for(i in seq_along(adjacent)) {
      nbr  <- adjacent[[i]]
      nx   <- nbr[1]
      ny   <- nbr[2]
      ndir <- unname(dir_name_to_idx[names(adjacent)[i]])
      cs   <- nbr[3]
      
      if(nx > N || ny > C || nx < 1 || ny < 1){
        next
      } 
      
      alt <- d + graph[nx,ny]
      key <- c(nx, ny, ndir, cs)
      
      if(alt < mindist$get(key, Inf)){
        mindist$set(key, alt)
        openset$push(key, priority = -alt)
      }
    }      
  }
  
  keys <- mindist$keys()
  if(!part2){
    end_goal_keys <- vapply(keys, \(x) x[1] == goal[1] && x[2] == goal[2], TRUE)
  } else {
    end_goal_keys <- vapply(keys, \(x) x[1] == goal[1] && x[2] == goal[2] && x[4] >= 4, TRUE)
  }
  end_goal_dists <- vapply(keys[end_goal_keys], \(k) mindist$get(k, Inf), 2)
  
  min(end_goal_dists)
}

# Part 1
dijkstra(input, part2 = FALSE)


# Part 2

dijkstra(input, part2 = TRUE)

