#===============================================================================
# hello_quantum.py                                                             #
#                                                                              #
# Cristiano Primitivo Constantino Morais Clemente                     n: 92440 #
# Data: 29/11/2018                                                             #
#===============================================================================

#-------------------------------------------------------------------------------
# FUNCOES AUXILIARES                                                           |
#-------------------------------------------------------------------------------
def checkifinst(lista, tipo):
        """lista x tipo -> booleano
        returna True se todos os elementos da lista sao do tipo"""
        return all(isinstance(x,tipo) for x in lista)

def jogada(t, porta, lado):
        """tabuleiro x porta x lado -> tabuleiro
        faz uma jogada: aplica a um tabuleiro 't' a porta e o lado que o jogador inseriu"""
        if porta == 'X':
                return porta_x(t, lado)
        elif porta == 'Z':
                return porta_z(t, lado)
        elif porta == 'H':
                return porta_h(t, lado)
#-------------------------------------------------------------------------------

#===============================================================================
# CELULA                                                                       #
# representacao interna ['inativo' | 'ativo' | 'incerto']                      #
#===============================================================================
def cria_celula(v):
        """{0, 1, −1} -> celula"""
        if isinstance(v,int) and v in (-1,0,1):
                if v == 0:
                        return ['inativo']
                elif v == 1:
                        return ['ativo']
                elif v == -1:
                        return ['incerto']
        raise ValueError('cria_celula: argumento invalido.')

def obter_valor(c):
        """celula -> {0, 1, -1}"""
        if c[0] == 'inativo':
                return 0
        elif c[0] == 'ativo':
                return 1
        elif c[0] == 'incerto':
                return -1

def inverte_estado(c):
        """celula -> celula"""
        if c[0] == 'inativo':
                c[0] = 'ativo'
        elif c[0] == 'ativo':
                c[0] = 'inativo'
        return c

def eh_celula(arg):
        """universal -> logico"""
        return (isinstance(arg,list) and len(arg) == 1 and                              #arg e uma lista de 1 elemento                                                            [*]                           ?
                isinstance(arg[0],str) and arg[0] in ('inativo','ativo','incerto'))     #o unico elemento da lista do tipo string e toma o valor 'inativo', 'ativo' ou 'incerto'  ['inativo'|'ativo'|'incerto'] ?

def celulas_iguais(c1, c2):
        """celula x celula -> logico"""
        return eh_celula(c1) and eh_celula(c2) and obter_valor(c1) == obter_valor(c2)

def celula_para_str(c):
        """celula -> cadeia de caracteres"""
        if c[0] == 'inativo':
                return '0'
        elif c[0] == 'ativo':
                return '1'
        elif c[0] == 'incerto':
                return 'x'
#===============================================================================


#===============================================================================
# COORDENADA (0|1|2, 0|1|2)                                                    #
#===============================================================================
def cria_coordenada(l, c):
        """|N x |N -> coordenada"""
        if checkifinst([l,c], int) and {l,c} < {0,1,2}:
                return (l,c)
        raise ValueError('cria_coordenada: argumentos invalidos.')

def coordenada_linha(c):
        """coordenada -> |N"""
        return c[0]

def coordenada_coluna(c):
        """coordenada -> |N"""
        return c[1]

def eh_coordenada(arg):
        """universal -> logico"""
        return (isinstance(arg, tuple) and len(arg) == 2 and    #arg e um tuplo de comprimento 2  (*, *)         ?
        checkifinst([arg[0],arg[1]], int) and                   #os elementos de arg sao inteiros (int, int)     ?
        {arg[0],arg[1]} < {0,1,2})                              #os elementos de arg sao 0,1,2    (0|1|2, 0|1|2) ?

def coordenadas_iguais(c1, c2):
        """coordenada x coordenada -> logico"""
        return eh_coordenada(c1) and eh_coordenada(c2) and c1 == c2

def coordenada_para_str(c):
        """coordenada -> cadeia de caracteres"""
        return '('+str(c[0])+', '+str(c[1])+')'
#===============================================================================


#=============================================================================================================================================
# TABULEIRO {(0, 0): celula, (0, 1): celula, (0, 2): celula, (1, 0): celula, (1, 1): celula, (1, 2): celula, (2, 1): celula, (2, 2): celula} #
#=============================================================================================================================================
def tabuleiro_inicial():
        """{} -> tabuleiro"""
        return {cria_coordenada(0,0): cria_celula(-1), cria_coordenada(0,1): cria_celula(-1), cria_coordenada(0,2): cria_celula(-1), \
                cria_coordenada(1,0): cria_celula(0), cria_coordenada(1,1): cria_celula(0), cria_coordenada(1,2): cria_celula(-1),   \
                cria_coordenada(2,1): cria_celula(0), cria_coordenada(2,2): cria_celula(-1)}

def str_para_tabuleiro(s): #'((-1, -1, -1), (0, 1, -1), (1, -1))'
        """cadeia de caracteres -> tabuleiro"""
        try:
                x = eval(s)
        except:
                raise ValueError('str_para_tabuleiro: argumento invalido.')
        if (isinstance(x, tuple) and len(x) == 3 and                                                                    #(*, *, *)                                                              ?
                checkifinst([x[0], x[1], x[2]], tuple) and                                                              #((*), (*), (*))                                                        ?
                len(x[0]) == len(x[1]) == 3 and len(x[2]) == 2 and                                                      #((*, *, *), (*, *, *), (*, *))                                         ?
                checkifinst([x[0][0], x[0][1], x[0][2], x[1][0], x[1][1], x[1][2], x[2][0], x[2][1]], int) and          #((int, int, int), (int, int, int), (int, int))                         ?
                {b for a in x for b in a} <= {-1,0,1}):                                                                 #((-1|0|1, -1|0|1, -1|0|1), (-1|0|1, -1|0|1, -1|0|1), (-1|0|1, -1|0|1)) ?
                        return {cria_coordenada(0,0): cria_celula(x[0][0]), cria_coordenada(0,1): cria_celula(x[0][1]), cria_coordenada(0,2): cria_celula(x[0][2]), \
                                cria_coordenada(1,0): cria_celula(x[1][0]), cria_coordenada(1,1): cria_celula(x[1][1]), cria_coordenada(1,2): cria_celula(x[1][2]), \
                                cria_coordenada(2,1): cria_celula(x[2][0]), cria_coordenada(2,2): cria_celula(x[2][1])}
        raise ValueError('str_para_tabuleiro: argumento invalido.')

def tabuleiro_dimensao(t):
        """tabuleiro -> |N"""
        return max([a for (a,b) in t]) + 1

def tabuleiro_celula(t, coor):
        """tabuleiro x coordenada -> celula"""
        return t[coor]

def tabuleiro_substitui_celula(t, cel, coor):
        """tabuleiro x celula x coordenada -> tabuleiro"""
        if eh_celula(cel) and eh_coordenada(coor) and coor != cria_coordenada(2,0) and eh_tabuleiro(t):
                t[coor] = cel
                return t
        raise ValueError('tabuleiro_substitui_celula: argumentos invalidos.')

def tabuleiro_inverte_estado(t, coor):
        """tabuleiro x coordenada -> tabuleiro"""
        if eh_coordenada(coor) and coor != cria_coordenada(2,0) and eh_tabuleiro(t):
                t[coor] = inverte_estado(t[coor])
                return t
        raise ValueError('tabuleiro_inverte_estado: argumentos invalidos.')

def eh_tabuleiro(arg): #{(0, 0): *, (0, 1): *, (0, 2): *, (1, 0): *, (1, 1): *, (1, 2): *, (2, 1): *, (2, 2): *}
        """universal -> logico"""
        return (isinstance(arg, dict) and len(arg) == 8 and                             #arg e dicionario com 8 chaves                    ?
                all(eh_coordenada(k) and k != cria_coordenada(2,0) for k in arg) and    #as chaves sao coordenadas diferentes de (2,0)    ?
                all(eh_celula(v) for v in arg.values()))                                #os valores correspondentes as chaves sao celulas ?

def tabuleiros_iguais(t1, t2):
        """tabuleiro x tabuleiro -> logico"""
        return eh_tabuleiro(t1) and eh_tabuleiro(t2) and t1 == t2

def tabuleiro_para_str(t): #{(0, 0): *, (0, 1): *, (0, 2): *, (1, 0): *, (1, 1): *, (1, 2): *, (2, 1): *, (2, 2): *}
        """tabuleiro -> cadeia de caracteres"""
        return  '+-------+\n'                                                                                                                                                                                                   \
                +'|...' + celula_para_str(tabuleiro_celula(t,cria_coordenada(0,2))) + '...|\n'                                                                                                                                  \
                +'|..' + celula_para_str(tabuleiro_celula(t,cria_coordenada(0,1))) +'.' + celula_para_str(tabuleiro_celula(t,cria_coordenada(1,2))) + '..|\n'                                                                   \
                +'|.' + celula_para_str(tabuleiro_celula(t,cria_coordenada(0,0))) + '.' + celula_para_str(tabuleiro_celula(t,cria_coordenada(1,1))) + '.' + celula_para_str(tabuleiro_celula(t,cria_coordenada(2,2))) + '.|\n'  \
                +'|..' + celula_para_str(tabuleiro_celula(t,cria_coordenada(1,0))) + '.' + celula_para_str(tabuleiro_celula(t,cria_coordenada(2,1))) + '..|\n'                                                                  \
                +'+-------+'
#===============================================================================


#===============================================================================
# PORTAS                                                                       #
#===============================================================================
def porta_x(t, p):
        """tabuleiro x {'E', 'D'} -> tabuleiro"""
        if not (eh_tabuleiro(t) and p in ('E', 'D')):
                raise ValueError('porta_x: argumentos invalidos.')
        if p == 'E':
                tabuleiro_inverte_estado(t, cria_coordenada(1,0)), tabuleiro_inverte_estado(t, cria_coordenada(1,1)), tabuleiro_inverte_estado(t, cria_coordenada(1,2))
        elif p == 'D':
                tabuleiro_inverte_estado(t, cria_coordenada(0,1)), tabuleiro_inverte_estado(t, cria_coordenada(1, 1)), tabuleiro_inverte_estado(t, cria_coordenada(2, 1))
        return t

def porta_z(t, p):
        """tabuleiro x {'E', 'D'} -> tabuleiro"""
        if not (eh_tabuleiro(t) and p in ('E', 'D')):
                raise ValueError('porta_z: argumentos invalidos.')
        if p == 'E':
                tabuleiro_inverte_estado(t, cria_coordenada(0,0))
                tabuleiro_inverte_estado(t, cria_coordenada(0,1))
                tabuleiro_inverte_estado(t, cria_coordenada(0,2))
        elif p == 'D':
                tabuleiro_inverte_estado(t, cria_coordenada(0,2))
                tabuleiro_inverte_estado(t, cria_coordenada(1,2))
                tabuleiro_inverte_estado(t, cria_coordenada(2,2))
        return t

def porta_h(t, p):
        """tabuleiro x {'E', 'D'} -> tabuleiro"""
        if not (eh_tabuleiro(t) and p in ('E', 'D')):
                raise ValueError('porta_h: argumentos invalidos.')
        a, b, c = tabuleiro_celula(t,cria_coordenada(0,0)), tabuleiro_celula(t,cria_coordenada(0,1)), tabuleiro_celula(t,cria_coordenada(0,2))
        d, e, f = tabuleiro_celula(t,cria_coordenada(1,0)), tabuleiro_celula(t,cria_coordenada(1,1)), tabuleiro_celula(t,cria_coordenada(1,2))
        g, h = tabuleiro_celula(t,cria_coordenada(2,1)), tabuleiro_celula(t,cria_coordenada(2,2))
        if p == 'E':
                tabuleiro_substitui_celula(t,d,cria_coordenada(0,0))
                tabuleiro_substitui_celula(t,e,cria_coordenada(0,1))
                tabuleiro_substitui_celula(t,f,cria_coordenada(0,2))
                tabuleiro_substitui_celula(t,a,cria_coordenada(1,0))
                tabuleiro_substitui_celula(t,b,cria_coordenada(1,1))
                tabuleiro_substitui_celula(t,c,cria_coordenada(1,2))
        elif p == 'D':
                tabuleiro_substitui_celula(t,c,cria_coordenada(0,1))
                tabuleiro_substitui_celula(t,b,cria_coordenada(0,2))
                tabuleiro_substitui_celula(t,f,cria_coordenada(1,1))
                tabuleiro_substitui_celula(t,e,cria_coordenada(1,2))
                tabuleiro_substitui_celula(t,h,cria_coordenada(2,1))
                tabuleiro_substitui_celula(t,g,cria_coordenada(2,2))
        return t
#===============================================================================


#===============================================================================
# JOGO                                                                         #
#===============================================================================
def hello_quantum(cc):
        """cadeia de caracteres -> logico"""
        jog = 1
        cc = cc.split(':')
        tf, max_jog = str_para_tabuleiro(cc[0]), eval(cc[1])
        print('Bem-vindo ao Hello Quantum!')
        print('O seu objetivo e chegar ao tabuleiro:')
        print(tabuleiro_para_str(tf))
        print('Comecando com o tabuleiro que se segue:')
        ti = tabuleiro_inicial()
        print(tabuleiro_para_str(ti))
        while ti != tf and jog <= max_jog:
                porta = input('Escolha uma porta para aplicar (X, Z ou H): ')
                lado = input('Escolha um qubit para analisar (E ou D): ')
                print(tabuleiro_para_str(jogada(ti, porta, lado)))
                jog += 1
        if jog > max_jog:
                if ti != tf:
                        return False
        print('Parabens, conseguiu converter o tabuleiro em', str(jog-1),'jogadas!')
        return True
#===============================================================================      
