setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'
W <- nchar(readLines(file_name)[1])
input <- read.fwf(file_name, rep(1, W)) |> as.matrix()
R <- nrow(input); C <- W;

touching <- matrix(-1, R, C)
visited  <- matrix(FALSE, R, C)

regions <- sort(unique(as.vector(input)))

neighbours <- function(cur_pt){
  
  cur_level <- input[cur_pt[1], cur_pt[2]]
  # all 4 directions
  list(
    c(cur_pt[1] - 1L, cur_pt[2]     ), # top
    c(cur_pt[1]     , cur_pt[2] + 1L), # right
    c(cur_pt[1] + 1L, cur_pt[2]     ), # down
    c(cur_pt[1]     , cur_pt[2] - 1L)  # left
  )
}

compute_sides <- function(coords){
  if(nrow(coords) < 3) return(4)
  
  com_cords <- complex(real = coords[,1], imaginary = coords[,2])
  dirs <- list(-1 + 0i, 1i, 1 + 0i, -1i)
  sides <- 0
  for(pt in com_cords){

    for(i in 1:4){
      
      d1 <- dirs[[i]]
      d2 <- dirs[[i %% 4 + 1]]
      np1 <- pt + d1
      np2 <- pt + d2
      np3 <- pt + d1 + d2
      
      if(np1 %in% com_cords && np2 %in% com_cords && !np3 %in% com_cords){
        sides <- sides + 1
      } else if(!np1 %in% com_cords && !np2 %in% com_cords){
        sides <- sides + 1
      } else {
        next
      }
    }    
  }
  
  sides
}


area_perimeter_one <- function(char){
  
  char_pos <- which(input == char, arr.ind = TRUE)
  char_pos_list <- apply(char_pos, 1, \(x) list(x)[[1]], simplify = FALSE)
  seen <- collections::dict(keys = char_pos_list, items = rep(FALSE, length(char_pos_list)))
  
  # find regions first
  price1 <- 0
  price2 <- 0
  for(i in 1:nrow(char_pos)){
    
    cur_pos <- char_pos[i,]
    # if this position is already part of some other region, then move on
    if(seen$get(cur_pos)) next
    seen$set(cur_pos, TRUE)
    
    touching[] <- -1
    
    # flood fill to find region
    Q <- collections::queue()
    Q$push(cur_pos)
    
    while(Q$size() > 0){
      
      cur <- Q$pop()
      touching[cur[1], cur[2]] <- 0
      
      for(nb in neighbours(cur)){
        
        # out of boundary
        if(nb[1] < 1 | nb[1] > R | nb[2] < 1 | nb[2] > C){
          next
        }
        
        # not same character
        if(input[nb[1], nb[2]] != char) next
        
        touching[cur[1], cur[2]] <- touching[cur[1], cur[2]] + 1
        
        if(seen$get(nb)) next
        
        Q$push(nb)
        seen$set(nb, TRUE)
        
      }
      
    }
    
    # found all blocks in the region
    # find perimeter of this region now
    perimeter <- sum(4 - touching[touching != -1])
    area <- sum(touching != -1)
    price1 <- price1 + area * perimeter
    
    # Part 2
    idx <- which(touching != -1, arr.ind = TRUE)
    sides <- compute_sides(idx)
    price2 <- price2 + area * sides
    
  }
  
  c(price1, price2)
  
}


p1 <- 0
p2 <- 0
for(char in regions){
  res <- area_perimeter_one(char)
  p1 <- p1 + res[1]
  p2 <- p2 + res[2]
}

p1
p2

