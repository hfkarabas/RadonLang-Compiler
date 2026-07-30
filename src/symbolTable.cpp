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
    std::cout << "add" << name << "scope=" << scopes.size() -1 << std::endl;
}

Symbol* SymbolTable::get(const std::string& name){
    
    std::cout << "[get]" << name << std::endl;

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
    
    std::cout << "enter scope =" << scopes.size() << std::endl;
}

void SymbolTable::exitScope(){
    if(scopes.size() > 1){
        scopes.pop_back();
    }
    
    std::cout << "exit scope=" << scopes.size() -1 << std::endl;
}