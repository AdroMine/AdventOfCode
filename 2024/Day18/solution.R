setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example1.txt'
file_name <- 'input.txt'

# add one since index starts at 1 for R
input <- strsplit(readLines(file_name), ",") |> lapply(\(x) as.numeric(x) + 1)

dirs <- list(
  c(-1, 0),  # top
  c(0 , 1),  # right
  c(1,  0),  # down
  c(0, -1)   # left
)

R <- 71; C <- 71;

create_grid <- function(input, R, C, steps){
  
  grid <- matrix(".", R, C)
  
  for(rock in input[1:steps]){
    
    grid[rock[2], rock[1]] <- "#"
    
  }
  
  grid
  
}

shortest_path <- function(grid, R, C){
  
  start <- c(1,1)
  end   <- c(R, C)
  
  # r, c, dist
  Q <- collections::queue(list(c(start, 0)))
  visited <- matrix(FALSE, R, C)
  
  best <- Inf
  reached <- FALSE
  
  while(Q$size() > 0){
    
    current <- Q$pop()
    pos <- current[-3]
    dist <- current[3]
    
    if(pos[1] == end[1] && pos[2] == end[2]){
      best <- min(best, dist)
      reached <- TRUE
      return(list(best, reached))
    }
    
    if(visited[pos[1], pos[2]]) next
    visited[pos[1], pos[2]] <- TRUE
    
    for(d in dirs){
      
      nxt <- pos + d
      
      if(nxt[1] < 1 || nxt[1] > R ||
         nxt[2] < 1 || nxt[2] > C || 
         grid[nxt[1], nxt[2]] == "#") next
      
      Q$push(c(nxt, dist + 1))
      
    }
  }
  
  list(best, reached)
  
}

grid <- create_grid(input, 71, 71, 1024)

shortest_path(grid, 71, 71)

# Part 2, use binary search to find step
path_at_step_i <- function(step){
  grid <- create_grid(input, R, C, step)
  shortest_path(grid, R, C)[[2]]
}

bin_search <- function(low, high){
  
  mid <- (low + high) %/% 2
  res_mid <- path_at_step_i(mid)
  res_low <- path_at_step_i(low)
  res_high <- path_at_step_i(high)
  if(low > high){
    return(-1)
  }
  if(res_low & !res_mid){
    return(bin_search(low, mid))
  } else if(res_low & res_mid){
    return(bin_search(mid + 1, high))
  } else if(!res_low & !res_mid){
    return(low)
  }
}

i <- bin_search(1024, length(input))

print(paste0(input[[i]] - 1, collapse = ","))






# Slow full brute force
for(i in 1025:length(input)){
  print(i)
  
  grid <- create_grid(input, R, C, i)
  res <- shortest_path(grid, R, C)
  if(!res[[2]]) break
  
}

# subtract one because of adding one above
print(paste0(input[[i]] - 1, collapse = ","))
