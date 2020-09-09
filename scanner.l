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
"byte"							return KW_BYTE;
"long"							return KW_LONG;

"if" 							return KW_IF;
"then" 							return KW_THEN;
"else" 							return KW_ELSE;
"while" 						return KW_WHILE;
"for" 							return KW_FOR;
"read" 							return KW_READ;
"print" 						return KW_PRINT;
"return" 						return KW_RETURN;
"break"							return KW_BREAK;

[,;:()\[\]{}+\-*/<>=|\^~&$#]	return yytext[0];

"<="							return OPERATOR_LE;
">="							return OPERATOR_GE;
"=="							return OPERATOR_EQ;
"!="							return OPERATOR_DIF;

"TRUE"							return LIT_TRUE;
"FALSE"							return LIT_FALSE;

[A-Za-z@_][A-Za-z@_0-9]*		*Table = hashInsert(yytext, TK_IDENTIFIER); return TK_IDENTIFIER;

[0-9][0-9A-F]*					*Table = hashInsert(yytext, LIT_INTEGER); return LIT_INTEGER;
([0-9][0-9A-F]*)*\.[0-9A-F]+	*Table = hashInsert(yytext, LIT_FLOAT); return LIT_FLOAT;
'.'								*Table = hashInsert(yytext, LIT_CHAR); return LIT_CHAR;
["]([^"\\\n]|\\.|\\\n)*["]		*Table = hashInsert(yytext, LIT_STRING); return LIT_STRING;

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
