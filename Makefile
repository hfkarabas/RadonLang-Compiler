CXX = g++

CXXFLAGS = -std=c++17 -Isrc -I.

BISON = bison
FLEX = flex

PARSER = src/parser.y
LEXER = src/lexer.l

TARGET = src/compiler.exe

SOURCES = $(filter-out src/temp_out.cpp,$(wildcard src/*.cpp)) \
	$(wildcard cli/*.cpp) \

all: parser lexer build

parser:
	$(BISON) -d -o src/parser.tab.cpp $(PARSER)

lexer:
	$(FLEX) -o src/lex.yy.cpp $(LEXER)

build:
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $(TARGET)

clean:
	rm -f src/compiler.exe
	rm -f src/parser.tab.cpp
	rm -f src/lex.yy.cpp
	rm -f src/parser.tab.hpp