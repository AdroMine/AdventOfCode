setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

Sys.setlocale(locale = "Chinese") # for printing block letter █

# file_name <- "sample.txt"
file_name <- "input.txt"

f <- file(file_name, open = "r")

env <- new.env()
first_fold <- TRUE

# function to create character name for (x,y) creats xgy (adds g as separator)
c_name <- function(x,y) paste0(x, "g", y, collapse = "")

while(TRUE){
    
    line <- readLines(f, n = 1)
    if(length(line) == 0)
        break
    
    if(line == "")
        next
    
    if(!startsWith(line, "fold")){
        xy <- as.numeric(strsplit(line, ",")[[1]])
        # store in env as a variable with name as output of c_name
        assign(c_name(xy[1],xy[2]), TRUE, envir = env)
    } else {
        
        # get fold data
        inst <- strsplit(line, " ")[[1]][3] # remove initial part
        inst <- strsplit(inst, "=")[[1]]    
        dir <- inst[1]                      # direction
        val <- as.integer(inst[2])          # value
        
        grid_nm <- ls(env)                  # "ON" grid locations
        grid <- strsplit(grid_nm, "g")      # convert name to (x,y)
        grid <- lapply(grid, as.integer)    
        
        new_grid <- new.env()               # new grid for after folding
        
        for(cord in grid){
            x <- cord[1]
            y <- cord[2]
            x2 <- if(dir == 'x') min(x, 2*val - x) else x
            y2 <- if(dir == 'y') min(y, 2*val - y) else y
            assign(c_name(x2, y2), TRUE, envir = new_grid)
        }
        
        env <- new_grid
        
        if(first_fold){
            print(length(env))
            first_fold <- FALSE
        }
    }
}
close(f)

print_env(env)

print_env <- function(env, char = "█"){
    nms <- ls(env)
    cds <- strsplit(nms, "g") |> lapply(as.integer)
    
    R <- max(sapply(cds, function(x) x[1]))
    C <- max(sapply(cds, function(x) x[2]))
    
    for(i in 0:C){
        for(j in 0:R){
            if(c_name(j,i) %in% nms) cat(char) else cat(" ")
        }
        cat("\n")
    }
}

print_env2 <- function(env){
    nms <- ls(env)
    cds <- strsplit(nms, "g") |> lapply(as.integer)
    
    R <- max(sapply(cds, function(x) x[1]))
    C <- max(sapply(cds, function(x) x[2]))
    
    for(i in 0:C){
        for(j in 0:R){
            if(c_name(j,i) %in% nms) cat("#") else cat(".")
        }
        cat("\n")
    }
}
