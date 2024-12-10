setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)
library(fastmatch)

# in_file <- 'sample.txt'
in_file <- 'input.txt'

width <- nchar(readLines(in_file,n= 1))
input <- read.fwf(in_file, widths = rep(1, width), comment.char = '')


R <- nrow(input)
C <- ncol(input)

start <- c(1, which(input[1,] == '.'))
goal  <- c(R, which(input[R,] == '.'))

movements <- list(
    '>' = c(0L,1L),  '<' = c(0L,-1L), 
    'v' = c(1L,0L),  '^' = c(-1L, 0L)
)

winds <- setNames(lapply(names(movements), \(x) which(input == x, arr.ind = TRUE)), names(movements))

winds_forecast <- function(t){
    
    right <- winds$`>`
    left <- winds$`<`
    up <- winds$`^`
    down <- winds$v
    
    right[,2] <- (right[,2] - 2 + t) %% (C-2) + 2
    left [,2] <- (left[,2]  - 2 - t) %% (C-2) + 2
    up   [,1] <- (up[,1]    - 2 - t) %% (R-2) + 2
    down [,1] <- (down[,1]  - 2 + t) %% (R-2) + 2
    
    k <- unname(rbind(right, left, up, down))
    
    lapply(seq_len(nrow(k)), \(i) k[i,])
    # k
    
}

wind_times <- vector('list', 2000)
for(t in 1:2000){
    print(t)
    new_forecast <- winds_forecast(t)
    wind_times[[t]] <- new_forecast
}


bfs <- function(start){
    
    Q    <- collections::queue()
    seen <- collections::dict()
    
    Q$push(list(start, 0))
    
    while(Q$size() > 0){
        
        if(seen$size() %% 1000 == 0) print(seen$size())
        
        item    <- Q$pop()
        cur_pos <- item[[1]]
        tm      <- item[[2]]
        
        if(cur_pos[1] < 1 || cur_pos[1] > R || 
           cur_pos[2] < 1 || cur_pos[2] > C || 
           input[cur_pos[1], cur_pos[2]] == '#') next
        
        if(cur_pos[1] == R){
            print(tm)
            break
        }
        
        key <- list(cur_pos, tm)
        if(seen$has(key)) next
        seen$set(key, TRUE)
        
        nxt_wind <- wind_times[[tm + 1]]
        # we could also try using anti-join here
        # that should be fast
        
        if(!list(cur_pos) %fin% nxt_wind){
            Q$push(list(cur_pos, tm + 1))
        }
        for(m in movements){
            ns <- cur_pos + m
            if(!list(ns) %fin% nxt_wind){
                Q$push(list(ns, tm + 1))
            }
        }
    }
    tm
}

bfs(start)



# Solution style 2 (playing to R strenghts)
winds <- setNames(lapply(names(movements), \(x) which(input == x, arr.ind = TRUE)), names(movements))
winds2 <- do.call(rbind, lapply(names(movements), function(x){
    df <- as.data.frame(which(input == x, arr.ind = TRUE))
    df$dir <- x
    df
}))

wind_forecast <- function(time){
    
    # dplyr::mutate(
    #     winds2,
    #     row = dplyr::case_when(
    #         dir == '^' ~ (row - 2 + time) %% (R-2) + 2,
    #         dir == 'v' ~ (row - 2 - time) %% (R-2) + 2,
    #         TRUE ~ row
    #     ), 
    #     col = dplyr::case_when(
    #         dir == '>' ~ (col - 2 + time) %% (C-2) + 2,
    #         dir == '<' ~ (col - 2 - time) %% (C-2) + 2,
    #         TRUE ~ col
    #     )
    # )
    
    winds2$row <- with(
        winds2, 
        data.table::fcase(
            dir == '^', as.integer((row - 2 - time) %% (R-2) + 2), 
            dir == 'v', as.integer((row - 2 + time) %% (R-2) + 2), 
            dir %in% c('<', '>'), row
        )
    )
    
    winds2$col <- with(
        winds2, 
        data.table::fcase(
            dir == '<', as.integer((col - 2 - time) %% (C-2) + 2), 
            dir == '>', as.integer((col - 2 + time) %% (C-2) + 2), 
            dir %in% c('v', '^'), col
        )
    )
    
    # winds2
    
    complex(real = winds2$row, imaginary = winds2$col)
    # sort(complex(real = winds2$row, imaginary = winds2$col))
    
    
}

winds_predicted <- lapply(1:2000, \(i){
    print(i)
    wind_forecast(i)
})

bfs2 <- function(start){
    
    Q    <- collections::queue()
    seen <- collections::dict()
    st <- complex(real =start[1], imaginary = start[2])
    
    Q$push(list(st, 0))
    dirs <- c(0 + 0i, 0 + 1i, 0 - 1i, 1 + 0i, -1 + 0i)
    
    while(Q$size() > 0){
        
        if(seen$size() %% 1000 == 0) print(seen$size())
        
        item    <- Q$pop()
        cur_pos <- item[[1]]
        tm      <- item[[2]]
        
        if(Re(cur_pos) < 1 || Re(cur_pos) > R || 
           Im(cur_pos) < 1 || Im(cur_pos) > C || 
           input[Re(cur_pos), Im(cur_pos)] == '#') next
        
        if(Re(cur_pos) == R){
            print(tm)
            break
        }
        
        key <- list(cur_pos, tm)
        if(seen$has(key)) next
        seen$set(key, TRUE)
        
        nxt_wind <- winds_predicted[[tm + 1]]
        # we could also try using anti-join here
        # that should be fast
        
        possibs <- cur_pos + dirs
        idx <- match(possibs, nxt_wind, nomatch = 0L)
        possibs <- possibs[-c(idx, 6L)]
        # possibs <- setdiff(possibs, nxt_wind)
        
        
        for(p in possibs){
            Q$push(list(p, tm + 1))
        }
    }
    tm
    
    
}
