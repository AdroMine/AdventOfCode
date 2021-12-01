library(fastmatch) # for faster %in% functioning , fastmatch creates a hash of table to be compared
library(stringr)
library(purrr)

# input <- readLines("sample.txt")
input <- readLines("input.txt")

dirs <- list(
    'nw' = -1 - 1i, 
    'ne' =  1 - 1i, 
    'sw' = -1 + 1i,
    'se' =  1 + 1i,
    'e'  =  2 + 0i, 
    'w'  = -2 + 0i 
)

parse_input <- function(tiles, dirs){
    tiles <- str_match_all(tiles, "([ns]?[ew])")
    tiles <- lapply(tiles, function(x) dirs[x[,1]])
    tiles <- vapply(tiles, function(x) sum(unlist(x)), FUN.VALUE = 0 + 1i)
    tiles
}



tiles <- parse_input(input, dirs)

floor <- setdiff(tiles, tiles[duplicated(tiles)])

# Part 1 Ans
length(floor)

# Part 2
add_dirs <- unlist(dirs)

get_nbrs <- function(tile){
    unname(tile + add_dirs)
}


add_criteria <- function(tile, nbr_count){
    (!(tile %fin% floor) && nbr_count == 2L) || (tile %fin% floor && nbr_count %in% c(1L,2L))
}

sum_nbrs <- function(tile){
    sum(get_nbrs(tile) %fin% floor)
}

# Part 1
for(day in 1:100){
    
    # list with neighbours and self
    candidates <- union( floor, as.list( unlist( lapply( floor, get_nbrs ) ) ) )
    
    nbrs <- vapply(candidates, sum_nbrs, FUN.VALUE = 0L)
    
    nxt_black <- map2_lgl(candidates, nbrs, ~add_criteria(.x, .y))
    
    nxt <- candidates[nxt_black]
    
    floor <- nxt
    print(paste(day, length(floor), sep = ": "))
}
# Ans2
length(floor)
