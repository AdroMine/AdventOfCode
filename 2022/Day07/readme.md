# Day 7: [No Space Left On Device](https://adventofcode.com/2022/day/7)

### Question Summary
- **Part 1** - Given output of terminal (cd and ls commands), Find sum of directories that have sum <= 100,000
- **Part 2** - Disk size is 7e7. Require 3e7 free space. Find smallest directory that can be deleted and free up enough space.

### Solution summary 

Create a flat hierarchy of file system

So if we have structure like:

- / (dir)
  - a (dir)
    - e (dir) 
      - i (file ...)
    - f (file ...)
    ...
  - d (dir) 
    - ...

Then we will create a list that will contain:
list['/'] - the top directory
list['//a'] - the a directory (with full path in its name)
list['//a/e'] - the e directory with again path from / to e in its name

each list item is a list containing 3 items:
  - parent - name of parent
  - size - 0 for directories initially, for files as provided
  - child - any files within that directory

Once we parse through the input and have created the file hierarchy, then we can go through each directory to determine its size (sum of files within it). If that directory has a parent, then we add its size to its parents size (and parent of parent and so on)

After this we have the correct sizes of each directory available to us. 

For part 1, we just find which directories have sum less than or equal to 1e5 and take their sum. 

For part 2, we determine the space required (Disk size is 7e7, space required is 3e7). So we determine disk usage (size of / folder) and subtract it from 3e7 to get what we need to free up. Then we just determine the smallest directory size greater than required. 
