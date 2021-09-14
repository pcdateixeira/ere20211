//
// INF01147 - Compiladores B - 2021/1
// Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

AST *astCreate(int type, HASH_NODE* symbol, AST* c0, AST* c1, AST* c2, AST* c3){
	AST* newnode;
	
	newnode = (AST*) calloc(1, sizeof(AST));
	
	newnode->type = type;
	newnode->symbol = symbol;
	newnode->child[0] = c0;
	newnode->child[1] = c1;
	newnode->child[2] = c2;
	newnode->child[3] = c3;
	
	return newnode;
}

void astPrint(AST* node, int level){

	if(node == 0)
		return;
	
	FILE* outputFile = fopen("o.txt", "a"); // Usa um arquivo temporario para imprimir a AST, que sera usado em decompileAST(fileName) para gerar o codigo fonte descompilado
	if (outputFile == 0){
		fprintf(stderr, "Erro ao abrir arquivo de saida\n");
		exit(2);
	}

	for(int i = 0; i < level; i++)
		fprintf(outputFile, "  ");
	
	switch(node->type){
		
		case AST_SYMBOL: fprintf(outputFile, "AST_SYMBOL"); break;
		case AST_VEC_SYMBOL: fprintf(outputFile, "AST_VEC_SYMBOL"); break;
		case AST_PROGRAM: fprintf(outputFile, "AST_PROGRAM"); break;
		case AST_DATASEC: fprintf(outputFile, "AST_DATASEC"); break;
		case AST_LGLOBALVAR: fprintf(outputFile, "AST_LGLOBALVAR"); break;
		case AST_GLOBALVAR: fprintf(outputFile, "AST_GLOBALVAR"); break;
		case AST_VEC_GLOBALVAR: fprintf(outputFile, "AST_VEC_GLOBALVAR"); break;
		case AST_LINITVAL: fprintf(outputFile, "AST_LINITVAL"); break;
		case AST_TYPE_CHAR: fprintf(outputFile, "AST_TYPE_CHAR"); break;
		case AST_TYPE_INT: fprintf(outputFile, "AST_TYPE_INT"); break;
		case AST_TYPE_FLOAT: fprintf(outputFile, "AST_TYPE_FLOAT"); break;
		case AST_LFUNCTION: fprintf(outputFile, "AST_LFUNCTION"); break;
		case AST_FUNCTION: fprintf(outputFile, "AST_FUNCTION"); break;
		case AST_LFUNCPARAM: fprintf(outputFile, "AST_LFUNCPARAM"); break;
		case AST_BLOCK: fprintf(outputFile, "AST_BLOCK"); break;
		case AST_LCMD: fprintf(outputFile, "AST_LCMD"); break;
		case AST_ATTR: fprintf(outputFile, "AST_ATTR"); break;
		case AST_VEC_ATTR: fprintf(outputFile, "AST_VEC_ATTR"); break;
		case AST_IF: fprintf(outputFile, "AST_IF"); break;
		case AST_IFELSE: fprintf(outputFile, "AST_IFELSE"); break;
		case AST_UNTIL: fprintf(outputFile, "AST_UNTIL"); break;
		case AST_COMEFROM: fprintf(outputFile, "AST_COMEFROM"); break;
		case AST_PRINT: fprintf(outputFile, "AST_PRINT"); break;
		case AST_RETURN: fprintf(outputFile, "AST_RETURN"); break;
		case AST_LABEL: fprintf(outputFile, "AST_LABEL"); break;
		case AST_LPRINT: fprintf(outputFile, "AST_LPRINT"); break;
		case AST_OP_ADD: fprintf(outputFile, "AST_OP_ADD"); break;
		case AST_OP_SUB: fprintf(outputFile, "AST_OP_SUB"); break;
		case AST_OP_MULT: fprintf(outputFile, "AST_OP_MULT"); break;
		case AST_OP_DIV: fprintf(outputFile, "AST_OP_DIV"); break;
		case AST_OP_LESS: fprintf(outputFile, "AST_OP_LESS"); break;
		case AST_OP_GREAT: fprintf(outputFile, "AST_OP_GREAT"); break;
		case AST_OP_OR: fprintf(outputFile, "AST_OP_OR"); break;
		case AST_OP_AND: fprintf(outputFile, "AST_OP_AND"); break;
		case AST_OP_NOT: fprintf(outputFile, "AST_OP_NOT"); break;
		case AST_OP_LE: fprintf(outputFile, "AST_OP_LE"); break;
		case AST_OP_GE: fprintf(outputFile, "AST_OP_GE"); break;
		case AST_OP_EQ: fprintf(outputFile, "AST_OP_EQ"); break;
		case AST_OP_DIF: fprintf(outputFile, "AST_OP_DIF"); break;
		case AST_PAREN: fprintf(outputFile, "AST_PAREN"); break;
		case AST_FUNC_CALL: fprintf(outputFile, "AST_FUNC_CALL"); break;
		case AST_READ: fprintf(outputFile, "AST_READ"); break;
		case AST_LFUNCARG: fprintf(outputFile, "AST_LFUNCARG"); break;
		default: fprintf(outputFile, "AST_UNKNOWN"); break;
	}
	
	if(node->symbol != 0)
		fprintf(outputFile, ", %s\n", node->symbol->text);
	else
		fprintf(outputFile, "\n");
	
	fclose(outputFile);
	
	for(int i = 0; i < MAX_CHILD_NODES; i++)
		astPrint(node->child[i], level + 1);
}
