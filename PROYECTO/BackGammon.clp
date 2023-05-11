(deftemplate jugador
    (slot tipo (type INTEGER)) 				; 0: humano, 1: cpu
    (slot color (type INTEGER))				; 0: negro, 1:blanco
	(slot nombre(type INTEGER))				; 1: jugador1, 2: jugador2
	(slot fichasJugando (type INTEGER))
	(slot fichasCasa (type INTEGER))
	(slot fichasUltimo (type INTEGER))
)

(deftemplate BackGammon
    (slot ID (type INTEGER))                    ; ID del nodo
    (slot padre (type INTEGER))                 ; ID del nodo padre
    (multislot tablero (type INTEGER))          ; representa el tablero, donde se encuentran las fichas
    (slot profundidad (type INTEGER))           ; profundidad del nodo
)

(deffunction tirarDados ()
    (printout t "Tirando dados..." crlf)
    (bind ?dado1 (random 1 6))
    (bind ?dado2 (random 1 6))
    
    (printout t "Dado 1: " ?dado1 crlf)
    (printout t "Dado 2: " ?dado2 crlf)
    (return (create$ ?dado1 ?dado2))
)

(deffunction imprimir-mapeo ($?mapeo)
     
    (printout t crlf "   ")
    (loop-for-count (?i 13 18)
        (printout t "   " ?i)
    )
    (printout t "     ")
	(loop-for-count (?i 19 24)
        (printout t "   " ?i)
    )
	(printout t crlf)

	(printout t "     ")
    (loop-for-count 13
        (printout t "____ ")
	)
	


    (printout t crlf)

   
	(printout t "    ")
	(loop-for-count 6
		(printout t "|    ")
	)
	(printout t "||||")
	(printout t "|")
	(loop-for-count 6
		(printout t "|    ")
	)
	(printout t "|")
	(printout t crlf)
	(printout t "    | ")
	(loop-for-count (?j 13 18)
		(if (eq (nth$ ?j $?mapeo) 0)
			then (printout t "  ")
		else 
			(if (< (nth$ ?j $?mapeo) 0) then
				(printout t (str-cat N (abs(nth$ ?j $?mapeo))))
			else
				(if (> (nth$ ?j $?mapeo) 0) then
					(printout t (str-cat B (abs(nth$ ?j $?mapeo))))
				)
			)
		)
		(if (neq ?j 18) then
			(printout t " | ")
		)
	)
	(printout t " |||||")
	(printout t "| ")
	(loop-for-count (?j 19 24)
		(if (eq (nth$ ?j $?mapeo) 0)
				then (printout t "  ")
		else 
			(if (< (nth$ ?j $?mapeo) 0) then
				(printout t (str-cat N (abs(nth$ ?j $?mapeo))))
			else
				(if (> (nth$ ?j $?mapeo) 0) then
					(printout t (str-cat B (abs(nth$ ?j $?mapeo))))
				)
			)
		)
		(printout t " | ")
	)
	(printout t crlf)
	(printout t "    ")
	(loop-for-count 6
		(printout t "|____")
	)
	(printout t "||||")
	(printout t "|")
	(loop-for-count 6
		(printout t "|____")
	)
	(printout t "|")
	(printout t crlf)

	
	(printout t "     ")
	(loop-for-count 13
		(printout t "____ ")
	)
	(printout t crlf)
	(printout t "     ")
	(loop-for-count 13
		(printout t "____ ")
	)
	(printout t crlf)
	(printout t "    ")
	(loop-for-count 6
		(printout t "|    ")
	)
	(printout t "||||")
	(printout t "|")
	(loop-for-count 6
		(printout t "|    ")
	)
	(printout t "|")
	(printout t crlf)

	(printout t "    | ")
	(bind ?j 12)
	(while (neq ?j 6)
		(if (eq (nth$ ?j $?mapeo) 0)
			then (printout t "  ")
		else 
			(if (< (nth$ ?j $?mapeo) 0) then
				(printout t (str-cat N (abs(nth$ ?j $?mapeo))))
			else
				(if (> (nth$ ?j $?mapeo) 0) then
					(printout t (str-cat B (abs(nth$ ?j $?mapeo))))
				)
			)
		)
		(bind ?j (- ?j 1))
		(if (neq ?j 6) then
			(printout t " | ")
		)
		
	)
	(printout t " |||||")
	(printout t "| ")
	(bind ?j 6)
	(while (neq ?j 0)
		(if (eq (nth$ ?j $?mapeo) 0)
				then (printout t "  ")
		else 
			(if (< (nth$ ?j $?mapeo) 0) then
				(printout t (str-cat N (abs(nth$ ?j $?mapeo))))
			else
				(if (> (nth$ ?j $?mapeo) 0) then
					(printout t (str-cat B (abs(nth$ ?j $?mapeo))))
				)
			)
		)
		(printout t " | ")
		(bind ?j (- ?j 1))
	)
	
	(printout t crlf)
	(printout t "    ")
	(loop-for-count 6
		(printout t "|____")
	)
	(printout t "||||")
	(printout t "|")
	(loop-for-count 6
		(printout t "|____")
	)
	(printout t "|")
	(printout t crlf)
	(printout t crlf "   ")
	
	(bind ?i 12)
	(while (neq ?i 6)
		(if (< ?i 10) then
			(printout t "    " ?i)
		else
			(printout t "   " ?i)
		)
		(bind ?i (- ?i 1))
	)
	(printout t "     ")
	(bind ?i 6)
	(while (neq ?i 0)
		(printout t "    " ?i)
		(bind ?i (- ?i 1))
	)
	(printout t crlf)
	(printout t crlf)
	(printout t crlf)
)

(deffunction posiblesDesplazamientos (?color ?fichasJugando ?dado1 ?dado2 ?sumadados $?tablero)
	(if (eq ?color 1) then
		(bind $?posiblesDespD1 (create$))
		(bind $?posiblesDespD2 (create$))
		(bind $?posiblesDespD1D2 (create$))
		(bind $?llegaCASA (create$))

		(bind ?i 1)
		(while(> 24 ?i)
			; hay alguna ficha blanca en la posicion i
			(if (> (nth$ ?i $?tablero) 0) then
				; puedo mover la ficha i dado1 posiciones		
				(bind ?posicionD1 (+ ?i ?dado1))
				(if(> (nth$ ?posicionD1 $?tablero) -1) then
					(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
					(bind ?tupla (create$ ?i ?posicionD1))
					(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
				)
				; si nos salimos de la posicion 24, entramos en casa
				(if(> (nth$ ?posicionD1 $?tablero) 24) then
					(printout t "La ficha de la posicion " ?i " puede moverse a CASA utilizando el dado1"crlf)
					(bind $?posiblesDespD1 $?llegaCASA ?i)
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (+ ?i ?dado2))
				(if(> (nth$ ?posicionD2 $?tablero) -1) then
					(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
					(bind ?tupla (create$ ?i ?posicionD2))
					(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla)
				)
				(if(> (nth$ ?posicionD2 $?tablero) 24) then
					(printout t "La ficha de la posicion " ?i " puede moverse a CASA utilizando el dado2"crlf)
					(bind $?posiblesDespD1 $?llegaCASA ?i)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (+ ?i ?sumadados))
				(if(> (nth$ ?posicionD1D2 $?tablero) -1) then
					(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
					(bind ?tupla (create$ ?i ?posicionD1D2))
					(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
				)
				(if(> (nth$ ?posicionD1D2 $?tablero) 24) then
					(printout t "La ficha de la posicion " ?i " puede moverse a CASA utilizando el dado1+2"crlf)
					(bind $?posiblesDespD1 $?llegaCASA ?i)
				)
			)
			(bind ?i (+ ?i 1))
		)
		(return (create$ ?posiblesDespD1 ?posiblesDespD2 ?posiblesDespD1D2))
	)
	else
		(bind $?posiblesDespD1 (create$))
		(bind $?posiblesDespD2 (create$))
		(bind $?posiblesDespD1D2 (create$))
		(bind ?i 24)
		(while(< 1 ?i)
			; hay alguna ficha blanca en la posicion i
			(if (< (nth$ ?i $?tablero) 0) then 

				; puedo mover la ficha i dado1 posiciones
				(bind ?posicionD1 (- ?i ?dado1))
				(if(< (nth$ ?posicionD1 $?tablero) 1) then
					(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
					(bind ?tupla (create$ ?i ?posicionD1))
					(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
				)
				(if(< (nth$ ?posicionD1 $?tablero) 1) then
					(printout t "La ficha de la posicion " ?i " puede moverse a CASA utilizando el dado1"crlf)
					(bind $?posiblesDespD1 $?llegaCASA ?i)
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (- ?i ?dado2))
				(if(< (nth$ ?posicionD2 $?tablero) 1) then
					(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
					(bind ?tupla (create$ ?i ?posicionD2))
					(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla)
				)
				(if(< (nth$ ?posicionD2 $?tablero) 1) then
					(printout t "La ficha de la posicion " ?i " puede moverse a CASA utilizando el dado2"crlf)
					(bind $?posiblesDespD1 $?llegaCASA ?i)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (- ?i ?sumadados))
				(if(< (nth$ ?posicionD1D2 $?tablero) 1) then
					(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
					(bind ?tupla (create$ ?i ?posicionD1D2))
					(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
				)
				(if(< (nth$ ?posicionD1D" $?tablero) 1) then
					(printout t "La ficha de la posicion " ?i " puede moverse a CASA utilizando el dado1+2"crlf)
					(bind $?posiblesDespD1 $?llegaCASA ?i)
				)
			)
			(bind ?i (- ?i 1))
		)
		; mostramos por pantalla ?posbilesDespD1 ?posiblesDespD2 ?posiblesDespD1D2
		;(printout t "Posibles movimientos con el dado1: " ?posiblesDespD1 crlf)
		(return (create$ ?posiblesDespD1 ?posiblesDespD2 ?posiblesDespD1D2)
	)
	
)

(deffacts inicial
    (estado "INICIO")            
	(comidasJ1 0)				; fichas que tiene comidas el jugador 1 y tiene que sacar
	(comidasJ2 0)				; fichas que tiene comidas el jugador 2 y tiene que sacar               
)

(defrule INICIO
    ?e<-(estado "INICIO")
    =>
    (retract ?e)

    (printout t "Bienvenid@ a BackGammon" crlf)

    ; ponemos las fichas en el tablero
    (bind $?tablero (create$ 2 0 0 0 0 -5 0 -3 0 0 0 5 -5 0 0 0 3 0 5 0 0 0 0 -2))
    (imprimir-mapeo $?tablero)

	(assert (BackGammon (ID 0)(padre -1)(tablero $?tablero)(profundidad 0)))

	; JUGADOR 1
    ; iniciar CPU o Humano
    (printout t "Jugador 1: (1->cpu o 0->humano)" crlf)
    (bind ?modo (read))

    ; iniciar blancas o negras
    (printout t "Ingrese el color de sus fichas: (1->blanco o 0->negro)" crlf)
    (bind ?colorj1 (read))
    (if (eq ?modo 0)
        then
            (if (eq ?colorj1 1)
                then
                    (assert (jugador (tipo 0)(color 1)(nombre 1)))
                else
                    (assert (jugador (tipo 0)(color 0)(nombre 1)))
            )  
    else
            (if (eq ?colorj1 1)
                then
                    (assert (jugador (tipo 1)(color 1)(nombre 1)))
                else
                    (assert (jugador (tipo 1)(color 0)(nombre 1)))
            )
    )

	; JUGADOR 2
	; iniciar CPU o Humano
    (printout t "Jugador 2:(1->cpu o 0->humano)" crlf)
    (bind ?modo (read))
	; contrario que j1
    (if (eq ?modo 0)
        then
            (if (eq ?colorj1 1)
                then
                    (assert (jugador (tipo 0)(color 0)(nombre 2)))
                else
                    (assert (jugador (tipo 0)(color 1)(nombre 2)))
            )  
    else
            (if (eq ?colorj1 1)
                then
                    (assert (jugador (tipo 1)(color 0)(nombre 2)))
                else
                    (assert (jugador (tipo 1)(color 1)(nombre 2)))
            )
    )

	(printout t "------------------------------------------------------" crlf)
    
	(printout t "Quien empieza el juego ..... " crlf)
    ; tira dados Jugador 1
    (printout t "Jugador 1 tira dados..." crlf)
    (bind ?dados (tirarDados))
    (bind ?dado1J1 (nth$ 1 ?dados))
    (bind ?dado2J1 (nth$ 2 ?dados))
    (bind ?sumadadosJ1 (+ ?dado1J1 ?dado2J1))

	(printout t "------------------------------------------------------" crlf)

    ; tira dados Jugador 2
    (printout t "Jugador 2 tira dados..." crlf)
    (bind ?dados (tirarDados))
    (bind ?dado1J2 (nth$ 1 ?dados))
    (bind ?dado2J2 (nth$ 2 ?dados))
    (bind ?sumadadosJ2 (+ ?dado1J2 ?dado2J2))
    
	(printout t "------------------------------------------------------" crlf)
	(printout t "------------------------------------------------------" crlf)

    (if (> ?sumadadosJ1 ?sumadadosJ2) 
        then
            (printout t "Jugador 1 empieza" crlf)
			(assert (turno 1))
        else
            (printout t "Jugador 2 empieza" crlf)
            (assert (turno 2))
    )

	
	(printout t "------------------------------------------------------" crlf)
	(printout t "------------------------------------------------------" crlf)
	(printout t "                    JUGANDO						   " crlf)
	(printout t "------------------------------------------------------" crlf)
	(printout t "------------------------------------------------------" crlf)

)


(defrule jugador1
    ?t<-(turno 1)
	?j1<-(jugador (tipo ?tipoj1)(color ?colorj1)(nombre 1)(fichasJugando ?fichasJugandoj1)(fichasCasa ?fichasCasaj1)(fichasUltimo ?fichasUltimoj1))
    ?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))

	=>
	
	(printout t "------------------------------------------------------" crlf)
	(printout t "TURNO DEL JUGADOR 1" crlf)
	(imprimir-mapeo $?tablero)

	(bind ?dados (tirarDados))
    (bind ?dado1 (nth$ 1 ?dados))
    (bind ?dado2 (nth$ 2 ?dados))
    (bind ?sumadados (+ ?dado1 ?dado2))

	(printout t "llega aqui 1" crlf)
	
	(bind ?listas (posiblesDesplazamientos ?colorj1 ?fichasJugandoj1 ?dado1 ?dado2 ?sumadados $?tablero))
	(printout t "llega aqui 2" crlf)

	(bind ?listaD1 (nth$ 1 ?listas))
	(bind ?listaD2 (nth$ 2 ?listas))
	(bind ?listaD3 (nth$ 3 ?listas))

	(printout t "------------------------------------------------------" crlf)
	; (printout t "suma de los dados: " ?sumadados crlf)
 
	; (printout t "Puedes realizar 2 cosas:" crlf)
	; (printout t "    1) Usar la suma de los dados para una sola ficha." crlf)
	; (printout t "    2) Mover una ficha por cada dado." crlf)

	; (printout t "------------------------------------------------------" crlf)
	; (printout t "Ingrese una de las dos opciones: " crlf)
	; (bind ?opcion (read))

	; (printout t "------------------------------------------------------" crlf)

	; (if (eq ?opcion 1) then
	; 	(printout t "Ingrese la posicion de la ficha que quieres mover: " crlf)
	; 	(bind ?posicion (read))

	; 	;ELEGIR LA FICHA A MOVER
	; 	; comprobar si hay alguna ficha del color en esa posicion
	; 	(if (eq ?colorj1 1) then	
	; 		(while (< (nth$ ?posicion $?tablero) 0)
	; 			(printout t (nth$ ?posicion $?tablero) crlf)
	; 			(printout t "No hay fichas de ese color en esa posicion. Ingrese la ficha a mover: " crlf)
	; 			(bind ?posicion (read))
	; 		)
	; 	else

	; 		(while (> (nth$ ?posicion $?tablero) 0)
	; 			(printout t (nth$ ?posicion $?tablero) crlf)
	; 			(printout t "No hay fichas de ese color en esa posicion. Ingrese la ficha a mover: " crlf)
	; 			(bind ?posicion (read))
	; 		)
	; 	)
	
	; 	;MOVER LA FICHA
	; 	; 1) no puede moverse para atras
	; 	; 2) si hay dos casillas del otro color, no puede quedarse ahí ni sobrepasar
	; 	; 3) si llega a donde hay una sola ficha del otro color, la come



		(retract ?t)
	    (assert (turno 2))
	;)

   
	

)

(defrule jugador2
    ?t<-(turno 2)
	?j2<-(jugador (tipo ?tipoj2)(color ?colorj2)(nombre 2)(fichasJugando ?fichasJugandoj2)(fichasCasa ?fichasCasaj2)(fichasUltimo ?fichasUltimoj2))
    ?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))

    =>
 
	(printout t "------------------------------------------------------" crlf)
	(printout t "TURNO DEL JUGADOR 2" crlf)
    (imprimir-mapeo $?tablero)

	(bind ?dados (tirarDados))
    (bind ?dado1 (nth$ 1 ?dados))
    (bind ?dado2 (nth$ 2 ?dados))
    (bind ?sumadados (+ ?dado1 ?dado2))

	(printout t "llega aqui 1" crlf)
	
	(bind ?listas (posiblesDesplazamientos ?colorj2 ?fichasJugandoj2 ?dado1 ?dado2 ?sumadados $?tablero))
	(printout t "llega aqui 2" crlf)
	
	(bind ?listaD1 (nth$ 1 ?listas))
	(bind ?listaD2 (nth$ 2 ?listas))
	(bind ?listaD3 (nth$ 3 ?listas))

	; (printout t "suma de los dados: " ?sumadados crlf)

	; (printout t "Puedes realizar 2 cosas:" crlf)
	; (printout t "    1) Usar la suma de los dados para una sola ficha." crlf)
	; (printout t "    2) Mover una ficha por cada dado." crlf)

	; (printout t "------------------------------------------------------" crlf)
	; (printout t "Ingrese una de las dos opciones: " crlf)
	; (bind ?opcion (read))

	; (printout t "------------------------------------------------------" crlf)

	; (if (eq ?opcion 1) then  
   
	; 	; eleccion de la posicion a mover
	; 	(printout t "Ingrese la posicion de la ficha que quieres mover: " crlf)
	; 	(bind ?posicion (read))

	; 	;ELEGIR FICHA A MOVER
	; 	; comprobar si hay alguna ficha del color en esa posicion
	; 	(if (eq ?colorj2 1) then
	; 		(while (< (nth$ ?posicion $?tablero) 0)
	; 			(printout t (nth$ ?posicion $?tablero) crlf)
	; 			(printout t "No hay fichas de ese color en esa posicion. Ingrese la ficha a mover: " crlf)
	; 			(bind ?posicion (read))
	; 		)
	; 	else
	; 		(while (> (nth$ ?posicion $?tablero) 0)
	; 			(printout t (nth$ ?posicion $?tablero) crlf)
	; 			(printout t "No hay fichas de ese color en esa posicion. Ingrese la ficha a mover: " crlf)
	; 			(bind ?posicion (read))
	; 		)
	; 	)
	; 	;MOVER LA FICHA
	; 	(if (eq ?colorj2 1) then
	; 		(bind ?c 1)
	; 		(while(= ?c 1)
	; 			; si es blanco no puede ir para atras ( de la pos 8 a la 4)
	; 			(if (< ?posicion (- ?posicion 1)) then
	; 				(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
	; 				(bind ?posicion (read))
	; 			if (> 0 (nth$ ?posicion $?tablero)) then
	; 				(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
	; 				(bind ?posicion (read))
	; 			else
	; 				(bind ?c 0) )         
	; 		)
	; 	else
	; 		(bind ?c 1)
	; 		(while(= ?c 1)
	; 			; si es negro no puede ir para atras ( de la pos 17 a la 23)
	; 			(if (> ?posicion (- ?posicion 1))then
	; 				(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
	; 				(bind ?posicion (read))
	; 			if (< 0 (nth$ ?posicion $?tablero)) then
	; 				(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
	; 				(bind ?posicion (read))
	; 			else
	; 				(bind ?c 0) )         
	; 		)
	; 	)
 	(retract ?t)
    (assert (turno 1))
	;)


	

)

(defrule sacarComidasJ1
	?j<-(comidasJ1 ?c)
	(test (> ?c 0))
	(turno 1)
	=>
	(printout t "Sigues teniendo fichas comidas. Primero debes sacar estas antes de mover cualquier otra.")
	(bind ?dados (tirarDados))
    (bind ?dado1J2 (nth$ 1 ?dados))
    (bind ?dado2J2 (nth$ 2 ?dados))
    (bind ?sumadadosJ2 (+ ?dado1J2 ?dado2J2))

	(printout t "Puedes realizar 2 cosas:" crlf)
	(printout t "Usar la suma de los dados para una sola ficha, o por cada dado dos fichas." crlf)


)

(defrule sacarComidasJ2
	?j<-(comidasJ2 ?c)
	(test (> ?c 0))
	(turno 2)
	=>
	(printout t "Sigues teniendo fichas comidas. Primero debes sacar estas antes de mover cualquier otra.")
	(bind ?dados (tirarDados))
    (bind ?dado1J2 (nth$ 1 ?dados))
    (bind ?dado2J2 (nth$ 2 ?dados))
    (bind ?sumadadosJ2 (+ ?dado1J2 ?dado2J2))

	(printout t "Puedes realizar 2 cosas:" crlf)
	(printout t "Usar la suma de los dados para una sola ficha, o por cada dado dos fichas." crlf)


)
