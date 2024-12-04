setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt') |>
# input <- readLines('example.txt') |>
  strsplit("") |> 
  do.call(rbind, args = _)

R <- nrow(input)
C <- ncol(input)


p1 <- 0

check <- function(arr){
  word <- paste0(arr, collapse = '')
  word == 'XMAS' 
}

for(i in 1:R){
  for(j in 1:C) {
    
    # right
    if(j + 3 <= C){
      if(check(input[i, j:(j+3)])) p1 <- p1 + 1
    }
    # left
    if(j - 3 >= 1){
      if(check(input[i, j:(j-3)])) p1 <- p1 + 1
    }
    # top
    if(i - 3 >= 1){
      if(check(input[i:(i-3), j])) p1 <- p1 + 1
    }
    # down
    if(i + 3 <= R){
      if(check(input[i:(i+3), j])) p1 <- p1 + 1
    }
    # diagonal down right
    if(i + 3 <= R & j + 3 <= C){
      if(check(input[cbind(i:(i+3), j:(j+3))])) p1 <- p1 + 1
    }
    # diagonal up right
    if(i - 3 >= 1 & j + 3 <= C){
      if(check(input[cbind(i:(i-3), j:(j+3))])) p1 <- p1 + 1
    }
    # diagonal up left
    if(i - 3 >= 1 & j - 3 >= 1){
      if(check(input[cbind((i):(i-3), (j):(j-3))])) p1 <- p1 + 1
    }
    # diagonal down left
    if(i + 3 <= R & j - 3 >= 1){
      if(check(input[cbind((i):(i+3), (j):(j-3))])) p1 <- p1 + 1
    }
  }
}

p1


# Part 2
valid_matches <- list(
  m1 = matrix(c("M", ".", "S", 
                ".", "A", ".", 
                "M", ".", "S"), nrow = 3, ncol = 3), 
  m2 = matrix(c("M", ".", "M", 
                ".", "A", ".", 
                "S", ".", "S"), nrow = 3, ncol = 3), 
  m3 = matrix(c("S", ".", "M", 
                ".", "A", ".", 
                "S", ".", "M"), nrow = 3, ncol = 3), 
  m4 = matrix(c("S", ".", "S", 
                ".", "A", ".", 
                "M", ".", "M"), nrow = 3, ncol = 3)
)

check_x_mas <- function(chunk){
  lapply(valid_matches, \(one_match){
      match <- chunk == one_match 
      all((one_match != '.') == match)
      # match[1,1] & match[1,3] & match[2,2] & match[3,1] & match[3,3]
  }) |> 
    unlist() |> 
    any()
}

p2 <- 0
for(i in 1:R){
  for(j in 1:C){
    
    if((i+2) > R | (j+2) > C) next
    p2 <- p2 + check_x_mas(input[i:(i+2), j:(j+2)])
    
  }
}

p2
