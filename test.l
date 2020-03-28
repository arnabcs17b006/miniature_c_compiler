%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}
alpha [A-Za-z]
digit [0-9]
%%
"int"								{return variableTypeInt;}
"float"								{return variableTypeFloat;}
"char"								{return variableTypeChar;}
{alpha}({alpha}|{digit})*    		{strcpy(yylval.lexeme, yytext); return variableName; }
{digit}+ 							{yylval.intVal = atoi(yytext); return variableValueInt;}
{digit}+.{digit}+					{yylval.floatVal = atof(yytext); return variableValueFloat;}
"="									{return assignment;}
"+"									{return addition;}
"-"									{return subtraction;}
"*"									{return multiplication;}
"/"									{return division;}
"%"									{return moduluss;}
"["									{return arrayOpening;}
"]"									{return arrayClosing;}
"{"									{return scopeOpening;}
"}"									{return scopeClosing;}
"("									{return parenthesisOpening;}
")"									{return parenthesisClosing;}
","									{return comma;}
";"									{return semiColon;}
"*"									{return p_ointer;}



[ \t\n] ;      /* ignore white space */


.  		{ return yytext[0]; }
%%
