#include "symbolTable.h"
#include <iostream>

bool SymbolTable::exists(const std::string& name){
    for (auto it = scopes.rbegin(); it != scopes.rend(); ++ it){
        if(it->symbols.find(name) != it->symbols.end())
        return true;
    }
    return false;
}

bool SymbolTable::existsCurrentScope(const std::string& name){
    return scopes.back().symbols.find(name) != scopes.back().symbols.end();
    for (auto &p: scopes.back().symbols)
        std::cout << p.first << std::endl;
}
    
bool SymbolTable::existsGlobal(const std::string& name){
    return scopes.front().symbols.find(name) != scopes.front().symbols.end();
}

void SymbolTable::add(const std::string& name, const Symbol& symbol){
    scopes.back().symbols[name] = symbol;
}

void SymbolTable::addGlobal(const std::string& name, const Symbol& symbol){
    scopes.front().symbols[name] = symbol;
    std::cout << "ADD" << name << std::endl;
    std:: cout << "scope size" << scopes.size() << std::endl;
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

