//
// INF01147 - Compiladores B - 2021/1
// Trabalho Pratico, Etapa 1: Analise Lexica e Inicializacao da Tabela de Simbolos
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#include <stdio.h>
#include <stdlib.h>
#include "tokens.h"

int yylex();
extern char *yytext;
extern FILE *yyin;

void initMe(void);
int getLineNumber(void);
int isRunning(void);
void hashPrint(void);

int main(int argc, char **argv){
	if (argc < 2){
		fprintf(stderr, "Argumentos insuficientes.\nChamada de execucao: etapa1 nomeDoArquivo\n");
		exit(1);
	}

	yyin = fopen(argv[1], "r");
	if (yyin == 0){
		fprintf(stderr, "Erro ao abrir o arquivo %s\n", argv[1]);
		exit(2);		
	}

	int tok;
	initMe();

	printf("Analise lexica comecando...\n");
	while(isRunning()){ 
		tok = yylex();

		if (!isRunning()) break;

		printf("%s:%d: ", argv[1], getLineNumber());
		switch(tok){
			case KW_CHAR:			printf("Palavra reservada char\n"); break;
			case KW_INT:			printf("Palavra reservada int\n"); break;
			case KW_FLOAT:			printf("Palavra reservada float\n"); break;
			case KW_DATA:			printf("Palavra reservada data\n"); break;

			case KW_IF:				printf("Palavra reservada if\n"); break;
			case KW_ELSE:			printf("Palavra reservada else\n"); break;
			case KW_UNTIL:			printf("Palavra reservada until\n"); break;
			case KW_COMEFROM:		printf("Palavra reservada comefrom\n"); break;
			case KW_READ:			printf("Palavra reservada read\n"); break;
			case KW_PRINT:			printf("Palavra reservada print\n"); break;
			case KW_RETURN:			printf("Palavra reservada return\n"); break;

			case OPERATOR_LE:		printf("Operador <=\n"); break;
			case OPERATOR_GE:		printf("Operador >=\n"); break;
			case OPERATOR_EQ:		printf("Operador ==\n"); break;
			case OPERATOR_DIF:		printf("Operador !=\n"); break;
			case OPERATOR_RANGE:	printf("Operador ..\n"); break;

			case TK_IDENTIFIER:		printf("Identificador %s\n", yytext); break;

			case LIT_INTEGER:		printf("Literal inteiro %s\n", yytext); break;
			case LIT_CHAR:			printf("Literal caractere %s\n", yytext); break;
			case LIT_STRING:		printf("Literal string %s\n", yytext); break;

			case TOKEN_ERROR:		printf("Erro, lexema nao reconhecido\n"); break;
			default:				printf("Simbolo %c de codigo ASCII %d\n", tok, (int)tok);
		}
	}

	printf("Analise lexica concluida. Numero de linhas: %d\n", getLineNumber());
	printf("\n---\n\n");
	printf("Tabela de simbolos:\n");
	hashPrint();
	exit(0);
}