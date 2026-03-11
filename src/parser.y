%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern char current_token[];
extern FILE* yyin;

int yylex(void);
void yyerror(const char* msg);
%}

/* Token declarations */
%token ID NUM
%token INT FLOAT CHAR DOUBLE
%token IF ELSE DO WHILE
%token ASSIGN
%token EQ NE LT GT LE GE

/* Operator precedence (lowest to highest) */
%left EQ NE
%left LT GT LE GE
%left '+' '-'
%left '*' '/' '%'
%nonassoc UMINUS

/* Resolve dangling else: ELSE binds tighter than lone IF */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program
    : stmt_list
    ;

stmt_list
    : stmt_list stmt
    | stmt
    ;

stmt
    : declaration
    | if_stmt
    | do_while_stmt
    | block
    | expr_stmt
    ;

    /* --- Declarations --- */
declaration
    : type declarator_list ';'
    ;

type
    : INT
    | FLOAT
    | CHAR
    | DOUBLE
    ;

declarator_list
    : declarator_list ',' declarator
    | declarator
    ;

declarator
    : ID ASSIGN expr
    | ID
    ;

    /* --- Control Statements --- */
if_stmt
    : IF '(' expr ')' stmt              %prec LOWER_THAN_ELSE
    | IF '(' expr ')' stmt ELSE stmt
    ;

do_while_stmt
    : DO stmt WHILE '(' expr ')' ';'
    ;

    /* --- Block --- */
block
    : '{' stmt_list '}'
    | '{' '}'
    ;

    /* --- Expression Statement --- */
expr_stmt
    : expr ';'
    ;

    /* --- Expressions --- */
expr
    : expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | expr '%' expr
    | expr EQ expr
    | expr NE expr
    | expr LT expr
    | expr GT expr
    | expr LE expr
    | expr GE expr
    | ID ASSIGN expr
    | '-' expr          %prec UMINUS
    | '(' expr ')'
    | ID
    | NUM
    ;

%%

void yyerror(const char* msg) {
    fprintf(stderr, "Syntax error at line %d, token %s: %s\n",
            yylineno, current_token, msg);
}

int main(int argc, char** argv) {
    FILE* file = NULL;

    if (argc > 1) {
        file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
    }

    int result = yyparse();

    if (file) fclose(file);

    if (result == 0) {
        printf("Syntax valid.\n");
        return 0;
    }
    return 1;
}
