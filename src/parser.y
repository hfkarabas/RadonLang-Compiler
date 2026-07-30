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
extern int lineNumber;
void yyerror(const char *s){
    printSyntaxError(s,lineNumber);
}
extern std::ofstream code_out;
extern SymbolTable symbolTable;

Expression* makeExpression(const std::string& code){%code requires
{
    Expression* expr = new Expression();
    expr->code = code;
    return expr;
}
}
%}

%code requires
{
  #include <expression.h>
}

%union {
    int ival;
    Expression* expr;
    char *sval;
}

%token INT ASSIGN SEMICOLON PLUS MINUS TIMES DIVIDE LPAREN RPAREN LBRACE RBRACE
%token CASE DEFAULT IF SWITCH ELSE FOR DO WHILE GOTO CONTINUE BREAK RETURN SIZEOF
%token EQUAL NEQUAL GEQUAL LEQUAL GREATER LESSTHAN
%token AND OR NOT COMMA INC DEC
%token PRINT

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
    : 
    |statements statement
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
            Symbol symbol;
            symbol.type = "int";

            symbolTable.add($1,symbol);

            code_out << "Value " << $1 << " = " << $3->code << ";\n";
        } else{
            code_out << $1 << " = " << $3->code << ";\n";
        }
        delete $3;
    }
    ;

expression
    : NUMBER
    {
        $$ = makeExpression("makeInt(" + std::to_string($1) + ")");
    }
    | IDENTIFIER
    {
        Symbol* s = symbolTable.get($1);

        if(s == nullptr){
            printSemanticError("Undefined Variable" + std::string($1) + "'", lineNumber);
            YYERROR;
        }
        $$ = makeExpression($1);
    }
    | LPAREN expression RPAREN{
        $$ = makeExpression("(" + $2->code + ")");
        delete $2;
    }
    | expression PLUS expression{
        $$ = makeExpression("(" + $1->code + " + " + $3->code + ")");
        delete $1;
        delete $3;
    }
    | expression MINUS expression{
        $$ = makeExpression("(" + $1->code + " - " + $3->code + ")");
        delete $1;
        delete $3;
    }
    | expression TIMES expression{
        $$ = makeExpression("(" + $1->code + " * " + $3->code + ")");
        delete $1;
        delete $3;

    }
    | expression DIVIDE expression{
        $$ = makeExpression("(" + $1->code + " / " + $3->code + ")");
        delete $1;
        delete $3;
    }
    ;

print_statement
    : PRINT LPAREN IDENTIFIER RPAREN SEMICOLON{
        Symbol* s = symbolTable.get($3);

        if(s == nullptr){
            printSemanticError(
                "Undefined variable " + std::string($3) + "'", lineNumber
            );
            YYERROR;
        }
       code_out << "printValue(" << $3 << ");\n";
    }
    
    | PRINT LPAREN STRING RPAREN SEMICOLON
      {
        code_out << "printValue(makeString(\"" << $3 << "\"));\n";
      }


    ;
%%