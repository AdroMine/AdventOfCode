setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in input
file_name <- "sample.txt"
file_name <- "input.txt"
width <- nchar(readLines(file_name, n = 1))

input <- as.matrix(read.fwf(file_name, widths = rep(1, width)))

row <- nrow(input)
col <- ncol(input)

mat <- matrix(NA_integer_, nrow = row + 2, ncol = col + 2)

mat[ 2:(row+1)  , 2:(col+1) ] <- input
mat[mat == 9] <- NA
mode(mat) <- "integer"


# generate next candidates (up, left, down, right)
# and return their coordinates and values
next_candidates <- function(x){
    r <- x[1]
    c <- x[2]
    
    candidates <- list(
        c(r-1, c), # left
        c(r+1, c), # right
        c(r, c-1), # up
        c(r, c+1)  # down
    )
    
    # extract vals
    cands <- sapply(candidates, function(x) mat[x[1], x[2]])
    
    # remove NAs
    non_na <- which(!is.na(cands))
    
    # return coordinates of non-NA candidates
    list(
        coords = candidates[non_na],
        vals   = cands[non_na]
    )
}

ans1 <- 0
basins <- vector("list", 300)
b <- 1
for(i in 2:(row + 1)){
    for(j in 2:(col + 1)){
        
        if(is.na(mat[i,j])){
            next
        }
            
        candidates <- next_candidates(c(i,j))
        
        vals <- candidates$vals
        
        pt <- mat[i, j]
        
        if(all((vals - pt) > 0)){
            # found low point!
            # cat(sprintf("x = %d, y = %d ; ", i-1, j-1))
            
            ans1 <- ans1 + pt + 1
            
            # Determine basin
            
            # create empty list of coordinates that will form basin
            bsn <- vector("list", 300)
            ii <- 1  # index for bsn
            
            # add low point to basin
            bsn[[ii]] <- as.numeric(c(i,j))    # i,j is integer, causes issues in identification
            ii <- ii + 1
            
            candidates <- candidates$coords
            
            # until there are no candidates left to be looked at
            while(length(candidates)){
                
                # pop one
                cd <- candidates[[1]]
                candidates <- candidates[-1]
                
                # add to basin if not in it
                if(!list(cd) %in% bsn){
                    bsn[[ii]] <- cd
                    ii <- ii + 1
                }
                
                # generate next possible candidates that have not been added to basin already
                nxt_cands <- setdiff(next_candidates(cd)$coords, bsn[1:ii])
                candidates <- union(candidates, nxt_cands)
                
            }
            
            # add to master basin list
            basins[[b]] <- bsn[1:(ii-1)]
            b <- b + 1
        }
    }
}

# Part 1
ans1

# Part 2
lens <- sapply(basins[1:(b-1)], length)         # get count of items in each basin
prod(lens[order(lens, decreasing = TRUE)][1:3]) # get product of largest 3
