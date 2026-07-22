%{
#include <stdio.h>

extern int yylex();
extern FILE *yyin;

void yyerror(const char *s);
%}

%token INT
%token IDENTIFIER
%token NUMBER
%token ASSIGN
%token SEMICOLON
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token LPAREN
%token RPAREN

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
    ;
    
declaration
    : INT IDENTIFIER ASSIGN NUMBER SEMICOLON
      {
          printf("Valid declaration!\n");
      }
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error!\n");
}

int main()
{
    printf("Enter code:\n");

    yyparse();

    return 0;
}