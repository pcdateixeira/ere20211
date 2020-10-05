
/*
	INF01147 - Compiladores B - 2020/1
	Trabalho Pratico, Etapa 2: Analise Sintatica e Preenchimento da Tabela de Simbolos
	Nome: Pedro Caetano de Abreu Teixeira
	Numero do cartao: 00228509
*/

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
%token TK_IDENTIFIER

%token LIT_INTEGER
%token LIT_FLOAT
%token LIT_TRUE
%token LIT_FALSE
%token LIT_CHAR
%token LIT_STRING

%token TOKEN_ERROR

%left '|' '^' '~'
%left '<' '>' OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_DIF
%left '+' '-'
%left '*' '/'

%%

programa: ldec
	;
	
ldec: globalvar ';' ldec
	| function ';' ldec
	|
	;

globalvar: TK_IDENTIFIER '=' type ':' initvalue
	| TK_IDENTIFIER '=' type '[' LIT_INTEGER ']' initvecvalue
	;

type: KW_CHAR
	| KW_INT
	| KW_FLOAT
	| KW_BOOL
	;

initvalue: LIT_INTEGER
	| LIT_FLOAT
	| LIT_CHAR
	| LIT_TRUE
	| LIT_FALSE
	;

initvecvalue: ':' initvalue rvecvalue
	|
	;

rvecvalue: initvalue rvecvalue
	|
	;

function: TK_IDENTIFIER '(' funcparam ')' '=' type body
	;

funcparam: TK_IDENTIFIER '=' type rfuncparam
	|
	;

rfuncparam: ',' TK_IDENTIFIER '=' type rfuncparam
	|
	;

body: '{' lcmd '}'
	;

lcmd: cmd lcmd
	|
	;

cmd: TK_IDENTIFIER '=' expr
	| TK_IDENTIFIER '[' expr ']' '=' expr
	| KW_IF '(' expr ')' KW_THEN cmd
	| KW_IF '(' expr ')' KW_THEN cmd KW_ELSE cmd
	| KW_WHILE '(' expr ')' cmd
	| KW_LOOP '(' TK_IDENTIFIER ':' expr ',' expr ',' expr ')' cmd
	| KW_READ TK_IDENTIFIER
	| KW_RETURN expr
	| KW_PRINT printvalue
	| body
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
	| expr '^' expr
	| expr '~' expr
	| expr OPERATOR_LE expr
	| expr OPERATOR_GE expr
	| expr OPERATOR_EQ expr
	| expr OPERATOR_DIF expr
	| '(' expr ')'
	| TK_IDENTIFIER '(' funcarg ')'
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


