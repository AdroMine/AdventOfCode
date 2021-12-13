setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

Sys.setlocale(locale = "Chinese") # for printing block letter █
library(magrittr)

# Read in input
# file_name <- "sample.txt"
file_name <- "input.txt"

input <- readLines(file_name)
sep <- which(input == "")

# read coordinates
coords <- head(input, sep-1) %>% strsplit(",") %>% lapply(as.numeric)
folds <- tail(input, -sep) %>% gsub("fold along ", "", .) %>% strsplit("=")

first_fold <- TRUE
for(fold in folds){
    
    dir <- fold[1]
    val <- as.integer(fold[2])
    
    new_coords <- vector("list", 1000)
    i <- 1
    for(xy in coords){
        x <- xy[1]
        y <- xy[2]
        new_x <- if(dir == 'x') min(x, 2*val - x) else x
        new_y <- if(dir == 'y') min(y, 2*val - y) else y
        new_coords[[i]] <- c(new_x, new_y)
        i <- i + 1
    }   
    
    coords <- purrr::discard(unique(new_coords), is.null)
    
    if(first_fold){
        print(length(coords))
        first_fold <- FALSE
    }
}

print_list_grid <- function(lst, char = "█", blank = " "){
    
    R <- max(sapply(lst, function(x) x[1])) 
    C <- max(sapply(lst, function(x) x[2]))
    
    for(i in 0:C){
        for(j in 0:R){
            # fails without converting to numeric for some chars
            x <- as.numeric(j)
            y <- as.numeric(i)
            # if(list(c(j,i)) %in% lst) cat(char) else cat(blank)
            if(list(c(x,y)) %in% lst) cat(char) else cat(blank)
        }
        cat("\n")
    }
    
}

print_list_grid(coords)
