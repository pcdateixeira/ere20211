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
	FILE* astFile = fopen("ast.txt", "r"); // Abre o arquivo temporario que contem a AST, gerado por astPrint()
	if (astFile == 0){
		fprintf(stderr, "Erro ao abrir arquivo de saida\n");
		exit(2);
	}

	FILE* outputFile = fopen(fileName, "w"); // Abre o arquivo onde sera recriado o codigo fonte atraves da decompilacao
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

	// Flags de controle pra fechar blocos com chaves
	int dataSecFinished = 0;

	while (fgets(line, 256, astFile) != NULL){ // Laco que le todas os nodos da AST
		if (strstr(line, "AST_PROGRAM") != NULL) // Se e o nodo raiz, nao faz nada
			continue;
		if (strstr(line, "AST_DATASEC") != NULL){ // Se e o nodo do inicio da secao de dados, comeca a sintaxe para isso
			fprintf(outputFile, "data {\n");
		}
		if (strstr(line, "AST_LGLOBALVAR") != NULL){ // Se e um elemento da lista de var. globais, precisa saber qual e seu tipo
			fgets(line, 256, astFile); // "AST_GLOBALVAR, ..." ou "AST_VEC_GLOBALVAR, ..."

			if (strstr(line, "AST_GLOBALVAR") != NULL) { // Se for uma variavel normal
				globalvarname = strstr(line, ", ") + 2;
				globalvarname[strcspn(globalvarname, "\n")] = 0;

				fgets(linetemp, 256, astFile); // "AST_TYPE_...."
				if (strstr(linetemp, "AST_TYPE_CHAR") != NULL)
					globalvartype = "char";
				else if (strstr(linetemp, "AST_TYPE_INT") != NULL)
					globalvartype = "int";
				else globalvartype = "float";

				fprintf(outputFile, "%s: %s = ", globalvartype, globalvarname);

				fgets(line, 256, astFile); // "AST_SYMBOL, ..."
				globalvarvalue = strstr(line, ", ") + 2;
				globalvarvalue[strcspn(globalvarvalue, "\n")] = 0;

				fprintf(outputFile, "%s;\n", globalvarvalue);
			}
			else if (strstr(line, "AST_VEC_GLOBALVAR") != NULL) { // Se for uma variavel do tipo vetor
				globalvarname = strstr(line, ", ") + 2;
				globalvarname[strcspn(globalvarname, "\n")] = 0;

				fgets(linetemp, 256, astFile); // "AST_TYPE_...."
				if (strstr(linetemp, "AST_TYPE_CHAR") != NULL)
					globalvartype = "char";
				else if (strstr(linetemp, "AST_TYPE_INT") != NULL)
					globalvartype = "int";
				else globalvartype = "float";

				fprintf(outputFile, "%s [", globalvartype);

				fgets(linetemp, 256, astFile); // "AST_SYMBOL, ..."
				globalvarvalue = strstr(linetemp, ", ") + 2;
				globalvarvalue[strcspn(globalvarvalue, "\n")] = 0;
				fprintf(outputFile, "%s..", globalvarvalue);

				fgets(linetemp, 256, astFile); // "AST_SYMBOL, ..."
				globalvarvalue = strstr(linetemp, ", ") + 2;
				globalvarvalue[strcspn(globalvarvalue, "\n")] = 0;
				fprintf(outputFile, "%s]: %s", globalvarvalue, globalvarname);

				filePosition = ftell(astFile);
				fgets(line, 256, astFile);
				if (strstr(line, "AST_LINITVAL") == NULL){ // Se for um vetor nao inicializado, para aqui
					fprintf(outputFile, ";\n");
					fseek(astFile, filePosition, SEEK_SET);
				}
				else { // Se for um vetor com valores inicializados, pega eles tambem
					fgets(line, 256, astFile); // "AST_SYMBOL, ..."
					globalvarvalue = strstr(line, ", ") + 2;
					globalvarvalue[strcspn(globalvarvalue, "\n")] = 0;
					fprintf(outputFile, " = %s", globalvarvalue);

					filePosition = ftell(astFile);
					fgets(line, 256, astFile);

					while (strstr(line, "AST_LINITVAL") != NULL){
						fgets(line, 256, astFile); // "AST_SYMBOL, ..."
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
		if (strstr(line, "AST_LFUNCTION") != NULL){ // Se for um elemento da lista de funcoes
			if (dataSecFinished == 0){ // Se e a primeira funcao apos a secao de dados, fecha ela com um '}'
				dataSecFinished = 1;
				fprintf(outputFile, "}\n\n");
			}

			fgets(line, 256, astFile); // "AST_FUNCTION, ..."
			globalvarname = strstr(line, ", ") + 2;
			globalvarname[strcspn(globalvarname, "\n")] = 0;

			fgets(linetemp, 256, astFile); // "AST_TYPE_...."
			if (strstr(linetemp, "AST_TYPE_CHAR") != NULL)
				globalvartype = "char";
			else if (strstr(linetemp, "AST_TYPE_INT") != NULL)
				globalvartype = "int";
			else globalvartype = "float";

			fprintf(outputFile, "%s: %s(", globalvartype, globalvarname);

			filePosition = ftell(astFile);
			fgets(line, 256, astFile); // "AST_LFUNCPARAM, ..." ou "AST_BLOCK"

			if (strstr(line, "AST_LFUNCPARAM") == NULL){ // Se for uma funcao sem parametros, ou seja, o inicio de um bloco
				fprintf(outputFile, ")\n");
				fseek(astFile, filePosition, SEEK_SET);
			}
			else { // Se for uma funcao com parametros, pega eles tambem
				globalvarname = strstr(line, ", ") + 2;
				globalvarname[strcspn(globalvarname, "\n")] = 0;

				fgets(linetemp, 256, astFile); // "AST_TYPE_...."
				if (strstr(linetemp, "AST_TYPE_CHAR") != NULL)
					globalvartype = "char";
				else if (strstr(linetemp, "AST_TYPE_INT") != NULL)
					globalvartype = "int";
				else globalvartype = "float";

				fprintf(outputFile, "%s: %s", globalvartype, globalvarname);

				filePosition = ftell(astFile);
				fgets(line, 256, astFile);

				while (strstr(line, "AST_LFUNCPARAM") != NULL){
					globalvarname = strstr(line, ", ") + 2;
					globalvarname[strcspn(globalvarname, "\n")] = 0;

					fgets(linetemp, 256, astFile); // "AST_TYPE_...."
					if (strstr(linetemp, "AST_TYPE_CHAR") != NULL)
						globalvartype = "char";
					else if (strstr(linetemp, "AST_TYPE_INT") != NULL)
						globalvartype = "int";
					else globalvartype = "float";

					fprintf(outputFile, ", %s: %s", globalvartype, globalvarname);

					filePosition = ftell(astFile);
					fgets(line, 256, astFile);
				}
				fprintf(outputFile, ")\n");
				fseek(astFile, filePosition, SEEK_SET);
			}
		}
		if (strstr(line, "AST_BLOCK") != NULL) { // Se comecou um bloco de codigo de uma funcao
		// Blocos de codigo internos serao tratados dentro deste if, que e somente para blocos de codigos de funcoes
			fprintf(outputFile, "{\n"); // primeiro abre chaves
			printf("%s comeco de bloco\n", line);

			filePosition = ftell(astFile);

			if (fgets(line, 256, astFile) == NULL) // Se a funcao tem uma lista vazia de comandos, e a leitura da AST chegou ao fim
				fprintf(outputFile, "}");
			else if (strstr(line, "AST_LCMD") == NULL){ // Se a leitura nao chegou ao fim, mas a funcao tem uma lista vazia de comandos
				fprintf(outputFile, "}\n");
				printf("%s final de bloco com uma linha a mais\n", line);
				fseek(astFile, filePosition, SEEK_SET);
			}
			else { // Se a funcao tem ao menos um comando
				fprintf(outputFile, "}\n");
			}
		}
	}

	if (dataSecFinished == 0) // Se nao ha nada apos a ultima variavel global na AST, fecha a secao de dados com um '}'
		fprintf(outputFile, "}");

	fclose(astFile);
	//remove("ast.txt"); // Remove o arquivo temporario

	fclose(outputFile);

}