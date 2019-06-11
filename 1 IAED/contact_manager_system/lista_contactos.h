/*
Autor     : Cristiano Clemente (ist192440)
Ficheiro  : lista_contactos.h
*/

#ifndef LISTA_CONTACTOS_H
#define LISTA_CONTACTOS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  char *nome;
  char *local;    /* 1a parte email */
  char *dominio;  /* 2a parte email */
  char *tel;
} info;

typedef struct contacto {
  info *info;
  struct contacto *prox;
} contacto;

typedef struct {
  contacto *primeiro;
  contacto *ultimo;
} lista;

lista* nova_lista();
info* nova_info(char* nome, char* local, char* dominio, char* tel);
int lista_vazia(lista *l);
void adiciona_contacto_lst(info *info, lista *l);
void liberta_info(info *info);
void liberta_contacto_info(contacto* cont);
void liberta_lista_contactos(lista *l);
void liberta_lista_contactos_info(lista *l);
void imprime_info(info *info);
void imprime_contactos(lista *l);
info* encontra_info_lst(char *nome, lista *l);
void remove_contacto_lst(info *info, lista *l);
void muda_email(info *info, char *local, char *dominio);
int conta_occurencias_lst(char *str, lista *l);

#endif
