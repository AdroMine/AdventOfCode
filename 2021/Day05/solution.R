setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in input
input <- readLines("input.txt")

coords_pairs <- lapply(strsplit(input, " -> "), trimws)

coords <- lapply(coords_pairs, function(x) strsplit(x, ","))

n <- max(as.numeric(unlist(coords))) + 1

m <- matrix(0, nrow = n, ncol = n)

overlapping_lines <- function(m, part2 = FALSE){
    
    for(pair in coords_pairs){
        
        start <- as.numeric(strsplit(pair[[1]], ",")[[1]]) + 1 # since index starts at 1
        end   <- as.numeric(strsplit(pair[[2]], ",")[[1]]) + 1
        
        # vertical line (same x)
        if(start[1] == end[1]){
            
            m[seq(start[2], end[2]), start[1]] <- m[seq(start[2], end[2]), start[1]] + 1
            
        } else if(start[2] == end[2]){ 
            # horizontal line
            
            m[start[2], seq(start[1], end[1])] <- m[start[2], seq(start[1], end[1])] + 1
            
        } else {
            
            # part 2 
            if(part2){
                m[cbind(seq(start[2], end[2]), seq(start[1], end[1]))] <- m[cbind(seq(start[2], end[2]), seq(start[1], end[1]))] + 1
            }
        }
    }  
    sum(m >= 2)
}

# part1 
overlapping_lines(m, FALSE)
overlapping_lines(m, TRUE)




# Smaller Code, don't need all if else

overlapping_lines2 <- function(m, part2 = FALSE){
    
    for(pair in coords_pairs){
        
        start <- as.numeric(strsplit(pair[[1]], ",")[[1]]) + 1 # since index starts at 1
        end   <- as.numeric(strsplit(pair[[2]], ",")[[1]]) + 1
        
        if(part2){ # draw for all pairs
            m[cbind(seq(start[2], end[2]), seq(start[1], end[1]))] <- m[cbind(seq(start[2], end[2]), seq(start[1], end[1]))] + 1
        }
        else {     # for part 1, don't consider diagonal lines
            if(start[1] == end[1] || start[2] == end[2])
                m[cbind(seq(start[2], end[2]), seq(start[1], end[1]))] <- m[cbind(seq(start[2], end[2]), seq(start[1], end[1]))] + 1
        }
    }  
    sum(m >= 2)
}


overlapping_lines2(m, FALSE)
overlapping_lines2(m, TRUE)