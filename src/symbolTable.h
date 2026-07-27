#pragma once
#include <unordered_map>
#include <string>

struct Symbol {
    std::string type;
    std::string data;
};

extern std::unordered_map <std::string, Symbol> symbolTable;