#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <cstdlib>
#include <cstdio>
#include <cerrno>

#include "utils/utils.h"
#include "cli/radoncli.h"

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
            outputPath = inputPath.stem();
        }
        
        if (outputPath.extension() != ".exe" ){
            exeName += ".exe";
        }

        //std::filesystem::create_directories("../bin");

        if(!outputPath.parent_path().empty()){
            std::filesystem::create_directories(outputPath.parent_path());
        }

        std::filesystem::path tempFile = outputPath.parent_path()/"temp_out.cpp";
       // std::string outputPath = "../bin/" + exeName;

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
    yyparse();

    code_out
            << "\nreturn 0;\n"
            << "}\n";

    code_out.close();
    fclose(yyin);

    std::string command = "g++ -I. \"" + tempFile.string() + "\" runtime.cpp -o \"" + outputPath.string() +"\"";
    int result = system(command.c_str());
    printSuccess("Compilation Successful!");

    //std::filesystem::remove(tempFile);
    return result;
}