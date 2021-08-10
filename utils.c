//
// INF01147 - Compiladores B - 2021/1
// Trabalho Pratico, Etapa 1: Analise Lexica e Inicializacao da Tabela de Simbolos
// Nome: Pedro Caetano de Abreu Teixeira
// Numero do cartao: 00228509

#include "utils.h"

int Running;
int LineNumber;

void initMe(void){
	Running = 1;
	LineNumber = 1;
	hashInit();
}

int getLineNumber(void){
	return LineNumber;
}

void incLineNumber(void){
	++LineNumber;
}

int isRunning(void){
	return Running;
}

void stopRunning(void){
	Running = 0;
}
