#
# INF01147 - Compiladores B - 2021/1
# Trabalho Pratico, Etapa 1: Analise Lexica e Inicializacao da Tabela de Simbolos
# Nome: Pedro Caetano de Abreu Teixeira
# Numero do cartao: 00228509
#

etapa1: main.o lex.yy.o hash.o utils.o
	gcc main.o lex.yy.o hash.o utils.o -o etapa1

main.o: lex.yy.c main.c
	gcc -c main.c

hash.o: hash.c
	gcc -c hash.c

utils.o: utils.c
	gcc -c utils.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

lex.yy.c: scanner.l
	lex scanner.l

clean:
	rm lex.yy.c *.o etapa1