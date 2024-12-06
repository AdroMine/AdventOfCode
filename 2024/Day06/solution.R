setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# input <- readr::read_file('example.txt') |> 
# file_name <- 'example.txt'
file_name <- 'input.txt'
input <- readLines(file_name)
C <- nchar(input[1])
R <- length(input)
input <- read.fwf(file_name, widths = rep(1,C), comment.char = "") |> as.matrix()

start <- which(input == '^', arr.ind = TRUE)[1,]

dirs <- list(
  c(-1, 0), # up
  c(0, 1),  # right
  c(1, 0),  # down
  c(0, -1)  # left
)

maze_traverse <- function(grid, cur_pos, stone_location = NULL){
  
  if(!is.null(stone_location)){
    grid[stone_location[1], stone_location[2]] <- '#'
  }
  
  # 0 means not visited, 1-4 means visited while facing particular direction
  # if visit same spot with same direction, means loop
  visited <- matrix(0, nrow = nrow(grid), ncol = C)
  cur_dir <- 1
  visited[cur_pos[1], cur_pos[2]] <- cur_dir
  escaped <- FALSE
  while(!escaped){
    
    new_pos <- cur_pos + dirs[[cur_dir]]
    if(new_pos[2] > C | new_pos[2] < 1 | new_pos[1] > R | new_pos[1] < 1){
      escaped <- TRUE
      next
    }
    
    if(grid[new_pos[1], new_pos[2]] == '#'){
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
  
  if(escaped & is.null(stone_location)){
    visited
  } else {
    !escaped
  }
}

p1_visited <- maze_traverse(input, start)

# Part 1
sum(p1_visited != 0)

# Part 2

possible_locations <- which(p1_visited != 0, arr.ind = TRUE)

p2 <- 0
for(i in cli::cli_progress_along(1:nrow(possible_locations))) {
  new_location <- possible_locations[i,]
  res <- maze_traverse(input, start, new_location)
  p2 <- p2 + res 
  start <- which(input == '^', arr.ind = TRUE)[1,]
}

p2
