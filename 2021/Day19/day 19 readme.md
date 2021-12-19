# Day 19: Beacon Scanner[Link](https://adventofcode.com/2021/day/19)

### Question Summary
- **Part 1** - Scanners and beacons scattered in ocean. Each scanner can scan beacons in a 1000 range in x,y,z directions, with positions relative to it. Number of scanners and the beacons they have detected is input. The scanners might have different orientations (x,y,z, total 24 orientations possible). If any two scanners have 12 beacons in common, we can determine the relative locations of beaconds compared to the first scanner. Need to determine the total number of scanners. 
- **Part 2** - Find the positions of scanners and then find the largest manhattan distance between any two scanners. 

### Solution summary 

- Assume first scanner at 0,0,0
- For each scanner except the first one, get all 24 possible rotations. 
- For each rotation, subtract the positions of each point in first scanner from each point in the rotated. All beacons that match will have the same difference (a,b,c). 
- If there are more than 12 matches, we have found the correct rotation and the center for the new scanner as well as the locations of beacon only seen by the second scanner in terms of the first scanner. 
- Keep repeating the above, until we have found the locations of all scanners. 


