%{
#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <cstdlib>
#include <cstdio>

#include "symbolTable.h"
#include "utils/utils.h"
#include "expression.h"

extern int yylex();
extern FILE *yyin;
extern int lineNumber;
void yyerror(const char *s){
    printSyntaxError(s,lineNumber);
}
extern std::ofstream code_out;
extern SymbolTable symbolTable;
%}

%token INT ASSIGN SEMICOLON PLUS MINUS TIMES DIVIDE LPAREN RPAREN LBRACE RBRACE
%token CASE DEFAULT IF SWITCH ELSE FOR DO WHILE GOTO CONTINUE BREAK RETURN SIZEOF
%token EQUAL NEQUAL GEQUAL LEQUAL GREATER LESSTHAN
%token AND OR NOT COMMA INC DEC
%token PRINT

%code requires
{
  #include <expression.h>
}

%union {
    int ival;
    Expression* expr;
    char *sval;
}

%token <ival> NUMBER
%token <sval> IDENTIFIER
%token <sval> STRING

%type <expr> expression

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
    : assignment
    | print_statement
    | block
    ;

block
    : LBRACE
    {
        symbolTable.enterScope();
    }
    statements
    RBRACE
    {
        symbolTable.exitScope();
    }
    ;

assignment
    : IDENTIFIER ASSIGN expression SEMICOLON
    {
        if(!symbolTable.exists($1)){
            Symbol s;
            s.type = "int";
            s.data = $3->code;

            symbolTable.add($1,s);

            code_out << "Value " << $1 << " = " << $3->code << ";\n";
        } else{
            Symbol* s = symbolTable.get($1);

            s->data = $3->code;
            code_out << $1 << " = " << $3->code << ";\n";
        }
    }
    | IDENTIFIER ASSIGN STRING SEMICOLON{

        if(!symbolTable.exists($1)){
            Symbol s;
            s.type = "string";
            s.data = $3;

            symbolTable.add($1,s);

            code_out << "Value " << $1 << " = makeString(" << $3 << "\");\n";
        } else{
            Symbol* s = symbolTable.get($1);
            s->type = "string";
            s->data = $3;
            code_out << $1 << " = makeString(" << $3 << "\");\n";
        }
    }
    ;

expression
    : NUMBER{
        $$ = new Expression();
        $$->code = "makeInt(" + std::to_string($1) + ")";
    }
    | IDENTIFIER{
        Symbol* s = symbolTable.get($1);

        if(s == nullptr){
            printSemanticError("Undefined Variable" + std::string($1) + "'", lineNumber);
            YYERROR;
        }
        $$ = new Expression();
        $$->code = $1;
    }
    | expression PLUS expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + " + " + $3->code + ")";
    }
    | expression MINUS expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + " - " + $3->code + ")";
    }
    | expression TIMES expression
    | expression DIVIDE expression
    | LPAREN expression RPAREN{
        $$ = $2;
    }
    ;

print_statement
    : PRINT LPAREN STRING RPAREN SEMICOLON
      {
        Symbol* s = symbolTable.get($3);

        if(s==nullptr){
            printSemanticError("Undefined Variable" + std::string($3) + "'",lineNumber);
            YYERROR;
        }

        code_out << "printValue(\"" << $3 << "\"))";
      }

    | PRINT LPAREN IDENTIFIER RPAREN SEMICOLON{
       code_out << "printValue(" << $3 << ");\n";
    }
    ;

%%