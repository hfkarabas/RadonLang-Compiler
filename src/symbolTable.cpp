#include "symbolTable.h"
#include <iostream>

bool SymbolTable::exists(const std::string& name){
    for (auto it = scopes.rbegin(); it != scopes.rend(); ++ it){
        if(it->symbols.find(name) != it->symbols.end())
        return true;
    }
    return false;
}

void SymbolTable::add(const std::string& name, const Symbol& symbol){
    scopes.back().symbols[name] = symbol;
}

Symbol* SymbolTable::get(const std::string& name){
    
    for (auto it = scopes.rbegin(); it != scopes.rend(); ++ it){
        auto symbol = it->symbols.find(name);

        if (symbol != it->symbols.end())
            return &symbol->second;
    }
    return nullptr;
}

SymbolTable::SymbolTable(){
    scopes.push_back(Scope{});
}

void SymbolTable::enterScope(){
    scopes.push_back(Scope{});
}

void SymbolTable::exitScope(){
    if(scopes.size() > 1){
        scopes.pop_back();
    }
}

bool SymbolTable::existsCurrentScope(const std::string& name){
    return scopes.back().symbols.find(name) != scopes.back().symbols.end();
}