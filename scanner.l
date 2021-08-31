%{

	//
	// INF01147 - Compiladores B - 2020/1
	// Trabalho Pratico, Etapa 1: Analise Lexica e Inicializacao da Tabela de Simbolos
	// Nome: Pedro Caetano de Abreu Teixeira
	// Numero do cartao: 00228509
	
	#include "y.tab.h"
	#include "hash.h"
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

[A-Za-z]([A-Za-z 0-9]+[A-Za-z0-9])* hashInsert(yytext, SYMBOL_IDENTIFIER); return TK_IDENTIFIER;

[0-9]+								hashInsert(yytext, SYMBOL_LIT_INTEGER); return LIT_INTEGER;
'.'									hashInsert(yytext, SYMBOL_LIT_CHAR); return LIT_CHAR;
["]([^"\\\n]|\\.|\\\n)*["]			hashInsert(yytext, SYMBOL_LIT_STRING); return LIT_STRING;

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