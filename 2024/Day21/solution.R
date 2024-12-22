setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'
# input <- c("029A", "980A", "179A", "456A", "379A")
input <- readLines(file_name)

num_keypad <- matrix(c(7:9, 4:6, 1:3, "", "0", "A"), 4, 3, byrow = TRUE)
dir_keypad <- matrix(c("", "^", "A", "<", "v", ">"), 2, 3, byrow = TRUE)

gen_path <- function(source, target, numpad = FALSE){
  grid <- if(numpad) num_keypad else dir_keypad
  
  dij <- target - source
  vert_char <- if(dij[1] > 0) "v" else "^"
  vert <- rep(vert_char, abs(dij[1]))
  horiz_char <- if(dij[2] > 0) ">" else "<"
  horiz <- rep(horiz_char, abs(dij[2]))
  if(dij[2] > 0 && grid[target[1], source[2]] != ""){
    return(c(vert, horiz, "A"))
  } 
  if(grid[source[1], target[2]] != ""){
    return(c(horiz, vert, "A"))
  }
  if(grid[target[1], source[2]] != ""){
    return(c(vert, horiz, "A"))
  }
}

key_sequence <- function(num){
  cur <- c(4,3) # A
  sequence <- c()
  num <- strsplit(num, "")[[1]]
  for(char in num){
    loc <- as.numeric(unname(which(num_keypad == char, arr.ind = TRUE)[1,]))
    # path <- gen_path(num_keypad, cur, loc)
    path <- gen_path(cur, loc, TRUE)
    sequence <- c(sequence, path)
    cur <- loc
    
  }
  sequence
  
}
dir_sequence <- function(char_seq, start = TRUE){
  
  if(start){
    cur <- c(1,3)
  } else {
    cur <- as.numeric(unname(which(dir_keypad == char_seq[1], arr.ind = TRUE)))
    char_seq <- char_seq[-1]
  }
  sequence <- c()
  for(char in char_seq){
    loc <- as.numeric(unname(which(dir_keypad == char, arr.ind = TRUE)[1,]))
    path <- gen_path(cur, loc, FALSE)
    sequence <- c(sequence, path)
    cur <- loc
  }
  sequence
}

# Part 1 & 2
cache2 <- collections::dict()

# Break each string into groups of two and calculate for them recursively
# the number of counts they will generate
dir_sequence_count <- function(char_seq, rounds){
  
  char_seq <- c("A", char_seq)
  
  if(cache2$has(list(char_seq, rounds))){
    return(cache2$get(list(char_seq, rounds)))
  }
  
  N <- length(char_seq)
  if(rounds == 1){
    seq <- dir_sequence(char_seq, FALSE)
    num <- length(seq)
    
  } else {
    num <- 0
    for(i in 1:(N - 1)){
      part <- dir_sequence(char_seq[c(i, i + 1)], FALSE)
      num <- num + Recall(part, rounds - 1)
    }
  }
  
  cache2$set(list(char_seq, rounds), num)
  
  return(num)
  
}

p1 <- 0
p2 <- 0
for(part in input){
  
  sequence <- key_sequence(part)
  len1 <- dir_sequence_count(sequence, 2)
  len2 <- dir_sequence_count(sequence, 25)
  num_val <- readr::parse_number(part)
  # print(paste0("Length: ", len, "; num_val = ", num_val, "; complexity = ", len*num_val))
  p1 <- p1 + len1*num_val
  p2 <- p2 + len2*num_val
  
  
}

as.character(p1)
as.character(p2)














# Old path solution, somewhat wrong
dirs <- list(
  c(-1, 0),  # top
  c(0 , 1),  # right
  c(1,  0),  # down
  c(0, -1)   # left
)
cache <- collections::dict()
dijkstra <- function(numpad = TRUE, start, end){
  if(identical(start, end)){
    return("A")
  }
  
  if(cache$has(c(numpad, start, end))){
    return(cache$get(c(numpad, start, end)))
  }
  
  grid <- if(numpad) num_keypad else dir_keypad
  R <- nrow(grid); C <- ncol(grid);
  
  Q <- collections::priority_queue() # going left
  mindist <- collections::dict()
  for(d in 1:4){
    mindist$set(c(start, d), 0)
    Q$push(c(start, d))
  }
  previous <- collections::dict()
  path_key <- c("^", ">", "v", "<")
  
  while(Q$size() > 0){
    
    current <- Q$pop()
    pos <- current[1:2]
    dir <- current[3]
    dist <- mindist$get(c(pos, dir))
    
    for(d in 1:4){
      
      nxt <- pos + dirs[[d]]
      if(nxt[1] < 1 || nxt[1] > R || 
         nxt[2] < 1 || nxt[2] > C ||
         grid[nxt[1], nxt[2]] == "") next
      
      new_dist <- if(d == dir) 1 else 2 # add penalty for changing directions for future robots
      alt <- dist + new_dist
      key <- c(nxt, d)
      if(alt < mindist$get(key, Inf)){
        mindist$set(key, alt)
        Q$push(key, priority = -alt)
        previous$set(key, c(pos, dir))
      }
    }
  }
  # generate path
  end_dir <- which.min(sapply(1:4, \(x) mindist$get(c(end, x), Inf)))
  path <- path_key[end_dir]
  cur <- c(end, end_dir)
  while(!identical(cur[-3], start)){
    temp    <- previous$get(cur)
    path    <- c(path_key[temp[3]], path)
    cur     <- temp
  }
  path <- c(path[-1], "A")
  # set path in cache
  cache$set(c(numpad, start, end), path)
  # return path
  path
  
}
