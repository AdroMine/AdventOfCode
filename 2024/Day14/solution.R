setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'

input <- readLines(file_name) |> 
  stringr::str_extract_all("-?\\d+") |> 
  lapply(as.numeric)

# R <- 7; C <- 11;
R <- 103;  C <- 101

determine_robot_quadrant <- function(robot, time){
  
  start_x <- robot[1]
  start_y <- robot[2]
  vel_x <- robot[3]
  vel_y <- robot[4]
  
  end_x <- (start_x + vel_x * time) %% C
  end_y <- (start_y + vel_y * time) %% R
  # print(c(end_x, end_y))
 
  mid_x <- C %/% 2 
  mid_y <- R %/% 2
  if(end_x < mid_x & end_y < mid_y){
    quad <- 1
  } else if(end_x > mid_x & end_y < mid_y){
    quad <- 2
  } else if(end_x < mid_x & end_y > mid_y){
    quad <- 3
  } else if(end_x > mid_x & end_y > mid_y){
    quad <- 4
  } else {
    quad <- 0
  }
  list(quad, end_x, end_y)
}

safety_value <- function(time){
  quadrants <- c(0, 0, 0, 0)
  for(robot in input){
    res <- determine_robot_quadrant(robot, time)
    quad <- res[[1]]
    quadrants[quad] <- quadrants[quad] + 1
  }
  prod(quadrants)
}

# Part 1
safety_value(100)

# Part 2
all_safety_values <- sapply(1:10000, \(t){
  if(t %% 1000 == 0) print(t)
  safety_value(t)
})

which.min(all_safety_values) 


t <- which.min(all_safety_values) 

# display tree
grid <- matrix(0, R, C)
quadrants <- c(0, 0, 0, 0)
for(robot in input){
  res <- determine_robot_quadrant(robot, t) #     quad <- res[[1]]
  grid[res[[3]], res[[2]]] <- 1
  quadrants[quad] <- quadrants[quad] + 1
}

# image(grid)
image(t(apply(grid, 2, rev)))

