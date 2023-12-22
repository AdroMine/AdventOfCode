setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(scipen = 999) # display all digits, no scientific mode

# file_name <- 'sample.txt'
# file_name <- 'sample2.txt'
file_name <- 'input.txt'
W <- nchar(readLines(file_name, n =1))
input <- as.matrix(read.fwf(file_name, widths = rep(1, W), comment.char = ''))


mat <- input

start <- which(mat == 'S', arr.ind = TRUE)[1,]

R <- nrow(mat)
C <- ncol(mat)

# See https://www.youtube.com/watch?v=9UOMZSL0JTg for approach used
bfs <- function(mat, location, steps){
  
  R <- nrow(mat)
  C <- ncol(mat)
  Q <- collections::deque(list(c(location, steps)))
  seen <- matrix(FALSE, R, C)
  ans <- matrix(FALSE, R, C)
  
  while(Q$size() > 0){
    
    cur <- Q$popleft()
    gr <- cur[1]
    gc <- cur[2]
    step <- cur[3]
    
    if(step %% 2 == 0){
      ans[gr, gc] <- TRUE
    }
    
    if(step == 0) next
    
    adjacent <- list(c(gr - 1, gc), c(gr, gc + 1), c(gr+1, gc), c(gr, gc - 1))
    for(nbr in adjacent){
      nr <- nbr[1]
      nc <- nbr[2]
      if(nr < 1 || nc < 1 || nr > R || nc > C ) next
      
      if(mat[nr, nc] == '#') next
      
      if(seen[nr, nc]) next
      
      seen[nr, nc] <- TRUE
      
      Q$push(c(nr, nc, step - 1))
      
    }
    
  }
  sum(ans)
}

# Part 1
bfs(mat, start, 64)


# Part 2

part2_fn <- function(part2_steps){
  
  # Looking at input, source is at middle, that row and column is completely empty, so in 
  # order to go from one grid to next in the infinite universe with repeating grids, we can 
  # just go the edge of the next grid and then travel from there to any point in that grid
  # and we already know the distance in our original grid between different points. 
  
  # Since the width of our grid (131) is odd, so if we take an odd number of steps, we can't 
  # reach our initial position again, but we can reach the initial position in the next grid, 
  # but not in the grid after that. So we can therefore divide grids into odd/even grids. 
  
  # Draw a diagonal/rhombus around the repeating grids, there are grids that are completely
  # reachable given our number of steps, and some that are partially reachable within this
  # diagonal (since we run out of steps to move).
  
  stopifnot(part2_steps %% R == R %/% 2)
  # Thus since we start from the middle of a grid, we can reach exactly the end of some
  # other grid if we keep going in one direction
  
  
  # Number of grids that can be reached in the given number of steps?
  
  grid_width <- part2_steps %/% R - 1 # subtracting one since we are at the middle of original grid
  
  
  # Next we compute the number of odd and even grids
  # the grids that can be reached in odd number of steps and even no of steps
  
  odd_grids <- (grid_width %/% 2 * 2 + 1) ^ 2 # floor to nearest multiple of 2, add 1, square
  even_grids <- ((grid_width + 1) %/% 2 * 2)^2 # ceil to nearest multiple of 2, square
  
  
  # the number of odd points that can be reached in a grid (in odd number of steps)
  # also the no of points that can be reached on an odd grid
  odd_points <- bfs(mat, start, R*2 + 1)
  
  # the number of even points that can be reached in a grid (in even no of steps)
  # also the number of points that can be reached on an even grid
  even_points <- bfs(mat, start, R*2)
  
  
  # So final no of points that can be reached will be:
  # the number of points that can be reached in odd grids
  # odd_grids * odd_points
  
  # plus
  # even_grids * even_points
  
  # Next in the diagonal that we created, for the four corners, there are points that can't
  # be reached in these corner grids since we don't have enough steps remaining
  
  # so let's start at the bottom of this corner grid, in the middle column and see how many
  # points we can reach in grid_size - 1, (since it we would reach the end of the corner
  # grid in complete steps, so at the bottom we will have grid_size - 1 steps remaining,
  # since we took one step to reach the boundary)
  # we do the same then for the other 3 corners. 
  corner_points_top <- bfs(mat, c(R, start[2]), R-1)
  corner_points_right <- bfs(mat, c(start[1], 1), R-1)
  corner_points_left <- bfs(mat, c(start[1], C), R-1)
  corner_points_bottom <- bfs(mat, c(1, start[2]), R-1)
  
  corner_part <- sum(corner_points_top, corner_points_right,
                     corner_points_bottom, corner_points_left)
  
  # now in the diagonal we have the grids that are completely within it, 
  # the 4 corners that are partially
  # and we still have the partial grids within the diagonal, which are of two types
  # see readme for chart, but small green and large blue types of partial
  
  # for the small green, four cases on four sides for top right, to reach this, we go from
  # corner grid middle where we have grid_size - 1 steps remaining, to reach from middle to 
  # end, we need grid_size %/% 2 steps, so after reaching the corner, we have 
  # grid_size %/% 2 - 1 steps remaining
  small_pt_top_right <- bfs(mat, c(R, 1), (R %/% 2) - 1)
  small_pt_bottom_right <- bfs(mat, c(1, 1), (R %/% 2) - 1)
  small_pt_top_left <- bfs(mat, c(R, C), (R %/% 2) - 1)
  small_pt_bottom_left <- bfs(mat, c(1, C), (R %/% 2) - 1)
  
  small_parts <- (grid_width + 1) * sum(small_pt_top_right, small_pt_top_left, 
                                        small_pt_bottom_right, small_pt_bottom_left)
  
  # each of these small segments is observed grid_width + 1 times
  
  # now for the large partial segments, let's move one tile down from top corner tile, 
  # we have therefore 2*grid_size steps remaining
  # and therefore to reach bottom corner of top right big partial grid, we will have
  # 1.5 grid_size - 1 = (3 grid_size) %/% 2 - 1 steps remaining
  
  large_pt_top_right <- bfs(mat, c(R, 1), ((R * 3) %/% 2) - 1)
  large_pt_bottom_right <- bfs(mat, c(1, 1), ((R *3) %/% 2) - 1)
  large_pt_top_left <- bfs(mat, c(R, C), ((R * 3) %/% 2) - 1)
  large_pt_bottom_left <- bfs(mat, c(1, C), ((R * 3) %/% 2) - 1)
  
  # these appear grid_width times
  large_parts <- (grid_width) * sum(large_pt_top_right, large_pt_top_left, 
                                    large_pt_bottom_right, large_pt_bottom_left)
  
  
  part2_ans <- odd_points*odd_grids + even_points*even_grids + corner_part + small_parts + large_parts
  part2_ans
}

part2_fn(26501365)




# Quadratic equation style

# write again to be more generic and find steps in infinite grid
grid_search <- function(mat, start, steps){
  size <- nrow(mat)
  Q    <- collections::deque(list(c(start, 0)))
  seen  <- collections::dict()
  ans  <- collections::dict()
  # ans <- 0
  
  while(Q$size() > 0){
    
    cur <- Q$popleft()
    gr <- cur[1]
    gc <- cur[2]
    step <- cur[3]
    
    if((step %% 2) == (steps %% 2)){
      ans$set(c(gr, gc), TRUE)
      # ans <- ans + 1
    }
    
    if(step > steps) next
    
    adjacent <- list(c(gr - 1, gc), c(gr, gc + 1), c(gr+1, gc), c(gr, gc - 1))
    for(nbr in adjacent){
      nr <- nbr[1]
      nc <- nbr[2]
      
      nrr <- (nr - 1) %% size + 1
      ncc <- (nc - 1) %% size + 1
      if(mat[nrr, ncc] == '#') next
      
      if(seen$has(c(nr, nc))) next
      
      seen$set(c(nr, nc), TRUE)
      
      Q$push(c(nr, nc, step + 1))
    }
  }
  ans$size()
  # ans
}

# grid_search(mat, start, 64)

# find number of steps at grid/2, grid/2 + grid, grid/2 + 2*grid, 
# these are the steps at which we reach the end of grid 1, 2, 3
a1 <- grid_search(mat, start, 65)
a2 <- grid_search(mat, start, 65 + grid_size)
a3 <- grid_search(mat, start, 65 + grid_size*2)

# need to find the line at step n
n <- part2_steps %/% R

# using lagrance interpolation
lagrange <- function(x0, y0) {
  f <- function (x) {
    sum(y0 * sapply(seq_along(x0), \(j) {
      prod(x - x0[-j])/prod(x0[j] - x0[-j])
    }))
  }
  Vectorize(f, "x")
}
lg_fn <- lagrange(0:2, c(a1, a2, a3))
lg_fn(n) # answer


# Using matrix linear equation solver
# solve for quadratic equation using the above 3 points
vandermonde <- matrix(c(0, 0, 1,  # at x = 0 (matrix rows are xi^2 xi 1)
                        1, 1, 1,  # at x = 1
                        4, 2, 1), # at x = 2
                      byrow = TRUE, nrow = 3)

x <- solve(vandermonde, c(a1, a2, a3))

# part 2 answer
x[1] * n^2 + x[2]*n + x[3]

