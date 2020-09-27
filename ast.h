//
// INF01147 - Compiladores B - 2020/1
// Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#ifndef AST_HEADER
#define AST_HEADER

#include "hash.h"

#define MAX_CHILD_NODES 6

#define AST_SYMBOL 1
#define AST_VEC_SYMBOL 2
#define AST_ADD 3
#define AST_SUB 4
#define AST_FUNC_CALL 5

typedef struct astnode
{
	int type;
	HASH_NODE *symbol;
	struct astnode *child[MAX_CHILD_NODES];
} AST;

AST *astCreate(int type, HASH_NODE* symbol, AST* c0, AST* c1, AST* c2, AST* c3, AST* c4, AST* c5);

void astPrint(AST* node, int level);

#endif
