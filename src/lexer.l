%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>   // atoi
#include <string.h>   // strdup
#include <iostream>
#include "parser.tab.hpp"

int lineNumber = 1;
%}

%%

"int" { return INT; }
"=" { return ASSIGN; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return TIMES; }
"/" { return DIVIDE; }
";" {
std::cout << "token semicolon " << std::endl;
return SEMICOLON; }
"(" {
std::cout << "token lparen " << std::endl;
return LPAREN; }
")" { 
std::cout << "token rparen " << std::endl;
return RPAREN; }
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
"{" {
std::cout << "token lbrace" << std::endl;
return LBRACE;}
"}" {
std::cout << "token rbrace" << std::endl;
return RBRACE;}
"++" {return INC;}
"--" {return DEC;}
"print" {
std::cout << "token print" << std::endl;
return PRINT;}
\"([^\\\"]|\\.)*\" {
    std::cout << "token identifier" << yytext << std::endl;
    yytext[yyleng - 1] = '\0';
    yylval.sval = strdup(yytext + 1);   
    return STRING;
}
[0-9]+ {yylval.ival = atoi(yytext); return NUMBER;}
[a-zA-Z_][a-zA-Z0-9_]* {
std::cout << "token identifier" << yytext << std::endl;
yylval.sval = strdup(yytext); return IDENTIFIER;}
[\n] {lineNumber++;}
[ \t\r]+ ;
. { printf("Unknown character: %s\n", yytext); }

%%