setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example1.txt'
file_name <- 'example2.txt'
file_name <- 'example3.txt'
file_name <- 'input.txt'

W <- nchar(readLines(file_name, n = 1))
input <- read.fwf(file_name, comment.char = "", widths = rep(1, W)) |> as.matrix()
R <- nrow(input); C <- ncol(input);

dirs <- list(
  '^' = c(-1, 0), 
  '>' = c(0, 1), 
  'v' = c(1, 0), 
  '<' = c(0, -1)
)

start <- unname(which(input == 'S', arr.ind = TRUE)[1,])
end   <- unname(which(input == "E", arr.ind = TRUE)[1,])

cur_dir <- 2

Q <- collections::priority_queue()
Q$push(c(start, cur_dir))

dist_start_to_end <- collections::dict()
dist_start_to_end$set(c(start, cur_dir), 0)

while(Q$size() > 0){
  
  current  <- Q$pop()
  cur_dir  <- current[3]
  pos      <- current[-3]
  cur_dist <- dist_start_to_end$get(current, Inf)
  
  for(steps in c(-1, 0, 1)){
    
    nxt_dir <- (cur_dir - 1 + steps) %% 4 + 1
    nxt_pos <- pos + dirs[[nxt_dir]]
    
    if(nxt_pos[1] < 1 || nxt_pos[1] > R || 
       nxt_pos[2] < 1 || nxt_pos[2] > C || 
       input[nxt_pos[1], nxt_pos[2]] == "#"){
      next
    }
    
    d <- if(steps == 0) 1 else 1001
    alt <- cur_dist + d
    key <- c(nxt_pos, nxt_dir)
    
    if(alt < dist_start_to_end$get(key, Inf)){
      dist_start_to_end$set(key, alt)
      Q$push(key, priority = -alt)
    }
    
  }
  
}

keys <- dist_start_to_end$keys()
end_goal_keys <- which(purrr::map_lgl(keys, \(x) x[1] == end[1] && x[2] == end[2]))
end_goal_dists <- vapply(keys[end_goal_keys], \(k) dist_start_to_end$get(k, Inf), 2)

# Part 1
best <- min(end_goal_dists)
print(best)

# Part 2

dist2   <- collections::dict()
Q       <- collections::priority_queue()
seen    <- collections::dict()

for(i in 1:4) Q$push(c(0, end, i))

while(Q$size() > 0){
  
  current  <- Q$pop()
  cur_dist <- current[1]
  pos      <- current[2:3]
  cur_dir  <- current[4]
  
  if(!dist2$has(current[-1])){
    dist2$set(current[-1], current[1])
  }
  if(seen$has(current[-1])) next
  seen$set(current[-1], TRUE)
  
  # backward movement since end to start
  nxt_dir2 <- dirs[[(cur_dir - 1 + 2) %% 4 + 1]]  # dr,dc = DIRS[(dir+2)%4]
  nxt_pos  <- pos + nxt_dir2                      # rr,cc = r+dr,c+dc
  
  if((nxt_pos[1] >= 1 & nxt_pos[1] <= R) &&
     (nxt_pos[2] >= 1 & nxt_pos[2] <= C) && 
     input[nxt_pos[1], nxt_pos[2]] != "#"){
    Q$push(c(cur_dist + 1, nxt_pos, cur_dir), priority = -(cur_dist + 1))
  }
  Q$push(c(cur_dist + 1000, pos, (cur_dir - 1 + 1) %% 4 + 1), priority = -(cur_dist + 1000))
  Q$push(c(cur_dist + 1000, pos, (cur_dir - 1 + 3) %% 4 + 1), priority = -(cur_dist + 1000))
  
}

# Part 2
# should give same answer when going right from start
dist2$get(c(start, 2))

tiles <- collections::dict()

for(rr in 1:R){
  for(cc in 1:C){
    for(dir in 1:4){
      key <- as.numeric(c(rr, cc, dir))
      # names(key)[1:2] <- c('row', 'col')
      if(dist_start_to_end$has(key) && dist2$has(key) && 
         (dist_start_to_end$get(key) + dist2$get(key) == best)){
        tiles$set(c(rr, cc), TRUE)
      }
    }
  }
}
tiles$size()
