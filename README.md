# RadonLang Compiler

RadonLang is a simple educational programming language developed using Flex, Bison and C++.

The purpose of this project is to demonstrate the complete compilation pipeline including lexical analysis, parsing, syntax validation and semantic analysis.

## Usage
./compiler.exe --help

## Features
- Lexer (Flex)
- Parser (Bison)
- Duck Typing
- Runtime System
- Lexical Scope
- Automatic C++ Code Generation
- Command-line Compiler
- Makefile Build System

## Example
- x = "Age "
- y = 25
-
- {
-  x = "Year "
-  y = 2026
-  SAY: x + y
- }

- SAY: x + y
