setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

input <- readLines('input.txt') 
    

blueprints <- lapply(input, function(line) as.integer(
        stringr::str_extract_all(line,  "\\d+")[[1]]))

# id ore_robot_cost, clay_robot_cost, (obsidian_r_cost 1, 2), (geode_r_cost 1, 2)
next_states <- function(bp, state){
    # bp <- as.integer(bp)
    # statez <- as.integer(state)
    
    o1 <- state[1]; o2 <- state[2]; o3 <- state[3]; o4 <- state[4];
    r1 <- state[5]; r2 <- state[6]; r3 <- state[7]; r4 <- state[8]
    or1  <- bp[2]; oc1  <- bp[3]; 
    obc1 <- bp[4]; obc2 <- bp[5]
    ogc1 <- bp[6]; ogc2 <- bp[7]
    
    max_ores <- max(or1, oc1, obc1, ogc1)
    tm <- state[9]
    
    # prioritise one geode robo if we can
    if((o1 >= ogc1) && (o3 >= ogc2)){
        return(
            list(
                c(o1-ogc1+r1, o2 + r2, o3 - ogc2+r3, o4 + r4, 
                  r1, r2, r3, r4+1L, tm - 1L)
            )
        )
    }
    
    # no robo
    no_robo <- c(o1 + r1, o2 + r2, o3 + r3, o4 + r4, r1, r2, r3, r4, tm-1L)
    states <- list(no_robo)
    
    # one ore robo, if haven't exceed max ores that are needed at any step
    if((o1 >= or1) && (r1 < max_ores)){
        states <- c(states, list(
            c(o1-or1+r1, o2 + r2, o3 + r3, o4 + r4, r1 + 1L, r2, r3, r4, tm-1L)
        ))
    }
    
    # one clay robo
    if((o1 >=oc1) && (r2 < obc2)){
        states <- c(states, list(
            c(o1-oc1+r1, o2+r2, o3+r3, o4+r4, r1, r2+1L, r3, r4, tm-1L)
        ))
    }
    
    # one obsidian robo
    if((o1 >= obc1) && (o2 >= obc2) && (r3 < ogc2)){
        states <- c(states, list(
            c(o1-obc1+r1, o2-obc2+r2, o3+r3, o4+r4, r1, r2, r3+1L, r4,tm-1L)
        ))
    }
    
    states
    
}

max_geodes2 <- function(blueprint, duration = 24){
    
    # start with no ores and one ore robot
    ores   <- as.integer(c(0, 0, 0, 0)) # ore/clay/obsidian/geode
    robots <- as.integer(c(1, 0, 0, 0)) # ore/clay/obsidian/geode
    blueprint <- as.integer(blueprint)
    
    dp <- utils::hashtab(size = 1e6)
    state <- c(ores, robots, duration)
    tri_nums <- sapply(1:32, \(t) (t+1)*t %/% 2)
    
    best <- 0
    max_ores_used <- max(blueprint[c(2, 3, 4, 6)])
    max_clay_used <- blueprint[5]
    max_obs_used  <- blueprint[7]
    
    dfs <- function(cur){
        
        # if(length(dp) %% 10000 == 0) print(length(dp))
        
        best <<- max(best, cur[4])
        tm <- cur[9]
        cur[1L] <- min(cur[1L], tm * max_ores_used - cur[5L] * (tm-1L))
        cur[2L] <- min(cur[2L], tm * max_clay_used - cur[6L] * (tm-1L))
        cur[3L] <- min(cur[3L], tm * max_obs_used  - cur[7L] * (tm-1L))
        
        if(tm == 0) return()
        if((cur[4] + cur[8]*tm + tri_nums[tm]) <= best) return()
        # if((tm * cur[4] + max((tm-2)*(tm-1)%/%2, 0)) < best) return()
        if(gethash(dp, cur, FALSE)) return()
        sethash(dp, cur, TRUE)
        
        for(state in next_states(blueprint, cur)){
            Recall(state)  
        } 
    }
    dfs(state)
    # dp
    best
    
}


# Part 1
scores <- sapply(blueprints, max_geodes2, 24)
sum(scores * 1:length(blueprints))

# Part 2
part2 <- sapply(blueprints[1:3], max_geodes2, 32)
prod(part2)
# max_geodes2(blueprints[[1]], 24)


    # # first priority to creating geode robo if we can
    # # if(os[1] >= cost[6] && os[3] >= cost[7]){
    # if(o1[1] >= cost[6] && os[3] >= cost[7]){
    #     # nos <- os + rb
    #     # nos[1] <- nos[1] - cost[6]
    #     # nos[3] <- nos[3] - cost[7]
    #     grobo <- c(os[1] + rb[1] - cost[6], 
    #                os[2] + rb[2], 
    #                os[3] + rb[3] - cost[7], 
    #                os[4] + rb[4], 
    #                rb[1:3], rb[4] + 1L
    #     )
    #     return(list(grobo))
    #     # states <- c(states, list(grobo))
    # }
    # 
    # # no robo
    # no_robo <- c(os + rb, rb)
    # states <- list(no_robo)
    # 
    # # one ore robo
    # if(os[1] >= cost[2] && rb[1] < max_ores){
    #     # nos <- os + rb
    #     # nos[1] <- nos[1] - cost[2]
    #     ore_robo <- c(os[1] + rb[1] - cost[2], 
    #                   os[2] + rb[2], os[3] + rb[3], os[4] + rb[4], 
    #                   rb[1] + 1L, rb[2:4])
    #     states <- c(states, list(ore_robo))
    # }
    # 
    # # one clay robo
    # if(os[1] >= cost[3] && rb[2] < max_clay){
    #     # nos <- os + rb
    #     # nos[1] <- nos[1] - cost[3]
    #     clay_robo <- c(os[1] + rb[1] - cost[3], 
    #                    os[2] + rb[2], 
    #                    os[3] + rb[3],
    #                    os[4] + rb[4],
    #                    rb[1], rb[2] + 1L, rb[3:4])
    #     states <- c(states, list(clay_robo))
    # }
    # 
    # # obsidian robo
    # if(os[1] >= cost[4] && os[2] >= cost[5] && rb[3] < max_obs){
    #     # nos <- os + rb
    #     # nos[1] <- nos[1] - cost[4]
    #     # nos[2] <- nos[2] - cost[5]
    #     obs_robo <- c(os[1] + rb[1] - cost[4], 
    #                   os[2] + rb[2] - cost[5], 
    #                   os[3] + rb[3], 
    #                   os[4] + rb[4],
    #                   rb[1:2], rb[3]+1L, rb[4])
    #     states <- c(states, list(obs_robo))
    # }
    # 
    # 