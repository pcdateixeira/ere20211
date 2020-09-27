%{

	//
	// INF01147 - Compiladores B - 2020/1
	// Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
	// Nome: Pedro Caetano de Abreu Teixeira
	// Numero do cartao: 00228509
	
	#include "hash.h"
	#include "y.tab.h"
	#include "utils.h"
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

"TRUE"							hashInsert(yytext, SYMBOL_LIT_TRUE); return LIT_TRUE;
"FALSE"							hashInsert(yytext, SYMBOL_LIT_FALSE); return LIT_FALSE;

[A-Za-z@_][A-Za-z@_0-9]*		yylval.symbol = hashInsert(yytext, SYMBOL_IDENTIFIER); return TK_IDENTIFIER;

[0-9][0-9A-F]*					yylval.symbol = hashInsert(yytext, SYMBOL_LIT_INTEGER); return LIT_INTEGER;
([0-9][0-9A-F]*)*\.[0-9A-F]+	hashInsert(yytext, SYMBOL_LIT_FLOAT); return LIT_FLOAT;
'.'								hashInsert(yytext, SYMBOL_LIT_CHAR); return LIT_CHAR;
["]([^"\\\n]|\\.|\\\n)*["]		hashInsert(yytext, SYMBOL_LIT_STRING); return LIT_STRING;

"\n"							incLineNumber();

[ \t\0]
"//".*

"/*"							BEGIN(COMMENT);
.								return TOKEN_ERROR;

<COMMENT>.
<COMMENT>"\n"					incLineNumber();
<COMMENT>"*/"					BEGIN(INITIAL);

%%

int yywrap(){
	stopRunning();
	return 1;
}
