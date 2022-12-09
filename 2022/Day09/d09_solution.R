setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# input <- read.table("sample.txt")
input <- read.table("input.txt")

movements <- c(
  'U' = 0 - 1i, 'D' =  0 + 1i, 
  'R' = 1 + 0i, 'L' = -1 + 0i
)
one_diag_dist <- Mod(1 + 1i)

#' @param knots number of knots in rope (does not include head)
#' @param directions data.frame two columns, first is direction, second is
#'   movement steps
simulate_rope <- function(directions, knots = 1){
  
  stopifnot(knots >= 1)
  
  N <- knots + 1
  points <- rep(0 + 0i, N)
  visits <- c(0 + 0i)
  for(i in seq_len(nrow(input))){
    
    dir <- input[[1]][i]
    mov <- input[[2]][i]
    
    # move head and tail, one step at a time
    
    for(j in seq_len(mov)){
      # move head
      points[1] <- points[1] + unname(movements[dir])
      
      # move the other knots
      for(k in 2:N){
        
        # find difference of this knot from previous knot
        dif <- points[k - 1] - points[k]
        
        # if more than one step away
        while(abs(dif) > one_diag_dist){
          x <- Re(dif) # difference along x axis
          y <- Im(dif) # difference along y axis
          
          points[k] <- points[k] + sign(x)
          points[k] <- points[k] + sign(y)*1i
          
          # for last knot, store visited points
          if(k == N) visits <- c(visits, points[N])
          dif <- points[k - 1] - points[k]
        }  
      }
    }
  }
  length(unique(visits))
}

# Part 1
simulate_rope(input, 1)
simulate_rope(input, 9)
