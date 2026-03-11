# ParseC - C Syntax Validator (PE2)

CC = gcc
FLEX = flex
BISON = bison
CFLAGS = -Wall

SRC_DIR = ./src
BUILD_DIR = ./build

# Source files
PARSER_Y = $(SRC_DIR)/parser.y
LEXER_L  = $(SRC_DIR)/lexer.l

# Generated files
PARSER_C = $(BUILD_DIR)/parser.tab.c
PARSER_H = $(BUILD_DIR)/parser.tab.h
LEXER_C  = $(BUILD_DIR)/lex.yy.c

# Output
TARGET = $(BUILD_DIR)/parser

.PHONY: all clean test

all: $(TARGET)

$(TARGET): $(PARSER_C) $(LEXER_C)
	$(CC) $(CFLAGS) -I$(BUILD_DIR) -o $@ $^

$(PARSER_C) $(PARSER_H): $(PARSER_Y)
	$(BISON) -d -o $(PARSER_C) $<

$(LEXER_C): $(LEXER_L) $(PARSER_H)
	$(FLEX) -o $@ $<

clean:
	rm -f $(BUILD_DIR)/*

test: $(TARGET)
	@echo "=== Test 1: Valid declarations ==="
	@./$(TARGET) input/test1.c && echo "" || echo ""
	@echo "=== Test 2: Control statements ==="
	@./$(TARGET) input/test2.c && echo "" || echo ""
	@echo "=== Test 3: Syntax errors ==="
	@./$(TARGET) input/test3_invalid.c && echo "" || echo ""
