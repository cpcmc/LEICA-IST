/*
Autor     : Cristiano Clemente (ist192440)
Ficheiro  : leitura.h
*/

#ifndef LEITURA_H
#define LEITURA_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXNOME 1023    /*comprimento maximo nome*/
#define MAXEMAIL 511    /*comprimento maximo email*/
#define MAXTEL 63       /*comprimento maximo telefone*/

char* le_linha(int tamanho_maximo);
char* le_nome();
char* le_local();
char* le_dominio();
char* le_telefone();

#endif
