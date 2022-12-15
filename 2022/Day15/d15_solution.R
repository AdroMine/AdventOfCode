setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# input <- readLines('sample.txt')
input <- readLines('input.txt')
input <- input |> 
    stringr::str_extract_all('[+-]?\\d+') |> 
    lapply(as.integer)

# Part 1 
# target_y <- 10
# Part 1 --------------------
target_y <- 2000000

not_poss <- c()

for(line in input){
    
    sensor_x <- line[1]
    sensor_y <- line[2]
    beacon_x <- line[3]
    beacon_y <- line[4]
    
    d_x <- abs(beacon_x - sensor_x)
    d_y <- abs(beacon_y - sensor_y)
    man_d <- d_x + d_y
    
    dist_to_y <- abs(target_y - sensor_y)
    left <- man_d - dist_to_y
    
    if(left >= 0){
        x_not <- sort(sensor_x - c(-1,1)*left)
        x_not <- seq.int(from = x_not[1], to = x_not[2], by = 1)
        if(beacon_y == target_y)
            x_not <- setdiff(x_not, beacon_x) # if beacon in range, remove it 
        if(sensor_y == target_y)
            x_not <- setdiff(x_not, sensor_x) # if sensor in location, remove it
        not_poss <- union(not_poss, x_not)
    }
}
length(not_poss)

do.call(rbind, input) %>%
    as.data.frame %>%
    dplyr::mutate(man_d = abs(V3 - V1) + abs(V4 - V2),
                  # dist_to_y = abs(target_y - V2),
                  # left = man_d - dist_to_y
                  )


# Part 2 --------------------

# space <- 20

man_distances <- sapply(input, function(x) abs(x[3]-x[1]) + abs(x[4]-x[2]))
sensor_x <- sapply(input, \(x) x[1])
sensor_y <- sapply(input, \(x) x[2])
ord <- order(sensor_x)



unionInterval <- function(p1, p2){
    # subset
    #           x...y      p2
    #        x ......... y p1
    if(p2[1] >= p1[1] && p2[2] <= p1[2]) return(p1)
    
    #        x ......... y p2
    # x.........y          p1
    if(p2[1] >= p1[1] && p2[1] <= p1[2]){
        return(c(p1[1], p2[2]))
    }
    #        x ......... y   p2
    #              x.......y p1
    if(p2[1] <= p1[1] && p1[1] <= p2[2]){
        return(c(p2[1], p1[2]))
    }
}
isOverlap <- function(p1, p2){
    p2[2] >= p1[1] && p2[1] <= p1[1]
}

N <- length(input)

gen_intervals <- function(y, sx, sy, space){
    intervals <- list()
    for(i in 1:N){
        left <- man_distances[i] - abs(y - sy[i])
        if(left >= 0){
            tmp <- c(sx[i]-left, sx[i]+left)
            tmp <- c(max(tmp[1], 0), min(tmp[2], space))
            intervals <- c(intervals, list(tmp))
        }
    }
    intervals
}

merge_intervals <- function(ints){
    
    ints <- ints[order(vapply(ints, \(x) x[1], 1))]
    
    mega_interval <- ints[[1]]
    for(i in 2:length(ints)){
        
        if(mega_interval[2] >= ints[[i]][1]){
            mega_interval[2] <- max(mega_interval[2], ints[[i]][2])
        } else {
            return(mega_interval[2]+1)
        }
    }
    if(mega_interval[1] != 0) return(0) 
    if(mega_interval[2] != space) return(space)
    
    # no solution in this line
    return(-1)
}

space <- 4e6
for(y in 0:space){
    if(!y %% 1e5) print(y)
    
    intervals <- gen_intervals(y, sensor_x, sensor_y, space)
    res <- merge_intervals(intervals)
    if(res == -1) next 
    else {
        print(res * space + y)
        break
    }
}




find_intervals <- function(y, sx, sy, space){
    
    # find all intervals for a given y
    intervals <- list()
    for(i in 1:N){
        left <- man_distances[i] - abs(y - sy[i]) # distance left after reaching y-axis
        if(left < 0){
            next
        } else {
            tmp <- sx[i]+ c(-1L, 1L)*left
            lo <- min(tmp); hi <- max(tmp)
            lo <- max(0, lo); hi <- min(space, hi)
            intervals <- c(intervals, list(c(lo, hi)))
        }
    }
    
    # sort by increasing x-axis
    ord <- order(vapply(intervals, \(x) x[1], 1))
    intervals <- intervals[ord]
    
    N <- length(intervals)
    mega_interval <- intervals[[1]]
    for(i in 2:N){
        if(all(mega_interval == c(0, space))) break
        if(isOverlap(intervals[[i]], mega_interval)){
            mega_interval <- unionInterval(mega_interval, intervals[[i]])
        } else {
            # found solution point!
            print(sprintf("Found Solution x=%d y = %d", mega_interval[2]+1, y))
            return(mega_interval[2]+1)
        }
    }
    if(!all(mega_interval == c(0, space))){
        if(!0 %in% mega_interval) {
            return(0)
        } else if(!space %in% mega_interval){
            return(space)
        } else {
            print("Error! This shouldn't have happened")
            return(-1)
        }
    }
    return(-1)
}

# space <- 20
space <- 4e6
for(y in 0:space){
    if(!y %% 1e5) print(y)
    
    k <- find_intervals(y, sensor_x, sensor_y, space)
    if(k == -1){
        next
    } else {
        print(k*4e6+y)
        break
    }
}



