setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# input <- readr::read_file('example.txt') |> 
file_name <- 'example.txt'
file_name <- 'input.txt'
input <- readLines(file_name)
C <- nchar(input[1])
R <- length(input)
input <- read.fwf(file_name, widths = rep(1,C), comment.char = "")

visited <- matrix(FALSE, nrow = length(input), ncol = C)

start <- which(input == '^', arr.ind = TRUE)[1,]

escaped <- FALSE

dirs <- list(
  c(-1, 0), # up
  c(0, 1),  # right
  c(1, 0),  # down
  c(0, -1)  # left
)
cur_dir <- 1
cur_pos <- start
visited[cur_pos[1], cur_pos[2]] <- TRUE

while(!escaped){
  
  new_pos <- cur_pos + dirs[[cur_dir]]
  
  if(new_pos[2] > C | new_pos[2] < 1 | new_pos[1] > R | new_pos[1] < 1){
    escaped <- TRUE
    next
  }
  
  if(input[new_pos[1], new_pos[2]] == '#'){
    # change dir
    cur_dir <- (cur_dir - 1 + 1) %% 4 + 1
  } else {
    visited[new_pos[1], new_pos[2]] <- TRUE
    cur_pos <- new_pos
  }
}

sum(visited)

# Part 2



possible_locations <- which(input == '.', arr.ind = TRUE)

loop_result <- function(stone_location, grid){
  
  grid[stone_location[1], stone_location[2]] <- '#'
  start <- which(input == '^', arr.ind = TRUE)[1,]
  # 0 means not visited, 1-4 means visited while facing particular direction
  # if visit same spot with same direction, means loop
  visited <- matrix(0, nrow = length(input), ncol = C)
  cur_dir <- 1
  cur_pos <- start
  visited[cur_pos[1], cur_pos[2]] <- cur_dir
  
  escaped <- FALSE
  while(!escaped){
    
    new_pos <- cur_pos + dirs[[cur_dir]]
    if(new_pos[2] > C | new_pos[2] < 1 | new_pos[1] > R | new_pos[1] < 1){
      escaped <- TRUE
      next
    }
    
    if(input[new_pos[1], new_pos[2]] == '#'){
      # change dir
      cur_dir <- (cur_dir - 1 + 1) %% 4 + 1
    } else {
      
      # detect loop, if visiting same place with the same direction again
      if(visited[new_pos[1], new_pos[2]] == cur_dir){
        break
      }
      visited[new_pos[1], new_pos[2]] <- cur_dir
      cur_pos <- new_pos
    }
  }
  
  return(!escaped)
  
  
}

p2 <- 0
for(i in 1:nrow(possible_locations)){
  new_location <- possible_locations[i,]
  res <- loop_result(new_location, input)
  p2 <- p2 + res 
  start <- which(input == '^', arr.ind = TRUE)[1,]
}

p2
