setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

Sys.setlocale(locale = "Chinese") # for printing block letter █

# Read in input
# file_name <- "sample.txt"
file_name <- "input.txt"

input <- readLines(file_name)
sep <- which(input == "")

# read coordinates
coords <- read.table(file_name, sep = ",", nrows = sep - 1)

# read folding instructions
fold_inst <- read.table(file_name, skip = sep, sep ="=")

# remove text from folding instr
fold_inst$V1 <- gsub("fold along ", "", fold_inst$V1)

C <- max(coords$V1) + 1
R <- max(coords$V2) + 1

# create matrix (make size larger, since in some cases we don't have enough cols/rows left for folding)
mat <- matrix(0, nrow = 2*R, ncol = 2*C)

# fill coordinates with values
mat[cbind(coords$V2+1, coords$V1+1)] <- 1


# fold
for(i in 1:nrow(fold_inst)){
    dir <- fold_inst$V1[i]
    place <- fold_inst$V2[i] + 1
    
    m1 <- seq(1, place - 1)
    m2 <- seq(place + 1, 2*place - 1)
    
    if(dir == 'x'){
        # fold left
        mat <- mat[, m1] | mat[, rev(m2)]
        
    } else {
        mat <- mat[m1, ] | mat[rev(m2), ]
    }
    
    # part 1
    if(i == 1)
        print(sum(mat))
    
}


print_mat <- function(mat){
    # Print
    k <- mat  
    # change TRUE FALSE to █ and  
    k[k == TRUE]  <- "█"   # if this character doesn't print properly, set your locate to Chinese (line # 2)
    k[k == FALSE] <- " "
    
    kl <- apply(k, 1, paste0, collapse = "")
    
    for(i in seq_along(kl)){
        cat(kl[i])
        cat("\n")
    }
}

print_mat(mat)

# HKUJGAJZ

