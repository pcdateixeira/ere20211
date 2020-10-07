//
// INF01147 - Compiladores B - 2020/1
// Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#ifndef AST_HEADER
#define AST_HEADER

#include "hash.h"

#define MAX_CHILD_NODES 4

#define AST_LDECL 1
#define AST_DECL 2
#define AST_VEC_DECL 3
#define AST_SYMBOL 4
#define AST_VEC_SYMBOL 5
#define AST_TYPE_CHAR 6
#define AST_TYPE_INT 7
#define AST_TYPE_FLOAT 8
#define AST_TYPE_BOOL 9
#define AST_LINITVAL 10
#define AST_FUNCTION 11
#define AST_LFUNCPARAM 12
#define AST_BLOCK 13
#define AST_LCMD 14
#define AST_ATTR 15
#define AST_VEC_ATTR 16
#define AST_IF 17
#define AST_IFELSE 18
#define AST_WHILE 19
#define AST_LOOP 20
#define AST_READ 21
#define AST_PRINT 22
#define AST_RETURN 23
#define AST_OP_ADD 24
#define AST_OP_SUB 25
#define AST_OP_MULT 26
#define AST_OP_DIV 27
#define AST_OP_LESS 28
#define AST_OP_GREAT 29
#define AST_OP_OR 30
#define AST_OP_AND 31
#define AST_OP_NOT 32
#define AST_OP_LE 33
#define AST_OP_GE 34
#define AST_OP_EQ 35
#define AST_OP_DIF 36
#define AST_PAREN 37
#define AST_FUNC_CALL 38
#define AST_LPRINT 39
#define AST_LFUNCARG 40

typedef struct astnode
{
	int type;
	HASH_NODE *symbol;
	struct astnode *child[MAX_CHILD_NODES];
} AST;

AST *astCreate(int type, HASH_NODE* symbol, AST* c0, AST* c1, AST* c2, AST* c3);

void astPrint(AST* node, int level);

#endif
