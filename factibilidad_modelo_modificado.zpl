#MINIMO DE CAPACIDAD PROCESAMIENTO DE OPERACIONES DE UNA CENTRAL PARA FACTIBILIDAD DEL MODELO MODIFICADO
#Se va a tener que cumplir h * #C >= (sum <i> in O: op[i])  y  #O / #C <= T

#Si no se cumple alguna de las 2 restricciones va a ser no factible, aun así si se cumple puede que tampoco sea factible


#Conjuntos
set O := {read "oficinas.txt" as "<1s>"};     #Conjunto de Oficinas
set C := {read "centrales.txt" as "<1s>"};    #Conjunto de Centrales


#Parametros
param op[O]:= read "oficinas.txt" as "<1s> 2n";      #Operaciones por hora de la oficina i
param d[O*C] := read "distancias.txt" as "n+";       #Distancia entre oficina i y central j 


#Variables
var y[C] binary;     #Si se abre la central j, c[j] = 1
var x[O*C] binary;   #Si la central operativa j abastece a la oficina i 
var H >= 0;          #Capacidad maxima de operaciones por hora que procesa una central, no puede ser negativo
var T >= 0;          #Cantidad máxima de oficinas que puede abastecer una central



#Objetivo
minimize horas: H + T;                                  


#Restricciones
subto oficina_conectada: forall <i> in O:       #Cada oficina debe estar abastecida por una central
	sum <j> in C: x[i,j] == 1;

subto operaciones: forall <j> in C:            #Capacidad máxima de operaciones por hora que procesa una central
	sum <i> in O: x[i,j] * op[i] <= H;

subto centrales_usadas: forall <i,j> in O*C:       #Forzar y[j] = 1 cuando la central j abastece a alguna oficina
	sum <i> in O: x[i,j] <= y[j]; 
#Restriccion Extra
subto cant_oficinas_por_central: forall <j> in C:   #Repetar la cantidad máxima de oficinas que puede abastecer una central
    sum <i> in O: x[i,j] <= T;
