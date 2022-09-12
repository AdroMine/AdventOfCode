setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read and Transform input ------------------------------------------------
file_name <- "input.txt"
algo <- readLines(file_name, n = 1) %>% strsplit("") %>% `[[`(1)
algo <- as.integer(algo == '#')
width <- readLines(file_name, n = 3)[3] %>% nchar

input <- as.matrix(read.fwf(file_name, widths = rep(1, width), skip = 2, comment.char = ""))
input <- as.integer(input == '#')
input <- matrix(input, width, width)

pad_size <- 50
pad_lr <- matrix(0, width, pad_size)
pad_up <- matrix(0, pad_size, width + 2*pad_size)

mat <- cbind(pad_lr, input, pad_lr)
mat <- rbind(pad_up, mat, pad_up)
N <- nrow(mat)

kernel <- 2^matrix(0:8, 3, 3, byrow = TRUE)
for(step in 1:50){
    tmp <- algo[gsignal::conv2(mat, kernel, 'same') + 1]
    mat <- matrix(tmp, N, N)
    
    if(step %in% c(2, 50)) print(sum(mat))
}

# convolution in scipy.ndimage by default uses reflect mode, 
# this one only has 'constant' mode (where edges are imagined to be 0)