#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <cstdlib>
#include <cstdio>
#include <cerrno>

#include "utils.h"

extern FILE *yyin;
std::ofstream code_out;

extern int yyparse();

const std::string ver = "0.1.0"; 
int main(int argc, char *argv[])
{
    if (argc<2)
    {
        std::cout << "Try --help for more information.\n";
        return 1;
    }

    if (std::string(argv[1]) == "--help"){
        std::cout << "RadonLang Compiler v" << ver << "\n\n";
        std::cout << "compiler.exe <input_file> [output_name]\n";
        std::cout << "--version     Show compiler version\n";
        std::cout << "--help        Show this help message\n";
        return 0;
    }

    if (std::string(argv[1]) == "--version"){
        std::cout << "RadonLang Compiler v" << ver << "\n\n";
        return 0;
    }

    std::filesystem::path inputPath(argv[1]);

    if(inputPath.extension() != ".rn"){
        printError("Only \".rn\" source files are supported.");
    }

    

    yyin = fopen(argv[1], "r");

    if (yyin == nullptr)
    {
        printSystemError("Failed to open input file.");
        return 1;
    }

    std::string exeName;
    std::filesystem::path outputPath;


    if (argc >= 3){
        outputPath = argv[2];
        }
        
        else{
            outputPath = inputPath.stem();
        }
        
        if (outputPath.extension() != ".exe" ){
            exeName += ".exe";
        }

        //std::filesystem::create_directories("../bin");

        if(!outputPath.parent_path().empty()){
            std::filesystem::create_directories(outputPath.parent_path());
        }

        std::filesystem::path tempFile = outputPath.parent_path()/"temp_out.c";
       // std::string outputPath = "../bin/" + exeName;

    code_out.open(tempFile);
   

    if (!code_out){
        printSystemError("Failed to create temp file.");
        fclose(yyin);
        return 1;
    }

    code_out 
    <<"#include <stdio.h>\n"
    <<"#include <stdlib.h>\n\n"
    <<"int main()\n"
    <<"{\n";
    yyparse();

    code_out
            << "\nreturn 0;\n"
            << "}\n";

    code_out.close();
    fclose(yyin);

    std::string command = "gcc \"" + tempFile.string() + "\" -o \"" + outputPath.string() +"\"";
    int result = system(command.c_str());
    printSuccess("Compilation Successful!");

    //std::filesystem::remove(tempFile);
    return result;
}