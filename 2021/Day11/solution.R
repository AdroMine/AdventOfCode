setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in input
file_name <- "sample.txt"
file_name <- "input.txt"

input <- as.matrix(read.fwf(file_name, widths = rep(1, 10)))

mat <- input

# pad with NA 
mat <- cbind(NA_integer_, mat, NA_integer_)
mat <- rbind(NA_integer_, mat, NA_integer_)


# function to get coordinates of adjacent points
adjacent <- function(pt){
    x <- pt[1]
    y <- pt[2]
    
    list(
        x = c(-1, 1, 0,  0, -1, 1, -1,  1) + x, 
        y = c( 0, 0, 1, -1, -1, 1,  1, -1) + y
    )
    
}

state <- 0
count <- 0
while(TRUE){
    state <- state + 1
    # print(state)
    mat <- mat + 1
    
    idx <- which(mat > 9, arr.ind = TRUE)
    fl <- nrow(idx)
    
    # mark as those that are going to flash
    if(fl > 0){
        will_flash <- vector("list", 100)
        flashed <- vector("list", 100)
    
        for(k in 1:fl){
            will_flash[[k]] <- unname(idx[k,])
        }
        fsh <- 0
        
    }
    
    
    while(fl > 0){
        
        pt <- will_flash[[fl]]
        
        # increment adjacent
        nbrs <- adjacent(pt)
        mat[cbind(nbrs$x, nbrs$y)] <- mat[cbind(nbrs$x, nbrs$y)] + 1
        
        # find those that will flash now
        idx <- which(mat > 9, arr.ind = TRUE)
        dimnames(idx) <- NULL
        idx <- lapply(1:nrow(idx), \(i) idx[i,]) # convert index to list of (x,y)
        
        # find new ones to flash
        to_flash <- setdiff(idx, will_flash)   # don't take which we already know are going to flash
        to_flash <- setdiff(to_flash, flashed) # remove those that have already flashed
        
        # remove current from will flash
        will_flash[fl] <- NULL
        fl <- fl - 1
        
        for(i in seq_along(to_flash)){
            fl <- fl + 1
            will_flash[fl] <- to_flash[i]
        }
        
        fsh <- fsh + 1
        flashed[[fsh]] <- pt
        count <- count + 1
        
    }
    
    mat[mat > 9 & !is.na(mat)] <- 0
    
    if(state == 100)
        ans1 <- count
    
    if(sum(mat==0, na.rm = TRUE) == 100)
        break
    
    
}

ans1
state





# matrix based using convolutions from gignal library


# convolution slides a 3x3 window across the matrix
# multiplies the sub matrix and the window (element wise)
# and then sums it to get a single value for each point
# in our case this calculates the number of points that will
# impact any point (increase due to flashing neighbour)

mat <- input

# kernel for adjacent
kernel <- matrix(data = 1, nrow = 3, ncol = 3)
kernel[2,2] <- 0

state <- 0
count <- 0
while(sum(mat) > 0){
    state <- state + 1
    
    mat <- mat + 1
    
    mat_copy <- mat
    
    repeat {
        
        flashed <- mat > 9
        
        # convolution calculates cells affected, increase count by same
        mat <- mat_copy + gsignal::conv2(mat > 9, kernel, 'same')
        
        # if no change in flashes
        if(all((mat > 9) == flashed)){
            count <- count + sum(flashed)
            mat[flashed] <- 0
            break
        }
    }
    
    
    if(state == 100){
        print(paste("No of flashes after state:100 =", count))
    }
}

print(paste("State when all flashed first =", state))
