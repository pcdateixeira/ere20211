/*
	INF01147 - Compiladores B - 2021/1
	Trabalho Pratico, Etapa 2: Analise Sintatica e Preenchimento da Tabela de Simbolos
	Nome: Pedro Caetano de Abreu Teixeira
	Numero do cartao: 00228509
*/

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

%token TK_IDENTIFIER

%token LIT_INTEGER
%token LIT_CHAR
%token LIT_STRING
%token TOKEN_ERROR

%left '|' '&' '~'
%left '<' '>' OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_DIF OPERATOR_RANGE
%left '+' '-'
%left '*' '/'

%%

programa: datasection lfunction
	;

datasection: KW_DATA '{' lglobalvar '}'
	;

lglobalvar: globalvar ';' rglobalvar
	;

rglobalvar: globalvar ';' rglobalvar
	|
	;

globalvar: type ':' TK_IDENTIFIER '=' initvalue
	| type '[' LIT_INTEGER OPERATOR_RANGE LIT_INTEGER ']' ':' TK_IDENTIFIER lvecvalue
	;

lvecvalue: '=' initvalue rvecvalue
	|
	;

rvecvalue: initvalue rvecvalue
	|
	;

type: KW_CHAR
	| KW_INT
	| KW_FLOAT
	;

initvalue: LIT_INTEGER
	| LIT_CHAR
	;

lfunction: function rfunction
	;

rfunction: function rfunction
	|
	;

function: type ':' TK_IDENTIFIER '(' lfuncparam ')' body
	;

lfuncparam: type ':' TK_IDENTIFIER rfuncparam
	|
	;

rfuncparam: ',' type ':' TK_IDENTIFIER rfuncparam
	|
	;

body: '{' lcmd '}'
	;

lcmd: cmd ';' lcmd
	|
	;

cmd: TK_IDENTIFIER '=' expr
	| TK_IDENTIFIER '[' expr ']' '=' expr
	| KW_IF '(' expr ')' cmd
	| KW_IF '(' expr ')' cmd KW_ELSE cmd
	| KW_UNTIL '(' expr ')' cmd
	| KW_COMEFROM ':' TK_IDENTIFIER
	| KW_PRINT lprintvalue
	| KW_RETURN expr
	| body
	| label
	|
	;

lprintvalue: LIT_STRING rprintvalue
	| expr rprintvalue
	;

rprintvalue: ',' lprintvalue
	|
	;

expr: TK_IDENTIFIER
	| TK_IDENTIFIER '[' expr ']'
	| initvalue
	| expr '+' expr
	| expr '-' expr
	| expr '*' expr
	| expr '/' expr
	| expr '<' expr
	| expr '>' expr
	| expr '|' expr
	| expr '&' expr
	| '~' expr
	| expr OPERATOR_LE expr
	| expr OPERATOR_GE expr
	| expr OPERATOR_EQ expr
	| expr OPERATOR_DIF expr
	| '(' expr ')'
	| TK_IDENTIFIER '(' lfuncarg ')'
	| KW_READ
	;

label: TK_IDENTIFIER
	;

lfuncarg: expr rfuncarg
	|
	;

rfuncarg: ',' expr rfuncarg
	|
	;


%%
#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

int yyerror(){
	fprintf(stderr, "Erro de sintaxe na linha %d.\n", getLineNumber());
	exit(3);
}