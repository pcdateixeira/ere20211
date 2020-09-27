#
# INF01147 - Compiladores B - 2020/1
# Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
# Nome: Pedro Caetano de Abreu Teixeira
# Numero do cartao: 00228509
#
# Makefile for single compiler call
# All source files must be included from code embedded in scanner.l
# In our case, you probably need #include "hash.c" at the beginning
# and #include "main.c" in the last part of the scanner.l
#

etapa3: main.o y.tab.o lex.yy.o hash.o utils.o
	gcc main.o y.tab.o lex.yy.o hash.o utils.o -o etapa3
main.o: main.c
	gcc -c main.c	
y.tab.o: y.tab.c
	gcc -c y.tab.c
lex.yy.o: lex.yy.c
	gcc -c lex.yy.c
hash.o: hash.c
	gcc -c hash.c
utils.o: utils.c
	gcc -c utils.c
y.tab.c: parser.y
	yacc -d parser.y
lex.yy.c: scanner.l
	lex scanner.l

clean:
	rm lex.yy.c y.tab.c y.tab.h *.o etapa3
