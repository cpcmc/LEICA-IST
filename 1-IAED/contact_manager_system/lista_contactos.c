#include "lista_contactos.h"

lista* nova_lista() {
  lista *l_nova = (lista*) malloc(sizeof(lista));
  l_nova->primeiro = l_nova->ultimo = NULL;
  return l_nova;
}

info* nova_info(char* nome, char* local, char* dominio, char* tel) {
  info *nova_info = (info*) malloc(sizeof(info));
  nova_info->nome = nome;
  nova_info->local = local;
  nova_info->dominio = dominio;
  nova_info->tel = tel;
  return nova_info;
}

int lista_vazia(lista *l) {
  return l->primeiro == NULL;
}

void adiciona_contacto_lst(info *info, lista *l) {
  contacto *novo = (contacto*) malloc(sizeof(contacto));
  novo->info = info;
  novo->prox = NULL;
  if(lista_vazia(l))
    l->primeiro = l->ultimo = novo;
  else {
    l->ultimo->prox = novo;
    l->ultimo = novo;
  }
}

void liberta_info(info *info) {
  free(info->nome);
  free(info->local);
  free(info->dominio);
  free(info->tel);
  free(info);
}

void liberta_contacto_info(contacto* cont) {
  liberta_info(cont->info);
  free(cont);
}

void liberta_lista_contactos(lista *l) {
  contacto *atual = l->primeiro;
  contacto *seguinte;
  while(atual != NULL) {
    seguinte = atual->prox;
    free(atual);
    atual=seguinte;
  }
  free(l);
}

void liberta_lista_contactos_info(lista *l) {
  contacto *atual = l->primeiro;
  contacto *seguinte;
  while(atual != NULL) {
    seguinte = atual->prox;
    liberta_contacto_info(atual);
    atual=seguinte;
  }
  free(l);
}

void imprime_info(info *i) {
  printf("%s %s@%s %s\n", i->nome, i->local, i->dominio, i->tel);
}

void imprime_contactos(lista *l) {
  contacto * p;
  for(p=l->primeiro; p!=NULL; p=p->prox)
    imprime_info(p->info);
}

info* encontra_info_lst(char *nome, lista *l) {
  contacto *p;
  for(p=l->primeiro; p!=NULL; p=p->prox)
    if(!strcmp(nome, p->info->nome))
      return p->info;
  return NULL;
}

void remove_contacto_lst(info *info, lista *l) {
  contacto *p;
  contacto *x;
  if(info == l->primeiro->info) {
    x = l->primeiro;
    l->primeiro = l->primeiro->prox;
    free(x);
    if(l->primeiro == NULL)
      l->ultimo = NULL;
  }
  else {
    for(p=l->primeiro; p->prox->info!=info; p=p->prox)
      ;
    x = p->prox;
    p->prox = x->prox;
    free(x);
    if(x == l->ultimo) {
        l->ultimo = p;
    }
  }
}

void muda_email(info *info, char *local, char *dominio) {
  free(info->local);
  free(info->dominio);
  info->local = local;
  info->dominio = dominio;
}

int conta_occurencias_lst(char *str, lista *l) {
  int ocurrencias = 0;
  contacto *p;
  for(p=l->primeiro; p!=NULL; p=p->prox)
    if(!strcmp(str, p->info->dominio))
      ocurrencias++;
  return ocurrencias;
}
