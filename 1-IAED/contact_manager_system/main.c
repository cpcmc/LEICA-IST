/*
Autor     : Cristiano Clemente (ist192440)
Ficheiro  : main.c
Descricao : Permite manipular contactos.
            A implementacao utiliza tres estruturas:
              * lista de contactos  -> impressao dos contactos pela ordem em que foram introduzidos
              * hashtable (nome)    -> procura (e alteracao) da informacao de um contacto dado um nome
              * hastable (dominio)  -> contagem do numero de ocorrencias de um determinado dominio de email
*/

#include <stdio.h>              /*getchar, printf*/
#include <stdlib.h>             /*free*/
#include "leitura.h"            /*le os argumentos depois do caracter de comando*/
#include "lista_contactos.h"    /*implementacao lista de contacto*/
#include "hashtable.h"          /*implementacao hashtable*/

#define HT_NOME_DIM 737         /*numero de linhas da hashtable nome*/
#define HT_DOMINIO_DIM 737      /*numero de linhas da hashtable dominio*/

void inicializa(lista **hashtable_nome, lista **hashtable_dominio);
void trata_a(char *nome, char *local, char *dominio, char *telefone, lista *lista_contactos, lista **hashtable_nome, lista **hashtable_dominio);
void trata_l(lista *lista_contactos);
void trata_p(char *nome, lista **hashtable_nome);
void trata_r(char *nome, lista *lista_contactos, lista **hashtable_nome, lista **hashtable_dominio);
void trata_e(char *nome, char *local, char *dominio, lista **hashtable_nome, lista **hashtable_dominio);
void trata_c(char *dominio, lista **hashtable_dominio);
void finaliza(lista *lista_contactos, lista **hashtable_nome, lista **hashtable_dominio);

/*
main:
  le o comando, os argumentos e executa a funcao correspondente
*/
int main() {
  /*declara a letra de comando e os argumentos*/
  char comando;
  char *nome;
  char *local;
  char *dominio;
  char *telefone;

  /*declara as estruturas: lista de contactos e hashtables*/
  lista *lst_contactos = nova_lista();
  lista *ht_nome[HT_NOME_DIM];
  lista *ht_dominio[HT_DOMINIO_DIM];

  /*inicializa as hashtables*/
  inicializa(ht_nome, ht_dominio);

  /*
  le o comando, os argumentos e executa a funcao
  o comando x termina o programa
  */
  while((comando=getchar()) != 'x') {
    switch(comando) {

      case 'a':
        nome = le_nome();
        local = le_local();
        dominio = le_dominio();
        telefone = le_telefone();
        trata_a(nome, local, dominio, telefone, lst_contactos, ht_nome, ht_dominio);
        break;

      case 'l':
        trata_l(lst_contactos);
        break;

      case 'p':
        nome = le_nome();
        trata_p(nome, ht_nome);
        break;

      case 'r':
        nome = le_nome();
        trata_r(nome, lst_contactos, ht_nome, ht_dominio);
        break;

      case 'e':
        nome = le_nome();
        local = le_local();
        dominio = le_dominio();
        trata_e(nome, local, dominio, ht_nome, ht_dominio);
        break;

      case 'c':
        dominio = le_dominio();
        trata_c(dominio, ht_dominio);
        break;
    }
  }
  finaliza(lst_contactos, ht_nome, ht_dominio);
  return 0;
}

/*
inicializa:
  inicializa todas as linhas (ie hashtable[i]=NULL) de ambas as hashtables
*/
void inicializa(lista **ht_nome, lista **ht_dominio) {
  inicializa_ht(ht_nome, HT_NOME_DIM);
  inicializa_ht(ht_dominio, HT_DOMINIO_DIM);
}

/*
trata_a:
  adiciona um novo contacto
  se ja existir um contacto com o nome passado, da erro
*/
void trata_a(char *nome, char *local, char *dominio, char *tel, lista *lst_contactos, lista **ht_nome, lista **ht_dominio) {
  info *info;
  if(encontra_info_ht(nome, ht_nome, HT_NOME_DIM) == NULL) {/*ie pessoa nao existe*/
    info = nova_info(nome, local, dominio, tel);
    adiciona_contacto_ht(info, ht_nome, HT_NOME_DIM, nome);
    adiciona_contacto_ht(info, ht_dominio, HT_DOMINIO_DIM, dominio);
    adiciona_contacto_lst(info, lst_contactos);
  }
  else {
    printf("Nome existente.\n");
    free(nome);
    free(local);
    free(dominio);
    free(tel);
  }
}

/*
trata_l:
  lista os contactos introduzidos
*/
void trata_l(lista *lst_contactos) {
  imprime_contactos(lst_contactos);
}

/*
trata_p:
  procura um contacto dado um nome
  se nao existir um contacto com o nome passado, da erro
*/
void trata_p(char *nome, lista **ht_nome) {
  info *info = encontra_info_ht(nome, ht_nome, HT_NOME_DIM);
  if (info != NULL) /*ie pessoa existe*/
    imprime_info(info);
  else
    printf("Nome inexistente.\n");
  free(nome);
}

/*
trata_r:
  remove um contacto dado um nome
  se nao existir um contacto com o nome passado, da erro
*/
void trata_r(char *nome, lista *lst_contactos, lista **ht_nome, lista **ht_dominio) {
  info *info = encontra_info_ht(nome, ht_nome, HT_NOME_DIM);
  if(info == NULL)
    printf("Nome inexistente.\n");
  else {
    remove_info_ht(info, ht_nome, HT_NOME_DIM, info->nome);
    remove_info_ht(info, ht_dominio, HT_DOMINIO_DIM, info->dominio);
    remove_contacto_lst(info, lst_contactos);
    liberta_info(info);
  }
  free(nome);
}

/*
trata_e:
  altera o email de um contacto dado um nome
  se nao existir um contacto com o nome passado, da erro
*/
void trata_e(char *nome, char *local, char *dominio, lista **ht_nome, lista **ht_dominio) {
  info *info = encontra_info_ht(nome, ht_nome, HT_NOME_DIM);
  if(info != NULL) {/*ie pessoa nao existe*/
    remove_info_ht(info, ht_dominio, HT_DOMINIO_DIM, info->dominio);
    muda_email(info, local, dominio);
    adiciona_contacto_ht(info, ht_dominio, HT_DOMINIO_DIM, info->dominio);
  }
  else {
    printf("Nome inexistente.\n");
    free(local);
    free(dominio);
  }
  free(nome);
}

/*
trata_c:
  conta o numero de ocorrencias de um dado dominio de email
*/
void trata_c(char *dominio, lista **ht_dominio) {
  int ocurrencias = conta_occurencias_ht(dominio, ht_dominio, HT_DOMINIO_DIM);
  printf("%s:%d\n", dominio, ocurrencias);
  free(dominio);
}

/*
finaliza:
  liberta TODO o espaco de memoria associado a lista de contactos e as hashtables
*/
void finaliza(lista *lst_contactos, lista **ht_nome, lista **ht_dominio) {
  liberta_ht(ht_nome, HT_NOME_DIM);
  liberta_ht(ht_dominio, HT_DOMINIO_DIM);
  liberta_lista_contactos_info(lst_contactos);
}
