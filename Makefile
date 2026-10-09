CC = gcc
CFLAGS = -Wall -Wextra -O2

.PHONY: all clean

all: valida

valida: valida.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o $@ valida.tab.c lex.yy.c

valida.tab.c valida.tab.h &: valida.y
	bison -d -o valida.tab.c valida.y

lex.yy.c: valida.l valida.tab.h
	flex -o lex.yy.c valida.l

clean:
	rm -f valida valida.tab.c valida.tab.h lex.yy.c

.PHONY: test

test: valida
	@acertos=0; erros=0; total=0; \
	for arquivo in exemplos/*.json; do \
		[ -f "$$arquivo" ] || continue; \
		nome=$${arquivo##*/}; \
		case "$$nome" in \
			valido*) esperado="JSON OK" ;; \
			ruim*) esperado="JSON COM ERRO" ;; \
			*) continue ;; \
		esac; \
		total=$$((total + 1)); \
		resultado=$$(./valida "$$arquivo"); \
		if [ "$$resultado" = "$$esperado" ]; then \
			echo "PASSOU: $$nome"; \
			acertos=$$((acertos + 1)); \
		else \
			echo "FALHOU: $$nome"; \
			echo "  Esperado: $$esperado"; \
			echo "  Recebido: $$resultado"; \
			erros=$$((erros + 1)); \
		fi; \
	done; \
	echo "-------------------------"; \
	echo "Total: $$total | Acertos: $$acertos | Erros: $$erros"; \
	[ "$$total" -eq 13 ] && [ "$$erros" -eq 0 ]
