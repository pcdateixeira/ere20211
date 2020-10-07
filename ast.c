//
// INF01147 - Compiladores B - 2020/1
// Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

AST *astCreate(int type, HASH_NODE* symbol, AST* c0, AST* c1, AST* c2, AST* c3, AST* c4, AST* c5){
	AST* newnode;
	
	newnode = (AST*) calloc(1, sizeof(AST));
	
	newnode->type = type;
	newnode->symbol = symbol;
	newnode->child[0] = c0;
	newnode->child[1] = c1;
	newnode->child[2] = c2;
	newnode->child[3] = c3;
	newnode->child[4] = c4;
	newnode->child[5] = c5;
	
	return newnode;
}

void astPrint(AST* node, int level){

	if(node == 0)
		return;

	for(int i = 0; i < level; i++)
		fprintf(stderr, "  ");

	fprintf(stderr, "ast(");
	
	switch(node->type){
		case AST_SYMBOL: fprintf(stderr, "AST_SYMBOL"); break;
		case AST_VEC_SYMBOL: fprintf(stderr, "AST_VEC_SYMBOL"); break;
		case AST_OP_ADD: fprintf(stderr, "AST_OP_ADD"); break;
		case AST_OP_SUB: fprintf(stderr, "AST_OP_SUB"); break;
		case AST_OP_MULT: fprintf(stderr, "AST_OP_MULT"); break;
		case AST_OP_DIV: fprintf(stderr, "AST_OP_DIV"); break;
		case AST_OP_LESS: fprintf(stderr, "AST_OP_LESS"); break;
		case AST_OP_GREAT: fprintf(stderr, "AST_OP_GREAT"); break;
		case AST_OP_OR: fprintf(stderr, "AST_OP_OR"); break;
		case AST_OP_AND: fprintf(stderr, "AST_OP_AND"); break;
		case AST_OP_NOT: fprintf(stderr, "AST_OP_NOT"); break;
		case AST_OP_LE: fprintf(stderr, "AST_OP_LE"); break;
		case AST_OP_GE: fprintf(stderr, "AST_OP_GE"); break;
		case AST_OP_EQ: fprintf(stderr, "AST_OP_EQ"); break;
		case AST_OP_DIF: fprintf(stderr, "AST_OP_DIF"); break;
		case AST_FUNC_CALL: fprintf(stderr, "AST_FUNC_CALL"); break;
		case AST_LFUNCARG: fprintf(stderr, "AST_LFUNCARG"); break;
		default: fprintf(stderr, "AST_UNKNOWN"); break;
	}
	
	if(node->symbol != 0)
		fprintf(stderr, ", %s\n", node->symbol->text);
	else
		fprintf(stderr, ", 0\n");
	
	for(int i = 0; i < MAX_CHILD_NODES; i++)
		astPrint(node->child[i], level + 1);
}
