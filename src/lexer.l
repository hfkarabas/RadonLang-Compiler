%option noyywrap

%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%

"int" { return INT; }

[0-9]+ { return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }

"=" { return ASSIGN; }

"+" { return PLUS; }

"-" { return MINUS; }

"*" { return TIMES; }

"/" { return DIVIDE; }

";" { return SEMICOLON; }

"(" { return LPAREN; }

")" { return RPAREN; }

[ \t\r\n]+ ;

. {
 printf("Unknown character: %s\n", yytext);
 }

%%