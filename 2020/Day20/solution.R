setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(stringr)
library(purrr)
library(dplyr)
input <- readLines("input.txt")

start <- grep("^Tile", input)

tiles <- map(start, function(x) str_split_fixed(input[(x + 1): (x + 10)], "", Inf))
names(tiles) <- str_extract(input[start], "\\d+")

nghbrs <- matrix(rep(c( NA,    NA,     NA,      NA,     NA,     NA,     NA,     NA), length(tiles)), nrow = length(tiles))
colnames(nghbrs) <- c("left", "lrev", "up", "urev", "right", "rrev", "down", "drev")

# CONSTANTS
E <- 10  # edge length
C <- R <- sqrt(length(tiles))

get_sides <- function(tile){
    l <- tile[  ,1] ; r <- tile[  ,E]
    u <- tile[1,  ] ; d <- tile[E,  ]
    unlist(lapply(list(l, u, r, d), 
                  function(x) c(paste(x, collapse = ""), 
                                paste(rev(x), collapse = ""))))
}

# Do two tiles match
matcher <- function(i, j){
    t1 <- tiles[[i]]
    t2 <- tiles[[j]]
    
    t1s <- get_sides(t1)
    t2s <- get_sides(t2)[c(1, 3, 5, 7)]
    
    any(outer(t1s, t2s, function(x,y) x == y))  # any matches between all sides
}

# Determine which tiles matches which tile
mtch <- expand.grid(i = 1:length(tiles), j = 1:length(tiles)) %>% filter(i!=j)
mtch$match <- apply(mtch, 1, function(x) matcher(x[1], x[2]))

# `nghbrs` becomes a list desribing which tile has which members 
# tile[[x]] = adjacent tile ids
nghbrs <- mtch %>% 
    mutate(j = ifelse(match, j, -1)) %>% filter(j != -1) %>% 
    group_by(i) %>% summarise(match = list(j)) %>%
    deframe()

# Part 1 Ans
corners <- which(lapply(nghbrs, length) == 2)
print(prod(as.numeric(names(tiles)[corners])), 22)

# Join Image

# start with empty board and let top left corner be any corner, we can rotate board so that it is the top left
board <- new.env()
board$g <- matrix(NA, sqrt(length(tiles)), sqrt(length(tiles)))
board$g[1, 1] <- current <- corners[1]

nxt <- nghbrs[current][[1]]
board$g[1,2] <- nxt[1]         # place tiles adjacent to corner to random adjacent cells
board$g[2,1] <- nxt[2]         # (it's all symmetric if you flip it around)

# list of possible adjacent cell coordinates for any tile
adjacent <- list(c(0,1), c(1,0), c(-1, 0), c(0,-1))
bR <- nrow(board$g)
bC <- ncol(board$g)
pieces_left <- setdiff(1:(R*C), c(current, nxt)) # tiles not placed

while(anyNA(board$g)){  # while board is empty go through every cell
    for(i in 1:bR){     # at any particular cell
        for(j in 1:bC){
            if(is.na(board$g[i,j])){
                possible <- pieces_left
                for(adj in adjacent){      # look at ajdacent cells if not empty
                    ii <- i + adj[1]
                    jj <- j + adj[2]
                    if((ii %in% 1:bR) && (jj %in% 1:bC) && !is.na(board$g[[ii,jj]] )){
                        possible <- intersect(possible, 
                                              nghbrs[board$g[ii,jj]][[1]])  # and reduce possibilities
                    }
                }
                if(length(possible)==1){    # correct tile will satisfy all adjacent cells and will be unique (at least here)
                    board$g[i,j] <- possible
                    pieces_left <- setdiff(pieces_left, possible)
                }
            }
        }
    }
}

# function to get all possible flip and rotations of a matrix
rot_flip <- function(mat){
    ret <- vector("list", 8)
    p1 <- ret[[1]] <- mat                            # Orig
    p2 <- ret[[5]] <- apply(mat, 2, rev)             # Vertical flip
    for(i in 2:4){
        p1 <- ret[[i]]   <- t(apply(p1, 2, rev))     # rotation clockwise 90
        p2 <- ret[[4+i]] <- t(apply(p2, 2, rev))     # rotation clockwise 90
    }
    ret
}

# Do two tiles match in a particular orientation?
tiles_matcher <- function(tile1, tile2, adj1, adj2){
    if( adj2 == 1 ){ # tile2 on right of tile1
        return(all(tile1[,E] == tile2[,1]))
    }
    if( adj1 == 1 ){ # tile2 below tile 1
        return(all(tile1[E,] == tile2[1,]))
    }
    if( adj1 == -1 ){ # tile2 above tile 1
        return(all(tile1[1,] == tile2[E,]))
    }
    if( adj2 == -1 ){ # tile2 left of tile 1
        return(all(tile1[,1] == tile2[,E]))
    }
}

# Now Orient
for(i in 1:R){                     # For every cell
    for(j in 1:C){
        t1 <- board$g[i,j]
        p1 <- rot_flip(tiles[[t1]]) # get all possible tile orientations
        selected <- 1:length(p1)
        for(adj in adjacent){       # then for each adjacent cell
            ii <- i + adj[1]
            jj <- j + adj[2]
            if( (ii %in%  1:R) && (jj %in% 1:C) ){
                t2 <- board$g[ii,jj]
                p2 <- rot_flip(tiles[[t2]])        # get all possible orientations
                k <- expand.grid(a = 1:8, b = 1:8)
                m <- apply(k, 1, function(x) tiles_matcher(p1[[x[1]]], p2[[x[2]]], adj[1], adj[2])) # which orientations match?
                idx <- unique(k$a[which(m)])
                selected <- intersect(selected, idx)  # for each adjacent cell keep on reducing possible orientations of current cell
            }
        }
        assertthat::assert_that(length(selected) == 1) # one unique orientation available, select it
        tiles[[t1]] <- p1[[selected]]
    }
}

###  CREATE IMAGE ###
# cbind all board rows and then rbind together the results
image <- as.matrix(
    bind_rows(
        lapply(1:bR,           # for all rows in board
               function(i){
                   bind_cols(  # horizontally stack (cbind) all tiles
                       lapply( board$g[i,], 
                               function(x) tiles[[x]][ 2:(E-1), 2:(E-1) ]) ) 
               }
        )
    )
)
dimnames(image) <- NULL
MR <- nrow(image)
MC <- ncol(image)

### MONSTER
# create monster as a matrix which we will `slide` over our image to check for match
monster <- unlist(strsplit(c("                  # ",
                             "#    ##    ##    ###",
                             " #  #  #  #  #  #   "), ""))
monster <- matrix(monster, nrow = 3, byrow = T)   
monster[monster == " "] <- NA           # since spaces don't count turn them to NA for easier matches later

images <- rot_flip(image)            # Get all possible orientations of image
s <- ncol(monster)
for(img in images){
    monster_found <- FALSE
    monst <- 0
    # sliding window approach
    for(i in 1:(MR-2)){
        for(j in 1:(MC-s+1)){
            ind1 <- i: (i + 2)
            ind2 <- j:(j + s-1)
            slide <- img[ind1, ind2] == monster   # compare
            if(all(slide, na.rm = TRUE)){         # if match
                monst <- monst + 1
                img[ind1,ind2][slide] <- "O"
                monster_found <- TRUE
            }
        }
    }
    if(monster_found)
        break
}
sum(img == "#")
sprintf("Monsters found: %d", monst)
