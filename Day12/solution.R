setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(stringr)
library(dplyr)

input <- readLines("input.txt")

parse_input <- function(input){
    input <- as.data.frame(str_match(input, "([A-Z])(\\d+)")[,-1])
    input %>% 
        mutate(V2 = as.numeric(V2), 
               V2 = case_when(V1 == "R" ~360-V2, 
                              TRUE ~ V2))
    
}

input <- parse_input(input)

# Using complex plane system! New trick discovered

movement <- list(E = 1 +0i, 
                 W = -1 + 0i,
                 N = 0 + 1i,
                 S = 0 - 1i)

move_ship <- function(input, waypoint = (1 + 0i), ship = (0 + 0i), part1 = TRUE){
    for(i in 1:nrow(input)){
        cur_step <- input[i, 1]
        count <- input[i, 2]
        if(cur_step %in% c("R", "L")){
            count <- count / 90
            waypoint <- waypoint * (0 + 1i)^count
        } else if(cur_step == "F"){
            ship <- ship + waypoint * count
        } else if(part1){
            ship <- ship + movement[[cur_step]] * count
        } else {
            waypoint <- waypoint + movement[[cur_step]] * count
        }
    }
    abs(Re(ship)) + abs(Im(ship))
}

# part 1
move_ship(input)

# part 2
move_ship(input, waypoint = (10 + 1i), ship = (0+0i), part1 = FALSE)



