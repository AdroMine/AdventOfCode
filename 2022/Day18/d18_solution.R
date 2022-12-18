setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)
library(fastmatch)

input <- read.table("input.txt", sep = ",", col.names = c('x', 'y', 'z'))

df_to_row_list <- function(tbl){
    unlist(apply(tbl, 1, \(x) list(as.integer(x))), recursive = FALSE)
}

# @param point - vector of size 3, denoting x,y,z values
# @param xyz - 1/2/3 corresponding to x/y/z coordinate
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

cmax <- c(max(input$x), max(input$y), max(input$z)) + 1L
cmin <- c(min(input$x), min(input$y), min(input$z)) - 1L

# can also use lists, but increasing their size within the loop slows down 
# operations. Compared to dict (takes around 2 secs), lists takes around 7-8 seconds
out <- collections::dict()
not_out <- collections::dict()

is_free <- function(point){
    
    point <- list(point)
    
    if(out$has(point)) return(TRUE)
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
                for(p1 in visited$keys()) out$set(p1, 0)
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




# Method 2 - # Flood fill from outside to inside 
Q <- collections::queue()

# ensure cmin is integer and not numeric, otherwise comparison with points fails
Q$push(cmin)
outside <- collections::dict()
outside$set(cmin, 0)

while(Q$size()){
    
    item <- Q$pop()
    
    for(nxt in neighbours(item)){
        if(list(nxt) %fin% points) next
        if(outside$has(nxt)) next
        if(any(nxt > cmax) || any(nxt < cmin)) next
        
        Q$push(nxt)
        outside$set(nxt, 0)
    }
}

area3 <- 0
for(p in points){
    for(nxt in neighbours(p)){
        if(outside$has(nxt)){
            area3 <- area3 + 1
        }
    }
}

area3

# almost same speed as method 1





















# Part 1 tidyverse style

library(dplyr)
library(tidyr)
input %>% 
    mutate(id =row_number()) %>% 
    tidyr::crossing(one = ., two = rename_with(., ~paste0(., '1'))) %>% 
# tidyr::crossing(one = input, two = rename_with(input, ~paste0(., '1'))) %>% 
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




