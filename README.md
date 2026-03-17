# ParseC - C Syntax Validator

A YACC/Bison parser to validate the syntax of a simplified subset of C. Programming Exercise 2 (PE2) for Compiler Design.

## Features

- Variable declarations with basic types (`int`, `float`, `char`, `double`) and comma-separated declarators
- Variable declaration with initialization (for example: `int a = 5, b, c, d = 10;`)
- Array declarations with multiple dimensions (for example: `int a[15];`, `int a[10][10];`, `int a[1][2][3][4];`, `int a[4][4], b[5];`)
- `if`, `if-else`, `do-while`, `while`, `for`, and `switch` control statements with nested block support
- Arithmetic expressions (`+`, `-`, `*`, `/`, `%`)
- Relational and logical expressions (`==`, `!=`, `<`, `>`, `<=`, `>=`, `&&`, `||`)
- Comment handling (single-line `//` and multi-line `/* */`)
- Line-accurate error reporting

## Build

```
make
```

## Usage

```
./build/parser <source_file.c>    # Validate a file
./build/parser                     # Read from stdin
```

## Example

```
./build/parser input/test1.c
```

Output:

```
Syntax valid.
```

```
./build/parser input/test3_invalid.c
```

Output:

```
Syntax error at line 3, token float: syntax error
```

## Run Tests

```
make test
```

## Clean

```
make clean
```

## Project Structure

```
ParseC/
├── src/
│   ├── lexer.l           # Flex lexer specification
│   └── parser.y          # Bison parser grammar
├── input/                # Test files
├── build/                # Compiled output
├── Makefile
└── README.md
```
