setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(purrr)
library(collections)
# Read and Transform input ------------------------------------------------
file_name <- "input.txt"

get_input <- function(file_name){
    width <- nchar(readLines(file_name, n = 1)[1])
    input <- read.fwf(file_name, widths = rep(1, width), comment.char = "", skip = 1)[-c(1, width)]
    input[is.na(input)] <- " "
    names(input) <- paste0("V", 1:ncol(input))
    input
}



#  Functions --------------------------------------------------------------
col_positions <- c(A = 3, B = 5, C = 7, D = 9)



# given a grid and start and end position, is moving possible
solve <- function(input, row_positions = c(2,3)){
    
    final_state <- function(grid){
        
        a_reach <- setequal("A", grid[row_positions, col_positions['A']])
        b_reach <- setequal("B", grid[row_positions, col_positions['B']])
        c_reach <- setequal("C", grid[row_positions, col_positions['C']])
        d_reach <- setequal("D", grid[row_positions, col_positions['D']])
        
        a_reach && b_reach && c_reach && d_reach
        
    }
    
    path_possible <- function(grid, start, end, pt){
        
        r1 <- start[1]
        c1 <- start[2]
        r2 <- end[1]
        c2 <- end[2]
        
        # can't move within hall
        if(r1 == 1 && r2 == 1){
            return(FALSE)
        }
        
        # end position is occupied
        if(grid[r2,c2] != ".")
            return(FALSE)
        
        # can't move to just outside any room; this shouldn't be necessary anymore
        if(r2 == 1 && c2 %in% col_positions)
            return(FALSE)
        
        # cannot move to other's rooms
        if(r2 %in% row_positions && c2 != col_positions[pt])
            return(FALSE)
        
        
        # path in hallway blocked
        if(r1 == 1 || r2 == 1){
            ## moving right
            if(c2 > c1){
                if(any(grid[1, (c1+1):c2] != "."))
                    return(FALSE)
            } else {
                ## moving left 
                if(any(grid[1, (c1 - 1):c2] != "."))
                    return(FALSE)
            }
        }
        
        # can't move if any other amphipod occupying room
        if(r2 %in% row_positions && c2 %in% col_positions[pt] && any(grid[row_positions, col_positions[pt]] %in% setdiff(LETTERS[1:4], pt))){
            return(FALSE)
        }
        
        # anything in path blocking above to hall
        if(r1 %in% row_positions && any(grid[(r1-1):1, c1] != "."))
            return(FALSE)
        
        # if moving from room to room, check all columns in hallway for block
        if(r1 %in% row_positions && r2 %in% row_positions){
            return(all(grid[1, c1:c2] == "."))
        }
        
        # possible to move
        return(TRUE)
    }
    
    can_move <- function(grid, loc, pt){
        
        r1 <- loc[1]
        c1 <- loc[2]
        cp <- col_positions[pt]
        
        # if in hall, can only move if it's room has an empty top
        # and no one else in its room
        if(r1 == 1){
            # open path
            if(!all(grid[row_positions, cp] %in% c(pt, "."))){
                return(FALSE)
            }
            
            # hallway not blocked
            c2 <- col_positions[pt]
            if(c1 < c2){
                cond3 <- all(grid[1, (c1 + 1): c2] == ".")
            } else {
                cond3 <- all(grid[1, (c1 - 1): c2] == ".")
            }
            
            return(cond3)
        }
        
        # if in room, can only move if no one above it
        if(grid[r1-1, c1] != ".")
            return(FALSE)
        
        return(TRUE)
        
    }
    
    move_cost <- function(start, end, pt){
        
        cost <- setNames(10^seq(0, 3), LETTERS[1:4])
        r1 <- start[1];  r2 <- end[1]
        c1 <- start[2];  c2 <- end[2]
        
        # dist <- abs(r2 - r1) + abs(c2 - c1)
        
        # move from hall to room or vice-versa
        if(r1 == 1 || r2 == 1){
            dist <- abs(r2 - r1 ) + abs(c2 - c1 )
        }  else {
            
            # moving from room to room
            # dist <- abs(r1 - 1 + r2 - 1) + abs(c2 - c1 + 1)
            dist <- abs(r1 + r2 - 2) + abs(c2 - c1 )
        }
        
        return(unname(dist * cost[pt]))
    }
    
    free_room <- function(grid, pt){
        vals <- grid[row_positions, col_positions[pt]]
        if(any(vals %in% setdiff(LETTERS[1:4], pt))) 
            return(NA)
        res <- Position(function(x) x == ".", vals, right = TRUE, nomatch = NA)
        if(!is.na(res)) res <- c(row_positions[res], col_positions[pt])
        res
    }
    
    at_dest <- function(loc, pt){
        (loc[1] %in% row_positions && loc[2] == col_positions[pt])
    }
    
    
    
    bottom_locs <- expand.grid(row_positions, unname(col_positions))
    
    cache <- dict()
    count <- 0
    min_path <- function(grid){
        
        if(final_state(grid)){
            count <<- count + 1
            print(count)
            return(0)
        }
        
        
        # cache memoization
        if(cache$has(grid)){ return(cache$get(grid)) }
        
        # anything that can be moved to destination?
        non_empty_top <- which(grid[1,] != ".")
        for(i in non_empty_top){
            
            pt <- grid[1, i]
            cur <- c(1, i)
            
            poss <- free_room(grid, pt)
            if(!is.na(poss) && path_possible(grid, cur, poss, pt)){
                new_grid <- grid
                new_grid[cur[1], cur[2]] <- "."
                new_grid[poss[1], poss[2]] <- pt
                cost <- move_cost(cur, poss, pt)
                return(cost + Recall(new_grid))
            }
        }
        
        cost <- Inf
        # direct destination not possible, let's try moving to hallway
        for(i in 1:nrow(bottom_locs)){
            cur <- as.integer(bottom_locs[i,])
            
            pt <- grid[cur[1], cur[2]]
            if(pt == ".") next
            
            if(at_dest(cur, pt)) next
            if(!can_move(grid, cur, pt)) next
            
            # search for empty positions in hallway
            # any empty position in rooms if possible to fill
            # will already have been filled
            empty_pts <- which(grid[1,] == ".")
            empty_pts <- setdiff(empty_pts, col_positions)
            
            if(length(empty_pts) == 0) next
            
            poss_paths <- which(
                # sapply(empty_pts, \(x) path_possible(grid, cur, c(1,x) ,pt))
                vapply(empty_pts, \(x) path_possible(grid, cur, c(1,x) ,pt), FUN.VALUE = TRUE)
            )
            
            for(p in empty_pts[poss_paths]){
                
                end <- c(1, p)
                
                # keep solving until we reach finish state
                # or we can't take any more steps
                new_grid <- grid
                new_grid[cur[1], cur[2]] <- "."
                new_grid[end[1], end[2]] <- pt
                mcost <- move_cost(cur, end, pt)
                cost <- min(cost, mcost + Recall(new_grid))
                print(paste0("x - ", count))
            }
        }
        cache$set(grid, cost)
        # print(cost)
        cost
    }
    print(min_path(input))
}

solve(get_input("input.txt"), c(2,3))

# Part 2
input2 <- get_input("input2.txt")
row_positions <- c(2,3, 4, 5)

bottom_locs <- expand.grid(row_positions, unname(col_positions))
cache <- dict()
count <- 0

solve(input2)
