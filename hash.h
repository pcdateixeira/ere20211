//
// INF01147 - Compiladores B - 2020/1
// Trabalho Pratico, Etapa 1: Analise Lexica e Inicializacao da Tabela de Simbolos
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#include <stdio.h>

#define HASH_SIZE 997

typedef struct hash_node
{
	int type;
	char *text;
	struct hash_node * next;
} HASH_NODE;

void hashInit(void);
int hashAddress(char *text);
HASH_NODE *hashFind(char *text);
HASH_NODE *hashInsert(char *text);
void hashPrint(void);

// END
