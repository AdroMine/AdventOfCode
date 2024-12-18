setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example1.txt'
file_name <- 'input.txt'

input <- strsplit(readr::read_file(file_name), "\n\n")[[1]]
registers <- as.numeric(stringr::str_extract_all(input[1], "\\d+")[[1]])
program <- as.numeric(stringr::str_extract_all(input[2], "\\d+")[[1]])               

# registers <- c(729, 0, 0)
# program <- c(0, 1, 5, 4, 3, 0)

output <- ""

i <- 1

while(i <= length(program)){
  
  opcode <- program[i]
  operand <- program[i + 1]
  i <- i + 2
  
  
  # operand
  # 0-3 = 0-3
  # 4 - register A
  # 5 - register B
  # 6 - register C
  # 7 - reserved and will not appear
  
  value <- if(operand %in% 0:3) operand else registers[operand - 3]
  
  # opcode 0 - adv (division) A / 2^operand truncated to integer -> A
  # opcode 1 - bxl (bitwise xor) register B and literal operand -> B
  # opcode 2 - bst combo operand modulo 8 -> B
  # opcode 3 - jnz (nothing if A = 0, else set instruction pointer to this value)
  # opcode 4 - bxc (bitwise XOR B | C) -> B (reads an operand, but ignores it)
  # opcode 5 - out combo operand modulo 8 -> outputs the value
  # opcode 6 - bdv A / 2^operand truncated to integer -> B
  # opcode 7 - cdv A / 2^operand truncated to integer -> C
  
  if(opcode == 0){
    registers[1] <- as.integer(registers[1] / (2^value)) # combo operand
  } else if (opcode == 1){
    registers[2] <- bitwXor(registers[2], operand) # literal operand
  } else if (opcode == 2){
    registers[2] <- value %% 8
  } else if (opcode == 3){
    if(registers[1] != 0){
      i <- operand + 1 # since index starts from 1
    } 
  } else if (opcode == 4){
    registers[2] <- bitwXor(registers[2], registers[3])
  } else if (opcode == 5){
    output <- paste0(output, value %% 8, sep = ",")
  } else if (opcode == 6){
    registers[2] <- as.integer(registers[1] / (2^value))
  } else if (opcode == 7){
    registers[3] <- as.integer(registers[1] / (2^value))
  }
  
}

output

# Part 2
# Operations 2 4   1 5   7 5   1 6   4 1   5 5   0 3   3 0
# B = A % 8 
# A = A / (2^B)
# C = A / (2^B)
# B = xor(B, 6)
# B = xor(B, C)
# output += B % 8
# A = A / (2^3) or A / 8
# Jump to start if A != 0
# B values should be from end to start -> 0 3 3 0 5 5 1 4 6 1 5 7 5 1 4 2 or these + 8n
