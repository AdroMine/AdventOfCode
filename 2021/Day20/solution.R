setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# Read and Transform input ------------------------------------------------
file_name <- "input.txt"
algo <- readLines(file_name, n = 1) %>% 
    strsplit("") %>% `[[`(1)
width <- readLines(file_name, n = 3) %>% 
    `[`(3) %>% nchar

input <- read.fwf(file_name, widths = rep(1, width), skip = 2, comment.char = "")

# function to make (x,y) -> ("x#y#") (string rep)
add_c <- function(xy) {
    paste0('x', xy[1], 'y',xy[2])
}

grid <- new.env()

for(i in 1:nrow(input)){
    for(j in 1:ncol(input)){
        assign(add_c( c(j,i) ), value = input[i,j], envir = grid)
    }
}

# Helper functions --------------------------------------------------------



neighbours <- function(x,y){
    nbrs <- list(
        c(x-1,y-1), 
        c(x,y-1),
        c(x+1, y-1), 
        c(x-1, y), 
        c(x, y), 
        c(x + 1, y), 
        c(x - 1, y + 1), 
        c(x, y+ 1), 
        c(x + 1, y + 1)
    )
    unlist(lapply(nbrs, add_c), recursive = FALSE, use.names = FALSE)
}



get_grid_val <- function(nm, e, step = 1){
    if(step %% 2){
        if(exists(nm, envir = e)) get(nm, envir = e) else '.'
    } else {
        if(exists(nm, envir = e)) get(nm, envir = e) else '#'
    }
}

enhance <- function(g,step = 1){
    
    # get all current points in grid
    pts <- ls(g)
    
    pts <- stringi::stri_match(pts, regex = "x(-?\\d+)y(-?\\d+)")[,-1]
    mode(pts) <- "integer"
    
    min_x <- min(pts[,1]) - 1
    max_x <- max(pts[,1]) + 1
    min_y <- min(pts[,2]) - 1
    max_y <- max(pts[,2]) + 1
    
    # add all extra points at boundary (one ahead)
    # min_x - 1, for all y [min_y - 1, max_y + 1]
    # max_x - 1, for all y [min_y - 1, max_y + 1]
    # similarly for y
    # [min_x - 1, max_x + 1] , min_y - 1
    # [min_x - 1, max_x + 1] , max_y + 1
    left_right <- expand.grid(x = c(min_x, max_x), 
                              y = seq(min_y, max_y))
    up_down <- expand.grid(x = seq(min_x+1, max_x - 1), 
                           y = c(min_y, max_y))
    pts <- rbind(pts, 
                 as.matrix(rbind(left_right, up_down)
                 ))
    
    
    # create new grid
    # clone works as below, otherwise new_g <- g leads
    # to new_g pointing to the same g
    new_g <- list2env(as.list(g))
    
    for(i in 1:nrow(pts)){
        
        x <- pts[i, 1]
        y <- pts[i, 2]
        nbrs <- neighbours(x,y)
        val <- paste0(sapply(nbrs, get_grid_val, g, step = step), collapse = "")
        num <- strtoi(chartr("#.","10", x = val), 2)
        stopifnot(!is.na(num))
        replacement <- algo[num + 1]
        assign(add_c( c(x,y)), value = replacement, envir = new_g)
    }
    
    new_g
}

for(step in 1:50){
    print(step)
    grid <- enhance(grid, step)
    
}

table(unlist(as.list(grid)), useNA = "always")
      
print_grid <- function(g, a = '#', b = '.'){
    pts <- ls(g)
    
    pts <- stringi::stri_match(pts, regex = "x(-?\\d+)y(-?\\d+)")[,-1]
    mode(pts) <- "integer"
    
    dimx <- max(pts[,1]) - min(pts[,1]) + 1
    dimy <- max(pts[,2]) - min(pts[,2]) + 1
    
    min_x <- min(pts[,1])
    min_y <- min(pts[,2])
    adj_x <- if(min_x <= 0) 0 - min_x + 1 else 0
    adj_y <- if(min_y <= 0) 0 - min_y + 1 else 0
    
    
    mat <- matrix(NA, nrow = dimy, ncol = dimx)
    
    for(i in 1:nrow(pts)){
        
        x <- pts[i, 1]
        y <- pts[i, 2]
        val <- get_grid_val(add_c(pts[i,]), e = g)
        mat[y + adj_y,x + adj_x] <- val
    }
    
    mat[mat == '#'] <- a
    mat[mat == '.'] <- b
    # mat
    for(i in 1:nrow(mat)){
        cat(paste0(mat[i,], collapse = ""))
        cat("\n")
    }
}

print_grid(grid, '')

