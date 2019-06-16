/*
Autor     : Cristiano Clemente (ist192440)
Ficheiro  : hashtable.h
*/

#ifndef HASHTABLE_H
#define HASHTABLE_H
#include "lista_contactos.h"

void inicializa_ht(lista **ht, int dim);
void adiciona_contacto_ht(info *info, lista **ht, int dim, char *str);
info* encontra_info_ht(char *nome, lista **ht, int dim);
void remove_info_ht(info *info, lista **ht, int dim, char* str);
int conta_occurencias_ht(char *str, lista **ht, int dim);
void liberta_ht(lista **ht, int dim);

#endif
