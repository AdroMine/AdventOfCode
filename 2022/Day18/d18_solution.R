setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)
library(dplyr)

input <- read.table("input.txt", sep = ",", col.names = c('x', 'y', 'z'))

input <- mutate(input, id = row_number())
library(fastmatch)

df_to_row_list <- function(tbl){
    unlist(apply(tbl[, c('x', 'y', 'z')], 1, \(x) list(as.integer(x))), recursive = FALSE)
}

# @param point - vector of size 3, denoting x,y,z values
get_nbr <- function(point, xyz){
    point1 <- point2 <- point
    point1[xyz] <- point[xyz] + 1L
    point2[xyz] <- point[xyz] - 1L
    return(list(point1, point2))
}

neighbours <- function(point){
    c(get_nbr(point, 1L), get_nbr(point, 2L), get_nbr(point, 3L))
}


points <- df_to_row_list(input)

# Part 1 & 2 

cmax <- c(max(input$x), max(input$y), max(input$z)) + 1
cmin <- c(min(input$x), min(input$y), min(input$z)) - 1

outside <- collections::dict()
not_out <- collections::dict()

is_free <- function(point){
    
    point <- list(point)
    
    if(outside$has(point)) return(TRUE)
    if(not_out$has(point)) return(FALSE)
    
    Q <- collections::queue()
    visited <- collections::dict()
    
    Q$push(point)
    while(Q$size()){
        
        item <- Q$pop()
        if(item %fin% points) next
        
        if(visited$has(item)) next 
        
        
        
        visited$set(item, 0L)
        
        nbrs <- neighbours(item[[1]])
        for(n in nbrs){
            # if we reach outside boundary of box
            # then steam can reach here 
            # through any of the points
            if(any(n > cmax) || any(n < cmin)) {
                # mark all these points as leading to outside
                for(p1 in visited$keys()) outside$set(p1, 0)
                return(TRUE)
            }
            Q$push(list(n))
        }
    }
    # we couldn't reach outside box from above
    # so we can mark all the points visited as those not leading to outside
    for(p1 in visited$keys()) not_out$set(p1, 0)
    FALSE
}

area1 <- 0
area2 <- 0
    
for(i in seq_along(points)){
    
    p <- points[[i]]
    nbrs <- neighbours(p)
    area1 <- area1 + 6 - sum(nbrs %fin% points) # part 1 reduce by adjacent
    area2 <- area2 + sum(sapply(nbrs, is_free)) # part 2 count which can reach out
    
}

area1 # part1 
area2 # part2






# Part 1 tidyverse style
tidyr::crossing(one = input, two = rename_with(input, ~paste0(., '1'))) %>% 
    tidyr::unnest(cols = c(one, two)) %>% 
    filter(id != id1) %>% 
    dplyr::mutate(
        x_cov1 = (x1 == x-1) & (y == y1) & (z == z1), 
        x_cov2 = (x1 == x+1) & (y == y1) & (z == z1), 
        y_cov1 = (y1 == y-1) & (x == x1) & (z == z1), 
        y_cov2 = (y1 == y+1) & (x == x1) & (z == z1), 
        z_cov1 = (z1 == z-1) & (y == y1) & (x == x1), 
        z_cov2 = (z1 == z+1) & (y == y1) & (x == x1) 
    ) %>% 
    group_by(id) %>% 
    summarise(across(c(x_cov1:z_cov2), any), across(c(x, y, z), first)) %>% 
    mutate(area = 6 - x_cov1 - x_cov2 - y_cov1 - y_cov2 - z_cov1 - z_cov2) %>% 
    pull(area) %>% sum




