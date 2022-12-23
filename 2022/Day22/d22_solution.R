setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

in_file <- 'input.txt'

temp         <- readLines(in_file)
sep          <- which(temp == '')
width        <- nchar(temp[1])
input        <- read.fwf(in_file, widths = rep(1, width), comment.char = "", n = sep-1)
instructions <- temp[sep + 1]


grid_print <- function(grid){
    grid[is.na(grid)] <- " "
    for(r in 1:nrow(grid)){
        cat(paste(grid[r, ], collapse = ""), "\n")
    }
}

directions <- list("U" = c(-1, 0), "R" = c(0 , 1),
                   "D" = c(1 , 0), "L" = c(0 , -1))

new_direction <- matrix(c("L", "U", "R", "D", "R", "D", "L", "U"),  4, 2,
                        dimnames = list(names(directions), c("L", "R")))

facing <- c('R' = 0, 'D' = 1, 'L' = 2, 'U' = 3)


part1 <- function(input, instruction){
    
    instrs <- stringr::str_match_all(instruction, "([0-9]+)|([LR])")[[1]][,1]
    # find start position
    for(row in 1:nrow(input)){
        if(all(is.na(input[row,]) & input[row,] == ' ')) {
            next 
        } else {
            col <- which(!is.na(input[row,]) & input[row,] != " ")[1]
            break
        }
    }
    
    
    cur_pos <- c(row, col)
    cur_dir <- 'R'
    R <- nrow(input)
    C <- ncol(input)
    
    # Part 1, Traverse Grid
    for(ins in instrs){
        # turn direction
        if(ins %in% c("L", "R")){
            cur_dir <- new_direction[cur_dir, ins]
        } else {
            # or move
            num <- as.integer(ins)
            mov <- directions[[cur_dir]]
            
            # move until face block, wrap around if face end
            k <- 1
            while(k <= num){
                new_pos <- cur_pos + mov            # get new position if we move
                np <- input[new_pos[1], new_pos[2]] # get point in this new position
                
                # if no point available, then wrap around
                if(new_pos[1] > R || new_pos[2] > C || new_pos[1] < 1 || new_pos[2] < 1 || is.na(np) || np == ' '){
                    # wrap around if no point available
                    if(cur_dir %in% c("L", "R")){
                        # wrap horizontally
                        new_pos[2] <- Position(function(x) !is.na(x) && x != " ", input[new_pos[1], ], right = cur_dir == 'L') 
                    } else {
                        # wrap vertically
                        new_pos[1] <- Position(function(x) !is.na(x) && x != ' ', input[, new_pos[2]], right = cur_dir == 'U')
                    }
                    np <- input[new_pos[1], new_pos[2]]
                }
                # once wrapped around and next point reached, check if it is '.'
                if(np == '.'){
                    # if free then move
                    k <- k + 1
                    cur_pos <- new_pos
                    next
                } else {
                    stopifnot(np == '#')
                    break
                }
            }       
        }
    }
    
    
    sum(cur_pos * c(1000, 4), facing[cur_dir])
    
}


part1(input, instructions)


# 17475 is incorrect

library(dplyr) # for between


# -1  1  2
# -2  3 -3
#  5  6 -4
#  4 -5 -6
# cubes, positive are present, negative are not
det_cube <- function(pos){
    # row, column
    cr <- pos[1];  cc <- pos[2]
    row_idx <- (cr - 1) %/% 50 + 1
    col_idx <- (cc - 1) %/% 50 + 1
    
    if(between(cr, 1, 200) & between(cc, 1, 150)){
        mat <- matrix(data = c(-1, -2, 5, 4, 
                               1, 3, 6, -5, 
                               2, -3, -4, -6), 4, 3)
        return(mat[row_idx, col_idx])
    } else {
        # go up
        if(cr < 1 && between(cc, 51, 100)) return(-5) # up from 1
        if(cr < 1 && between(cc, 101, 150)) return(-6) # up from 2
        # go left
        if(cc < 1){
            if(between(cr, 101, 150)) return(-4) # left from 5
            if(between(cr, 151, 200)) return(-6) # left from 4
        } 
        # go down
        if(cr > 200){
            if(between(cc, 1, 50)) return(-1) # from 4
        }
        # go right
        if(cc > 150){
            if(between(cr, 1, 50)) return(-1) # from 2
        }
    }
}

wrap <- function(cur_cube, new_cube, new_pos, cur_dir){
        
        if(cur_cube == 1 && new_cube == -1){ # go left from 1, reach 5
            new_pos[2] <- 1
            new_pos[1] <- 151 - new_pos[1]
            cur_dir <- 'R'
        } else if (cur_cube == 1 && new_cube == -5){ # go up from 1, 4
            new_pos[1] <- new_pos[2] + 100
            new_pos[2] <- 1
            cur_dir <- 'R'
        } else if(cur_cube == 2 && new_cube == -1){ # go right from 2, reach 6
            new_pos[1] <- 151 - new_pos[1]
            new_pos[2] <- 100
            cur_dir <- 'L'
        } else if(cur_cube == 2 && new_cube == -6){ # go up from 2, reach 4
            new_pos[1] <- 200
            new_pos[2] <- new_pos[2] - 100
            cur_dir <- 'U'
        } else if(cur_cube == 2 && new_cube == -3){ # go down from 2, reach 3
            new_pos[1] <- new_pos[2] - 50
            new_pos[2] <- 100
            cur_dir <- 'L'
        } else if(cur_cube == 3 && new_cube == -2){ # go left from 3, reach 5
            new_pos[2] <- new_pos[1] - 50
            new_pos[1] <- 101
            cur_dir <- 'D'
        } else if(cur_cube == 3 && new_cube == -3){ # go right from 3, reach 2
            new_pos[2] <- new_pos[1] + 50
            new_pos[1] <- 50
            cur_dir <- 'U'
        } else if(cur_cube == 6 && new_cube == -4){ # go right from 6, reach 2
            new_pos[2] <- 150
            new_pos[1] <- 151 - new_pos[1] 
            cur_dir <- 'L'
        } else if(cur_cube == 6 && new_cube == -5){ # go down from 6, reach 4
            new_pos[1] <- new_pos[2] + 100
            new_pos[2] <- 50
            cur_dir <- 'L'
        } else if(cur_cube == 4 && new_cube == -6){ # go left from 4, reach 1
            new_pos[2] <- new_pos[1] - 100
            new_pos[1] <- 1
            cur_dir <- 'D'
        } else if(cur_cube == 4 && new_cube == -5){ # go right from 4, reach 6
            new_pos[2] <- new_pos[1] - 100
            new_pos[1] <- 150
            cur_dir <- 'U'
        } else if(cur_cube == 4 && new_cube == -1){ # go down from 4, reach 2
            new_pos[2] <- new_pos[2] + 100
            new_pos[1] <- 1
            cur_dir <- 'D'
        } else if(cur_cube == 5 && new_pos[2] < 1){ # go left from 5, reach 1
            new_pos[2] <- 51
            new_pos[1] <- 151 - new_pos[1]
            cur_dir <- 'R'
        } else if(cur_cube == 5 && new_cube == -2){ # go up from 5, reach 3
            new_pos[1] <- new_pos[2] + 50
            new_pos[2] <- 51
            cur_dir <- 'R'
        } 
    return(list(new_pos, cur_dir))
}


part2 <- function(input, instructions){
    
    instrs <- stringr::str_match_all(instructions, "([0-9]+)|([LR])")[[1]][,1]
    # find start position
    for(row in 1:nrow(input)){
        if(all(is.na(input[row,]) & input[row,] == ' ')) {
            next 
        } else {
            col <- which(!is.na(input[row,]) & input[row,] != " ")[1]
            break
        }
    }
    
    
    cur_pos <- c(row, col)
    cur_dir <- 'R'
    R <- nrow(input)
    C <- ncol(input)
    
    # Part 1, Traverse Grid
    for(it in seq_along(instrs)){
        print(it)
        # if(it == 1057) browser()
        ins <- instrs[[it]]
        # turn direction
        if(ins %in% c("L", "R")){
            cur_dir <- new_direction[cur_dir, ins]
        } else {
            # or move
            num <- as.integer(ins)
            
            # move until face block, wrap around if face end
            k <- 1
            while(k <= num){
                new_pos <- cur_pos + directions[[cur_dir]]            # get new position if we move
                np <- input[new_pos[1], new_pos[2]] # get point in this new position
                
                cur_cube <- det_cube(cur_pos)
                new_cube <- det_cube(new_pos)
                # if no point available, then wrap around
                # also change direction!!
                if(cur_cube != new_cube){
                    found <- FALSE
                    while(!found){
                        temp <- wrap(cur_cube, new_cube, new_pos, cur_dir)
                        new_pos <- temp[[1]]
                        np <- input[new_pos[1], new_pos[2]]
                        if(input[new_pos[1], new_pos[2]] == '#') break
                        cur_dir <- temp[[2]]
                        if(is.na(np) || np == ' '){
                            new_pos <- new_pos + directions[[cur_dir]]
                        } else {
                            found <- TRUE
                        }
                        cur_cube <- new_cube
                        new_cube <- det_cube(new_pos)
                    }
                }
                
                # once wrapped around and next point reached, check if it is '.'
                if(np == '.'){
                    # if free then move
                    k <- k + 1
                    cur_pos <- new_pos
                    next
                } else {
                    stopifnot(np == '#' || np == ' ')
                    break
                }
            }       
        }
    }
    
    sum(cur_pos * c(1000, 4), facing[cur_dir])
    
}

part2(input, instructions)
