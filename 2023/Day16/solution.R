setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file_name <- 'sampl2.txt'
file_name <- 'input.txt'
W <- nchar(readLines(file_name, n = 1))
input <- as.matrix(read.fwf(file_name, widths = rep(1, W)))
mat <- input

movements <- list(
  'r' = c(0, 1), 
  'l' = c(0, -1), 
  'u' = c(-1, 0), 
  'd' = c(1, 0)
)
opposite_dir <- list('r' = 'l', 'u' = 'd', 'd' = 'u', 'l' = 'r')
# reflectors coordinates
reflector_coords <- which(input != '.', arr.ind = TRUE) |> apply(1, paste0, collapse = ':')

lava_energy <- function(start, dir){
  
  energised <- matrix(0L, nrow = nrow(input), ncol = ncol(input))
  # have we visited this reflector while coming from the same direction before?
  visited <- setNames(vector('list', length(reflector_coords)), reflector_coords)
  
  browse_mat <- function(cur_pos = c(1,1), dir = c('r', 'u', 'd', 'l')) {
    
    # while the beams can keep moving
    while(TRUE) {
      nxt_pos <- cur_pos + movements[[dir]]
      if(nxt_pos[1] < 1 || nxt_pos[1] > nrow(mat) || 
         nxt_pos[2] < 1 || nxt_pos[2] > ncol(mat)) break
      
      energised[nxt_pos[1], nxt_pos[2]] <<- 1L
      nxt_char <- mat[nxt_pos[1], nxt_pos[2]]
      
      if(nxt_char != '.') {
        id <- paste0(nxt_pos, collapse = ':')
        
        # already visited this reflector coming from the same direction, so we know where
        # this will go
        if(dir %in% visited[[id]]){
          break
        } else {
          visited[[id]] <<- c(visited[[id]], dir) #, opposite_dir[[dir]])
          # when splitting visiting from either direction is same
          if(nxt_char == '|' && dir %in% c('l', 'r')){
            visited[[id]] <<- c(visited[[id]], opposite_dir[[dir]]) 
          }
          if(nxt_char == '-' && dir %in% c('u', 'd')){
            visited[[id]] <<- c(visited[[id]], opposite_dir[[dir]]) 
          }
          
        }
      }
      
      cur_pos <- nxt_pos
      # find next direction
      if(nxt_char == '.') {
        next
      } else if(nxt_char == '\\') {
        dir <- switch(dir, 
                      'r' = 'd', 
                      'l' = 'u', 
                      'u' = 'l', 
                      'd' = 'r')
      } else if (nxt_char == '/') {
        dir <- switch(dir, 
                      'r' = 'u', 
                      'l' = 'd', 
                      'u' = 'r', 
                      'd' = 'l')
      } else if (nxt_char == '-' && dir %in% c('l', 'r')) {
        dir <- dir
      } else if (nxt_char == '|' && dir %in% c('u', 'd')) {
        dir <- dir
      } else if (nxt_char == '|' && dir %in% c('l', 'r')) {
        # split
        Recall(nxt_pos, dir = 'u')
        Recall(nxt_pos, dir = 'd')
        break
      } else if (nxt_char == '-' && dir %in% c('u', 'd')) {
        # split
        Recall(nxt_pos, dir = 'l')
        Recall(nxt_pos, dir = 'r')
        break
      }
    }
  }

  # debug(browse_mat)
  browse_mat(start, dir)
  
  sum(energised)
  
}

# Part 1
lava_energy(c(1,0), 'r')

# Part 2

R <- nrow(input)
C <- ncol(input)
p2 <- 0
for(i in 1:R){
  print(i)
  p2 <- max(p2, lava_energy(c(i, 0)  , 'r')) # from left
  p2 <- max(p2, lava_energy(c(i, C+1), 'l')) # from left
}

for(i in 1:C){
  print(i)
  p2 <- max(p2, lava_energy(c(0, i)  , 'd')) # from left
  p2 <- max(p2, lava_energy(c(R+1, i), 'u')) # from left
}

p2



