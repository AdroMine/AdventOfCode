setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'example2.txt'
file_name <- 'input.txt'

input <- strsplit(readr::read_file(file_name), "\n\n")[[1]]

input1 <- strsplit(strsplit(input[1], "\n")[[1]], ": ")
wires <- strsplit(strsplit(input[2], "\n")[[1]], " ")

bits_to_integer <- function(bits){
  sum(bits * (2^seq(length(bits) - 1, 0)))
}


gates <- list()
for(gate in input1){
  # gates$set(gate[1], as.integer(gate[2]))
  gates[[gate[1]]] <- as.integer(gate[2])
}
for(wire in wires){
  if(!wire[1] %in% names(gates)){
    gates[[wire[1]]] <- -1
  }
  if(!wire[3] %in% names(gates)){
    gates[[wire[3]]] <- -1
  }
  if(!wire[5] %in% names(gates)){
    gates[[wire[5]]] <- -1
  }
}

z_gates <- names(gates) |> unlist() |> sort() |> grep("^z", x = _, value = TRUE)
x_gates <- names(gates) |> unlist() |> sort() |> grep("^x", x = _, value = TRUE)
y_gates <- names(gates) |> unlist() |> sort() |> grep("^y", x = _, value = TRUE)

gate_flow <- function(gates, wires){
  
  while(any(unlist(gates[z_gates]) == -1)){
    
    new_wires <- wires
    for(i in seq_along(wires)){
      if(wires[[i]][1] == 'skip') next
      
      w1 <- wires[[i]][1]
      op <- wires[[i]][2]
      w2 <- wires[[i]][3]
      w3 <- wires[[i]][5]
      
      if((gates[[w1]] == -1) || (gates[[w2]] == -1)) {
        next
      }
      gates[[w3]] <- switch(op, 
                            "AND" = gates[[w1]] & gates[[w2]], 
                            "OR"  = gates[[w1]] | gates[[w2]], 
                            "XOR" = base::xor(gates[[w1]], gates[[w2]]), 
                            stop("Not a valid operation"))
      new_wires[[i]] <- 'skip'
    }
    wires <- new_wires
    
  }
  # gates
  k <- gates[z_gates] |> unlist() |> rev()
  # as.character(sum(k * (2^seq(length(z_gates) - 1, 0))))
  bits_to_integer(k)
}

as.character(gate_flow(gates, wires))


# Part 2



find_part2_gate <- function(wire, wire_mat){
  
  nxt <- wire_mat[wire_mat[,1] == wire | wire_mat[,3] == wire,5]
  out_g <- startsWith(nxt, 'z')
  if(any(out_g)){
    ans <- nxt[which(out_g)]
    # subtract one from this gate number
    return(sprintf("z%02d", as.integer(substr(ans, 2, 3)) - 1))
  } else {
    return(find_part2_gate(nxt, wire_mat))
  }
  
}


correct_gates <- function(wires, gates){
  
  # 45 bit ripple carry adder chaining 45 1-bit adders each bit connected to carry bit of
  # all previous adders. 
  
  # each output bit is computed using a, b and carry bit c. 
  
  # output = a xor b xor c
  # nxt carry bit = (a AND b) OR ((a XOR b) AND c)
  
  # Rule 1 - if output gate is z, operation has to be xor unless last z gate
  # Rule 2 - if output gate is not z, and inputs are not x,y, then it should be AND/OR not XOR
  # After these 6 there are still 2 gates left. One carry bit got messed up somewhere
  # so we need to find a x## and y## operation that is incorrect. We can search through
  # the 0-44 gates and swap their outputs one by one until we get the result
  
  # find cases where above conditions are met
  
  # Rule 1 & 2
  incorrect1 <- list()
  incorrect2 <- list()
  for(wire in wires){
    if(startsWith(wire[5], 'z') && 
       (wire[5] != 'z45') && 
       (wire[2] != "XOR")){
      incorrect1 <- c(incorrect1, list(wire))
    }
    if(!startsWith(wire[5], 'z') &&
       !grepl('^x|y', wire[1]) && 
       !grepl("^x|y", wire[3]) && 
       wire[2] == "XOR"){
      incorrect2 <- c(incorrect2, list(wire))
    }
  }
  
  wire_mat <- do.call(rbind, wires)
  
  # we find 6 incorrect gates here
  for(pos in incorrect2){
    
    swap_gate   <- find_part2_gate(pos[5], wire_mat)
    # assert this gate does exist in incorrect1 list
    stopifnot(any(sapply(incorrect1, \(x) swap_gate == x[5])))
    
    replace_idx1 <- which(wire_mat[,5] == swap_gate)
    g1 <- wires[[replace_idx1]][5]
    
    replace_idx2 <- match(list(pos), wires)
    g2 <- pos[5] # wires[[]]
    wires[[replace_idx1]][5] <- g2
    wires[[replace_idx2]][5] <- g1
    
  }
  
  # two swaps left
  x_val <- gates[x_gates] |> unlist() |> rev() |> bits_to_integer()
  y_val <- gates[y_gates] |> unlist() |> rev() |> bits_to_integer()
  res <- (x_val + y_val) # correct sum
  inc_res <- gate_flow(gates, wires) # currently incorrect result from adder
  
  wire_mat <- do.call(rbind, wires)
  # search through each x## and swap their outputs until we get the result right
  found <- FALSE
  for(i in 0:44){
    
    check <- sprintf("x%02d", i)
    new_wires <- wires
    
    incorrect3 <- apply(wire_mat[wire_mat[,1] == check | wire_mat[,3] == check,], 1, list) |> unlist(recursive = FALSE)
    idx1 <- match(incorrect3[1], wires)
    idx2 <- match(incorrect3[2], wires)
    g1 <- wires[[idx1]][5]
    g2 <- wires[[idx2]][5]
    new_wires[[idx1]][5] <- g2
    new_wires[[idx2]][5] <- g1
    
    new_res <- gate_flow(gates, new_wires)
    if(res == new_res){
      found <- TRUE
      break
    }
  }
  if(!found) stop("Ohho")
  
  c(sapply(incorrect1, `[[`, 5), 
    sapply(incorrect2, `[[`, 5), 
    g1, g2) |> 
  sort() |> 
  paste0(collapse = ",")
  
}

correct_gates(wires, gates)
