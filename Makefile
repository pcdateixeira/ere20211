#
# INF01147 - Compiladores B - 2021/1
# Trabalho Pratico, Etapa 3: Geracao de Arvore Sintatica Abstrata - AST
# Nome: Pedro Caetano de Abreu Teixeira
# Numero do cartao: 00228509
#

etapa3: main.o lex.yy.o y.tab.o hash.o ast.o utils.o
	gcc main.o lex.yy.o y.tab.o hash.o ast.o utils.o -o etapa3

main.o: y.tab.c lex.yy.c main.c
	gcc -c main.c

hash.o: hash.c
	gcc -c hash.c

ast.o: ast.c
	gcc -c ast.c

utils.o: utils.c
	gcc -c utils.c

y.tab.o: y.tab.c
	gcc -c y.tab.c

y.tab.c: parser.y
	yacc parser.y -d

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

lex.yy.c: scanner.l
	lex scanner.l

clean:
	rm lex.yy.c y.tab.c y.tab.h *.o etapa3