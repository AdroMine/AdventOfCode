setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file_name <- 'example.txt'
file_name <- 'input.txt'
W <- nchar(readLines(file_name)[1])
input <- read.fwf(file_name, widths = rep(1, W)) |> as.matrix()

R <- nrow(input); C <- ncol(input)
visited <- matrix(FALSE, R, C)

possible_nbrs <- function(cur_pt){
  cur_level <- input[cur_pt[1], cur_pt[2]]
  # all 4 directions
  nbrs <- list(
    c(cur_pt[1] - 1, cur_pt[2]    ), # top
    c(cur_pt[1]    , cur_pt[2] - 1), # left
    c(cur_pt[1]    , cur_pt[2] + 1), # right
    c(cur_pt[1] + 1, cur_pt[2]    )  # down
  )
  # remove those that are not 1 height up (or are already at top (9))
  nbrs2 <- lapply(nbrs, \(pt){
    if(pt[1] < 1 | pt[1] > R | pt[2] < 1 | pt[2] > C){
      NULL
    } else if(input[pt[1], pt[2]] == 9 | (input[pt[1], pt[2]] - cur_level != 1)){
      NULL
    } else {
      as.numeric(pt) # just to avoid dictionary keys issues between integer/numeric
    }
  }) |> 
    purrr::discard(is.null)
  nbrs2
}

start_points <- which(input == 0, arr.ind = TRUE)
end_points   <- which(input == 9, arr.ind = TRUE)

bfs <- function(start){
  
  visited[] <- FALSE
  
  Q <- collections::queue()
  start <- as.numeric(start)
  Q$push(start)
  visited[start[1], start[2]] <- TRUE
  
  parents <- collections::dict()
  parents$set(start, NULL) # keep a set of parents for each point
  
  # search bfs outwards
  while(Q$size() > 0){
    
    current <- Q$pop()
    
    nbrs <- possible_nbrs(current)
    for(nb in nbrs){
      nb <- as.numeric(nb)
      if(!visited[nb[1], nb[2]]){
        Q$push(nb)
        visited[nb[1], nb[2]] <- TRUE
        parents$set(nb, c(list(current)))
      } else {
        # if already visited, then add another parent to this
        old_parent <- parents$get(nb, NULL)
        if(!list(nb) %in% old_parent) parents$set(nb, c(list(current), old_parent))
      }
    }
  }
  
  # compute distinct paths from given start to each end
  # compute path ratings (number of distinct ways to reach an end point from a start pt)
  rating <- 0
  for(i in 1:nrow(end_points)){
    end_pt     <- as.numeric(end_points[i,])
    if(!visited[end_pt[1], end_pt[2]]) next
    
    # for each visited end point
    ind_rating <- 1
    
    pt <- end_pt
    # find path to start from end and keep track of how many parents at each node
    q2 <- collections::queue()
    q2$push(pt)
    
    while(q2$size() > 0){
      pt <- q2$pop()
      
      # find current points parents and update distinct paths if multiple parents
      pars <- parents$get(pt, NULL)
      if(!is.null(pars)){
        for(item in pars) q2$push(item)
        ind_rating <- ind_rating + length(pars) - 1
      }
    }
    rating <- rating + ind_rating
  }
  
  list(
    p1 = sum(visited[end_points]),
    p2 = rating
  )
  
}

p1 <- 0
p2 <- 0
for(i in 1:nrow(start_points)){
  res <- bfs(start_points[i,])
  p1 <- p1 + res$p1
  p2 <- p2 + res$p2
}

p1
p2
