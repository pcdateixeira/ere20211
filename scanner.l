<<<<<<< HEAD
%{

	//
	// INF01147 - Compiladores B - 2020/1
	// Trabalho Pratico, Etapa 2: Analise Sintatica e Preenchimento da Tabela de Simbolos
	// Nome: Pedro Caetano de Abreu Teixeira
	// Numero do cartao: 00228509
	
	#include "y.tab.h"
	#include "hash.c"
	#include "utils.c"
%}

%x COMMENT


%%

"char" 							return KW_CHAR;
"int" 							return KW_INT;
"float" 						return KW_FLOAT;
"bool" 							return KW_BOOL;

"if" 							return KW_IF;
"then" 							return KW_THEN;
"else" 							return KW_ELSE;
"while" 						return KW_WHILE;
"loop" 							return KW_LOOP;
"read" 							return KW_READ;
"print" 						return KW_PRINT;
"return" 						return KW_RETURN;

[,;:()\[\]{}+\-*/<>=|\^~&$#]	return yytext[0];

"<="							return OPERATOR_LE;
">="							return OPERATOR_GE;
"=="							return OPERATOR_EQ;
"!="							return OPERATOR_DIF;

"TRUE"							*Table = hashInsert(yytext, SYMBOL_LIT_TRUE); return LIT_TRUE;
"FALSE"							*Table = hashInsert(yytext, SYMBOL_LIT_FALSE); return LIT_FALSE;

[A-Za-z@_][A-Za-z@_0-9]*		*Table = hashInsert(yytext, SYMBOL_IDENTIFIER); return TK_IDENTIFIER;

[0-9][0-9A-F]*					*Table = hashInsert(yytext, SYMBOL_LIT_INTEGER); return LIT_INTEGER;
([0-9][0-9A-F]*)*\.[0-9A-F]+	*Table = hashInsert(yytext, SYMBOL_LIT_FLOAT); return LIT_FLOAT;
'.'								*Table = hashInsert(yytext, SYMBOL_LIT_CHAR); return LIT_CHAR;
["]([^"\\\n]|\\.|\\\n)*["]		*Table = hashInsert(yytext, SYMBOL_LIT_STRING); return LIT_STRING;

"\n"							incLineNumber();

[ \t\0]
"//".*

"/*"							BEGIN(COMMENT);
.								return TOKEN_ERROR;

<COMMENT>.
<COMMENT>"\n"					incLineNumber();
<COMMENT>"*/"					BEGIN(INITIAL);

%%

#include "y.tab.c"
#include "main.c"
int yywrap(){
	stopRunning();
	return 1;
}
=======
%{

	//
	// INF01147 - Compiladores B - 2021/1
	// Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
	// Nome: Pedro Caetano de Abreu Teixeira
	// Numero do cartao: 00228509
	
	#include "hash.h"
	#include "ast.h"
	#include "y.tab.h"
	#include "utils.h"
%}

%x COMMENT

%%

"char"								return KW_CHAR;
"int"								return KW_INT;
"float"								return KW_FLOAT;
"data"								return KW_DATA;

"if"								return KW_IF;
"else"								return KW_ELSE;
"until"								return KW_UNTIL;
"comefrom"							return KW_COMEFROM;
"read"								return KW_READ;
"print"								return KW_PRINT;
"return"							return KW_RETURN;

[,;:()\[\]{}+\-*/<>|&~=]			return yytext[0];

"<="								return OPERATOR_LE;
">="								return OPERATOR_GE;
"=="								return OPERATOR_EQ;
"!="								return OPERATOR_DIF;
".."								return OPERATOR_RANGE;

[A-Za-z]([A-Za-z 0-9]+[A-Za-z0-9])* yylval.symbol = hashInsert(yytext, SYMBOL_IDENTIFIER); return TK_IDENTIFIER;

[0-9]+								yylval.symbol = hashInsert(yytext, SYMBOL_LIT_INTEGER); return LIT_INTEGER;
'.'									yylval.symbol = hashInsert(yytext, SYMBOL_LIT_CHAR); return LIT_CHAR;
["]([^"\\\n]|\\.|\\\n)*["]			yylval.symbol = hashInsert(yytext, SYMBOL_LIT_STRING); return LIT_STRING;

[ \t]
("\n"|"\r\n")						incLineNumber();

"##".*"\n"							incLineNumber();
"#/"								BEGIN(COMMENT);

.									return TOKEN_ERROR;

<COMMENT>"/#"						BEGIN(INITIAL);
<COMMENT>("\n"|"\r\n")				incLineNumber();
<COMMENT>.

%%

int yywrap(){
	stopRunning();
	return 1;
}
>>>>>>> etapa3
