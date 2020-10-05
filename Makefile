#
# INF01147 - Compiladores B - 2020/1
# Trabalho Pratico, Etapa 1: Analise Lexica e Inicializacao da Tabela de Simbolos
# Nome: Pedro Caetano de Abreu Teixeira
# Numero do cartao: 00228509
#
# Makefile for single compiler call
# All source files must be included from code embedded in scanner.l
# In our case, you probably need #include "hash.c" at the beginning
# and #include "main.c" in the last part of the scanner.l
#

etapa2: y.tab.c lex.yy.c
	gcc -o etapa2 lex.yy.c
y.tab.c: parser.y
	yacc -d parser.y
lex.yy.c: scanner.l
	lex scanner.l

clean:
	rm lex.yy.c y.tab.c y.tab.h etapa2
