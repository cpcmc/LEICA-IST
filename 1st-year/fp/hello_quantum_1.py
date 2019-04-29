def checkifinst(lista, tipo):
    """lista x tipo -> booleano"""
    return all(isinstance(x, tipo) for x in lista)                              	# todos os elementos da lista sao de um certo tipo? se sim: devolve True

def eh_tabuleiro(x):
    """universal -> booleano"""
    forma = False
    conteudo = False
    if isinstance(x, tuple) and len(x) == 3:                                       	# e do tipo (*, *, *) ?
        if checkifinst([x[0], x[1], x[2]], tuple):                                	# e do tipo ((*), (*), (*)) ?
            if len(x[0]) == len(x[1]) == 3 and len(x[2]) == 2:                     	# e do tipo ((*, *, *), (*, *, *), (*, *)) ?
                if checkifinst([x[0][0], x[0][1], x[0][2]], int):					# e do tipo ((int, int, int), (*, *, *), (*, *)) ?
                    if checkifinst([x[1][0], x[1][1], x[1][2]], int):				# e do tipo ((int, int, int), (int, int, int), (*, *)) ?
                        if checkifinst([x[2][0], x[2][1]], int):                 	# e do tipo ((int, int, int), (int, int, int), (int, int)) ?
                            forma = True                                       		# se sim: forma esta ok
    if forma:
        if {b for a in x for b in a} <= {-1, 0, 1}:                              	# o (set que contem todos os valores distintos existentes em x) esta contido ou e igual ao (set com todos os valores possiveis) ?
            conteudo = True                                                      	# se sim: conteudo esta ok (parte do principio que forma esta ok)
    return forma and conteudo                                                     	# forma e conteudo estao ok? se sim: e tabuleiro

def conv(x):
    """estado celula -> string (estado celula)"""
    return 'x' if x == -1 else str(x)                                         		# -1->'x'   0->'0'   1->'1'

def tabuleiro_str(t):
    """tabuleiro -> string"""
    if eh_tabuleiro(t) is False:
        raise ValueError('tabuleiro_str: argumento invalido')
    ((a, b, c), (d, e, f), (g, h)) = t
    return  '+-------+\n'                                           \
           +'|...' + conv(c) + '...|\n'                             \
           +'|..' + conv(b) +'.' + conv(f) + '..|\n'                \
           +'|.' + conv(a) + '.' + conv(e) + '.' + conv(h) + '.|\n' \
           +'|..' + conv(d) + '.' + conv(g) + '..|\n'               \
           +'+-------+'

def tabuleiros_iguais(t1,t2):
    """tabuleiro x tabuleiro -> booleano"""
    if (eh_tabuleiro(t1) and eh_tabuleiro(t2)) is False:
        raise ValueError('tabuleiros_iguais: um dos argumentos nao e tabuleiro')
    return t1 == t2                                                   				# os tuplos sao (exatamente) iguais ? se sim: devolve True

def inv(pos):
    """estado celula -> estado celula"""
    return -1 if (pos == -1) else (1 - pos)                                        	# -1->-1   0->1   1->0

def checkargs(porta, t, char):
    """tabuleiro x "E"|"D" -> NOP / raise Error"""
    if (eh_tabuleiro(t) and char in ["E", "D"]) is False:
        raise ValueError('porta_' + porta + ': um dos argumentos e invalido')

def porta_x(t, char):
    """tabuleiro x "E"|"D" -> tabuleiro"""
    checkargs('x', t, char)                                                        	# verifica a validade dos argumentos
    ((a, b, c), (d, e, f), (g, h)) = t
    if char == "E":
        return ((a, b, c), (inv(d), inv(e), inv(f)), (g, h))
    elif char == "D":
        return ((a, inv(b), c), (d, inv(e), f), (inv(g), h))

def porta_z(t, char):
    """tabuleiro x "E"|"D" -> tabuleiro"""
    checkargs('z', t, char)                                                    		# verifica a validade dos argumentos
    ((a, b, c), (d, e, f), (g, h)) = t
    if char == "E":
        return ((inv(a), inv(b), inv(c)), (d, e, f), (g, h))
    elif char == "D":
        return ((a, b, inv(c)), (d, e, inv(f)), (g, inv(h)))

def porta_h(t, char):
    """tabuleiro x "E"|"D" -> tabuleiro"""
    checkargs('h', t, char)                                                 		# verifica a validade dos argumentos
    ((a, b, c), (d, e, f), (g, h)) = t
    if char == "E":
        return ((d, e, f), (a, b, c), (g, h))
    elif char == "D":
        return ((a, c, b), (d, f, e), (h, g))