# RadonLang Compiler

RadonLang Compiler is an experimental compiler project written in **C++**, using **Flex** and **Bison**. It compiles a dynamically typed language into C++ source code, which is then compiled into a native executable.

## Usage

```bash
./compiler.exe --help
```

## Features

- Lexical Analysis (Flex)
- Syntax Analysis (Bison)
- Automatic C++ Code Generation
- Dynamic (Duck) Typing
- Lexical Scope Management
- Variable Shadowing
- Arithmetic and String Operations
- Automatic Variable Declaration
- Global Variable Support
- Semantic Analysis
- Error Detection
- Runtime Type System
- Command-Line Compiler
- Makefile Build System

## Example Syntax

```radon
x = "Age "
y = 25
GLOBAL z = 40

{
    x = "Year "
    y = 2026

    SAY: x + y
    SAY: z
}

SAY: x + y
```

### Output

```text
Year 2026
40
Age 25
```