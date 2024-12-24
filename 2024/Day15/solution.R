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


enlarge_grid <- function(grid){
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
}

move_robots <- function(grid, part2 = FALSE){
  if(part2) grid <- enlarge_grid(grid)
  
  robot_loc <- which(grid == '@', arr.ind = TRUE)[1,]
  pos <- robot_loc
  
  for(i in seq_along(instructions)){
    inst <- instructions[i]
    
    dir     <- dirs[[inst]]
    new_loc <- pos + dir
    
    if(grid[new_loc[1], new_loc[2]] == '#'){
      next
    } else if(grid[new_loc[1], new_loc[2]] == '.'){
      grid[new_loc[1], new_loc[2]] <- "@"
      grid[pos[1], pos[2]] <- "."
      pos <- new_loc
      next
    } else if(grid[new_loc[1], new_loc[2]] %in% c("[", "]","O")){
      
      Q <- collections::queue(list(pos))
      seen <- collections::dict()
      ok <- TRUE
      
      # check all the blocks affected by current push
      while(Q$size() > 0){
        
        cpos <- Q$pop()
        
        if(seen$has(cpos)) next
        seen$set(cpos, TRUE)
        
        npos <- cpos + dir
        # if wall ahead, we can't move anything
        if(grid[npos[1], npos[2]] == '#'){
          ok <- FALSE
          break
        }
        if(grid[npos[1], npos[2]] == 'O'){
          Q$push(npos)
        }
        if(grid[npos[1], npos[2]] == '['){
          Q$push(npos)
          Q$push(npos + c(0,1))
        }
        if(grid[npos[1], npos[2]] == ']'){
          Q$push(npos)
          Q$push(npos + c(0,-1))
        }
      }
      if(!ok) next
      
      while(seen$size() > 0){
        
        for(sk in seen$keys()){
          
          npos <- sk + dir
          if(!seen$has(npos)){
            stopifnot("ohho" = grid[npos[1], npos[2]] == '.')
            grid[npos[1], npos[2]] <- grid[sk[1], sk[2]]
            grid[sk[1], sk[2]] <- "."
            seen$remove(sk)
          }
        }
      }
      # pos <- new_loc
      pos <- pos + dir
    }
  }
  # print(grid)
  
  char <- if(part2) "[" else "O"
  box_locations <- which(grid == char, arr.ind = TRUE)
  sum((box_locations[,1] - 1) * 100 + (box_locations[,2] - 1))
  
  
}

move_robots(grid, FALSE)
move_robots(grid, TRUE)
