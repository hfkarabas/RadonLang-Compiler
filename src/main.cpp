#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <cstdlib>
#include <cstdio>

extern FILE *yyin;
extern FILE *code_out;

extern int yyparse();

int main(int argc, char *argv[])
{
    std::filesystem::path inputPath(argv[1]);

    if(inputPath.extension() != ".rn"){
        std::cerr << "Error: Only \".rn\" source files are supported." << std::endl;
    }

    if (argc<2)
    {
        std::cout << "Usage:" << argv[0] << "<input_file> [output_name]\n";
        return 1;
    }

    yyin = fopen(argv[1], "r");

    if (yyin == nullptr)
    {
        perror("Cannot open input file");
        return 1;
    }

    std::string exeName;
    if (argc >= 3){
        exeName = argv[2];
        }
        
        else{
            std::filesystem::path inputPath(argv[1]);
            exeName = inputPath.stem().string();
        }
        
        if (exeName.size() < 4 || exeName.substr(exeName.size() -4) != ".exe" ){
            exeName += ".exe";
        }

        std::filesystem::create_directories("../bin");

        std::string tempFile = "../bin/temp_out.c";
        std::string outputPath = "../bin/" + exeName;

    code_out = fopen(tempFile.c_str(),"w");
    if (!code_out){
        perror("Create temp C file failed");
        fclose(yyin);
        return 1;
    }

    fprintf(code_out,   "#include <stdio.h>\n"
                        "#include <stdlib.h>\n\n"
                        "int main()\n"
                        "{\n");
    yyparse();

    fprintf(code_out,
            "\nreturn 0;\n"
            "}\n");
    fclose(code_out);
    fclose(yyin);

    std::string command = "gcc \"" + tempFile + "\" -o \"" + outputPath +"\"";
    int result = system(command.c_str());

    remove(tempFile.c_str());
    return result;
}