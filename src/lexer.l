%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"

/* Store current token text for error reporting */
char current_token[256];

void update_token(void) {
    strncpy(current_token, yytext, sizeof(current_token) - 1);
    current_token[sizeof(current_token) - 1] = '\0';
}
%}

%option noyywrap
%option yylineno

%%

    /* Keywords */
"int"       { update_token(); return INT; }
"float"     { update_token(); return FLOAT; }
"char"      { update_token(); return CHAR; }
"double"    { update_token(); return DOUBLE; }
"if"        { update_token(); return IF; }
"else"      { update_token(); return ELSE; }
"do"        { update_token(); return DO; }
"while"     { update_token(); return WHILE; }

    /* Identifiers */
[a-zA-Z_][a-zA-Z0-9_]*  { update_token(); return ID; }

    /* Numeric literals */
[0-9]+\.[0-9]+  { update_token(); return NUM; }
[0-9]+          { update_token(); return NUM; }

    /* Relational operators (multi-char first) */
"=="    { update_token(); return EQ; }
"!="    { update_token(); return NE; }
"<="    { update_token(); return LE; }
">="    { update_token(); return GE; }
"<"     { update_token(); return LT; }
">"     { update_token(); return GT; }

    /* Assignment */
"="     { update_token(); return ASSIGN; }

    /* Arithmetic operators */
"+"     { update_token(); return '+'; }
"-"     { update_token(); return '-'; }
"*"     { update_token(); return '*'; }
"/"     { update_token(); return '/'; }
"%"     { update_token(); return '%'; }

    /* Punctuators */
";"     { update_token(); return ';'; }
","     { update_token(); return ','; }
"("     { update_token(); return '('; }
")"     { update_token(); return ')'; }
"{"     { update_token(); return '{'; }
"}"     { update_token(); return '}'; }

    /* Single-line comments - skip */
"//".*  { /* skip */ }

    /* Multi-line comments - skip */
"/*"([^*]|\*+[^*/])*\*+"/"  { /* skip */ }

    /* Whitespace */
[ \t\n]+  { /* skip */ }

    /* Invalid character */
.       { update_token(); return yytext[0]; }

%%
