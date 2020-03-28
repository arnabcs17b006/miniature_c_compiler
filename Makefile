minicc: y.tab.c lex.yy.c y.tab.h
	g++ -std=c++11 y.tab.c lex.yy.c  -ll -ly  -o minicc
lex.yy.c: test.l
	lex test.l
y.tab.c: test.y
	yacc -v -d test.y
clean:
	rm -f minicc y.tab.c lex.yy.c y.tab.h y.output
