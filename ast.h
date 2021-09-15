//
// INF01147 - Compiladores B - 2021/1
// Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#ifndef AST_HEADER
#define AST_HEADER

#include "hash.h"

#define MAX_CHILD_NODES 4

#define AST_SYMBOL 1
#define AST_VEC_SYMBOL 2
#define AST_PROGRAM 3
#define AST_DATASEC 4
#define AST_LGLOBALVAR 5
#define AST_GLOBALVAR 6
#define AST_VEC_GLOBALVAR 7
#define AST_LINITVAL 8
#define AST_TYPE_CHAR 9
#define AST_TYPE_INT 10
#define AST_TYPE_FLOAT 11
#define AST_LFUNCTION 12
#define AST_FUNCTION 13
#define AST_LFUNCPARAM 14
#define AST_BLOCK 15
#define AST_LCMD 16
#define AST_ATTR 17
#define AST_VEC_ATTR 18
#define AST_IF 19
#define AST_IFELSE 20
#define AST_UNTIL 21
#define AST_COMEFROM 22
#define AST_PRINT 23
#define AST_RETURN 24
#define AST_LABEL 25
#define AST_LPRINT 26
#define AST_OP_ADD 27
#define AST_OP_SUB 28
#define AST_OP_MULT 29
#define AST_OP_DIV 30
#define AST_OP_LESS 31
#define AST_OP_GREAT 32
#define AST_OP_OR 33
#define AST_OP_AND 34
#define AST_OP_NOT 35
#define AST_OP_LE 36
#define AST_OP_GE 37
#define AST_OP_EQ 38
#define AST_OP_DIF 39
#define AST_PAREN 40
#define AST_FUNC_CALL 41
#define AST_READ 42
#define AST_LFUNCARG 43

typedef struct astnode
{
	int type;
	HASH_NODE *symbol;
	struct astnode *child[MAX_CHILD_NODES];
} AST;

AST *astCreate(int type, HASH_NODE* symbol, AST* c0, AST* c1, AST* c2, AST* c3);

void astPrint(AST* node, int level);

#endif
