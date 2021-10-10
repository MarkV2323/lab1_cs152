%{
    int currentLine = 1;        /* Setup Line and Depth tracking variables */
    int currentColumn = 0;
%}

DIGIT		[0-9]
IDENT		[a-z][a-zA-Z0-9]*
WHITESPACE	[ \t\0]
WHITESPACENL	[\n\r]
INVALIDSTART	[0-9|_][a-zA-Z0-9]*
INVALIDEND	[a-zA-Z][a-zA-Z0-9|_]*[_]
COMMENTS	[##].*

%%
"function"	{printf("FUNCTION\n"); currentColumn += yyleng;} /* Reserved Words */
"beginparams" 	{printf("BEGIN_PARAMS\n"); currentColumn += yyleng;}
"endparams"     {printf("END_PARAMS\n"); currentColumn += yyleng;}
"beginlocals" 	{printf("BEGIN_LOCALS\n"); currentColumn += yyleng;}
"endlocals"     {printf("END_LOCALS\n"); currentColumn += yyleng;}
"beginbody"     {printf("BEGIN_BODY\n"); currentColumn += yyleng;}
"endbody"     	{printf("END_BODY\n"); currentColumn += yyleng;}
"integer"   	{printf("INTEGER\n"); currentColumn += yyleng;}
"read"     	{printf("READ\n"); currentColumn += yyleng;}
"write"     	{printf("WRITE\n"); currentColumn += yyleng;}
"array"	    	{printf("ARRAY\n"); currentColumn += yyleng;}
"of"		{printf("OF\n"); currentColumn += yyleng;}
"if"		{printf("IF\n"); currentColumn += yyleng;}
"then"		{printf("THEN\n"); currentColumn += yyleng;}
"endif"		{printf("ENDIF\n"); currentColumn += yyleng;}
"else"		{printf("ELSE\n"); currentColumn += yyleng;}
"while"		{printf("WHILE\n"); currentColumn += yyleng;}
"do"		{printf("DO\n"); currentColumn += yyleng;}
"beginloop"	{printf("BEGINLOOP\n"); currentColumn += yyleng;}
"endloop"	{printf("ENDLOOP\n"); currentColumn += yyleng;}
"continue"	{printf("CONTINUE\n"); currentColumn += yyleng;}
"and"		{printf("AND\n"); currentColumn += yyleng;}
"or"		{printf("OR\n"); currentColumn += yyleng;}
"not"		{printf("NOT\n"); currentColumn += yyleng;}
"true"		{printf("TRUE\n"); currentColumn += yyleng;}
"false"		{printf("FALSE\n"); currentColumn += yyleng;}
"return"	{printf("RETURN\n"); currentColumn += yyleng;}

"-"     {printf("SUB\n"); currentColumn += yyleng;} /* Arithmetic Operators */
"+"     {printf("ADD\n"); currentColumn += yyleng;}
"*"     {printf("MULT\n"); currentColumn += yyleng;}
"/"     {printf("DIV\n"); currentColumn += yyleng;}
"%"     {printf("MOD\n"); currentColumn += yyleng;}

"=="	{printf("EQ\n"); currentColumn += yyleng;} /* Comparison Operators */
"<"	{printf("LT\n"); currentColumn += yyleng;}
">"	{printf("GT\n"); currentColumn += yyleng;}
"<="	{printf("LTE\n"); currentColumn += yyleng;}
"=>"	{printf("GTE\n"); currentColumn += yyleng;}
"<>"	{printf("NEQ\n"); currentColumn += yyleng;}

";"     {printf("SEMICOLON\n"); currentColumn += yyleng;} /* Other Special Symbols */
":"     {printf("COLON\n"); currentColumn += yyleng;}
"("     {printf("L_PAREN\n"); currentColumn += yyleng;}
")"     {printf("R_PAREN\n"); currentColumn += yyleng;}
":="   	{printf("ASSIGN\n"); currentColumn += yyleng;}
","	{printf("COMMA\n"); currentColumn += yyleng;}
"["	{printf("L_SQUARE_BRACKET\n"); currentColumn += yyleng;}
"]"	{printf("R_SQUARE_BRACKET\n"); currentColumn += yyleng;}

{IDENT}		{printf("IDENT\n"); currentColumn += yyleng;} /* Identifiers */

{DIGIT}+	{printf("INT\n"); currentColumn += yyleng;} /* Numbers */

{WHITESPACE}+ 	{printf("WHITESPACE\n"); currentColumn += yyleng;} /* WHITESPACE */
{WHITESPACENL}+ {printf("WHITESPACENL\n"); currentColumn = 0; currentLine += 1;} /* WHITESPACENL */

{INVALIDSTART}	{printf("Error at line %d, column $d: identifier \"%s\" must begin with a letter\n",
		    currentLine, currentColumn, yytext); exit(1);} /*Invalid identifiers: must start with a letter */

{INVALIDEND}	{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n",
		    currentLine, currentColumn, yytext); exit(1);} /*Invalid identifiers: cannot end with an underscore */

{COMMENTS}	{currentLine += 1; currentColumn = 0;} /*Comments on a single line */

.		{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n",
                    currentLine, currentColumn, yytext); exit(1);}                        /* Catch anything else */

%%

int main(int argc, char ** argv) {
        // allows for a file or command line arguments
        if (argc >= 2) {
            yyin = fopen(argv[1], "r");
            yylex();
            fclose(yyin);
        } else {
            yylex();
        }
}
