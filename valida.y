%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *mensagem);
extern FILE *yyin;
%}

%token STRING NUMERO TRUE FALSE NULO INVALIDO
%start documento

%%

documento:
      valor
    ;

valor:
      STRING
    | NUMERO
    | TRUE
    | FALSE
    | NULO
    | objeto
    | array
    ;

objeto:
      '{' '}'
    | '{' pares '}'
    ;

pares:
      par
    | pares ',' par
    ;

par:
      STRING ':' valor
    ;

array:
      '[' ']'
    | '[' valores ']'
    ;

valores:
      valor
    | valores ',' valor
    ;

%%

void yyerror(const char *mensagem) {
    (void)mensagem;
}

int main(int argc, char *argv[]) {
    FILE *arquivo;
    int resultado;

    if (argc != 2) {
        puts("JSON COM ERRO");
        return 1;
    }

    arquivo = fopen(argv[1], "rb");
    if (arquivo == NULL) {
        puts("JSON COM ERRO");
        return 1;
    }

    yyin = arquivo;
    resultado = yyparse();
    fclose(arquivo);

    if (resultado == 0) {
        puts("JSON OK");
        return 0;
    }

    puts("JSON COM ERRO");
    return 1;
}
