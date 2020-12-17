setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines("input.txt")
input <- chartr(".#", "01", input)

input <- stringr::str_split_fixed(input, "", Inf)
mode(input) <- "integer"
n <- max(dim(input))
# one extra unit increase each round + 1 padding
grid_size <- 2*(6 + 2) + n

pocket <- array(0L, dim = rep(grid_size, 4))

start <- (grid_size %/% 2 - n/2)
k <- start : (start + n-1)
# Part 1
# store at middle
pocket[k, k, start, start] <- input

# ind <- 2:(grid_size - 1)

for(i in 1:6){
    ind <- seq(start - i, start + n-1 + i)
    updated <- pocket
    for(x in ind){
        for(y in ind){
            for(z in ind){
                # part 2
                for(w in ind){
                    pt <- pocket[x, y ,z, w]
                    neighbours <- sum(pocket[x + (-1L:1L),
                                             y + (-1L:1L),
                                             z + (-1L:1L),
                                             w + (-1L:1L)
                                             ]) - pt
                    if(pt == 1 && !(neighbours %in% c(2,3))){
                        updated[x, y, z, w] <- 0L
                    } else if(pt == 0 && neighbours == 3){
                        updated[x, y, z, w] <- 1L
                    }
                }
            }
        }
    }
    pocket <- updated
}
sum(pocket)
