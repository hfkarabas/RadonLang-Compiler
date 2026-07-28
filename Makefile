CXX = g++

CXXFLAGS = -std=c++17 -lsrc

TARGET = src/compiler.exe

SOURCES = $(wildcard src/*.cpp) \
	$(wildcard src/cli/*.cpp)

SOURCES += src/parser.tab.cpp src/lex.yy.cpp

all:
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $(TARGET)

parser:
	$(BISON) -d -o src/parser.tab.tpp $(PARSER)

lexer:
	$(FLEX) -o src/lex.yy.cpp $(LEXER)

clean:
	rm -f src/compiler.exe
	rm -f src/parser.tab.cpp
	rm -f src/lex.yy.cpp
	rm -f src/parser.tab.hpp