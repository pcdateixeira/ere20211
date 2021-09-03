//
// INF01147 - Compiladores B - 2021/1
// Trabalho Pratico, Etapa 2: Análise Sintática e Preenchimento da Tabela de Símbolos
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
