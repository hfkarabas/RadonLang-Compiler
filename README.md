# RadonLang Compiler

RadonLang Compiler is an experimental compiler project written in C++, using Flex and Bison. It compiles a dynamically typed language into C++ source code, which is then compiled into a native executable.

## Usage
./compiler.exe --help

## Features
- Lexical Analysis (Flex)
- Syntax Analysis (Bison)
- Automatic C++ Code Generation
- Dynamic (duck) Typing
- Lexical Scope Management
- Variable Shadowing
- Arithmetic and String Operations
- Automatic variable declaration
- Semantic analysis
- Error Detection
- Runtime Type System
- Command-line Compiler
- Makefile Build System



## Example Syntax
- x = "Age "
- y = 25
-
- {
-     x = "Year "
-     y = 2026
-     SAY: x + y
- }

- SAY: x + y

- Output: 
- Year 2026
- Age 25