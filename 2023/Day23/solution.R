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

graph_to_dag <- function(graph, part1 = FALSE){
  
  adj <- collections::dict()
  
  coords <- which(input != '#', arr.ind = TRUE)
  
  
  for(cd in 1:nrow(coords)){
    
    gr <- unname(coords[cd, 1])
    gc <- unname(coords[cd, 2])
    
    adjacent <- list('^' = c(-1L, 0L), '>' = c(0L, 1L),
                     'v' = c(1L, 0L) , '<' = c(0L, -1L))
    
    all_nbrs <- collections::dict()
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
      
      all_nbrs$set(as.integer(c(nr, nc)), 1)
      # cur <- adj$get(key, list())
      # adj$set(key, c(cur, list(c(nr, nc, 1))))
      
    }
    key <- c(as.integer(gr), as.integer(gc))
    adj$set(key, all_nbrs)
  }
  adj
}

edge_contraction <- function(dag){
  
  vertices <- dag$keys()
  
  for(vert in vertices){
    
    nbrs <- dag$get(vert, NULL)
    
    # only 2 neighbours, so we can contract the edge
    # from u -> v -> w we can make u -> w
    if(nbrs$size() == 2){
      
      n_keys <- nbrs$keys()
      left_nbr <- n_keys[[1]]
      right_nbr <- n_keys[[2]]
      
      left_dict <- dag$get(left_nbr, NULL)
      right_dict <- dag$get(right_nbr, NULL)
      
      left_dist_to_cur <- left_dict$pop(vert, 0)
      right_dist_to_cur <- right_dict$pop(vert, 0)
      
      dist_to_left <- nbrs$get(right_nbr, 0)
      dist_to_right <- nbrs$get(left_nbr, 0)
      
      left_dict$set(right_nbr, dist_to_left + dist_to_right)
      right_dict$set(left_nbr, dist_to_left + dist_to_right)
      
      dag$set(left_nbr, left_dict)
      dag$set(right_nbr, right_dict)
      
      # finally remove this current vertex
      dag$pop(vert, NULL)
      
    }
  }
  dag
}

count <- 0
dfs <- function(dag, start, end, dist = 0){
  max_dist <- 0
  if(all(start == end)) return(max(max_dist, dist))
  
  nbrs <- dag$get(start, NULL)
  
  for(nb in nbrs$keys()){
    # if(visited$has(nb)) next
    if(visited[nb[1], nb[2]]) next
    # visited$set(nb, TRUE)
    visited[nb[1], nb[2]] <<- TRUE
    max_dist <- max(max_dist, Recall(dag, nb, end, dist + nbrs$get(nb, 0)))
    # visited$remove(nb)
    visited[nb[1], nb[2]] <<- FALSE
  }
  max_dist
}


solver <- function(input, start, end, part1 = TRUE){
  dag <- graph_to_dag(input, part1)
  dag <- edge_contraction(dag)
  dfs(dag, start, end)
}

# visited <- collections::dict()
visited <- matrix(FALSE, R, C)
solver(input, start, end, TRUE)
# visited$clear()
res <- solver(input, start, end, FALSE)



# somewhat faster
dfs2 <- function(dag, start, end, dist = 0){
  max_dist <- 0
  if(all(start == end)) return(sum(unlist(dists$values())))
  
  nbrs <- dag$get(start, NULL)
  
  for(nb in nbrs$keys()){
    if(dists$has(nb)) next
    
    dists$set(nb, nbrs$get(nb, 0))
    
    max_dist <- max(max_dist, Recall(dag, nb, end, dist + nbrs$get(nb, 0)))
    dists$remove(nb)
  }
  
  max_dist
  
}

dists <- collections::dict()
dists$set(as.integer(start), 0)

system.time(dfs2(dag, start, end, 0))
dfs2(dag, start, end, 0)
