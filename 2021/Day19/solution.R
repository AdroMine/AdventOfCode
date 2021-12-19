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

# roll <- function(m) return(c(m[1], m[3], -m[2]))
roll <- function(m) return(cbind(m[,1], m[,3], -m[,2]))

# turn <- function(m) return(c(-m[2], m[1], m[3]))
turn <- function(m) return(cbind(-m[,2], m[,1], m[,3]))

rot24 <- function(m){
    
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

# keep doing this until we find location of all scanners
while(anyNA(location_scanners)){
    
    for(i in 2:length(scanners)){
        
        if(!anyNA(location_scanners[i,])){
            next
        }
        
        s24 <- rot24(scanners[[i]])
        n2 <- nrow(scanners[[i]])
        n1 <- nrow(og)
        cat(sprintf("\nScanner:%d",i))
        rotation <- 0
        for(s in s24){
            rotation <- rotation + 1
            res <- vector("list", n2)
            
            # for each beacon in s, calculate the difference from 
            # every beacon in scanner 0 [og]
            for(ii in 1:n2){
                res[[ii]] <- vector("list", n1)
                for(jj in 1:n1){
                    res[[ii]][[jj]] <- og[jj,] - s[ii,]
                }
            }
            
            # intersections
            combos <- combn(n2, 2)
            # combos <- gtools::permutations(n2, 2)
            
            matches <- apply(combos, 2, simplify = FALSE, \(x) {
                rr <- x[1]
                cc <- x[2]
                intersect(res[[ rr ]], res[[ cc ]])
            })
            
            matches <- unique(unlist(matches, recursive = FALSE))
            
            if(length(matches) > 0){
                cat("match found at rotation:")
                cat(rotation)
                for(match_vals in matches){
                    # match_vals <- matches[[1]]
                    locations <- c()
                    
                    found <- 0
                    for(pt in 1:n2){
                        idx <- which(sapply(res[[pt]], \(x) all(x == match_vals)))
                        if(length(idx) > 0){
                            found <- found + 1
                            locations <- c(locations, pt)
                        }
                    }
                    
                    if(found >= 12){
                        cat(" success!")
                        
                        # find which point matches which
                        location_scanners[i,] <- match_vals
                        s <- t(t(s) + match_vals)
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
