setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(purrr)
library(collections)
# Read and Transform input ------------------------------------------------
file_name <- "sample3.txt"
input <- readLines(file_name)

# Part 1

pattern <- "[xyz]=(-?\\d+)\\.\\.(-?\\d+),?"

nums <- stringr::str_match(input, 
                           pattern = paste0("(on|off) ",pattern, pattern, pattern))[,-1]
command <- nums[,1]
nums <- nums[,-1]
mode(nums) <- "integer"

volume <- function(r){
    prod(abs(r[1] - r[2]) + 1, abs(r[3] - r[4]) + 1, abs(r[5] - r[6]) + 1)
}

intersecting_volume <- function(p1, p2){
    x1 <- max(p2[1], p1[1]); x2 <- min(p2[2], p1[2])
    y1 <- max(p2[3], p1[3]); y2 <- min(p2[4], p1[4])
    z1 <- max(p2[5], p1[5]); z2 <- min(p2[6], p1[6])
    
    if(x1 <= x2 && y1 <= y2 && z1 <= z2)
        return(c(x1, x2, y1, y2, z1, z2))
}

solve <- function(nums){
    
    all_cubes <- dict()
    
    for(i in 1:nrow(nums)){
        # if on, we add volumn, if off we subtract volume
        sgn <- if(command[i] == "on") 1 else -1
        
        cubei <- nums[i, ]
        existing_cubes <- all_cubes$keys()
        
        # temp dictionary 
        dict2 <- dict()
        
        # find intersections with all existing cubes
        for(cube in existing_cubes){
            res <- intersecting_volume(cubei,  cube)
            # if intersection, update the count intersection region
            # in the list of cubes
            if(length(res) > 0)
                dict2$set(res, dict2$get(res, 0) - all_cubes$get(cube))
        }
        # add the current cube to dict2
        if(command[i] == "on"){
            dict2$set(cubei, dict2$get(cubei, 0) + sgn)
        }
        
        # now that the loop is over, add(update) the cubes count to the actual list of cubes
        for(k in dict2$keys()){
            all_cubes$set(k, dict2$get(k) + all_cubes$get(k, 0))
        }
    }
    
    vol <- 0
    for(key in all_cubes$keys()){
        vol <- vol + volume(key) * all_cubes$get(key)
    }
    as.character(vol)
    
}

# Part 1
solve(nums[apply(nums >= -50 & nums <= 50, 1, any),])

# Part 2
solve(nums)




# earlier brute force for part 1
grid_reboot <- function(nums, commands, part1 = TRUE){
    
    grid <- dict()
    for(i in 1:nrow(nums)){
        
        print(i)
        line <- nums[i,]
        x <- seq(line[1], line[2])
        y <- seq(line[3], line[4])
        z <- seq(line[5], line[6])
        if(part1){
            x <- x[x >= -50 & x <= 50]
            y <- y[y >= -50 & y <= 50]
            z <- z[z >= -50 & z <= 50]
        }
        for(xx in x){
            for(yy in y){
                for(zz in z){
                    key <- c(xx,yy,zz)
                    if(command[i] == "on"){
                        grid$set(key, TRUE)
                    } else {
                        if(grid$has(key))
                            grid$remove(key)
                    }
                }
            }
        }
    }
    grid$size()
}

# Part 1 
grid_reboot(nums, commands, TRUE)