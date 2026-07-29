#pragma once
#include <unordered_map>
#include <string>
#include <vector>

struct Symbol {
    std::string type;
    std::string data;
};

class SymbolTable{
    public:
        SymbolTable();

        bool exists(const std::string& name);
        void add(const std::string& name, const Symbol& symbol);
        Symbol* get(const std::string& name);

        struct Scope{
            std::unordered_map<std::string, Symbol> symbols;
            };

        void enterScope();
        void exitScope();

    private:
        std::vector<Scope> scopes;

    
};