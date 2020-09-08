//
// INF01147 - Compiladores B - 2020/1
// Trabalho Pratico, Etapa 2: Analise Sintatica e Preenchimento da Tabela de Simbolos
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#include <stdio.h>
#include <stdlib.h>

//lex.yy.h
int yylex();
extern char *yytext;
extern FILE *yyin;


int isRunning(void);
void initMe(void);

int main(int argc, char ** argv){
	if(argc < 2){
		fprintf(stderr, "Argumentos insuficientes.\nChamada de execução: etapa1 nomeDoArquivo\n");
		exit(1);
	}
	yyin = fopen(argv[1],"r");
	if(yyin == 0){
		fprintf(stderr, "Erro ao abrir arquivo %s\n", argv[1]);
		exit(2);
	}
	
	int tok;
	
	initMe();
	
	printf("Análise léxica começando...\n");
	while(isRunning()){
		tok = yylex();
		
		if (!isRunning())
			break;
      
		switch(tok){
			case KW_CHAR:		printf("%s:%d: Palavra reservada char\n", argv[1], getLineNumber()); break;
			case KW_INT:		printf("%s:%d: Palavra reservada int\n", argv[1], getLineNumber()); break;
			case KW_FLOAT:		printf("%s:%d: Palavra reservada float\n", argv[1], getLineNumber()); break;
			case KW_BOOL:		printf("%s:%d: Palavra reservada bool\n", argv[1], getLineNumber()); break;
			
			case KW_IF:			printf("%s:%d: Palavra reservada if\n", argv[1], getLineNumber()); break;
			case KW_THEN:		printf("%s:%d: Palavra reservada then\n", argv[1], getLineNumber()); break;
			case KW_ELSE:		printf("%s:%d: Palavra reservada else\n", argv[1], getLineNumber()); break;
			case KW_WHILE:		printf("%s:%d: Palavra reservada while\n", argv[1], getLineNumber()); break;
			case KW_LOOP:		printf("%s:%d: Palavra reservada loop\n", argv[1], getLineNumber()); break;
			case KW_READ:		printf("%s:%d: Palavra reservada read\n", argv[1], getLineNumber()); break;
			case KW_PRINT:		printf("%s:%d: Palavra reservada print\n", argv[1], getLineNumber()); break;
			case KW_RETURN:		printf("%s:%d: Palavra reservada return\n", argv[1], getLineNumber()); break;
			
			case OPERATOR_LE:	printf("%s:%d: Operador <=\n", argv[1], getLineNumber()); break;
			case OPERATOR_GE:	printf("%s:%d: Operador >=\n", argv[1], getLineNumber()); break;
			case OPERATOR_EQ:	printf("%s:%d: Operador ==\n", argv[1], getLineNumber()); break;
			case OPERATOR_DIF:	printf("%s:%d: Operador !=\n", argv[1], getLineNumber()); break;
			
			case LIT_TRUE:		printf("%s:%d: Literal TRUE\n", argv[1], getLineNumber()); break;
			case LIT_FALSE:		printf("%s:%d: Literal FALSE\n", argv[1], getLineNumber()); break;
			
			case TK_IDENTIFIER:	printf("%s:%d: Identificador %s\n", argv[1], getLineNumber(), yytext); break;
			
			case LIT_INTEGER:	printf("%s:%d: Literal inteiro %s\n", argv[1], getLineNumber(), yytext); break;
			case LIT_FLOAT:		printf("%s:%d: Literal real %s\n", argv[1], getLineNumber(), yytext); break;
			case LIT_CHAR:		printf("%s:%d: Literal caractere %s\n", argv[1], getLineNumber(), yytext); break;
			case LIT_STRING:	printf("%s:%d: Literal string %s\n", argv[1], getLineNumber(), yytext); break;
			
			case TOKEN_ERROR:	printf("%s:%d: Erro, lexema não reconhecido\n", argv[1], getLineNumber()); break;
			default:			printf("%s:%d: Símbolo %c de código ASCII %d\n", argv[1], getLineNumber(), tok, (int)tok); break;
		}
	}
	printf("Análise léxica concluída.\n");
	printf("\n---\n\n");
	printf("Tabela de símbolos:\n");
	hashPrint();
}
