setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# input <- readr::read_file('example.txt') |> 
file_name <- 'example.txt'
file_name <- 'input.txt'
input <- readLines(file_name) |> strsplit(": ")
cal_values <- lapply(input, \(x) as.double(x[1])) |> unlist()
numbers <- lapply(input, \(x) as.numeric(strsplit(x[2], " ")[[1]]))


check_validity <- function(calb, nums, operations = c("*", "||", "+"), part2 = FALSE){
  
  perms <- gtools::permutations(n = length(operations),
                                r = length(nums) - 1,
                                v = operations,
                                repeats.allowed = TRUE)
  if(part2){
    # only keep the ones with the concatenation operation, have already checked the ones
    # without in part 1
    perms <- perms[apply(perms, 1, \(x) '||' %in% x)]
  }
  found <- FALSE
  for(j in 1:nrow(perms)){
    cur_perm <- perms[j,]
    ans <- nums[1] 
    for(k in 1:(length(nums)-1)){
      
      if(cur_perm[k] == '*'){
        ans <- ans * nums[k+1]
      } else if (cur_perm[k] == '||') {
        ans <- as.numeric(paste0(ans, nums[k+1]))
      } else {
        ans <- ans + nums[k+1]
      }
      if(ans > calb) break
      
    }
    if(ans == calb) {
      found <- TRUE
      break
    }
  }
  found
}


p1 <- 0
p2 <- 0
for(i in seq_along(cal_values)){
  if(i %% 50 == 0) print(i)
  
  part1 <- check_validity(cal_values[i], numbers[[i]], operations = c("*", "+"))
  p1 <- p1 + part1 * cal_values[i]
  
  # only check concatenation if part 1 wasn't already TRUE
  if(part1){
    part2 <- TRUE
  } else {
    part2 <- check_validity(cal_values[i], numbers[[i]], operations = c("*", "||","+"))
  }
  p2 <- p2 + part2 * cal_values[i]
  
}

p1
p2
