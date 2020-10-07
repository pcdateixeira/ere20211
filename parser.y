
/*
	INF01147 - Compiladores B - 2020/1
	Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
	Nome: Pedro Caetano de Abreu Teixeira
	Numero do cartao: 00228509
*/

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

%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_WHILE
%token KW_LOOP
%token KW_READ
%token KW_PRINT
%token KW_RETURN

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
%token<symbol> LIT_STRING

%token TOKEN_ERROR

%type<ast> type
%type<ast> initvalue
%type<ast> function
%type<ast> funcparam
%type<ast> rfuncparam
%type<ast> body
%type<ast> lcmd
%type<ast> cmd
%type<ast> expr
%type<ast> printvalue
%type<ast> rprintvalue
%type<ast> funcarg
%type<ast> rfuncarg

%left '|' '^' '~'
%left '<' '>' OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_DIF
%left '+' '-'
%left '*' '/'

%%

programa: ldec
	;
	
ldec: globalvar ';' ldec
	| function ';' ldec { astPrint($1, 0); }
	|
	;

globalvar: TK_IDENTIFIER '=' type ':' initvalue
	| TK_IDENTIFIER '=' type '[' LIT_INTEGER ']' initvecvalue
	;

type: KW_CHAR	{ $$ = astCreate(AST_TYPE_CHAR, 0, 0, 0, 0, 0, 0, 0); }
	| KW_INT	{ $$ = astCreate(AST_TYPE_INT, 0, 0, 0, 0, 0, 0, 0); }
	| KW_FLOAT	{ $$ = astCreate(AST_TYPE_FLOAT, 0, 0, 0, 0, 0, 0, 0); }
	| KW_BOOL	{ $$ = astCreate(AST_TYPE_BOOL, 0, 0, 0, 0, 0, 0, 0); }
	;

initvalue: LIT_INTEGER 	{ $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| LIT_FLOAT 		{ $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| LIT_CHAR 			{ $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| LIT_TRUE 			{ $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| LIT_FALSE 		{ $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	;

initvecvalue: ':' initvalue rvecvalue
	|
	;

rvecvalue: initvalue rvecvalue
	|
	;

function: TK_IDENTIFIER '(' funcparam ')' '=' type body { $$ = astCreate(AST_FUNCTION, $1, $3, $6, $7, 0, 0, 0); }
	;

funcparam: TK_IDENTIFIER '=' type rfuncparam	{ $$ = astCreate(AST_LFUNCPARAM, $1, $3, $4, 0, 0, 0, 0); }
	|											{ $$ = 0; }
	;

rfuncparam: ',' TK_IDENTIFIER '=' type rfuncparam	{ $$ = astCreate(AST_LFUNCPARAM, $2, $4, $5, 0, 0, 0, 0); }
	|												{ $$ = 0; }
	;

body: '{' lcmd '}' { $$ = astCreate(AST_BLOCK, 0, $2, 0, 0, 0, 0, 0); }
	;

lcmd: cmd lcmd 	{ $$ = astCreate(AST_LCMD, 0, $1, $2, 0, 0, 0, 0); }
	|			{ $$ = 0; }
	;

cmd: TK_IDENTIFIER '=' expr 										{ $$ = astCreate(AST_ATTR, $1, $3, 0, 0, 0, 0, 0); }
	| TK_IDENTIFIER '[' expr ']' '=' expr							{ $$ = astCreate(AST_VEC_ATTR, $1, $3, $6, 0, 0, 0, 0); }
	| KW_IF '(' expr ')' KW_THEN cmd 								{ $$ = astCreate(AST_IF, 0, $3, $6, 0, 0, 0, 0); }
	| KW_IF '(' expr ')' KW_THEN cmd KW_ELSE cmd 					{ $$ = astCreate(AST_IFELSE, 0, $3, $6, $8, 0, 0, 0); }
	| KW_WHILE '(' expr ')' cmd 									{ $$ = astCreate(AST_WHILE, 0, $3, $5, 0, 0, 0, 0); }
	| KW_LOOP '(' TK_IDENTIFIER ':' expr ',' expr ',' expr ')' cmd	{ $$ = astCreate(AST_LOOP, $3, $5, $7, $9, $11, 0, 0); }
	| KW_READ TK_IDENTIFIER 										{ $$ = astCreate(AST_READ, $2, 0, 0, 0, 0, 0, 0); }
	| KW_PRINT printvalue											{ $$ = astCreate(AST_PRINT, 0, $2, 0, 0, 0, 0, 0); }
	| KW_RETURN expr 												{ $$ = astCreate(AST_RETURN, 0, $2, 0, 0, 0, 0, 0); }
	| body															{ $$ = $1; }
	|																{ $$ = 0; }
	;

expr: TK_IDENTIFIER 				{ $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0, 0, 0); }
	| TK_IDENTIFIER '[' expr ']' 	{ $$ = astCreate(AST_VEC_SYMBOL, $1, $3, 0, 0, 0, 0, 0); }
	| initvalue						{ $$ = $1; }
	| expr '+' expr 				{ $$ = astCreate(AST_OP_ADD, 0, $1, $3, 0, 0, 0, 0); }
	| expr '-' expr 				{ $$ = astCreate(AST_OP_SUB, 0, $1, $3, 0, 0, 0, 0); }
	| expr '*' expr 				{ $$ = astCreate(AST_OP_MULT, 0, $1, $3, 0, 0, 0, 0); }
	| expr '/' expr 				{ $$ = astCreate(AST_OP_DIV, 0, $1, $3, 0, 0, 0, 0); }
	| expr '<' expr 				{ $$ = astCreate(AST_OP_LESS, 0, $1, $3, 0, 0, 0, 0); }
	| expr '>' expr 				{ $$ = astCreate(AST_OP_GREAT, 0, $1, $3, 0, 0, 0, 0); }
	| expr '|' expr 				{ $$ = astCreate(AST_OP_OR, 0, $1, $3, 0, 0, 0, 0); }
	| expr '^' expr					{ $$ = astCreate(AST_OP_AND, 0, $1, $3, 0, 0, 0, 0); }
	| expr '~' expr 				{ $$ = astCreate(AST_OP_NOT, 0, $1, $3, 0, 0, 0, 0); }
	| expr OPERATOR_LE expr 		{ $$ = astCreate(AST_OP_LE, 0, $1, $3, 0, 0, 0, 0); }
	| expr OPERATOR_GE expr 		{ $$ = astCreate(AST_OP_GE, 0, $1, $3, 0, 0, 0, 0); }
	| expr OPERATOR_EQ expr 		{ $$ = astCreate(AST_OP_EQ, 0, $1, $3, 0, 0, 0, 0); }
	| expr OPERATOR_DIF expr 		{ $$ = astCreate(AST_OP_DIF, 0, $1, $3, 0, 0, 0, 0); }
	| '(' expr ')' 					{ $$ = astCreate(AST_PAREN, 0, $2, 0, 0, 0, 0, 0); }
	| TK_IDENTIFIER '(' funcarg ')' { $$ = astCreate(AST_FUNC_CALL, $1, $3, 0, 0, 0, 0, 0); }
	;

printvalue: LIT_STRING rprintvalue	{ $$ = astCreate(AST_LPRINT, $1, 0, $2, 0, 0, 0, 0); }
	| expr rprintvalue				{ $$ = astCreate(AST_LPRINT, 0, $1, $2, 0, 0, 0, 0); }
	;

rprintvalue: ',' printvalue			{ $$ = $2; }
	|								{ $$ = 0; }
	;

funcarg: expr rfuncarg 	{ $$ = astCreate(AST_LFUNCARG, 0, $1, $2, 0, 0, 0, 0); }
	| 					{ $$ = 0; }
	;

rfuncarg: ',' expr rfuncarg { $$ = astCreate(AST_LFUNCARG, 0, $2, $3, 0, 0, 0, 0); }
	| 						{ $$ = 0; }
	;

%%

int yyerror(){
	fprintf(stderr, "Erro de sintaxe na linha %d.\n", getLineNumber());
	exit(3);
}


