#MINIMO DE CAPACIDAD PROCESAMIENTO DE OPERACIONES DE UNA CENTRAL PARA FACTIBILIDAD DEL MODELO
#Se va a tener que cumplir h * #C >= (sum <i> in O: op[i])

#Si no se cumple esto va a ser no factible, aun así si se cumple puede que tampoco sea factible por la restricción 
#de que cada oficina puede estar abastecida por solo una central de operaciones. Sin esa restricción, si o si es factible
#si se cumple la ecuacion anterior
#8800 mínima capacidad para que el problema sea factible


#Conjuntos
set O := {read "oficinas.txt" as "<1s>"};     #Conjunto de Oficinas
set C := {read "centrales.txt" as "<1s>"};    #Conjunto de Centrales


#Parametros
param M := 56;      #Máximo de oficinas, variable usada para ligar

param op[O]:= read "oficinas.txt" as "<1s> 2n";      #Operaciones por hora de la oficina i
param d[O*C] := read "distancias.txt" as "n+";       #Distancia entre oficina i y central j 


#Variables
var c[C] binary;     #Si se abre la central j, c[j] = 1
var x[O*C] binary;   #Si la central operativa j abastece a la oficina i 
var h >= 0;          #Capacidad maxima de operaciones por hora que procesa una central, no puede ser negativo



#Objetivo
minimize horas: h;                                  


#Restricciones
subto oficina_conectada: forall <i> in O:       #Cada oficina debe estar abastecida por una central
	sum <j> in C: x[i,j] == 1;

subto operaciones: forall <j> in C:            #Capacidad máxima de operaciones por hora que procesa una central
	sum <i> in O: x[i,j] * op[i] <= h;

subto centrales_usadas: forall <j> in C:       #Forzar c[j] = 1 cuando la central j abastece a alguna oficina
	sum <i> in O: x[i,j] <= c[j] * M; 
