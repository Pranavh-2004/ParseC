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
%token IF ELSE FOR DO WHILE SWITCH CASE DEFAULT BREAK
%token ASSIGN INC DEC AND OR
%token EQ NE LT GT LE GE

/* Operator precedence (lowest to highest) */
%right ASSIGN
%left OR
%left AND
%left EQ NE
%left LT GT LE GE
%left '+' '-'
%left '*' '/' '%'
%nonassoc POSTFIX
%nonassoc UMINUS

/* Resolve dangling else: ELSE binds tighter than lone IF */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program
    : stmt_list_opt
    ;

stmt_list_opt
    : /* empty */
    | stmt_list
    ;

stmt_list
    : stmt_list stmt
    | stmt
    ;

stmt
    : declaration
    | if_stmt
    | do_while_stmt
    | while_stmt
    | for_stmt
    | switch_stmt
    | break_stmt
    | block
    | expr_stmt
    | ';'
    ;

    /* --- Declarations --- */
declaration
    : type declarator_list ';'
    ;

declaration_no_semicolon
    : type declarator_list
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
    : ID array_dims_opt init_opt
    ;

array_dims_opt
    : /* empty */
    | array_dims
    ;

array_dims
    : array_dims '[' NUM ']'
    | '[' NUM ']'
    ;

init_opt
    : /* empty */
    | ASSIGN expr
    ;

    /* --- Control Statements --- */
if_stmt
    : IF '(' expr ')' stmt              %prec LOWER_THAN_ELSE
    | IF '(' expr ')' stmt ELSE stmt
    ;

do_while_stmt
    : DO stmt WHILE '(' expr ')' ';'
    ;

while_stmt
    : WHILE '(' expr ')' stmt
    ;

for_stmt
    : FOR '(' opt_for_init ';' opt_expr ';' opt_for_update ')' stmt
    ;

opt_for_init
    : /* empty */
    | declaration_no_semicolon
    | expr_list
    ;

opt_for_update
    : /* empty */
    | expr_list
    ;

opt_expr
    : /* empty */
    | expr
    ;

expr_list
    : expr_list ',' expr
    | expr
    ;

switch_stmt
    : SWITCH '(' expr ')' '{' case_block_list_opt default_block_opt '}'
    ;

case_block_list_opt
    : /* empty */
    | case_block_list
    ;

case_block_list
    : case_block_list case_block
    | case_block
    ;

case_block
    : CASE case_const ':' stmt_list_opt
    ;

default_block_opt
    : /* empty */
    | DEFAULT ':' stmt_list_opt
    ;

case_const
    : NUM
    | '-' NUM      %prec UMINUS
    ;

break_stmt
    : BREAK ';'
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
    : ID ASSIGN expr
    | expr OR expr
    | expr AND expr
    | expr EQ expr
    | expr NE expr
    | expr LT expr
    | expr GT expr
    | expr LE expr
    | expr GE expr
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | expr '%' expr
    | ID INC         %prec POSTFIX
    | ID DEC         %prec POSTFIX
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
