%{
#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <cstdlib>
#include <cstdio>

#include "symbolTable.h"

extern int yylex();
extern FILE *yyin;
void yyerror(const char *s);
extern std::ofstream code_out;
%}

%token INT ASSIGN SEMICOLON PLUS MINUS TIMES DIVIDE LPAREN RPAREN LBRACE RBRACE
%token CASE DEFAULT IF SWITCH ELSE FOR DO WHILE GOTO CONTINUE BREAK RETURN SIZEOF
%token EQUAL NEQUAL GEQUAL LEQUAL GREATER LESSTHAN
%token AND OR NOT COMMA INC DEC
%token PRINT

%union {
    int ival;
    char *sval;
}

%token <ival> NUMBER
%token <sval> IDENTIFIER
%token <sval> STRING

%type <ival> expression

%left PLUS MINUS
%left TIMES DIVIDE

%%
program
    : statements
    ;

statements
    : statements statement
    | statement
    ;

statement
    : declaration
    | assignment
    | print_statement
    ;

declaration
    : INT IDENTIFIER ASSIGN expression SEMICOLON{
        symbolTable[$2].type = "int";
        symbolTable[$2].data = std::to_string($4);
        code_out << "Value " << $2 << " = makeInt(" << $4 << ");\n";
    }
    ;

assignment
    : IDENTIFIER ASSIGN expression SEMICOLON{
        symbolTable[$1].data = std::to_string($3);
        code_out << $1 << " = makeInt(" << $3 << ");\n";
    }
    | IDENTIFIER ASSIGN STRING SEMICOLON{
        symbolTable[$1].type = "string";
        symbolTable[$1].data = $3;

        code_out << $1 << " = makeString(\"" << $3 << "\");\n";
    }
    ;

expression
    : NUMBER{
        $$ = $1;
    }
    | IDENTIFIER{
        $$ = std::stoi(symbolTable[$1].data);
    }
    | expression PLUS expression
    | expression MINUS expression
    | expression TIMES expression
    | expression DIVIDE expression
    | LPAREN expression RPAREN{
        $$ = $2;
    }
    ;

print_statement
    : PRINT LPAREN STRING RPAREN SEMICOLON
      {
        // fprintf(code_out, "   printf(\"%s\");\n printf(\"\\n\");\n", $3);
        // code_out << "   printf(\"" << $3 << "\");\n";
        // code_out << "printf(\"\\n\");\n";
        code_out << "printValue(makeString(\"" << $3 << "\"))";
      }

    | PRINT LPAREN IDENTIFIER RPAREN SEMICOLON{
       // code_out << "printf(\"%d\\n\","<< $3 << ");\n";
       code_out << "printValue(" << $3 << ");\n";
    }
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error!\n");
}