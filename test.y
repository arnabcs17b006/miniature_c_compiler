%{
#include<iostream>
#include<string>
#include<stack>
#include<vector>
#define pb push_back
using namespace std;


int yylex();
int yyerror(char *);

typedef struct Snode
{
  	int intVal;
  	float floatVal;
  	string lexVal;
  	bool isInt = false;
  	bool isFloat = false;
    bool isChar = false;
    bool isArray = false;
    bool isPointer = false;
    bool isVariableName = false;
    bool isInitialized = false;
    bool isRegister = false;
    int registerNumber;
    int arraySize;
}Snode;

Snode* createNode(Snode* p)
{
    Snode* n=new Snode();
    n->intVal=p->intVal;
    n->floatVal=p->floatVal;
    n->lexVal=p->lexVal;
    n->isInt=p->isInt;
    n->isFloat=p->isFloat;
    n->isArray=p->isArray;
    n->isChar=p->isChar;
    n->isPointer=p->isPointer;
    n->isVariableName=p->isVariableName;
    n->isInitialized=p->isInitialized;
    n->arraySize=p->arraySize;
    return n;
}

void copyNode(Snode* a, Snode* b)
{
	a->intVal=b->intVal;
	a->floatVal=b->floatVal;
	a->lexVal=b->lexVal;
	a->isInt=b->isInt;
	a->isFloat=b->isFloat;
	a->isChar=b->isChar;
	a->isArray=b->isArray;
	a->isPointer=b->isPointer;
	a->isVariableName=b->isVariableName;
	a->isInitialized=b->isInitialized;
	a->isRegister=b->isRegister;
	a->registerNumber=b->registerNumber;
	a->arraySize=b->arraySize;
}

int globalRegister=0;
char dataType[20];
stack<int> S;
vector<Snode* > V;
vector<string> undeclared;
bool isValid=true;
string variableType="";
vector<string> CODE;

%}
		  
%union
{
	 int intVal;
	 float floatVal;
	 char lexeme[20];
	 struct Snode *snode;
}


%token variableTypeInt variableTypeFloat variableTypeChar variableName variableValueInt variableValueFloat assignment addition subtraction multiplication division moduluss comma scopeOpening scopeClosing arrayOpening arrayClosing semiColon p_ointer parenthesisOpening parenthesisClosing

%type <snode> F
%type <snode> G;
%type <snode> E;
%type <snode> D;
%type <snode> C;
%type <snode> B;
%type <snode> A;
%type <snode> S;
%type <snode> S1;
%type <snode> B1;
%type <snode> B2;
%type <snode> B3;
%type <snode> B4;
%type <snode> B5;
%type <intVal> variableValueInt;
%type <floatVal> variableValueFloat;
%type <lexeme> variableName;


%%
S1 : scopeOpening
	{
		S.push(0);

	} S scopeClosing 
	{
		int i=0;
		while(i<S.top())
		{
			V.pop_back();
			i++;
		}
		S.pop();
	};
S : S A | A ;
A : scopeOpening
	{
		S.push(0);
	} S scopeClosing 
	{
		int i=0;
		while(i<S.top())
		{
			V.pop_back();
			i++;
		}
		S.pop();
	}
	| B ;
B : B1 | B2 ;
B2 : F 
	{
		bool flag=false;
		for(Snode* p: V)
		{
			if(p->lexVal==$1->lexVal)
			{
				
				if(p->isInt==true)
					$1->isInt=true;
				else if(p->isFloat==true)
					$1->isFloat=true;
				flag=true;
				break;
			}

		}
		if(flag==false)
		{
			cout<<"var '"<<$1->lexVal<<"' is not declared in the scope"<<endl;
			return 0;
		}
			
	}
		
assignment B3 semiColon 
	{
		$$ = new Snode;
		cout<<$1->lexVal<<" = ";
		string T="";
		string T3="";
		if($1->isFloat==true)
			T="float";
		else if($1->isInt==true)
			T="int";
		string temp="LD R0, ";
		if($4->isFloat==true)
			T3="float";
		else if($4->isInt==true)
			T3="int";
		if(T!=T3)
			cout<<"("<<T<<")";
		if($4->isRegister==true)
		{
			temp=temp+"t"+to_string($4->registerNumber);
			cout<<"t"<<$4->registerNumber;
		}
		else if($4->isVariableName==true)
		{
			temp=temp+$4->lexVal;
			cout<<$4->lexVal;
		}
		else if($4->isInt==true)
		{
			temp=temp+to_string($4->intVal);
			cout<<$4->intVal;
		}
		else if($4->isFloat==true)
		{
			temp=temp+to_string($4->floatVal);
			cout<<$4->floatVal;
		}
		CODE.pb(temp);
		temp="ST "+$1->lexVal+", R0";
		CODE.pb(temp);

		cout<<endl;
		
	}; 
B3 : B3 addition B4 
	 {
	 	$$ = new Snode;
		$$->isRegister=true;
		$$->registerNumber=globalRegister;
		cout<<"t"<<globalRegister<<" = ";
		globalRegister++;
		string T="";
		string temp="LD R0, ";
		if($1->isFloat==true || $3->isFloat==true)
		{
			$$->isFloat=true;
			T="float";
		}
		else if($1->isInt==true && $3->isInt==true)
		{
			$$->isInt=true;
			T="int";
		}
		//cout<<"T "<<T<<endl;
		string T1="";
		string T3="";
		if($1->isFloat==true)
			T1="float";
		else if($1->isInt==true)
			T1="int";

		if($3->isFloat==true)
			T3="float";
		else if($3->isInt==true)
			T3="int";

		if(T!=T1)
			cout<<"("<<T<<")";	

		if($1->isRegister==true)
		{
			temp=temp+"t"+to_string($1->registerNumber);
			cout<<"t"<<$1->registerNumber;
		}
		else if($1->isVariableName==true)
		{
			temp=temp+$1->lexVal;
			cout<<$1->lexVal;
		}
		else if($1->isInt==true)
		{
			temp=temp+to_string($1->intVal);
			cout<<$1->intVal;
		}
		else if($1->isFloat==true)
		{
			temp=temp+to_string($1->floatVal);
			cout<<$1->floatVal;
		}
		CODE.pb(temp);
		cout<<" + ";
		if(T!=T3)
			cout<<"("<<T<<")";
		temp="LD R1, ";
		if($3->isRegister==true)
		{
			temp=temp+"t"+to_string($3->registerNumber);
			cout<<"t"<<$3->registerNumber;
		}
		else if($3->isVariableName==true)
		{
			temp=temp+$3->lexVal;
			cout<<$3->lexVal;
		}
		else if($3->isInt==true)
		{
			temp=temp+to_string($3->intVal);
			cout<<$3->intVal;
		}
		else if($3->isFloat==true)
		{
		    temp=temp+to_string($3->floatVal);
			cout<<$3->floatVal;
		}
		CODE.pb(temp);
		CODE.pb("ADD R0, R0, R1");
		CODE.pb("ST t"+to_string($$->registerNumber)+", R0");


		cout<<endl;
	}
	| B3 subtraction B4 
	{
		$$ = new Snode;
		$$->isRegister=true;
		$$->registerNumber=globalRegister;
		cout<<"t"<<globalRegister<<" = ";
		globalRegister++;
		string T="";
		string temp="LD R0, ";
		if($1->isFloat==true || $3->isFloat==true)
		{
			$$->isFloat=true;
			T="float";
		}
		else if($1->isInt==true && $3->isInt==true)
		{
			$$->isInt=true;
			T="int";
		}
		//cout<<"T "<<T<<endl;
		string T1="";
		string T3="";
		if($1->isFloat==true)
			T1="float";
		else if($1->isInt==true)
			T1="int";

		if($3->isFloat==true)
			T3="float";
		else if($3->isInt==true)
			T3="int";

		if(T!=T1)
			cout<<"("<<T<<")";	

		if($1->isRegister==true)
		{
			temp=temp+"t"+to_string($1->registerNumber);
			cout<<"t"<<$1->registerNumber;
		}
		else if($1->isVariableName==true)
		{
			temp=temp+$1->lexVal;
			cout<<$1->lexVal;
		}
		else if($1->isInt==true)
		{
			temp=temp+to_string($1->intVal);
			cout<<$1->intVal;
		}
		else if($1->isFloat==true)
		{
			temp=temp+to_string($1->floatVal);
			cout<<$1->floatVal;
		}
		CODE.pb(temp);
		cout<<" - ";
		if(T!=T3)
			cout<<"("<<T<<")";
		temp="LD R1, ";
		if($3->isRegister==true)
		{
			temp=temp+"t"+to_string($3->registerNumber);
			cout<<"t"<<$3->registerNumber;
		}
		else if($3->isVariableName==true)
		{
			temp=temp+$3->lexVal;
			cout<<$3->lexVal;
		}
		else if($3->isInt==true)
		{
			temp=temp+to_string($3->intVal);
			cout<<$3->intVal;
		}
		else if($3->isFloat==true)
		{
		    temp=temp+to_string($3->floatVal);
			cout<<$3->floatVal;
		}
		CODE.pb(temp);
		CODE.pb("SUB R0, R0, R1");
		CODE.pb("ST t"+to_string($$->registerNumber)+", R0");
	}
	| B4 
	{
		$$ = new Snode;
		copyNode($$,$1);
	}
	;
B4 : B4 multiplication B5 
	{
		$$ = new Snode;
		$$->isRegister=true;
		$$->registerNumber=globalRegister;
		cout<<"t"<<globalRegister<<" = ";
		globalRegister++;
		string T="";
		string temp="LD R0, ";
		if($1->isFloat==true || $3->isFloat==true)
		{
			$$->isFloat=true;
			T="float";
		}
		else if($1->isInt==true && $3->isInt==true)
		{
			$$->isInt=true;
			T="int";
		}
		//cout<<"T "<<T<<endl;
		string T1="";
		string T3="";
		if($1->isFloat==true)
			T1="float";
		else if($1->isInt==true)
			T1="int";

		if($3->isFloat==true)
			T3="float";
		else if($3->isInt==true)
			T3="int";

		if(T!=T1)
			cout<<"("<<T<<")";	

		if($1->isRegister==true)
		{
			temp=temp+"t"+to_string($1->registerNumber);
			cout<<"t"<<$1->registerNumber;
		}
		else if($1->isVariableName==true)
		{
			temp=temp+$1->lexVal;
			cout<<$1->lexVal;
		}
		else if($1->isInt==true)
		{
			temp=temp+to_string($1->intVal);
			cout<<$1->intVal;
		}
		else if($1->isFloat==true)
		{
			temp=temp+to_string($1->floatVal);
			cout<<$1->floatVal;
		}
		CODE.pb(temp);
		cout<<" * ";
		if(T!=T3)
			cout<<"("<<T<<")";
		temp="LD R1, ";
		if($3->isRegister==true)
		{
			temp=temp+"t"+to_string($3->registerNumber);
			cout<<"t"<<$3->registerNumber;
		}
		else if($3->isVariableName==true)
		{
			temp=temp+$3->lexVal;
			cout<<$3->lexVal;
		}
		else if($3->isInt==true)
		{
			temp=temp+to_string($3->intVal);
			cout<<$3->intVal;
		}
		else if($3->isFloat==true)
		{
		    temp=temp+to_string($3->floatVal);
			cout<<$3->floatVal;
		}
		CODE.pb(temp);
		CODE.pb("MUL R0, R0, R1");
		CODE.pb("ST t"+to_string($$->registerNumber)+", R0");
		cout<<endl;
	}
	| B4 division B5 
	{
		$$ = new Snode;
		$$->isRegister=true;
		$$->registerNumber=globalRegister;
		cout<<"t"<<globalRegister<<" = ";
		globalRegister++;
		string T="";
		string temp="LD R0, ";
		if($1->isFloat==true || $3->isFloat==true)
		{
			$$->isFloat=true;
			T="float";
		}
		else if($1->isInt==true && $3->isInt==true)
		{
			$$->isInt=true;
			T="int";
		}
		//cout<<"T "<<T<<endl;
		string T1="";
		string T3="";
		if($1->isFloat==true)
			T1="float";
		else if($1->isInt==true)
			T1="int";

		if($3->isFloat==true)
			T3="float";
		else if($3->isInt==true)
			T3="int";

		if(T!=T1)
			cout<<"("<<T<<")";	

		if($1->isRegister==true)
		{
			temp=temp+"t"+to_string($1->registerNumber);
			cout<<"t"<<$1->registerNumber;
		}
		else if($1->isVariableName==true)
		{
			temp=temp+$1->lexVal;
			cout<<$1->lexVal;
		}
		else if($1->isInt==true)
		{
			temp=temp+to_string($1->intVal);
			cout<<$1->intVal;
		}
		else if($1->isFloat==true)
		{
			temp=temp+to_string($1->floatVal);
			cout<<$1->floatVal;
		}
		CODE.pb(temp);
		cout<<" / ";
		if(T!=T3)
			cout<<"("<<T<<")";
		temp="LD R1, ";
		if($3->isRegister==true)
		{
			temp=temp+"t"+to_string($3->registerNumber);
			cout<<"t"<<$3->registerNumber;
		}
		else if($3->isVariableName==true)
		{
			temp=temp+$3->lexVal;
			cout<<$3->lexVal;
		}
		else if($3->isInt==true)
		{
			temp=temp+to_string($3->intVal);
			cout<<$3->intVal;
		}
		else if($3->isFloat==true)
		{
		    temp=temp+to_string($3->floatVal);
			cout<<$3->floatVal;
		}
		CODE.pb(temp);
		CODE.pb("DIV R0, R0, R1");
		CODE.pb("ST t"+to_string($$->registerNumber)+", R0");
	}
	| B4 moduluss B5
	{
		$$ = new Snode;
		$$->isRegister=true;
		$$->registerNumber=globalRegister;
		cout<<"t"<<globalRegister<<" = ";
		globalRegister++;
		string T="";
		string temp="LD R0, ";
		if($1->isFloat==true || $3->isFloat==true)
		{
			$$->isFloat=true;
			T="float";
		}
		else if($1->isInt==true && $3->isInt==true)
		{
			$$->isInt=true;
			T="int";
		}
		//cout<<"T "<<T<<endl;
		string T1="";
		string T3="";
		if($1->isFloat==true)
			T1="float";
		else if($1->isInt==true)
			T1="int";

		if($3->isFloat==true)
			T3="float";
		else if($3->isInt==true)
			T3="int";

		if(T!=T1)
			cout<<"("<<T<<")";	

		if($1->isRegister==true)
		{
			temp=temp+"t"+to_string($1->registerNumber);
			cout<<"t"<<$1->registerNumber;
		}
		else if($1->isVariableName==true)
		{
			temp=temp+$1->lexVal;
			cout<<$1->lexVal;
		}
		else if($1->isInt==true)
		{
			temp=temp+to_string($1->intVal);
			cout<<$1->intVal;
		}
		else if($1->isFloat==true)
		{
			temp=temp+to_string($1->floatVal);
			cout<<$1->floatVal;
		}
		CODE.pb(temp);
		cout<<" % ";
		if(T!=T3)
			cout<<"("<<T<<")";
		temp="LD R1, ";
		if($3->isRegister==true)
		{
			temp=temp+"t"+to_string($3->registerNumber);
			cout<<"t"<<$3->registerNumber;
		}
		else if($3->isVariableName==true)
		{
			temp=temp+$3->lexVal;
			cout<<$3->lexVal;
		}
		else if($3->isInt==true)
		{
			temp=temp+to_string($3->intVal);
			cout<<$3->intVal;
		}
		else if($3->isFloat==true)
		{
		    temp=temp+to_string($3->floatVal);
			cout<<$3->floatVal;
		}
		CODE.pb(temp);
		CODE.pb("MOD R0, R0, R1");
		CODE.pb("ST t"+to_string($$->registerNumber)+", R0");
		cout<<endl;
	}
	| B5 
	{
		$$ = new Snode;
		copyNode($$,$1);
	}; 

B5 : F 
	{
		$$ = new Snode;
		copyNode($$,$1);
		bool flag=false;
		for(Snode* iter: V)
		{
			if((iter->lexVal)==($1->lexVal))
			{
				flag=true;
				if(iter->isInt==true)
					$$->isInt=true;
				else if(iter->isFloat==true)
					$$->isFloat=true;
				//cout<<$$->lexVal<<" id "<<$$->isInt<<" int "<<$$->isFloat<<" float\n";
				break;
			}
		}
		//cout<<"\nFlag for "<<$1->lexVal<<" "<<flag<<endl;
		//cout<<"----------------------\n";
		if(flag==false)
		{
			cout<<"var '"<<$1->lexVal<<"' is not declared in the scope"<<endl;
			return 0;
		}

	}
	| G
	{
		$$ = new Snode;
		copyNode($$,$1);
	} 
	| parenthesisOpening B3 parenthesisClosing
	{
		$$ = new Snode;
		copyNode($$,$2);
	} ;
B1 : C D semiColon ;
C : variableTypeInt
	{
		variableType="int";
	}
 | variableTypeFloat 
 	{
 		variableType="float";
	} ;

D : D comma E 
	{
		int x=S.top();
		S.pop();
		S.push(++x);
		Snode *T=new Snode();
		
		if(variableType=="int")
		{
			$3->isInt=true;	
		}
		else if(variableType=="float")
		{
			$3->isFloat=true;
		}

		//cout<<"\nPushing "<<$3->lexVal<<" int "<<$3->isInt<<" float "<<$3->isFloat<<endl;
		//cout<<"----------------------\n";
		copyNode(T,$3);
		V.push_back(T);
	}
	| E
	{
		int x=S.top();
		S.pop();
		S.push(++x);
		Snode *T=new Snode();
		if(variableType=="int")
		{
			$1->isInt=true;
		}
		else if(variableType=="float")
		{
			$1->isFloat=true;
		}
		//cout<<"\nPushing "<<$1->lexVal<<" int "<<$1->isInt<<" float "<<$1->isFloat<<endl;
		//cout<<"----------------------\n";
		copyNode(T,$1);
		V.push_back(T);
	} ;
E : F assignment G  | F
G : variableValueInt 
	{
        $$ = new Snode;
        $$->isInt = true;
        $$->intVal = $1;
    }
  | variableValueFloat
	{
        $$ = new Snode;
        $$->isFloat = true;
        $$->floatVal = $1;
    };
F : variableName 
	{
		$$ = new Snode;
        $$->isVariableName = true;
        $$->lexVal=$1;
    };
%%

int main()
{
  extern FILE *yyin;
  yyin=fopen("inp.txt","r");	
  yyparse();
  for(string str: CODE)
  	cout<<str<<endl;
}

int yyerror(char *s)
{
  printf("invalid\n");
} 




