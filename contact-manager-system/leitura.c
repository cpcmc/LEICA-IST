#include "leitura.h"

char* le_linha(int tamanho_maximo) {
  char *linha = (char*) malloc(sizeof(char) * (tamanho_maximo+1));  /* aloca string tamanho + 1(\0) */
  scanf("%s", linha);                                               /* le linha */
  linha = (char*) realloc(linha, strlen(linha)+1);                  /*realoca string para apenas o necessario */
  return linha;
}

char* le_nome() {
  char *nome = le_linha(MAXNOME);
  return nome;
}

char* le_local() {
  char *local = (char*) malloc(sizeof(char) * (MAXEMAIL+1));
  char c;
  int i;
  for(i=0, getchar() ; (c=getchar())!='@' ; i++)
    local[i] = c;
  local[i] = '\0';
  local = (char*) realloc(local, strlen(local)+1);
  return local;
}

char* le_dominio() {
  char *dominio = le_linha(MAXEMAIL);
  return dominio;
}

char* le_telefone() {
  char *tel = le_linha(MAXTEL);
  return tel;
}
