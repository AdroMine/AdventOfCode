library(collections)

# Read and Transform input ------------------------------------------------
file_name <- "input.txt"
algo <- readLines(file_name, n = 1) %>%  strsplit("") %>% `[[`(1)
width <- readLines(file_name, n = 3)[3] %>% nchar

input <- read.fwf(file_name, widths = rep(1, width), skip = 2, comment.char = "")

gog <- dict()

on_state <- unname(which(input == '#', arr.ind = TRUE))
for(i in 1:nrow(on_state)){
    gog$set(on_state[i,], 1)
}

enhance <- function(d, step){
    
    d2 <- dict()
    keys <- d$keys()
    min_x <- min(vapply(keys, `[`, 1, FUN.VALUE = 1L))
    max_x <- max(vapply(keys, `[`, 1, FUN.VALUE = 1L))
    min_y <- min(vapply(keys, `[`, 1, FUN.VALUE = 1L))
    max_y <- max(vapply(keys, `[`, 1, FUN.VALUE = 1L))
    
    for(x in (min_x - 1) : (max_x + 1)){
        for(y in (min_y - 1) : (max_y + 1)){
            
            num <- 0
            bit_pos <- 8
            for(xx in -1:1){
                for(yy in -1:1){
                    if(d$has(c(x + xx, y + yy)) == step)
                        num <- num + 2^bit_pos
                    bit_pos <- bit_pos - 1
                }
            }
            val <- algo[num + 1]
            if((val == '#') != step){
                d2$set(c(x,y), 1)
            }
        }
    }
    d2
}

d <- gog
for(step in 1:10){
    print(step)
    d <- enhance(d, step %% 2)
    if(step %in% c(2,50)) print(d$size())
}