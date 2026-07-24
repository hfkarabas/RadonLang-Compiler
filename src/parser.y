%{
#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <cstdlib>
#include <cstdio>

using namespace std;

extern int yylex();
extern FILE *yyin;
void yyerror(const char *s);
FILE *code_out;
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
    : INT IDENTIFIER ASSIGN expression SEMICOLON
    ;

assignment
    : IDENTIFIER ASSIGN expression SEMICOLON
    ;

expression
    : NUMBER 
    {
        printf("%d\n", $1);
    }
    | IDENTIFIER
    | expression PLUS expression
    | expression MINUS expression
    | expression TIMES expression
    | expression DIVIDE expression
    | LPAREN expression RPAREN
    ;

print_statement
    : PRINT LPAREN STRING RPAREN SEMICOLON
      {
          fprintf(code_out, "   printf(\"%s\");\n printf(\"\\n\");\n", $3);
      }
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error!\n");
}