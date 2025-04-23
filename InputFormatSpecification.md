# Input Format Specification

This document outlines the format for the input data used in the program.


### Input Format
1. The first line contains the number `OP`, representing the number of operations.
2. Starting from the second line, each operation is encoded as follows:
   - **1 - ADD**:  
     ```
     1
     N
     fd1
     size1
     fd2
     size2
     ...
     fdN
     sizeN
     ```
     - `N`: Number of files to be added.
     - `fdX`: File descriptor.
     - `sizeX`: File size in kB.
   - **2 - GET**:  
     ```
     2
     fd
     ```
     - `fd`: File descriptor to retrieve.
   - **3 - DELETE**:  
     ```
     3
     fd
     ```
     - `fd`: File descriptor to delete.
   - **4 - DEFRAGMENTATION**:  
     ```
     4
     ```

# Example
### Input
```
4 
1
5
1
124
4
350
121
75
254
1024
70
30
2
121
3
4
4
```
### Explanation
```
1. **4 operations** are performed.
2. **ADD** operation:
   - 5 files are added with descriptors and sizes:
     - `1: 124 kB`
     - `4: 350 kB`
     - `121: 75 kB`
     - `254: 1024 kB`
     - `70: 30 kB`
3. **GET** operation for file descriptor `121`.
4. **DELETE** operation for file descriptor `4`.
5. **DEFRAGMENTATION** operation.
```

### Ouput
```
1: (0, 15)
4: (16, 59)
121: (60, 69)
254: (70, 197)
70: (198, 201)
(60, 69)
1: (0, 15)
121: (60, 69)
254: (70, 197)
70: (198, 201)
1: (0, 15)
121: (16, 25)
254: (26, 153)
70: (154, 157)
```
