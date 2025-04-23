# MinimalOS-StorageManager
 

**MinimalOS-StorageManager** is a minimal storage management system built in MIPS assembly. It is designed as a component of a custom operating system to manage storage devices (hard-disk or SSD). The project implements basic file operations, memory allocation, and defragmentation for both unidimensional and bidimensional memory models, focusing on efficient resource management and low-level hardware interaction.

## Features

### Unidimensional Memory Management
- **Fixed Storage Capacity**: Simulated storage device with a fixed capacity of 8MB, divided into 8kB blocks.
- **File Storage**:
  - Each file requires at least two contiguous blocks for storage.
  - Files are stored contiguously; if contiguous space is unavailable, storage fails.
- **File Operations**:
  - Add a file: Allocates the first available contiguous block interval for the file.
  - Get file location: Returns the start and end block interval for a given file descriptor.
  - Delete a file: Frees the blocks occupied by the file by resetting their descriptor to 0.
  - Defragmentation: Reorganizes files to occupy consecutive blocks starting from block 0, eliminating gaps.

### Example Operations
- **Add File**: Allocates blocks for a file based on its size and descriptor.
- **Get File Location**: Returns the block interval for a file.
- **Delete File**: Frees the blocks occupied by a file.
- **Defragmentation**: Compacts memory to optimize storage and reduce fragmentation.

## How to Run

Command to obtain the executable:
```bash
gcc -m32 143_Donea_Fernando-Emanuel_0.s -o task1 -no-pie -z noexecstack
```
Command to run the executable:
```bash
./task1 < input.txt
```
