//
// INF01147 - Compiladores B - 2021/1
// Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
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

void decompileAst(char *fileName){
	FILE* astFile = fopen("o.txt", "r"); // Abre o arquivo temporario que contem a AST, gerado por astPrint()
	if (astFile == 0){
		fprintf(stderr, "Erro ao abrir arquivo de saida\n");
		exit(2);
	}

	FILE* outputFile = fopen(fileName, "w");
	if (outputFile == 0){
		fprintf(stderr, "Erro ao abrir arquivo de saida\n");
		exit(2);
	}

	char line[256];
	char linetemp[256];
	char* globalvarname;
	char* globalvartype;
	char* globalvarvalue;
	int filePosition;
	int endDataSec = 0;

	while (fgets(line, 256, astFile) != NULL){
		if (strstr(line, "AST_PROGRAM") != NULL)
			continue;
		if (strstr(line, "AST_DATASEC") != NULL){
			fprintf(outputFile, "data {\n");
		}
		if (strstr(line, "AST_LGLOBALVAR") != NULL){
			fgets(line, 256, astFile);

			if (strstr(line, "AST_GLOBALVAR") != NULL) {
				globalvarname = strstr(line, ", ") + 2;
				globalvarname[strcspn(globalvarname, "\n")] = 0;

				fgets(linetemp, 256, astFile); //"AST_TYPE_...."
				if (strstr(linetemp, "AST_TYPE_CHAR") != NULL)
					globalvartype = "char";
				else if (strstr(linetemp, "AST_TYPE_INT") != NULL)
					globalvartype = "int";
				else globalvartype = "float";

				fprintf(outputFile, "%s: %s = ", globalvartype, globalvarname);

				fgets(line, 256, astFile); //"AST_SYMBOL, ..."
				globalvarvalue = strstr(line, ", ") + 2;
				globalvarvalue[strcspn(globalvarvalue, "\n")] = 0;

				fprintf(outputFile, "%s;\n", globalvarvalue);
			}
			else if (strstr(line, "AST_VEC_GLOBALVAR") != NULL) {
				globalvarname = strstr(line, ", ") + 2;
				globalvarname[strcspn(globalvarname, "\n")] = 0;

				fgets(linetemp, 256, astFile); //"AST_TYPE_...."
				if (strstr(linetemp, "AST_TYPE_CHAR") != NULL)
					globalvartype = "char";
				else if (strstr(linetemp, "AST_TYPE_INT") != NULL)
					globalvartype = "int";
				else globalvartype = "float";

				fprintf(outputFile, "%s [", globalvartype);

				fgets(linetemp, 256, astFile); //"AST_SYMBOL, ..."
				globalvarvalue = strstr(linetemp, ", ") + 2;
				globalvarvalue[strcspn(globalvarvalue, "\n")] = 0;
				fprintf(outputFile, "%s..", globalvarvalue);

				fgets(linetemp, 256, astFile); //"AST_SYMBOL, ..."
				globalvarvalue = strstr(linetemp, ", ") + 2;
				globalvarvalue[strcspn(globalvarvalue, "\n")] = 0;
				fprintf(outputFile, "%s]: %s", globalvarvalue, globalvarname);

				filePosition = ftell(astFile);
				fgets(line, 256, astFile);
				if (strstr(line, "AST_LINITVAL") == NULL){
					fprintf(outputFile, ";\n");
					fseek(astFile, filePosition, SEEK_SET);
				}
				else {
					fgets(line, 256, astFile); //"AST_SYMBOL, ..."
					globalvarvalue = strstr(line, ", ") + 2;
					globalvarvalue[strcspn(globalvarvalue, "\n")] = 0;
					fprintf(outputFile, " = %s", globalvarvalue);

					filePosition = ftell(astFile);
					fgets(line, 256, astFile);

					while (strstr(line, "AST_LINITVAL") != NULL){
						fgets(line, 256, astFile); //"AST_SYMBOL, ..."
						globalvarvalue = strstr(line, ", ") + 2;
						globalvarvalue[strcspn(globalvarvalue, "\n")] = 0;
						fprintf(outputFile, " %s", globalvarvalue);

						filePosition = ftell(astFile);
						fgets(line, 256, astFile);
					}
					fprintf(outputFile, ";\n");
					fseek(astFile, filePosition, SEEK_SET);
				}
			}
		}
		if (strstr(line, "AST_LFUNCTION") != NULL){
			if (endDataSec == 0){ // Se e a primeira funcao apos a secao de dados, fecha ela com um '}'
				endDataSec = 1;
				fprintf(outputFile, "}\n");
			}
		}
	}

	if (endDataSec == 0) // Se nao ha nada apos a ultima variavel global na AST, fecha a secao de dados com um '}'
		fprintf(outputFile, "}");

	fclose(astFile);
	//remove("o.txt"); // Remove o arquivo temporario

	fclose(outputFile);

}