setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'

input <- readr::read_file(file_name)
W <- nchar(readLines(file_name, n = 1))
input <- strsplit(input, "\\n\\n")[[1]]
grid <- read.table(text = input[1], comment.char = "")

grid <- read.fwf(file_name, n = nrow(grid), comment.char = "", widths = rep(1, W)) |> as.matrix()
instructions <- strsplit(gsub("\n", "", input[2]), "")[[1]]

dirs <- list(
  '^' = c(-1, 0), 
  '>' = c(0, 1), 
  'v' = c(1, 0), 
  '<' = c(0, -1)
)

move_one_step <- function(inst, pos, grid){
  
  dir <- dirs[[inst]]
  
  new_loc <- pos + dir
  if(grid[new_loc[1], new_loc[2]] == '#'){
    return(list(pos, grid))
  } else if(grid[new_loc[1], new_loc[2]] == 'O'){
    stone_loc <- new_loc
    while(grid[stone_loc[1], stone_loc[2]] == "O"){
      stone_loc <- stone_loc + dir
    }
    if(grid[stone_loc[1], stone_loc[2]] == '#'){
      return(list(pos, grid))
    } else {
      grid[stone_loc[1], stone_loc[2]] <- 'O'
      grid[new_loc[1], new_loc[2]] <- "@"
      grid[pos[1], pos[2]] <- "."
      return(list(new_loc, grid))
    }
  } else if(grid[new_loc[1], new_loc[2]] == '.'){
    grid[new_loc[1], new_loc[2]] <- "@"
    grid[pos[1], pos[2]] <- "."
    return(list(new_loc, grid))
  }
}

new_grid <- grid
robot_loc <- which(grid == '@', arr.ind = TRUE)[1,]
for(i in seq_along(instructions)){
  inst <- instructions[i]
  
  res <- move_one_step(inst, robot_loc, new_grid)
  new_grid <- res[[2]]
  robot_loc <- res[[1]]
  
}

box_locations <- which(new_grid == "O", arr.ind = TRUE)
sum((box_locations[,1] - 1) * 100 + (box_locations[,2] - 1))




part2_grid <- matrix('.', nrow = nrow(grid), ncol = ncol(grid) * 2)
for(row in seq_len(nrow(grid))){
  for(col in seq_len(ncol(grid))){
    
    item <- switch(
      grid[row, col], 
      '#' = c('#', '#'), 
      'O' = c('[', ']'), 
      '.' = c('.', '.'), 
      '@' = c('@', '.')
    )
    
    part2_grid[row, 2*col - 1] <- item[1]
    part2_grid[row, 2*col    ] <- item[2]
    
  }
}

part2_grid

move_one_step_part_2 <- function(inst, pos, grid){
  
  dir <- dirs[[inst]]
  
  new_loc <- pos + dir
  if(grid[new_loc[1], new_loc[2]] == '#'){
    return(list(pos, grid))
  } else if(grid[new_loc[1], new_loc[2]] == 'O'){
    stone_loc <- new_loc
    while(grid[stone_loc[1], stone_loc[2]] == "O"){
      stone_loc <- stone_loc + dir
    }
    if(grid[stone_loc[1], stone_loc[2]] == '#'){
      return(list(pos, grid))
    } else {
      grid[stone_loc[1], stone_loc[2]] <- 'O'
      grid[new_loc[1], new_loc[2]] <- "@"
      grid[pos[1], pos[2]] <- "."
      return(list(new_loc, grid))
    }
  } else if(grid[new_loc[1], new_loc[2]] == '.'){
    grid[new_loc[1], new_loc[2]] <- "@"
    grid[pos[1], pos[2]] <- "."
    return(list(new_loc, grid))
  }
}
