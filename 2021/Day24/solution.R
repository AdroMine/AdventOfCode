setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# day 24
library(purrr)
library(collections)

file_name <- "input.txt"

library(dplyr)
library(tidyr)


# Parse input -------------------------------------------------------------

input2 <- readr::read_table(file_name, col_names = c("op", "var1", "var2"))
input2 <- input2 %>% 
    mutate(idx = cumsum(op == "inp")) %>%  # determine each digit operation start point
    group_by(idx) %>%                      # for each input find the nums to add
    mutate(push_pop = ifelse(var2[5] == "26", "pop", "peek")) %>%
    slice(6, 16) %>% 
    pivot_wider(names_from = var1, values_from = var2) %>% 
    ungroup() %>% 
    select(-op, -idx) %>% 
    mutate(x = as.integer(x), 
           y = as.integer(y))

nums <- collections::stack()
possibilities <- vector("list", 14)


# Determine possible digits for each location
for(i in 1:nrow(input2)){
    
    inst <- input2[i,]
    if(inst$push_pop == "peek"){
        nums$push(c(i, inst$y))
    } else {
        x <- nums$pop()
        digit_loc <- x[1]
        d <- inst$x
        s <- x[2] + d
        poss <- which((1:9 + s) %in% 1:9)
        possibilities[[digit_loc]] <- poss
        possibilities[[i]] <- poss + s
    }
}    

# Part 1 High
paste0(sapply(possibilities, max), collapse = "")

# Part 2 Low
paste0(sapply(possibilities, min), collapse = "")




# Below not necessary
# MONAD ALU ---------------------------------------------------------------

input <- readLines(file_name)

instructions <- strsplit(input, " ")
for(i in seq_along(instructions)){
    
    line <- instructions[[i]]
    line <- as.list(line)
    
    if(length(line) == 3){
        if(!line[[3]] %in% c("w", "x", "y", "z")){
            line[[3]] <- as.integer(line[[3]])
        }
    }
    instructions[[i]] <- line
}

monad <- function(instructions, num){
    
    if(any(num == 0)) 
        return(FALSE)
    i <- 0
    
    vars <- c(w = 0, x = 0, y = 0, z = 0)
    
    for(line in instructions){
        
        op <- line[[1]]
        if(op == "inp"){
            
            var1 <- line[[2]]
            i <- i + 1
            vars[var1] <- num[i]
            
        } else {
            
            var1 <- line[[2]]
            var2 <- line[[3]]
            if(is.character(var2)) var2 <- vars[var2]
            # var2 <- if(grepl("\\d+", line[3])) as.integer(line[3]) else vars[line[3]]
            # var2 <- if(var2 %in% names(vars)) vars[line[3]] else as.integer(line[3])
            
            
            vars[var1] <- switch(op,
                                 add = vars[var1] + var2, 
                                 mul = vars[var1] * var2, 
                                 div = {stopifnot(var2!=0) ; vars[var1] %/% var2}, # round towards 0, integer division or round up as well?
                                 mod = {stopifnot(vars[var1] >=0 && var2 > 0); vars[var1] %% var2}, 
                                 eql = if(vars[var1] == var2) 1 else 0
            )
        }
    }
    print(vars)
    vars['z'] == 0
}



number <- "13579246899999"


# running below will take forever, we need to find constraints
# by reverse engineering the code
num <- 1e14 - 1
while(TRUE){
# for(i in 1:1000){
    k <- as.integer(strsplit(as.character(num), "")[[1]])
    if(monad(instructions, k))
        break
    num <- num - 1
    print(num)
}
print(num)


low <- 11164118121471
high <- 93499629698999
