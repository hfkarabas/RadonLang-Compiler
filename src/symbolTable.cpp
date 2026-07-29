#include "symbolTable.h"

bool SymbolTable::exists(const std::string& name){
    return symbols.find(name) != symbols.end();
}

void SymbolTable::add(const std::string& name, const Symbol& symbol){
    symbols[name] = symbol;
}

Symbol* SymbolTable::get(const std::string& name){
    auto it = symbols.find(name);

    if (it == symbols.end())
        return nullptr;

    return &(it -> second);
}