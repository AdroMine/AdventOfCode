# Day 4: Passport Processing - [Link](https://adventofcode.com/2020/day/4)

### Question Summary
Passport data available in the form of key:value format, with each passport containing upto 8 fields.
cid is optional field, rest are mandatory. 

- **Part 1** - find number of records with all mandatory fields present
- **Part 2** - field wise validity rules provided for each field. Find no of valid records

### Solution summary 
1. First parse to find blank lines and using these idx, separate records into one line per record. 
2. Read in records as data.frame (using data.table which can handle missing fields easily)
3. Currently column names do not mean anything so, 
3. Convert to long form (passport#:field_value), separate out field_value to field and value
4. remove NAs and pivot back to wide form. We get a table with passport id and 8 columns for the 8 fields. 
5. Now for part 1 compute rowwise if all seven required fields are present
6. For part 2, compute column wise which fields are valid or not according to given rules