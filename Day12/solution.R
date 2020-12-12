setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(stringr)
library(dplyr)

input <- readLines("input.txt")

parse_input <- function(input){
    input <- as.data.frame(str_match(input, "([A-Z])(\\d+)")[,-1])
    input %>% 
        mutate(V2 = as.numeric(V2), 
               V2 = case_when(V1 == "W" ~-V2,
                              V1 == "S" ~-V2,
                              V1 == "L" ~360-V2, 
                              TRUE ~ V2))
    
}

input <- parse_input(input)

# Part 1, only ship moves
part1 <- function(input, east = 0, north = 0, direction = 1){
    directions <- setNames(c(0,   1,   2,   3), 
                           c('N', 'E', 'S', 'W'))
    curr_dir <- names(directions)[direction+1]
    for(i in 1:nrow(input)){
        curr_step <- input[i, 1]
        count <- input[i, 2]
        if(curr_step == "F"){
            curr_step <- curr_dir
            if(curr_step %in% c("W", "S"))
                count <- -count
        }
        if(curr_step %in% c("W", "E"))
            east <- east + count
        if(curr_step %in% c("N", "S"))
            north <- north + count
        if(curr_step %in%  c("R", "L")){
            direction <- (direction + count / 90) %% 4
            curr_dir <- names(directions)[direction+1]
        }
    }
    sum(abs(east), abs(north))
}
part1(input)

# Part 2 ship and waypoint move
part2 <- function(input, wp_n = 1, wp_e = 10, sh_n = 0, sh_e = 0){
    for(i in 1:nrow(input)){
        curr_step <- input[i,1]
        count <- input[i, 2]
        
        if(curr_step == "F"){
            sh_n <- sh_n + count * wp_n
            sh_e <- sh_e + count * wp_e
        }
        if(curr_step %in% c("N", "S")){
            wp_n <- wp_n + count
        }
        if(curr_step %in% c("E", "W")){
            wp_e <- wp_e + count
        }
        if(curr_step %in% c("R", "L")){
            if(count == 90){
                tmp <- wp_n
                wp_n <- -wp_e
                wp_e <- tmp
            }
            if(count == 180){
                wp_n <- -wp_n
                wp_e <- -wp_e
            }
            if(count == 270){
                tmp <- wp_n
                wp_n <- wp_e
                wp_e <- -tmp
                
            }
        }
    }
    sum(abs(sh_e), abs(sh_n))
}
part2(input)




