# Assembly Memory Manager

## Overview
## alloc
This is a custom Memory Manager written in x86 Assembly.

## toupper
This is a x86 Assembly Programme that take a file and outputs a version of the file with uppercase letters.

## Purpose

The purpose of these programs is to learn about assembly language and computer architecture.

## Usage by Example

- **Assemble:**
Ensure you have a suitable assembler(GNU Assembler) installed on your system.
Assemble the source code using the following command:
```
as alloc.s -o alloc.o
```
- **Linking:**
Link the object file with your own program, as this Memory Manager is not a standalone program.

## toupper
- **Assemble:**
```
as -g -o toupper.o toupper.s
```
- **Linking:**
```
ld -o toupper toupper.o
```
- **Execution**
```
./toupper input.txt output.txt
```
