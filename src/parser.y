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
          printf("Print statement parsed: %s\n", $3);
      }
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error!\n");
}

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        printf("Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");

    if (yyin == NULL)
    {
        perror("Input file name is null");
        return 1;
    }

    FILE *output = fopen(argv[2], "w");

    if (output == NULL)
    {
        perror("Output file name is null");
        fclose(yyin);
        return 1;
    }

    yyparse();

    fprintf(output, "It works\n");

    fclose(output);
    fclose(yyin);

    return 0;
}