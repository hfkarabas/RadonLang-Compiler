%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>   // atoi
#include <string.h>   // strdup
#include "parser.tab.hpp"
%}

%%

"int" { return INT; }
"=" { return ASSIGN; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return TIMES; }
"/" { return DIVIDE; }
";" { return SEMICOLON; }
"(" { return LPAREN; }
")" { return RPAREN; }
"case" {return CASE;}	
"default" {return DEFAULT;}
"if" {return IF;}
"switch" {return SWITCH;}
"else" {return ELSE;}
"for" {return FOR;}
"do" {return DO;}
"while" {return WHILE;}
"goto" {return GOTO;}
"continue" {return CONTINUE;}
"break" {return BREAK;}
"return" {return RETURN;}
"sizeof" {return SIZEOF;}
"==" {return EQUAL;}
"!=" {return NEQUAL;}
">=" {return GEQUAL;}
"<=" {return LEQUAL;}
">" {return GREATER;}
"<" {return LESSTHAN;}
"&&" {return AND;}
"||" {return OR;}
"!" {return NOT;}
"," {return COMMA;}
"{" {return LBRACE;}
"}" {return RBRACE;}
"++" {return INC;}
"--" {return DEC;}
"print" {return PRINT;}
\"([^\\\"]|\\.)*\" {
    yytext[yyleng - 1] = '\0';
    yylval.sval = strdup(yytext + 1);   
    return STRING;
}
[0-9]+ {yylval.ival = atoi(yytext); return NUMBER;}
[a-zA-Z_][a-zA-Z0-9_]* {yylval.sval = strdup(yytext); return IDENTIFIER;}
[ \t\n]+ ;
. { printf("Unknown character: %s\n", yytext); }

%%