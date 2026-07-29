#pragma once
#include <unordered_map>
#include <string>

struct Symbol {
    std::string type;
    std::string data;
};

class SymbolTable{
    public:
        bool exists(const std::string& name);
        void add(const std::string& name, const Symbol& symbol);
        Symbol* get(const std::string& name);

    private:
        std::unordered_map<std::string, Symbol> symbols;
};

