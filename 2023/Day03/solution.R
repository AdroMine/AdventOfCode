
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
width <- readLines(file_name, n = 1) |> nchar()

input <- as.matrix(read.fwf(file_name, widths = rep(1, width), comment.char = ''))

mat <- rbind('.', cbind('.', input, '.'), '.')
  

R <- nrow(input)
C <- ncol(input)

nums <- as.character(0:9)

x <- 2; 
p1 <- 0
found <- c()
star_numbers <- list()
while(x <= R+1) {
  y <- 2
  while(y <= C+1) {
    
    if(!mat[x,y] %in% nums){
      y <- y+1
      next
    }
    
    end_y <- y
    while(mat[x,end_y] %in% nums){
      end_y <- end_y + 1
      if(end_y > C+1) break
    }
    
    nbrs <- mat[x + (-1:1), (y-1):(end_y)]
    if (length(grep("\\d|\\.", nbrs, invert = TRUE)) > 0) {
      n <- as.numeric(paste0(mat[x, y:(end_y-1)], collapse = ''))
      found <- c(found, n)
      p1 <- p1 + n
      
      star_location <- which(nbrs == '*', arr.ind = TRUE)
      if(length(star_location) > 1){
        for(i in seq_along(nrow(star_location))){
          star_x <- x + (star_location[i, 1] - 2) # since nbrs is from x-1
          star_y <- y + (star_location[i, 2] - 2) # since nbrs is from y-1
          star_numbers[[paste0(star_x, ':', star_y)]] <- c(
            star_numbers[[paste0(star_x, ':', star_y)]], 
            n
          )
        }
      }
    }
    y <- end_y
  }
  x <- x+1
}

# Part 1
p1

# Part 2
Filter(\(x) length(x) == 2, star_numbers) |> 
  sapply(prod) |> 
  sum()
