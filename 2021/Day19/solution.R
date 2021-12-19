setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# Read and Transform input ------------------------------------------------
file_name <- "input.txt"
input <- readLines(file_name)
starts <- grep("--- scanner", input)
ends <- c(starts[-1] - 2, length(input))

scanners <- vector("list", length(starts))

for(i in seq_along(starts)){
    
    sn <- input[(starts[i]+1) : (ends[i])]
    sn <- do.call(rbind, unname(sapply(sn, \(x) as.numeric(strsplit(x, ",")[[1]]), simplify = FALSE)))
    scanners[[i]] <- sn
    
}



# 24 orientations of matrices ---------------------------------------------

rot24 <- function(m){
    
    roll <- function(m) return(cbind(m[,1], m[,3], -m[,2]))
    turn <- function(m) return(cbind(-m[,2], m[,1], m[,3]))
    res <- vector("list", 24)
    i <- 1
    
    for(cycle in 1:2){
        for(step in 1:3){
            m <- roll(m)
            res[[i]] <- m
            i <- i + 1
            for(j in 1:3){
                m <- turn(m)
                res[[i]] <- m
                i <- i + 1
            }
        }
        m <- roll(turn(roll(m)))
    }
    res
}


# find matches ------------------------------------------------------------

og <- scanners[[1]]
beacons <- og
n1 <- nrow(og)
location_scanners <- matrix(NA, length(scanners), 3)
location_scanners[1,] <- c(0, 0, 0)

# generate 24 rotations of each scanner
scanner_rotations <- lapply(scanners, rot24)



# keep doing this until we find location of all scanners
while(anyNA(location_scanners)){
    
    # for each scanner
    for(i in 2:length(scanners)){
        
        # if we already know it's center, ignore
        if(!anyNA(location_scanners[i,])){
            next
        }
        
        # get all 24 rotations for the scanner
        s24 <- scanner_rotations[[i]]
        
        n1 <- nrow(og)
        n2 <- nrow(scanners[[i]])
        
        cat(sprintf("\nScanner:%d ",i))
        
        rotation <- 0
        for(s in s24){
            rotation <- rotation + 1
            # res <- apply(s, 1, \(x) t(t(og) - x), simplify = FALSE)
            
            # for each beacon in s, calculate the difference with each pair in og
            # below takes each row of s (the apply(s, 1, ...))
            # then subtracts it from og (the sweep(...))
            # res is thus a list that contains:
            # res[[1]] = og - s[1,] (this notation leads to errors, since R
            # subtracts column wise) which is why we use sweep
            
            res <- apply(s, 1, \(x) sweep(og, 2, x, '-'), simplify = FALSE)
            
            # combine all these pair wise differences
            # as.data.frame since duplicate on data.frame is faster
            # duplicate on data.table is even faster so using converting to data.table
            res_ <- data.table::as.data.table(do.call(rbind, res))
            
            if(anyDuplicated(res_)){
                
                # if there are duplicates, that means we have found 
                # situations where the same difference repeats
                matches <- unique(res_[duplicated(res_),])
                
                # if there were matches, and more than one
                # then for each match, we need to find the # of common beacons
                for(m in 1:nrow(matches)){
                    
                    match_vals <- as.numeric(matches[m,])
                    
                    cat("match found at rotation: ")
                    cat(rotation)
                    
                    # add the difference to each row of s
                    s <- sweep(s, 2, match_vals, '+')
                    
                    # combine this new 'adjusted' scanner locations with og
                    # and search for duplicates to find matching beacons
                    # below gives TRUE/FALSE, TRUE means duplicate and thus matching beacon
                    found <- duplicated(rbind(og, s))
                    
                    if(sum(found) >= 12){
                        cat(" success!")
                        
                        # duplicated gives the first duplicate idx
                        # since we have s afterwards, we subtract the # of beacons in og
                        locations <- which(found) - n1 
                        
                        # store new scanner location
                        location_scanners[i,] <- match_vals
                        
                        # store scanner orientation
                        scanners[[i]] <- s
                        
                        # add the new beacons not seen by og to matrix of beacons
                        og <- rbind(og, s[-locations,])
                        break
                        
                    } else {
                        next
                    }
                }
            }
        }
    }   
}

nrow(og)


# Part 2
N <- nrow(location_scanners)
mh_combos <- expand.grid(x = 1:N, y = 1:N) %>% 
    dplyr::filter(x != y)

best <- 0
for(i in 1:nrow(mh_combos)){
    a <- location_scanners[mh_combos$x[i],]
    b <- location_scanners[mh_combos$y[i],]
    best <- max(best, sum(abs(a-b)))
}
best
