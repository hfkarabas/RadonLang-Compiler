#pragma once

#include <iostream>
#include <cstring>
#include <cerrno>

extern int yylineno;

#define RESET "\e[0m"
#define RED "\e[31m"
#define GREEN "\e[32m"
#define YELLOW "\e[33m"
#define CYAN "\e[36m"

inline void printError(const std::string& msg){
    std::cerr << RED << "[ERROR] " << msg << RESET << std::endl;
}

inline void printSystemError(const std::string& msg){
    std::cerr << RED << "[ERROR] " << msg << ":" << strerror(errno) << RESET << std::endl;
}

inline void printSyntaxError(const std::string& msg, int line){
    std::cerr << RED << "[SYNTAX ERROR] Line " << line << ":" << RESET << std::endl;
}

inline void printSemanticError(const std::string& msg, int line){
    std::cerr << RED << "[SEMANTIC ERROR] Line " << line << ":" << RESET << std::endl;
}

inline void printSuccess(const std::string& msg){
    std::cerr << GREEN << "[SUCCESS] " << msg << RESET << std::endl;
}

inline void printInfo(const std::string& msg){
    std::cerr << CYAN << "[INFO] " << msg << RESET << std::endl;
}

inline void printWarning(const std::string& msg){
    std::cerr << YELLOW << "[WARNING] " << msg << RESET << std::endl;
}