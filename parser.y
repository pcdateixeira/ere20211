%{
	#include "hash.h"
	#include "ast.h"
	#include "utils.h"
	int yyerror();
	int yylex();
%}

%union
{
	HASH_NODE *symbol;
	AST *ast;
}


%token KW_CHAR
%token KW_INT
%token KW_FLOAT
%token KW_BOOL
%token KW_BYTE
%token KW_LONG

%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_WHILE
%token KW_FOR
%token KW_READ
%token KW_PRINT
%token KW_RETURN
%token KW_BREAK

%token OPERATOR_LE
%token OPERATOR_GE
%token OPERATOR_EQ
%token OPERATOR_DIF
%token<symbol> TK_IDENTIFIER

%token<symbol> LIT_INTEGER
%token<symbol> LIT_FLOAT
%token<symbol> LIT_TRUE
%token<symbol> LIT_FALSE
%token<symbol> LIT_CHAR
%token LIT_STRING

%token TOKEN_ERROR

%type<ast> initvalue
%type<ast> expr
%type<ast> funcarg

%left '|' '&' '.' 'v' '~'
%left '<' '>' OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_DIF
%left '+' '-'
%left '*' '/'

%%

programa: ldec
	;
	
ldec: globalvar ';' ldec
	| function ldec
	|
	;

globalvar: type TK_IDENTIFIER '=' initvalue
	| type TK_IDENTIFIER '[' LIT_INTEGER ']' initvecvalue
	;

type: KW_INT
	| KW_FLOAT
	| KW_BOOL
	| KW_BYTE
	| KW_LONG
	;

initvalue: LIT_INTEGER { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| LIT_FLOAT { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| LIT_CHAR { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| LIT_TRUE { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| LIT_FALSE { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	;

initvecvalue: ':' initvalue rvecvalue
	|
	;

rvecvalue: initvalue rvecvalue
	|
	;

function: type TK_IDENTIFIER '(' funcparam ')' body
	;

funcparam: type TK_IDENTIFIER rfuncparam
	|
	;

rfuncparam: ',' type TK_IDENTIFIER rfuncparam
	|
	;

body: '{' lcmd '}'
	;

lcmd: cmd ';' lcmd
	|
	;

cmd: TK_IDENTIFIER '=' expr { astPrint($3, 0); }
	| TK_IDENTIFIER '[' expr ']' '=' expr
	| KW_IF '(' expr ')' KW_THEN cmd
	| KW_IF '(' expr ')' KW_THEN cmd KW_ELSE cmd
	| KW_WHILE '(' expr ')' cmd
	| KW_FOR '(' TK_IDENTIFIER ':' expr ',' expr ',' expr ')' cmd
	| KW_BREAK
	| KW_READ TK_IDENTIFIER
	| KW_RETURN expr
	| KW_PRINT printvalue
	| body
	|
	;

expr: TK_IDENTIFIER { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| TK_IDENTIFIER '[' expr ']' { $$ = astCreate(AST_VEC_SYMBOL, $1, $3, 0, 0, 0, 0, 0); }
	| initvalue
	| expr '+' expr { $$ = astCreate(AST_ADD, 0, $1, $3, 0, 0, 0, 0); }
	| expr '-' expr { $$ = astCreate(AST_SUB, 0, $1, $3, 0, 0, 0, 0); }
	| expr '*' expr
	| expr '/' expr
	| expr '<' expr
	| expr '>' expr
	| expr '|' expr
	| expr '&' expr
	| expr '.' expr
	| expr 'v' expr
	| expr '~' expr
	| expr OPERATOR_LE expr
	| expr OPERATOR_GE expr
	| expr OPERATOR_EQ expr
	| expr OPERATOR_DIF expr
	| '(' expr ')' { $$ = $2; }
	| TK_IDENTIFIER '(' funcarg ')' { $$ = astCreate(AST_FUNC_CALL, $1, $3, 0, 0, 0, 0, 0); }
	;

printvalue: LIT_STRING rprintvalue
	| expr rprintvalue
	;

rprintvalue: ',' printvalue
	|
	;

funcarg: expr rfuncarg
	|
	;

rfuncarg: ',' expr rfuncarg
	|
	;

%%

int yyerror(){
	fprintf(stderr, "Erro de sintaxe na linha %d.\n", getLineNumber());
	exit(3);
}


