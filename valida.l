%option noyywrap noinput nounput nodefault

%{
#include "valida.tab.h"
%}

DIGITO     [0-9]
INTEIRO    (0|[1-9]{DIGITO}*)
NUMERO     -?{INTEIRO}(\.{DIGITO}+)?
STRING     \"[^\"\r\n]*\"

%%

[ \t\r\n]+       ;
"true"          { return TRUE; }
"false"         { return FALSE; }
"null"          { return NULO; }
{STRING}         { return STRING; }
{NUMERO}         { return NUMERO; }
"{"              { return '{'; }
"}"              { return '}'; }
"["              { return '['; }
"]"              { return ']'; }
":"              { return ':'; }
","              { return ','; }
.                { return INVALIDO; }

%%
