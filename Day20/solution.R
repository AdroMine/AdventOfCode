setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(stringr)
library(purrr)
library(dplyr) # for between
input <- readLines("input.txt")

st <- grep("^Tile", input)

tiles <- map(st, function(x) str_split_fixed(input[(x + 1): (x + 10)], "", Inf))
names(tiles) <- str_extract(input[st], "\\d+")

nghbrs <- matrix(rep(c( NA,    NA,     NA,      NA,     NA,     NA,     NA,     NA), length(tiles)), nrow = length(tiles))
colnames(nghbrs) <- c("left", "lrev", "up", "urev", "right", "rrev", "down", "drev")

# CONSTANTS
E <- 10  # edge length
R <- sqrt(length(tiles))
C <- R

get_sides <- function(tile){
    l <- tile[,1]
    r <- tile[,10]
    u <- tile[1,]
    d <- tile[10,]
    tmp <- unlist(lapply(list(l, u, r, d), function(x)
        c(paste(x, collapse = ""), paste(rev(x), collapse = ""))))
    names(tmp) <- c("left", "lrev", "up", "urev","right", "rrev","down", "drev")
    tmp
}

# Do two tiles match
matcher <- function(i, j,n = 10){
    t1 <- tiles[[i]]
    t2 <- tiles[[j]]
    
    t1s <- get_sides(t1)
    t2s <- get_sides(t2)[c(1, 3, 5, 7)]
    
    mtch <- outer(t1s, t2s, function(x,y) x == y)
    if(any(mtch)){
        # matches!
        idx <- which(mtch, arr.ind = TRUE)
        return(idx)
    } else
        return(NA)
}

# find which edge matches which edge
for(i in 1:(length(tiles)-1)){
    for(j in (i + 1):length(tiles)){
        # print(paste0("i:", i, ";  j=",j))
        idx <- matcher(i, j)
        if(any(!is.na(idx))){
            t1 <- idx[,1]
            t2 <- idx[,2] * 2 - 1
            nghbrs[i, t1] <- j
            nghbrs[j, t2] <- i
        } 
    }
}
# Part 1 Ans
corners <- which(rowSums(!is.na(nghbrs)) == 2)
print(prod(as.numeric(names(tiles)[corners])), 22)

# let top left corner be any corner, we can rotate board so that it is the top left
current <- corners[1]

board <- new.env()
board$g <- matrix(NA, sqrt(length(tiles)), sqrt(length(tiles)))
board$g[1, 1] <- current

nxt <- as.integer(na.omit(nghbrs[current,]))

board$g[1,2] <- nxt[1]
board$g[2,1] <- nxt[2]


adjacent <- list(c(0,1), c(1,0), c(-1, 0), c(0,-1))
bR <- nrow(board$g)
bC <- ncol(board$g)
keys_left <- setdiff(1:(R*C), c(current, nxt))

while(anyNA(board$g)){
    for(i in 1:bR){
        for(j in 1:bC){
            # print(sprintf("(i,j) = (%d, %d)", i,j))
            if(is.na(board$g[i,j])){
                possible <- keys_left
                for(adj in adjacent){
                    ii <- i + adj[1]
                    jj <- j + adj[2]
                    if((ii %in% 1:bR) && (jj %in% 1:bC) && !is.na(board$g[[ii,jj]] )){
                        possible <- intersect(possible, nghbrs[board$g[ii,jj],])
                    }
                }
                if(length(possible)==1){
                    board$g[i,j] <- possible
                    keys_left <- setdiff(keys_left, possible)
                }
                
            }
        }
    }
}

rot_flip <- function(mat){
    p1 <- mat                            # Orig
    p2 <- apply(mat, 2, rev)             # Vertical flip
    # p2 <- t(apply(mat, 1, rev)) # Horizontal flip
    # rotations of above two
    p3 <- t(apply(p1, 2, rev))
    p4 <- t(apply(p3, 2, rev))
    p5 <- t(apply(p4, 2, rev))
    
    p6 <- t(apply(p2, 2, rev))
    p7 <- t(apply(p6, 2, rev))
    p8 <- t(apply(p7, 2, rev))
    list(p1, p2, p3, p4, p5, p6, p7, p8)
}

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
for(i in 1:R){
    for(j in 1:C){
        t1 <- board$g[i,j]
        p1 <- rot_flip(tiles[[t1]])
        selected <- 1:length(p1)
        for(adj in adjacent){
            ii <- i + adj[1]
            jj <- j + adj[2]
            if( (ii %in%  1:R) && (jj %in% 1:C) ){
                t2 <- board$g[ii,jj]
                p2 <- rot_flip(tiles[[t2]])
                k <- expand.grid(a = 1:8, b = 1:8)
                idx <- k %>% 
                    rowwise() %>% 
                    mutate(match = tiles_matcher(p1[[a]], p2[[b]], adj[1], adj[2])) %>% 
                    filter(match == TRUE) %>% 
                    pull(a) %>% unique()
                selected <- intersect(selected, idx)
            }
        }
        assertthat::assert_that(length(selected) == 1)
        tiles[[t1]] <- p1[[selected]]
    }
}

image <- as.matrix(bind_rows(lapply(1:bR, function(i){
    bind_cols(lapply(board$g[i,], function(x) tiles[[x]][2:(E-1), 2:(E-1)]))  
})))
dimnames(image) <- NULL
MR <- nrow(image)
MC <- ncol(image)

monster <- unlist(strsplit(c("                  # ",
                             "#    ##    ##    ###",
                             " #  #  #  #  #  #   "), ""))
monster <- matrix(monster, nrow = 3, byrow = T)
monster[monster == " "] <- NA



images <- rot_flip(image)            # Get all possible variations of image
s <- ncol(monster)
for(img in images){
    monster_found <- FALSE
    
    # sliding window approach
    for(i in 1:(MR-2)){
        for(j in 1:(MC-s+1)){
            ind1 <- i: (i + 2)
            ind2 <- j:(j + s-1)
            slide <- img[ind1, ind2] == monster
            if(all(slide, na.rm = TRUE)){
                print("found it!")
                img[ind1,ind2][slide] <- "O"
                monster_found <- TRUE
            }
        }
    }
    if(monster_found)
        break
}
sum(img == "#")
