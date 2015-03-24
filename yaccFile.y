%{
	#include <iostream>
	#include <stdio.h>
	#include <vector>
	#include "NodeHeader2.h"
	extern int yylineno;
	extern int yylex(void);
	extern void yyerror(char *);

	using namespace std;
	int symbolTable[50];
	int id;
	Stack St;
%}

%union{
	int ivalue;
	char sindex;
	class Node *nptr;
}

%token <ivalue> INTEGER
%token KEYWORD FLOAT
%token <sindex> ALPHA
%token IF ELSE WHILE
%token DECLARE
%token EQ NEQ LEQ GEQ

%type <nptr> block expr statement statements

%left EQ NEQ LEQ GEQ
%left '+' '-' 
%left '*' '/'

%%

start:
	block
	;
block:
	bopen statements bclose	 	{ 
						$$ = St.Pop();
						printf("{}->"); 
					}
	;
bopen:
	'{'				{
						St.Push();
						id = 0;
						printf("{ ...");
					}
	;
bclose:
	'}'				{
						
						//id = pop_id();
						printf("....}->");
					}
	;
statements:	
		statements statement	
		|
		;
statement:
		expr ';'		{ 
						$$ = $1;
					 	St.Add($1);
					  	//printf("Exp:ID:%d\t val:%d\n",id++,$1); 	    
					}	
		|';'
		|IF expr block		{ 
						$$ = Create($2,$3,IF);
						//printf("IF{}\n");
						
					}
		|IF expr block ELSE block	{
							Node *ptr = Create($3,$5,ELSE);
							$$ = Create($2,ptr,IF); 
							printf("IF{}ELSE{}\n");
						}

		|WHILE expr block	{ printf("WHILE{}\n");}

		|DECLARE ALPHA ';' 	{
			 			symbolTable[$2] = 0; 
						//$$ = symbolTable[$2];
					}
		;
expr:
	INTEGER				{ 
						//$$ = $1;		
					}
	|FLOAT
	|ALPHA				{ 
						//$$ = symbolTable[$1]; 
					}
	|'(' expr ')'			{ 	$$ = $2;	}
	| expr '+' expr			{ 
						//$$ = $1+$3;		
					}
	| expr '-' expr			{ 
						//$$ = $1-$3;		
					}
	| expr '*' expr			{ 
						//$$ = $1*$3;		
					}
	| expr '/' expr			{ 
						//$$ = $1/$3;		
					}
	|ALPHA '=' expr 		{
						//symbolTable[$1] = $3;
						//$$ = symbolTable[$1];
					}
	;

%%

void yyerror(char *ch)
{
	printf("\n%s on lineNo:%d\n",ch,yylineno);
}

int main()
{
	yyparse();
	return 0;
}

