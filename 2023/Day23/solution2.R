setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(scipen = 999) # display all digits, no scientific mode

# file_name <- 'sample.txt'
file_name <- 'input.txt'
W <- nchar(readLines(file_name, n = 1))
input <- as.matrix(read.fwf(file_name, widths = rep(1, W), comment.char = ''))

R <- nrow(input)
C <- ncol(input)

start <- as.integer(c(1L, unname(which(input[1,] == '.'))))
end <- as.integer(c(R, unname(which(input[R,] == '.'))))

graph_to_dag <- function(graph, start, end, part1 = FALSE){
  
  # get all vertices, that is points that have more than 2 neighbours
  V <- apply(which(input != '#', arr.ind = TRUE), 1, \(coord){
    gr <- unname(coord[1])
    gc <- unname(coord[2])
    
    adjacent <- list('^' = c(-1L, 0L), '>' = c(0L, 1L),
                     'v' = c(1L, 0L) , '<' = c(0L, -1L))
    
    all_nbrs <- 0
    for(i in seq_along(adjacent)){
      nbr <- adjacent[[i]]
      dir <- names(adjacent)[i]
      nr <- gr + nbr[1]
      nc <- gc + nbr[2]
      
      if(nr < 1 || nr > R || nc < 1 || nc > C) next
      if(graph[nr, nc] == '#') next
      if(part1){
        if(graph[gr, gc] %in% c('v', '^', '<', '>') && 
           graph[gr, gc] != dir) next
      }
      all_nbrs <- all_nbrs + 1
    }
    if(all_nbrs > 2) list(c(gr, gc)) else NULL
  }) |> 
    Filter(\(x) length(x) > 0, x = _) |> 
    unlist(recursive = FALSE)
  
  
  # add start and end to these
  V <- c(list(start), V, list(end))
  
  # Now find all edges between these vertices
  E <- vector('list', length(V))
  
  # Now find distances between these vertices
  for(vid in 1:length(V)){
    
    vert <- V[[vid]]
    
    Q <- collections::queue()
    Q$push(c(vert, 0L))
    seen <- collections::dict()
    
    while(Q$size() > 0){
      
      curr <- Q$pop()
      coord <- as.integer(curr[-3])
      gr <- curr[1]
      gc <- curr[2]
      d <- curr[3]
      if(seen$has(coord)) next
      seen$set(coord, TRUE)
      
      if(list(coord) %in% V && !identical(coord, vert)){
        idx <- which(sapply(V,identical, coord))
        E[[vid]] <- c(E[[vid]], list(c(curr, idx)))
        next
      }
      
      adjacent <- list('^' = c(-1L, 0L), '>' = c(0L, 1L),
                       'v' = c(1L, 0L) , '<' = c(0L, -1L))
      
      for(i in seq_along(adjacent)){
        nbr <- adjacent[[i]]
        dir <- names(adjacent)[i]
        nr <- gr + nbr[1]
        nc <- gc + nbr[2]
        
        if(nr < 1 || nr > R || nc < 1 || nc > C) next
        if(graph[nr, nc] == '#') next
        if(seen$has(c(nr, nc))) next
        if(part1){
          if(graph[gr, gc] %in% c('v', '^', '<', '>') && 
             graph[gr, gc] != dir) next
        }
        Q$push(c(nr, nc, d + 1L))
      }
    }
  }
  V2 <- collections::dict(items = V, seq_along(V))
  E2 <- collections::dict(E, keys = V2$values())
  # list(V2, E2)
  list(V, E)
}

solver <- function(input, start, end, part1 = TRUE){
  adj <- graph_to_dag(input, start, end, part1)
  V <- adj[[1]]
  E <- adj[[2]]
  end_vid <- length(V)
  # for second last vertex, only try to go to the end, not again start going through all
  # paths, since it is the only vertex that can go to the end
  # this can help bring down the runtime by half (100M dfs to 57M)
  penultimate <- E[[end_vid - 1L]]
  end_path <- which(sapply(penultimate, `[[`, 4) == end_vid)
  E[[end_vid - 1L]] <- E[[end_vid - 1L]][end_path]
  count <- 0
  best <- 0
  visited <- vector('logical', length(V))
  
  dfs <- function(vid, dist = 0L){
    count <<- count + 1
    vert <- V[[vid]]
    if(vid == end_vid) {
      best <<- max(best, dist)
    }
    
    if(visited[vid]) return(0)
    visited[vid] <<- TRUE
    
    for(nbr in E[[vid]]){
      Recall(nbr[4], dist + nbr[3])
    }
    visited[vid] <<- FALSE
  } 
  dfs(1, 0)
  print(count)
  best
}

solver(input, start, end, TRUE)
solver(input, start, end, FALSE)
