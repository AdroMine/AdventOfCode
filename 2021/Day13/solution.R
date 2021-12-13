setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

Sys.setlocale(locale = "Chinese")

# Read in input
file_name <- "sample.txt"
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

# create matrix
mat <- matrix(0, nrow = R, ncol = C)

# fill coordinates with values
mat[cbind(coords$V2+1, coords$V1+1)] <- 1


# fold
for(i in 1:nrow(fold_inst)){
    dir <- fold_inst$V1[i]
    place <- fold_inst$V2[i] + 1
    
    if(dir == 'x'){
        # fold left
        
        m1 <- 1:(place-1)
        m2 <- (place + 1):ncol(mat)
        # length(m2) might not match length(m1)
        m2 <- m2[1:length(m1)] # this might create NAs though, fill them with FALSE
        mat <- mat[, m1] | mat[, rev(m2)]
        
        
    } else {
        # fold up 
        
        m1 <- 1: (place - 1)
        m2 <- (place + 1):nrow(mat)
        m2 <- m2[1:length(m1)]
        mat <- mat[m1, ] | mat[rev(m2), ]
        
    }
    mat[is.na(mat)] <- FALSE
    
    # part 1
    if(i == 1)
        print(sum(mat))
    
}

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

# HKUJGAJZ
