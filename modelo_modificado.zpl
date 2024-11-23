#MODELO CON RESTRICCIÓN ADICIONAL

#Conjuntos
set O := {read "oficinas.txt" as "<1s>"};     #Conjunto de Oficinas
set C := {read "centrales.txt" as "<1s>"};    #Conjunto de Centrales


#Parametros
param costo_apertura := 5700;    #Costo de apertura central operativa -> USD5700
param costo_cable := 0.017;      #Costo por 1000m de cable -> USD17, 1m -> 0,017
param M := 15000;                #Capacidad maxima de operaciones por hora que procesa una central

param op[O]:= read "oficinas.txt" as "<1s> 2n";      #Operaciones por hora de la oficina i
param d[O*C] := read "distancias.txt" as "n+";       #Distancia entre oficina i y central j 


#Variables
var y[C] binary;     #Si se abre la central j, y[j] = 1
var x[O*C] binary;   #Si la central operativa j abastece a la oficina i 



#Objetivo
minimize cost:                                                  #Minimizo el costo
	(sum <j> in C: y[j] * costo_apertura)                        #Costo por cada central abierta
    +  (sum <i,j> in O*C: x[i,j] * d[i,j] * costo_cable);        #Costo de cable por metro


#Restricciones
subto oficina_conectada: forall <i> in O:       #Cada oficina debe estar abastecida por una central
	sum <j> in C: x[i,j] == 1;

subto operaciones: forall <j> in C:            #Capacidad máxima de operaciones por hora que procesa una central
	sum <i> in O: x[i,j] * op[i] <= M;

subto centrales_usadas: forall <i,j> in O*C:       #Forzar y[j] = 1 cuando la central j abastece a alguna oficina
	sum <i> in O: x[i,j] <= y[j]; 

#Restriccion Extra
subto cant_oficinas_por_central: forall <j> in C:
    sum <i> in O: x[i,j] <= 10;