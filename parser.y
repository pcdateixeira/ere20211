/*
	INF01147 - Compiladores B - 2021/1
	Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
	Nome: Pedro Caetano de Abreu Teixeira
	Numero do cartao: 00228509
*/

%{
	#include "hash.h"
	#include "ast.h"
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
%token KW_DATA

%token KW_IF
%token KW_ELSE
%token KW_UNTIL
%token KW_COMEFROM
%token KW_READ
%token KW_PRINT
%token KW_RETURN

%token OPERATOR_LE
%token OPERATOR_GE
%token OPERATOR_EQ
%token OPERATOR_DIF
%token OPERATOR_RANGE

%token<symbol> TK_IDENTIFIER

%token<symbol> LIT_INTEGER
%token<symbol> LIT_CHAR
%token<symbol> LIT_STRING

%token TOKEN_ERROR

%type<ast> datasection
%type<ast> lglobalvar
%type<ast> rglobalvar
%type<ast> globalvar
%type<ast> lvecvalue
%type<ast> rvecvalue
%type<ast> type
%type<ast> initvalue
%type<ast> lfunction
%type<ast> function
%type<ast> lfuncparam
%type<ast> rfuncparam
%type<ast> body
%type<ast> lcmd
%type<ast> cmd
%type<ast> lprintvalue
%type<ast> rprintvalue
%type<ast> expr
%type<ast> label
%type<ast> lfuncarg
%type<ast> rfuncarg

%left '|' '&' '~'
%left '<' '>' OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_DIF OPERATOR_RANGE
%left '+' '-'
%left '*' '/'

%%

program: datasection lfunction { astPrint(astCreate(AST_PROGRAM, 0, $1, $2, 0, 0), 0); }
	;

datasection: KW_DATA '{' lglobalvar '}' { $$ = astCreate(AST_DATASEC, 0, $3, 0, 0, 0); }
	;

lglobalvar: globalvar ';' rglobalvar { $$ = astCreate(AST_LGLOBALVAR, 0, $1, $3, 0, 0); }
	;

rglobalvar: globalvar ';' rglobalvar { $$ = astCreate(AST_LGLOBALVAR, 0, $1, $3, 0, 0); }
	| { $$ = 0; }
	;

globalvar: type ':' TK_IDENTIFIER '=' initvalue { $$ = astCreate(AST_GLOBALVAR, $3, $1, $5, 0, 0); }
	| type '[' LIT_INTEGER OPERATOR_RANGE LIT_INTEGER ']' ':' TK_IDENTIFIER lvecvalue { $$ = astCreate(AST_VEC_GLOBALVAR, $8, $1,
		astCreate(AST_SYMBOL, $3, 0, 0, 0, 0),
		astCreate(AST_SYMBOL, $5, 0, 0, 0, 0), $9); }
	;

lvecvalue: '=' initvalue rvecvalue { $$ = astCreate(AST_LINITVAL, 0, $2, $3, 0, 0); }
	| { $$ = 0; }
	;

rvecvalue: initvalue rvecvalue { $$ = astCreate(AST_LINITVAL, 0, $1, $2, 0, 0); }
	| { $$ = 0; }
	;

type: KW_CHAR { $$ = astCreate(AST_TYPE_CHAR, 0, 0, 0, 0, 0); }
	| KW_INT { $$ = astCreate(AST_TYPE_INT, 0, 0, 0, 0, 0); }
	| KW_FLOAT { $$ = astCreate(AST_TYPE_FLOAT, 0, 0, 0, 0, 0); }
	;

initvalue: LIT_INTEGER { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0); }
	| LIT_CHAR { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0); }
	;

lfunction: function lfunction { $$ = astCreate(AST_LFUNCTION, 0, $1, $2, 0, 0); }
	| { $$ = 0; }
	;

function: type ':' TK_IDENTIFIER '(' lfuncparam ')' body { $$ = astCreate(AST_FUNCTION, $3, $1, $5, $7, 0); }
	;

lfuncparam: type ':' TK_IDENTIFIER rfuncparam { $$ = astCreate(AST_LFUNCPARAM, $3, $1, $4, 0, 0); }
	| { $$ = 0; }
	;

rfuncparam: ',' type ':' TK_IDENTIFIER rfuncparam { $$ = astCreate(AST_LFUNCPARAM, $4, $2, $5, 0, 0); }
	| { $$ = 0; }
	;

body: '{' lcmd '}' { $$ = astCreate(AST_BLOCK, 0, $2, 0, 0, 0); }
	;

lcmd: cmd ';' lcmd { $$ = astCreate(AST_LCMD, 0, $1, $3, 0, 0); }
	| { $$ = 0; }
	;

cmd: TK_IDENTIFIER '=' expr { $$ = astCreate(AST_ATTR, $1, $3, 0, 0, 0); }
	| TK_IDENTIFIER '[' expr ']' '=' expr { $$ = astCreate(AST_VEC_ATTR, $1, $3, $6, 0, 0); }
	| KW_IF '(' expr ')' cmd { $$ = astCreate(AST_IF, 0, $3, $5, 0, 0); }
	| KW_IF '(' expr ')' cmd KW_ELSE cmd { $$ = astCreate(AST_IFELSE, 0, $3, $5, $7, 0); }
	| KW_UNTIL '(' expr ')' cmd { $$ = astCreate(AST_UNTIL, 0, $3, $5, 0, 0); }
	| KW_COMEFROM ':' TK_IDENTIFIER { $$ = astCreate(AST_COMEFROM, $3, 0, 0, 0, 0); }
	| KW_PRINT lprintvalue { $$ = astCreate(AST_PRINT, 0, $2, 0, 0, 0); }
	| KW_RETURN expr { $$ = astCreate(AST_RETURN, 0, $2, 0, 0, 0); }
	| body { $$ = $1; }
	| label { $$ = astCreate(AST_LABEL, 0, $1, 0, 0, 0); }
	| { $$ = 0; }
	;

lprintvalue: LIT_STRING rprintvalue { $$ = astCreate(AST_LPRINT, $1, 0, $2, 0, 0); }
	| expr rprintvalue { $$ = astCreate(AST_LPRINT, 0, $1, $2, 0, 0); }
	;

rprintvalue: ',' lprintvalue { $$ = $2; }
	| { $$ = 0; }
	;

expr: TK_IDENTIFIER { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0); }
	| TK_IDENTIFIER '[' expr ']' { $$ = astCreate(AST_VEC_SYMBOL, $1, $3, 0, 0, 0); }
	| initvalue { $$ = $1; }
	| expr '+' expr { $$ = astCreate(AST_OP_ADD, 0, $1, $3, 0, 0); }
	| expr '-' expr { $$ = astCreate(AST_OP_SUB, 0, $1, $3, 0, 0); }
	| expr '*' expr { $$ = astCreate(AST_OP_MULT, 0, $1, $3, 0, 0); }
	| expr '/' expr { $$ = astCreate(AST_OP_DIV, 0, $1, $3, 0, 0); }
	| expr '<' expr { $$ = astCreate(AST_OP_LESS, 0, $1, $3, 0, 0); }
	| expr '>' expr { $$ = astCreate(AST_OP_GREAT, 0, $1, $3, 0, 0); }
	| expr '|' expr { $$ = astCreate(AST_OP_OR, 0, $1, $3, 0, 0); }
	| expr '&' expr { $$ = astCreate(AST_OP_AND, 0, $1, $3, 0, 0); }
	| '~' expr { $$ = astCreate(AST_OP_NOT, 0, $2, 0, 0, 0); }
	| expr OPERATOR_LE expr { $$ = astCreate(AST_OP_LE, 0, $1, $3, 0, 0); }
	| expr OPERATOR_GE expr { $$ = astCreate(AST_OP_GE, 0, $1, $3, 0, 0); }
	| expr OPERATOR_EQ expr { $$ = astCreate(AST_OP_EQ, 0, $1, $3, 0, 0); }
	| expr OPERATOR_DIF expr { $$ = astCreate(AST_OP_DIF, 0, $1, $3, 0, 0); }
	| '(' expr ')' { $$ = astCreate(AST_PAREN, 0, $2, 0, 0, 0); }
	| TK_IDENTIFIER '(' lfuncarg ')' { $$ = astCreate(AST_FUNC_CALL, $1, $3, 0, 0, 0); }
	| KW_READ { $$ = astCreate(AST_READ, 0, 0, 0, 0, 0); }
	;

label: TK_IDENTIFIER { $$ = astCreate(AST_SYMBOL, $1, 0, 0, 0, 0); }
	;

lfuncarg: expr rfuncarg { $$ = astCreate(AST_LFUNCARG, 0, $1, $2, 0, 0); }
	| { $$ = 0; }
	;

rfuncarg: ',' expr rfuncarg { $$ = astCreate(AST_LFUNCARG, 0, $2, $3, 0, 0); }
	| { $$ = 0; }
	;


%%
#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

int yyerror(){
	fprintf(stderr, "Erro de sintaxe na linha %d.\n", getLineNumber());
	exit(3);
}