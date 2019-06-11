#include "hashtable.h"

unsigned long hash(char *str) {
    unsigned long hash = 5381;
    int i;
    for(i=0; str[i]!='\0'; i++)
        hash = hash*33 + str[i];
    return hash;
}

void inicializa_ht(lista **ht, int dim) {
  int i;
  for(i=0; i<dim; i++)
    ht[i] = NULL;
}

void adiciona_contacto_ht(info *info, lista **ht, int dim, char *str) {
  unsigned long key = hash(str)%dim;
  if(ht[key] == NULL)
    ht[key] = nova_lista();
  adiciona_contacto_lst(info, ht[key]);
}

info* encontra_info_ht(char *nome, lista **ht, int dim) {
  info *info;
  unsigned long key = hash(nome)%dim;
  if(ht[key] == NULL)
    return NULL;
  else {
    info = encontra_info_lst(nome, ht[key]);
    return info;
  }
}

void remove_info_ht(info *info, lista **ht, int dim, char *str) {
  unsigned long key = hash(str)%dim;
  remove_contacto_lst(info, ht[key]);
}

int conta_occurencias_ht(char *str, lista **ht, int dim) {
  int ocurrencias = 0;
  unsigned long key = hash(str)%dim;
  if(ht[key] != NULL)
    ocurrencias = conta_occurencias_lst(str, ht[key]);
  return ocurrencias;
}

void liberta_ht(lista **ht, int dim) {
  int i;
  for(i=0; i<dim; i++)
    if(ht[i] != NULL)
      liberta_lista_contactos(ht[i]);
}
