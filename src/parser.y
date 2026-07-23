%{
#include <stdio.h>

extern int yylex();
extern FILE *yyin;

void yyerror(const char *s);
%}

%token INT ASSIGN SEMICOLON PLUS MINUS TIMES DIVIDE LPAREN RPAREN LBRACE RBRACE
%token CASE DEFAULT IF SWITCH ELSE FOR DO WHILE GOTO CONTINUE BREAK RETURN SIZEOF
%token EQUAL NEQUAL GEQUAL LEQUAL GREATER LESSTHAN
%token AND OR NOT COMMA INC DEC
%union {
    int ival;
    char *sval;
}

%token <ival> NUMBER
%token <sval> IDENTIFIER
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
    ;

declaration
    : INT IDENTIFIER ASSIGN expression SEMICOLON
      {
          printf("Valid declaration!\n");
      }
    ;

assignment
    : IDENTIFIER ASSIGN expression SEMICOLON
      {
          printf("Valid assignment!\n");
      }
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

%%

void yyerror(const char *s)
{
    printf("Syntax Error!\n");
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");

    if (yyin == NULL)
    {
        perror("Cannot open input file");
        return 1;
    }

    yyparse();

    fclose(yyin);

    return 0;
}