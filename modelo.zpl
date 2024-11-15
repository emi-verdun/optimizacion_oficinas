#MODELO INICIAL
#Conjuntos
set O := {read "oficinas.txt" as "<1s>"};     #Conjunto de Oficinas
set C := {read "centrales.txt" as "<1s>"};    #Conjunto de Centrales


#Parametros
param a := 5700;    #Costo de apertura central operativa -> USD5700
param m := 0.017;   #Costo por 1000m de cable -> USD17
param h := 15000;   #Capacidad maxima de operaciones por hora que procesa una central
param M := 56;      #Máximo de oficinas, variable usada para ligar

param op[O]:= read "oficinas.txt" as "<1s> 2n";      #Operaciones por hora de la oficina i
param d[O*C] := read "distancias.txt" as "n+";       #Distancia entre oficina i y central j 


#Variables
var c[C] binary;     #Si se abre la central j, c[j] = 1
var x[O*C] binary;   #Si la central operativa j abastece a la oficina i 



#Objetivo
minimize cost:                                                #Minimizo el costo
	(sum <j> in C: c[j] * a)                                  #Costo por cada central abierta
    +  (sum <j, i> in C cross O: x[i,j] * d[i,j] * m);        #Costo de cable


#Restricciones
subto oficina_conectada: forall <i> in O:       #Cada oficina debe estar abastecida por una central
	sum <j> in C: x[i,j] == 1;

subto operaciones: forall <j> in C:            #Capacidad máxima de operaciones por hora que procesa una central
	sum <i> in O: x[i,j] * op[i] <= h;

subto centrales_usadas: forall <j> in C:       #Forzar c[j] = 1 cuando la central j abastece a alguna oficina
	sum <i> in O: x[i,j] <= c[j] * M; 