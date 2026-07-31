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
extern std::ostringstream global_out;
extern std::ostringstream code_out;
extern SymbolTable symbolTable;
%}

%token INT ASSIGN NEWLINE PLUS MINUS TIMES DIVIDE LPAREN RPAREN LBRACE RBRACE
%token CASE DEFAULT IF SWITCH ELSE FOR DO WHILE GOTO CONTINUE BREAK RETURN SIZEOF
%token EQUAL NEQUAL GEQUAL LEQUAL GREATER LESSTHAN
%token AND OR NOT COMMA INC DEC
%token SAY COLON GLOBAL

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

%left EQUAL NEQUAL GREATER LESSTHAN GEQUAL LEQUAL
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
    : assignment NEWLINE
    | global_assignment
    | print_statement NEWLINE
    | block
    | NEWLINE
    ;

block
    : LBRACE
    {
        symbolTable.enterScope();
        code_out << "{\n";
    }
    statements
    RBRACE
    {
        symbolTable.exitScope();
        code_out << "}\n";
    }
    ;

global_assignment
    : GLOBAL IDENTIFIER ASSIGN expression NEWLINE{
        if(!symbolTable.existsGlobal($2)){
            Symbol s;
            s.type = "int";
            s.data = $4->code;

            symbolTable.addGlobal($2,s);

            global_out << "Value " << $2 << " = " << $4->code << ";\n";
        } else {
            yyerror("Global variable already exists.");
        }
    }
    | GLOBAL IDENTIFIER ASSIGN STRING NEWLINE{
        if(!symbolTable.exists($2)){
            Symbol s;
            s.type = "string";
            s.data = $4;

            symbolTable.addGlobal($2,s);

            global_out << "Value " << $2 << " = makeString(\"" << $4 << "\");\n";
        } else {
            yyerror("Global variable already exists.");
        }

    }

assignment
    : IDENTIFIER ASSIGN expression
    {
        if(symbolTable.existsCurrentScope($1)){
            Symbol* s = symbolTable.get($1);
            s->data = $3->code;

            code_out << "Value " << $1 << " = " << $3->code << ";\n";
        } else if (symbolTable.existsGlobal($1)){
            Symbol* s = symbolTable.get($1);
            s->data = $3->code;  

            code_out << "Value " << $1 << " = " << $3->code << ";\n";
        } else {
            Symbol s;
            s.type = "int";
            s.data = $3->code;
            symbolTable.add($1,s);

            code_out << "Value " << $1 << " = " << $3->code << ";\n";
        }
    }
    | IDENTIFIER ASSIGN STRING{

        if(symbolTable.existsCurrentScope($1)){
            Symbol* s = symbolTable.get($1);
            s->data = $3;

            code_out << $1 << " = makeString(\"" << $3 << ";\n";
        } else if (symbolTable.existsGlobal($1)){
            Symbol* s = symbolTable.get($1);
            s->data = $3;  

            code_out << $1 << " = makeString(\"" << $3 << ";\n";
        } else {
            Symbol s;
            s.type = "string";
            s.data = $3;
            symbolTable.add($1,s);

            code_out << "Value " << $1 << " = makeString(\"" << $3 << ";\n";
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
            printSemanticError("Undefined Variable " + std::string($1) + "'", lineNumber);
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
    | expression TIMES expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + " * " + $3->code + ")";
    }
    | expression DIVIDE expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + " . " + $3->code + ")";
    }
    | expression EQUAL expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + "==" + $3->code + ")";
    }
    | expression NEQUAL expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + "!=" + $3->code + ")";
    }
    | expression GREATER expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + ">" + $3->code + ")";
    }
    | expression LESSTHAN expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + "<" + $3->code + ")";
    }
    | expression GEQUAL expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + ">=" + $3->code + ")";
    }
    | expression LEQUAL expression{
        $$ = new Expression();
        $$->code = "(" + $1->code + "<=" + $3->code + ")";
    }
    | LPAREN expression RPAREN{
        $$ = $2;
    }
    ;

print_statement
    : SAY COLON STRING
        {
        code_out << "printValue(makeString(\"" << $3 << "\"));\n";
    }

    | SAY COLON expression
        {
        code_out << "printValue(" << $3->code << ");\n";
    }
    ;

%%