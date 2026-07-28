#include <iostream>

#include "radonCli.h"

const std::string ver = "0.1.0";

void showWelcome(){
    std::cout << "RadonLang Compiler v" << ver << "\n\n";
    std::cout << "compiler.exe <input_file> [output_name]\n";
    std::cout << "--version     Show compiler version\n";
    std::cout << "--help        Show this help message\n";
}

void showHelp(){
    std::cout << "--version     Show compiler version\n";
    std::cout << "--help        Show this help message\n";
}

void showVersion(){
    std::cout << "RadonLang Compiler v" << ver << "\n\n";
}