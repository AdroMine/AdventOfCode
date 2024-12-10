setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)
library(fastmatch)

# in_file <- 'sample.txt'
in_file <- 'input.txt'

width <- nchar(readLines(in_file,n= 1))
input <- read.fwf(in_file, widths = rep(1, width), comment.char = '')

elves <- which(input == '#', arr.ind = TRUE)
elves <- as.list(complex(real = elves[,1], imaginary = elves[,2]))

get_nbrs <- function(x){
    
    nbr <- c(
        N  = -1 + 0i, 
        NW = -1 - 1i, 
        NE = -1 + 1i, 
        S  = 1 + 0i, 
        SE = 1 + 1i, 
        SW = 1 - 1i, 
        E  = 0 + 1i, 
        W  = 0 - 1i
    )
    x + nbr
    # list(
    #     N  = c(r - 1L, c),     
    #     NW = c(r - 1L, c - 1L),
    #     NE = c(r - 1L, c + 1L),
    #     S  = c(r + 1L, c),     
    #     SE = c(r + 1L, c + 1L),
    #     SW = c(r + 1L, c - 1L),
    #      E = c(r     , c + 1L),
    #      W = c(r     , c - 1L) 
    # )
}

print_grid <- function(grid, padding, centering = 5){
    x_r <- max(Re(grid)) + padding + centering
    y_r <- max(Im(grid)) + padding + centering
    m <- matrix('.', nrow = x_r, ncol = y_r)
    for(pt in grid){
        m[Re(pt) + centering, Im(pt) + centering] <- '#'
    }
    for(i in seq_len(nrow(m))){
        cat(paste(m[i,], collapse = ""), '\n')
    }
}

empty_count <- function(elves){
    x_range <- range(Re(elves))
    y_range <- range(Im(elves))
    
    ans <- 0
    for(x in seq.int(x_range[1], x_range[2])){
        for(y in seq.int(y_range[1], y_range[2])){
            if(!complex(real = x, imaginary = y) %in% elves) ans <- ans + 1
        }
    }
    ans
}

directions <- list(
    N = c("N", 'NE', 'NW'), 
    S = c('S', 'SE', 'SW'), 
    W = c('W', 'NW', 'SW'), 
    E = c('E', 'NE', 'SE')
)

rnd <- 0L
while(TRUE){
# for(rnd in seq_len(21)){
    
    rnd <- rnd + 1L
    cat('Round', rnd, '\n')
    new_elves <- lapply(seq_along(elves), function(i){
        
        pt <- elves[[i]]
        nbrs <- get_nbrs(pt)
        common <- setNames(nbrs %fin% elves, names(nbrs))
        if(!any(common)){
            # no other elves, do nothing, current point remains
            pt
        } else {
            # elves are present, move acc to below
            
            dirs <- (rnd:(rnd + 3) - 1) %% 4 + 1
            movs <- names(directions)[dirs]
            if (!any(common[directions[[dirs[1]]]])){
                nbrs[[movs[1]]]
            } else if (!any(common[directions[[dirs[2]]]])){
                nbrs[[movs[2]]]
            } else if (!any(common[directions[[dirs[3]]]])){
                nbrs[[movs[3]]]
            } else if (!any(common[directions[[dirs[4]]]])){
                nbrs[[movs[4]]]
            } else {
                pt # can't move anywhere, so stay
            }
        }
    })
    
    new_elves <- unlist(new_elves)
    if(identical(unlist(elves), new_elves)) break
    
    # deal with duplicate movements
    for(i in which(duplicated(new_elves))){
        dups <- which(new_elves[i] == new_elves)
        new_elves[dups] <- unlist(elves[dups])
    }
    elves <- as.list(new_elves)
    if(rnd == 10){
        print(empty_count(new_elves))
    }
}

rnd 



# Second style using hashtab 
# only slightly faster

h <- hashtab(size = length(elves))
for(e in elves) sethash(h, e, TRUE)

rnd <- 0L
while(TRUE){
# for(rnd in seq_len(21)){
    
    rnd <- rnd + 1L
    cat('Round', rnd, '\n')
    new_elves <- lapply(seq_along(elves), function(i){
        
        pt <- elves[[i]]
        nbrs <- get_nbrs(pt)
        common <- vapply(nbrs, \(x) gethash(h, x, FALSE), TRUE) # this is the main bottleneck
        if(!any(common)){
            pt  # no other elves, don't move
        } else {
            # elves are present, move acc to below
            dirs <- (rnd:(rnd + 3) - 1) %% 4 + 1
            movs <- names(directions)[dirs]

            if (!any(common[directions[[dirs[1]]]])){
                nbrs[[movs[1]]]
            } else if (!any(common[directions[[dirs[2]]]])){
                nbrs[[movs[2]]]
            } else if (!any(common[directions[[dirs[3]]]])){
                nbrs[[movs[3]]]
            } else if (!any(common[directions[[dirs[4]]]])){
                nbrs[[movs[4]]]
            } else {
                pt # can't move anywhere, so stay
            }
        }
    })
    
    new_elves <- unlist(new_elves)
    if(identical(unlist(elves), new_elves)) break
    
    # deal with duplicate movements
    for(i in which(duplicated(new_elves))){
        dups <- which(new_elves[i] == new_elves)
        new_elves[dups] <- unlist(elves[dups])
    }
    elves <- as.list(new_elves)
    if(rnd == 10){
        print(empty_count(new_elves))
    }
    clrhash(h)
    for(e in elves) sethash(h, e, TRUE)
}