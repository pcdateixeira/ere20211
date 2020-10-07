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
#define AST_LCMD 130
#define AST_ATTR 80
#define AST_VEC_ATTR 90
#define AST_IF 50
#define AST_IFELSE 60
#define AST_WHILE 30
#define AST_LOOP 100
#define AST_READ 70
#define AST_PRINT 110
#define AST_RETURN 40
#define AST_OP_ADD 3
#define AST_OP_SUB 4
#define AST_OP_MULT 5
#define AST_OP_DIV 6
#define AST_OP_LESS 7
#define AST_OP_GREAT 8
#define AST_OP_OR 9
#define AST_OP_AND 10
#define AST_OP_NOT 11
#define AST_OP_LE 12
#define AST_OP_GE 13
#define AST_OP_EQ 14
#define AST_OP_DIF 15
#define AST_FUNC_CALL 16
#define AST_LPRINT 120
#define AST_LFUNCARG 17

typedef struct astnode
{
	int type;
	HASH_NODE *symbol;
	struct astnode *child[MAX_CHILD_NODES];
} AST;

AST *astCreate(int type, HASH_NODE* symbol, AST* c0, AST* c1, AST* c2, AST* c3, AST* c4, AST* c5);

void astPrint(AST* node, int level);

#endif
