%{
    int currentLine = 1;        /* Setup Line and Depth tracking variables */
    int currentColumn = 0;
%}

DIGIT   [0-9]
IDENT   [a-z][a-zA-Z0-9]*
WHITESPACE [ \t\0]
WHITESPACENL [\n\r]

%%
function     {printf("FUNCT\n"); currentColumn += yyleng;} /* Reserved Words */
"beginparams"     {printf("BEGIN_PARAMS\n"); currentColumn += yyleng;}
"endparams"     {printf("END_PARAMS\n"); currentColumn += yyleng;}
"beginlocals"     {printf("BEGIN_LOCALS\n"); currentColumn += yyleng;}
"endlocals"     {printf("END_LOCALS\n"); currentColumn += yyleng;}
"beginbody"     {printf("BEGIN_BODY\n"); currentColumn += yyleng;}
"endbody"     {printf("END_BODY\n"); currentColumn += yyleng;}
"integer"   {printf("INTEGER\n"); currentColumn += yyleng;}
"read"     {printf("READ\n"); currentColumn += yyleng;}
"write"     {printf("WRITE\n"); currentColumn += yyleng;}

"-"     {printf("SUB\n"); currentColumn += yyleng;} /* Arithmetic Operators */
"+"     {printf("ADD\n"); currentColumn += yyleng;}
"*"     {printf("MULT\n"); currentColumn += yyleng;}
"/"     {printf("DIV\n"); currentColumn += yyleng;}
"%"     {printf("MOD\n"); currentColumn += yyleng;}

"=="     {printf("EQ\n"); currentColumn += yyleng;} /* Comparison Operators */

";"     {printf("SEMICOLON\n"); currentColumn += yyleng;} /* Other Special Symbols */
":"     {printf("COLON\n"); currentColumn += yyleng;}
"("     {printf("L_PAREN\n"); currentColumn += yyleng;}
")"     {printf("R_PAREN\n"); currentColumn += yyleng;}
":="     {printf("ASSIGN\n"); currentColumn += yyleng;}

{IDENT} {printf("IDENT\n"); currentColumn += yyleng;} /* Identifiers */

{DIGIT}+ {printf("INT\n"); currentColumn += yyleng;} /* Numbers */

{WHITESPACE}+ {printf("WHITESPACE\n"); currentColumn += yyleng;} /* WHITESPACE */
{WHITESPACENL}+ {printf("WHITESPACENL\n"); currentColumn = 0; currentLine += 1;} /* WHITESPACENL */

.               {printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n",
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
