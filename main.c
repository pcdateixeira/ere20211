//
// INF01147 - Compiladores B - 2020/1
// Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#include <stdio.h>
#include <stdlib.h>
#include "hash.h"

int yylex();
extern char *yytext;
extern FILE *yyin;
extern int yyparse(void);


int isRunning(void);
void initMe(void);

int main(int argc, char ** argv){
	if (argc < 2){
		fprintf(stderr, "Argumentos insuficientes.\nChamada de execução: etapa1 nomeDoArquivo\n");
		exit(1);
	}
	yyin = fopen(argv[1],"r");
	if (yyin == 0){
		fprintf(stderr, "Erro ao abrir arquivo %s\n", argv[1]);
		exit(2);
	}
	
	int tok;
	
	initMe();
	
	printf("Análise sintática começando...\n");	
	yyparse();
	printf("Análise sintática concluída.\n");
	printf("\n---\n\n");
	
	printf("Tabela de símbolos:\n");
	hashPrint();
	
	exit(0);
}
