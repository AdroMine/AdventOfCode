library(fastmatch)
a_star <- function(graph){
    
    
    width <- nrow(graph)
    
    # curr,goal = c(x,y)
    h <- function(curr, goal = c(width, width)) sum(goal - curr) 
        
        
    dist <- matrix(Inf, width, width)
    dist[1,1] <- 0
    
    # for heuristic
    hdist <- matrix(Inf, width, width)
    hdist[1,1] <- h(c(1,1))
    
    # for keeping track of which to visit next
    visits <- matrix(FALSE, width, width)
    visits[1,1] <- TRUE
    
    # fn to give next neighbours (right and down only)
    nxt_possible <- function(xy){
        x <- xy[1]
        y <- xy[2]
        
        list(
            c(x , y + 1),  # right
            c(x + 1, y )  # down
        )
    }
    
    # which next to visit costs least
    min_unvisited <- function(v){
        unvisited <- which(v, arr.ind = TRUE)
        idx <- which.min(hdist[unvisited])
        unvisited[idx,]
    }
    
    
    while(any(visits)){
        
        current <- unname(min_unvisited(visits))
        print(current)
        
        if(all(current == c(width, width)))
            break
        
        visits[current[1], current[2]] <- FALSE
        
        adjacent <- nxt_possible(current)
        for(nbr in adjacent){
            
            x <- nbr[1]
            y <- nbr[2]
            
            if(x > width || y > width || x < 0 || y < 0)
                next
            
            tmp <- dist[current[1], current[2]] + graph[x,y]
            
            if(tmp < dist[x,y]){
                dist[x,y] <- tmp
                hdist[x,y] <- tmp + h(nbr)
                if(!visits[x,y]){
                    visits[x,y] <- TRUE
                }
            }
            
        }
        
    }
    
    dist[width, width]
    
}


# Part 1
a_star(input)



# Part 2

# Expand horizontally
resx <- input
mat <- input
for(i in 1:4){
    mat <- mat + 1
    mat[mat > 9] <- 1
    resx <- cbind(resx, mat)
}
# Expand vertically
mat <- resx
for(i in 1:4){
    mat <- mat + 1
    mat[mat > 9] <- 1
    resx <- rbind(resx, mat)
    
}

a_star(resx)
