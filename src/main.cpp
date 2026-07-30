#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <cstdlib>
#include <cstdio>
#include <cerrno>

#include "utils/utils.h"
#include "cli/radoncli.h"
#include "symbolTable.h"

SymbolTable symbolTable;

extern FILE *yyin;
std::ofstream code_out;

extern int yyparse();

int main(int argc, char *argv[])
{
    if (argc == 1)
    {
        showWelcome();
        return 0;
    }

    if (std::string(argv[1]) == "--help"){
        showHelp();
        return 0;
    }

    if (std::string(argv[1]) == "--version"){
        showVersion();
        return 0;
    }

    std::filesystem::path inputPath(argv[1]);

    if(inputPath.extension() != ".rn"){
        printError("Only \".rn\" source files are supported.");
        return 1;
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
            outputPath = "src";
            outputPath /= inputPath.stem();
        }

        if(outputPath.parent_path().empty()){
            outputPath = std::filesystem::path("src") / outputPath;
        } else {
            std::filesystem::create_directories(outputPath.parent_path());
        }
        
        if (outputPath.extension() != ".exe" ){
            outputPath += ".exe";
        }
        std::filesystem::path tempFile = "src/temp_out.cpp";

    code_out.open(tempFile);
   

    if (!code_out){
        printSystemError("Failed to create temp file.");
        fclose(yyin);
        return 1;
    }

    code_out 
    <<"#include <stdio.h>\n"
    <<"#include <stdlib.h>\n"
    <<"#include \"runtime.h\"\n\n"
    <<"int main()\n"
    <<"{\n";
    
    int parseResult = yyparse();

    if(parseResult != 0){
            code_out.close();
            fclose(yyin);
            printError("Compilation Failed");
            return 1;
        }

    code_out
            << "\nreturn 0;\n"
            << "}\n";

        code_out.close();
        fclose(yyin);

    std::string command = "g++ -I. \"" + tempFile.string() + "\" src/runtime.cpp -o \"" + outputPath.string() +"\"";
    // std::cout << command << std::endl;
    int result = system(command.c_str());


    //compileGeneratedCpp();

    if(result == 0)
        printSuccess("Compilation Successful!");
    else
        printError("C++ Compilation Failed");

    //std::filesystem::remove(tempFile);
    return result;
}