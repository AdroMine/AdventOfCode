setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(purrr)
library(data.table)
library(dplyr)
library(tidyr)

input <- readLines("input.txt")

# Find where records start and end
n_line <- which(input == '')
record_start_idx <- c(1, n_line + 1)
record_end_idx <- c(n_line - 1, length(input))

# Create one line per record
records <- map2_chr(record_start_idx, record_end_idx, function(s,e) {
    paste(input[s:e], collapse = ' ')
})

# Convert to table with 8 columns (each column contains key:value pairs)
df <- fread(text = records, fill = TRUE)
df[, id:= 1:nrow(df)]

# Clean data to separate key value pairs into separate columns
df2 <- df %>% 
    pivot_longer(-id, values_to = "val") %>%
    separate(val, into = c("field", "text"),sep = ":") %>% 
    na.omit() %>% 
    select(-name) %>% 
    pivot_wider(id_cols = id, names_from = field, values_from = text, values_fill = NA) %>% 
    rowwise(id) %>% 
    mutate(valid = !any(is.na(c_across(hcl:byr)))) %>% 
    ungroup() %>% 
    mutate(across(c(iyr, eyr, byr), as.numeric))

# Part 1 Solution
sum(df2$valid)

# Part 2 Solution

# function for computing if height|hgt is valid
valid_height <- function(x){
    valid <- rep(FALSE, length(x))
    which_cm <- grep("cm$", x)
    which_in <- grep("in$", x)
    valid[which_cm] <- between(as.numeric(gsub("cm", "", x[which_cm])), 150, 193)
    valid[which_in] <- between(as.numeric(gsub("in", "", x[which_in])), 59, 76)
    valid
}

# Compute validity (changing original fields)
df3 <- df2 %>% 
    mutate(across(c(iyr, eyr, byr), as.numeric)) %>% 
    mutate(byr = between(byr, 1920, 2002), 
           iyr = between(iyr, 2010, 2020), 
           eyr = between(eyr, 2020, 2030), 
           hgt = valid_height(hgt), 
           hcl = grepl("^#[0-9a-f]{6}", hcl), 
           ecl = ecl %in% c('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'), 
           pid = grepl("^[0-9]{9}$", pid)) %>% 
    select(-cid) %>% 
    rowwise(id) %>% 
    mutate(valid2 = all(c_across())) 

# Answer
sum(df3$valid2)
