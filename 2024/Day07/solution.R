setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file_name <- 'example.txt'
file_name <- 'input.txt'
input <- readLines(file_name) |> strsplit(": ")
cal_values <- lapply(input, \(x) as.double(x[1])) |> unlist()
numbers <- lapply(input, \(x) as.numeric(strsplit(x[2], " ")[[1]]))

# faster than using paste and as.numeric aftewards by 7X
combine2nums <- function(x,y) x * 10^(as.integer(log10(y))+1) + y

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
        # ans <- as.numeric(paste0(ans, nums[k+1]))
        ans <- combine2nums(ans, nums[k+1])
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
# takes around 14-15 seconds, faster version below
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


# Optimised approach, just check from the reverse if any operation is valid, and if yes, 
# keep recursing and trying out each operation
# Based on Verulean314's insights

num_digits <- function(num){
  as.integer(log10(num)) + 1
}

ends_with_num <- function(a, b){
  (a %% 10^num_digits(b)) == b
}

remove_digits <- function(a, b){
  a %/% (10 ^ num_digits(b))
}

check_validity2 <- function(calb, nums, part2 = FALSE){
  
  last <- length(nums)
  if(last == 1){
    return(calb == nums[last])
  }
  if((calb %% nums[last] == 0) && check_validity2(calb / nums[last], nums[-last], part2)) {
    return(TRUE)
  } else if (part2 && ends_with_num(calb, nums[last]) && Recall(remove_digits(calb, nums[last]), nums[-last], part2)) {
    return(TRUE)
  } else {
    return(Recall(calb - nums[last], nums[-last], part2))
  }
}

p1 <- 0
p2 <- 0
for(i in seq_along(cal_values)){
  part1 <- check_validity2(cal_values[i], numbers[[i]], FALSE)
  if(part1){
    p1 <- p1 + cal_values[i]
    p2 <- p2 + cal_values[i]
  } else {
    if(check_validity2(cal_values[i], numbers[[i]], TRUE)){
      p2 <- p2 + cal_values[i]
    }
  }
}

p1
p2

