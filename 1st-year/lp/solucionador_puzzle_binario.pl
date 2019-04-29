%%%============================================================================
%%% Autor:      Cristiano Clemente
%%% Numero:     92440
%%% Nome:       proj1_92440.pl
%%% Data:       28 abril 2019
%%% Disciplina: Logica para Programacao
%%%============================================================================

:- consult(codigo_comum).     % "importa" o codigo comum (diversas operacoes sobre puzzles)


%-----------------------------------------------------------------------------
%% conta_vars/2
% descricao:  conta o numero de variaveis numa lista (ou lista de listas)
% recebe:     uma lista
% devolve:    um inteiro
%-----------------------------------------------------------------------------
conta_vars([], 0).

conta_vars([P|R], N) :- conta_vars(R, N_R),
  (is_list(P), !, conta_vars(P, N_P), N is N_P+N_R;   % se o primeiro elemento e uma lista
  var(P), !, N is N_R+1;                              % se o primeiro elemento e uma variavel
  N is N_R).                                          % se o primeiro elemento e um numero


%-----------------------------------------------------------------------------
%% conta_ocurr/3
% descricao:  conta o numero de ocurrencias de um determinado inteiro num triplo
% recebe:     um triplo, um inteiro
% devolve:    um inteiro
%-----------------------------------------------------------------------------
conta_ocurr([], _, 0).

conta_ocurr([P|R], X, N) :- conta_ocurr(R, X, N_R),
  (P == X, !, N is N_R+1;                               % se P coincide com o numero procurado
  N is N_R).                                            % se P e uma variavel ou e um numero mas nao coincide com o numero procurado


%-----------------------------------------------------------------------------
%% conta_0s/2
% descricao:  conta o numero de zeros num triplo
% recebe:     um triplo
% devolve:    um inteiro
%-----------------------------------------------------------------------------
conta_0s(T, Num_0s) :- conta_ocurr(T, 0, Num_0s).


%-----------------------------------------------------------------------------
%% conta_1s/2
% descricao:  conta o numero de uns num triplo
% recebe:     um triplo
% devolve:    um inteiro
%-----------------------------------------------------------------------------
conta_1s(T, Num_1s) :- conta_ocurr(T, 1, Num_1s).


%-----------------------------------------------------------------------------
%% vars_para_x/3
% descricao:  subtitui todas as variaveis numa lista por um determinado inteiro
% recebe:     uma lista, um inteiro
% devolve:    uma lista
%-----------------------------------------------------------------------------
vars_para_x([], _, []).

vars_para_x([P|R], X, [X|L_R]) :-
  var(P), !, vars_para_x(R, X, L_R).    % se P e uma variavel, e subtituido por X

vars_para_x([P|R], X, [P|L_R]) :-
  vars_para_x(R, X, L_R).               % se P e um inteiro, nao e substituido


%-----------------------------------------------------------------------------
%% preenche_1/2
% descricao:  preenche um triplo com uma so variavel segundo a regra 1 do puzzle
% recebe:     um triplo
% devolve:    um triplo
%-----------------------------------------------------------------------------
preenche_1(T, N_T) :-
  (conta_0s(T, 2), !, vars_para_x(T, 1, N_T);     % se o triplo tem 2 zeros, a variavel passa a 1
  conta_1s(T, 2), !, vars_para_x(T, 0, N_T);      % se o triplo tem 2 uns, a variavel passa a 0
  N_T = T).                                       % se o triplo tem 1 zero e 1 um, nao se pode concluir nada


%%%============================================================================
%% aplica_R1_triplo/2
% descricao:  aplica a um triplo a regra 1 do puzzle
% recebe:     um triplo
% devolve:    um triplo
%%%============================================================================
aplica_R1_triplo(T, N_T) :- conta_vars(T, Num_Vars),
  (Num_Vars=0, !, \+ conta_0s(T, 3), \+ conta_1s(T, 3), N_T = T;    % se o triplo nao tem variaveis, verifica que nao e [0,0,0] nem [1,1,1]
  Num_Vars=1, !, preenche_1(T, N_T);                                % se o triplo tem uma variavel, preenche a variavel (se possivel)
  member(Num_Vars,[2,3]), !, N_T = T).                              % se o triplo tem mais de uma variavel, nao se pode concluir nada


%%%============================================================================
%% aplica_R1_fila_aux/2
% descricao:  aplica a regra 1 uma so vez a uma fila (linha ou coluna)
% recebe:     uma fila (linha ou coluna)
% devolve:    uma fila (linha ou coluna)
%%%============================================================================
aplica_R1_fila_aux([A,B,C,D|R],[N_A|N_Fila_R]) :-         % se a lista tem pelo menos 4 elementos
  !, aplica_R1_triplo([A,B,C],[N_A,N_B,N_C]),
  aplica_R1_fila_aux([N_B,N_C,D|R], N_Fila_R).

aplica_R1_fila_aux(Triplo, N_Triplo) :-                   % se a lista so tem 3 elementos
  aplica_R1_triplo(Triplo,N_Triplo).


%%%============================================================================
%% aplica_R1_fila/2
% descricao:  aplica a regra 1 a uma fila (linha ou coluna) ate que todas as
%             posicoes possiveis de preencher sejam preenchidas
% recebe:     uma fila
% devolve:    uma fila
%%%============================================================================
aplica_R1_fila(Fila, Res) :- conta_vars(Fila,X1),                     % conta as variaveis da fila original
  aplica_R1_fila_aux(Fila,N_Fila_Aux), conta_vars(N_Fila_Aux,X2),     % aplica R1 a fila e conta as variaveis da fila resultante
  (X1=:=X2, !, Res=Fila;                                              % se nenhuma posicao foi preenchida, a funcao para
  aplica_R1_fila(N_Fila_Aux,N_Fila), Res=N_Fila).                     % se pelo menos uma posicao foi preenchida, aplica-se R1 a fila resultante


%%%============================================================================
%% aplica_R2_fila/2
% descricao:  aplica a regra 2 a uma fila (linha ou coluna)
% recebe:     uma fila
% devolve:    uma fila
%%%============================================================================
aplica_R2_fila(Fila, N_Fila) :-
  length(Fila, Len), conta_0s(Fila, Num_0s), conta_1s(Fila, Num_1s),    % conta o numero de 0s e 1s na fila
  (Num_0s =:= Len/2, !, vars_para_x(Fila, 1, N_Fila);                   % se o numero de 0s e metade do numero de elementos da fila, o resto da fila e preenchida com 1s
  Num_1s =:= Len/2, !, vars_para_x(Fila, 0, N_Fila);                    % se o numero de 1s e metade do numero de elementos da fila, o resto da fila e preenchida com 0s
  Num_0s < Len/2, Num_1s < Len/2, !, N_Fila = Fila).                    % se tanto o numero de 0s como o numero de 1s sao inferiores a metade do numero de elementos da fila, nada se pode concluir


%%%============================================================================
%% aplica_R1_R2_fila/2
% descricao:  aplica a regra 1 a uma fila (linha ou coluna) e depois aplica a
%             regra 2
% recebe:     uma fila
% devolve:    uma fila
%%%============================================================================
aplica_R1_R2_fila(Fila, N_Fila) :-
  aplica_R1_fila(Fila, N_Fila_Aux),
  aplica_R2_fila(N_Fila_Aux, N_Fila).


%-----------------------------------------------------------------------------
%% aplica_R1_R2_linhas/2
% descricao:  aplica a regra 1 e depois aplica a regra 2 as linhas de um puzzle
% recebe:     um puzzle
% devolve:    um puzzle
%-----------------------------------------------------------------------------
aplica_R1_R2_linhas([],[]).

aplica_R1_R2_linhas([P|R], [N_P|N_R]) :-
  aplica_R1_R2_fila(P, N_P),
  aplica_R1_R2_linhas(R, N_R).


%-----------------------------------------------------------------------------
%% aplica_R1_R2_colunas/2
% descricao:  aplica a regra 1 e depois aplica a regra 2 as colunas de um puzzle
% recebe:     um puzzle
% devolve:    um puzzle
%-----------------------------------------------------------------------------
aplica_R1_R2_colunas(Puz, Transp2) :- % colunas_puzzle_original = linhas_puzzle_transposta
  mat_transposta(Puz, Transp1),
  aplica_R1_R2_linhas(Transp1, N_Puz_Aux),
  mat_transposta(N_Puz_Aux, Transp2).


%%%============================================================================
%% aplica_R1_R2_puzzle/2
% descricao:  aplica a regra 1 a um puzzle e depois aplica a regra 2
% recebe:     um puzzle
% devolve:    um puzzle
%%%============================================================================
aplica_R1_R2_puzzle(Puz, N_Puz) :-
  aplica_R1_R2_linhas(Puz,N_Puz_Aux),
  aplica_R1_R2_colunas(N_Puz_Aux,N_Puz).


%%%============================================================================
%% inicializa/2
% descricao:  inicializa um puzzle - aplica R1 R2 a cada linha/coluna do puzzle
%             ate nao serem preenchidas novas posicoes
% recebe:     um puzzle
% devolve:    um puzzle
%%%============================================================================
inicializa(Puz, Res) :- conta_vars(Puz, X1),                          % conta as variaveis do puzzle original
  aplica_R1_R2_puzzle(Puz, N_Puz_Aux), conta_vars(N_Puz_Aux, X2),     % aplica R1 R2 ao puzzle e conta as variaveis do puzzle modificado
  (X1 =:= X2, !, Res = Puz;                                           % se nenhuma posicao e preenchida, a funcao para
  inicializa(N_Puz_Aux, N_Puz), Res = N_Puz).                         % se pelo menos uma posicao e preenchida, aplica-se verifica ao puzzle modificado


%-----------------------------------------------------------------------------
%% verifica_linha_R3/2
% descricao:  verifica se uma linha nao existe numa determinada lista de linhas
% recebe:     uma linha, uma lista de linhas
% devolve:    verdadeiro/falso
%-----------------------------------------------------------------------------
verifica_linha_R3(_,[]).

verifica_linha_R3(L, [P|R]) :-
  L \== P,
  verifica_linha_R3(L, R).


%-----------------------------------------------------------------------------
%% verifica_linhas_R3/1
% descricao:  verifica se as linhas de um puzzle obedecem a regra 3 (sao todas
%             distintas)
% recebe:     um puzzle
% devolve:    verdadeiro/falso
%-----------------------------------------------------------------------------
verifica_linhas_R3([]).

verifica_linhas_R3([P|R]) :-
  verifica_linha_R3(P, R), !,
  verifica_linhas_R3(R).


%-----------------------------------------------------------------------------
%% verifica_colunas_R3/1
% descricao:  verifica se as colunas de um puzzle obedecem a regra 3 (sao todas
%             distintas)
% recebe:     um puzzle
% devolve:    verdadeiro/falso
%-----------------------------------------------------------------------------
verifica_colunas_R3(Puz) :- % colunas_puzzle_original = linhas_puzzle_transposta
  mat_transposta(Puz, Transp),
  verifica_linhas_R3(Transp).


%-----------------------------------------------------------------------------
%% verifica_R3/1
% descricao:  verifica se todas as linhas/colunas sao diferentes entre si
% recebe:     um puzzle
% devolve:    verdadeiro/falso
%-----------------------------------------------------------------------------
verifica_R3(Puz) :-
  verifica_linhas_R3(Puz),
  verifica_colunas_R3(Puz).


%-----------------------------------------------------------------------------
%% dif/3
% descricao:  verifica se os elementos que correspondem a um determinado indice
%             em duas filas sao distintos
% recebe:     um indice, duas linhas
% devolve:    verdadeiro/falso
%-----------------------------------------------------------------------------
dif(Ind, Fila, N_Fila) :-
  nth1(Ind, Fila, El1),
  nth1(Ind, N_Fila, El2),
  nonvar(El2), var(El1).


%-----------------------------------------------------------------------------
%% fila_pos_aux/4
% descricao:  gera uma lista que contem os indices dos elementos em duas listas
%             que diferem
% recebe:     um contador, duas filas
% devolve:    uma lista de indices
%-----------------------------------------------------------------------------
fila_pos_aux(Contador, Fila, _, []) :-
  length(Fila, Dim), Contador > Dim, !.                               % chegamos ao final da fila

fila_pos_aux(Contador, Fila, N_Fila, Ids) :-
  (dif(Contador, Fila, N_Fila), !, append([Contador], Ids_R, Ids);    % se os elementos diferem, o indice e adicionado a lista
  Ids = Ids_R),
  Contador1 is Contador+1,
  fila_pos_aux(Contador1, Fila, N_Fila, Ids_R).


%-----------------------------------------------------------------------------
%% ids_linha_para_pos/3
% descricao:  gera uma lista das posicoes dos elementos a propagar
% recebe:     uma lista de indices, um numero de linha
% devolve:    uma lista de posicoes
%-----------------------------------------------------------------------------
ids_linha_para_pos([], _, []).

ids_linha_para_pos([P|R], L, Pos) :-
  append([(L, P)], Pos_R, Pos),
  ids_linha_para_pos(R, L, Pos_R).


%-----------------------------------------------------------------------------
%% linha_pos/4
% descricao:  gera uma lista das posicoes dos elementos a propagar de uma
%             determinada linha
% recebe:     um numero de linha, duas linhas
% devolve:    uma lista de posicoes
%-----------------------------------------------------------------------------
linha_pos(L, Linha, N_Linha, Pos_L) :-
  fila_pos_aux(1, Linha, N_Linha, Ids),         % obtem lista de indices
  ids_linha_para_pos(Ids, L, Pos_L).            % transforma lista de indices em lista de posicoes


%-----------------------------------------------------------------------------
%% propaga_linha/4
% descricao:  aplica R1 R2 a uma linha e gera uma lista das posicoes dos
%             elementos a propagar
% recebe:     um numero de linha, dois puzzles
% devolve:    uma lista de posicoes
%-----------------------------------------------------------------------------
propaga_linha(L, Puz, N_Puz, Pos_L) :-
  nth1(L, Puz, Linha),                          % busca a linha
  aplica_R1_R2_fila(Linha, N_Linha),            % aplica-lhe R1 R2
  mat_muda_linha(Puz, L, N_Linha, N_Puz),       % subtitui a nova linha no puzzle
  linha_pos(L, Linha, N_Linha, Pos_L).          % descobre as posicoes mudadas


%-----------------------------------------------------------------------------
%% ids_coluna_para_pos/3
% descricao:  gera uma lista das posicoes dos elementos a propagar
% recebe:     uma lista de indices, um numero de coluna
% devolve:    uma lista de posicoes
%-----------------------------------------------------------------------------
ids_coluna_para_pos([], _, []).

ids_coluna_para_pos([P|R], C, Pos) :-
  append([(P, C)], Pos_R, Pos),
  ids_coluna_para_pos(R, C, Pos_R).


%-----------------------------------------------------------------------------
%% coluna_pos/4
% descricao:  gera uma lista das posicoes dos elementos a propagar de uma
%             determinada coluna
% recebe:     um numero de coluna, duas colunas
% devolve:    uma lista de posicoes
%-----------------------------------------------------------------------------
coluna_pos(C, Coluna, N_Coluna, Pos_C) :-
  fila_pos_aux(1, Coluna, N_Coluna, Ids),         % obtem lista de indices
  ids_coluna_para_pos(Ids, C, Pos_C).             % transforma lista de indices em lista de posicoes


%-----------------------------------------------------------------------------
%% propaga_coluna/4
% descricao:  aplica R1 R2 a uma coluna e gera uma lista das posicoes dos
%             elementos a propagar
% recebe:     um numero de coluna, dois puzzles
% devolve:    uma lista de posicoes
%-----------------------------------------------------------------------------
propaga_coluna(C, Puz, N_Puz, Pos_C) :-
  mat_elementos_coluna(Puz, C, Coluna),       % busca a linha
  aplica_R1_R2_fila(Coluna, N_Coluna),        % aplica-lhe R1 R2
  mat_muda_coluna(Puz, C, N_Coluna, N_Puz),   % subtitui a nova coluna no puzzle
  coluna_pos(C, Coluna, N_Coluna, Pos_C).     % posicoes mudadas


%%%============================================================================
%% propaga_posicoes/3
% descricao:  propaga recursivamente as posices dadas
% recebe:     uma lista de posicoes, um puzzle
% devolve:    um puzzle
%%%============================================================================
propaga_posicoes([], N_Puz, N_Puz).

propaga_posicoes([(L,C)|R], Puz, N_Puz) :-
  propaga_linha(L, Puz, N_Puz_L, Pos_L),
  propaga_coluna(C, N_Puz_L, N_Puz_LC, Pos_C),
  append([Pos_L, Pos_C, R], Pos),
  propaga_posicoes(Pos, N_Puz_LC, N_Puz).


%-----------------------------------------------------------------------------
%% encontra_1a_var_aux/6
% descricao:  gera a posicao da primeira variavel de um puzzle (lendo da esquerda
%             para a direita e de cima para baixo)
% recebe:     um puzzle, uma posicao, uma dimensao do puzzle
% devolve:    uma posicao
%-----------------------------------------------------------------------------
encontra_1a_var_aux(Puz, (L,C), _, (L,C)) :-
  mat_ref(Puz, (L, C), Cont), var(Cont), !.                   % se foi encontrada uma variavel, entao para

encontra_1a_var_aux(Puz, (L,C), Dim, (L_R,C_R)) :-
  (C_N is C+1, C_N =< Dim, !,
  encontra_1a_var_aux(Puz, (L,C_N), Dim, (L_R,C_R))           % mesma linha, coluna seguinte
  ;
  L_N is L+1, L_N =< Dim, !,
  encontra_1a_var_aux(Puz, (L_N,1), Dim, (L_R,C_R))).         % proxima linha, primeira coluna


%-----------------------------------------------------------------------------
%% encontra_1a_var/3
% descricao:  gera a posicao da primeira variavel de um puzzle (lendo da esquerda
%             para a direita e de cima para baixo)
% recebe:     um puzzle
% devolve:    uma posicao
%-----------------------------------------------------------------------------
encontra_1a_var(Puz, (L,C)) :-
  length(Puz, Dim),
  encontra_1a_var_aux(Puz, (1,1), Dim, (L,C)).


%-----------------------------------------------------------------------------
%% experimenta/2
% descricao:  enquanto for possivel, substitui a primeira variavel de um puzzle
%             por 0 e propaga posicoes e, se tal nao originar um puzzle valido, substitui a primeira variavel de um puzzle por 1 e propaga posicoes
% recebe:     um puzzle
% devolve:    um puzzle
%-----------------------------------------------------------------------------
experimenta(Puz_I, Puz_I) :-
  conta_vars(Puz_I, 0), !.                                              % se ja nao ha variaveis, entao para

experimenta(Puz_I, Puz_F) :-
  encontra_1a_var(Puz_I, (L,C)),
  (mat_muda_posicao(Puz_I, (L,C), 0, Puz_0_Aux),                        % experimenta o valor 0
  propaga_posicoes([(L,C)], Puz_0_Aux, Puz_0), verifica_R3(Puz_0), !,
  experimenta(Puz_0, Puz_F)
  ;
  mat_muda_posicao(Puz_I, (L,C), 1, Puz_1_Aux),                         % experimenta o valor 1
  propaga_posicoes([(L,C)], Puz_1_Aux, Puz_1), verifica_R3(Puz_1), !,
  experimenta(Puz_1, Puz_F)).


%%%============================================================================
%% resolve/2
% descricao:  inicializa um puzzle; se ainda existirem variaveis experimenta
%             substitui-las por 0 ou por 1 ate obter um solucao para o puzzle
% recebe:     um puzzle
% devolve:    um puzzle
%%%============================================================================
resolve(Puz, Sol) :-
  inicializa(Puz, Puz_Inic),
  verifica_R3(Puz_Inic),
  experimenta(Puz_Inic, Sol).
