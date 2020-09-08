#
# INF01147 - Compiladores B - 2020/1
# Trabalho Pratico, Etapa 2: Analise Sintatica e Preenchimento da Tabela de Simbolos
# Nome: Pedro Caetano de Abreu Teixeira
# Numero do cartao: 00228509
#
# Makefile for single compiler call
# All source files must be included from code embedded in scanner.l
# In our case, you probably need #include "hash.c" at the beginning
# and #include "main.c" in the last part of the scanner.l
#

etapa1: lex.yy.c
	gcc -o etapa2 lex.yy.c
lex.yy.c: scanner.l
	lex scanner.l

clean:
	rm lex.yy.c etapa2
