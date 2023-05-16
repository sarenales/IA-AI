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
	(bind $?posiblesDespD1 (create$))
	(bind $?posiblesDespD2 (create$))
	(bind $?posiblesDespD1D2 (create$))
	(if (eq ?color 1) then
		(bind ?i 1)
		(while(> 24 ?i)
			; hay alguna ficha blanca en la posicion i
			(if (> (nth$ ?i $?tablero) 0) then
				; puedo mover la ficha i dado1 posiciones		
				(bind ?posicionD1 (+ ?i ?dado1))
				(if(< ?posicionD1 24) then 
					(if (= (nth$ ?posicionD1 $?tablero) -1) then
						;(printout t "podemos comer siuuu con el dado1" crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
						(bind $?posiblesDespD1 $?posiblesDespD1 1)
						;(bind $?despD1comen $?despD1comen ?tupla)
					)
					(if(> (nth$ ?posicionD1 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
						(bind $?posiblesDespD1 $?posiblesDespD1 2)
					)
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (+ ?i ?dado2))
				(if(< ?posicionD2 24) then
					(if (= (nth$ ?posicionD2 $?tablero) -1) then 
						;(printout t "podemos comer siuuu con el dado2" crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla)
						(bind $?posiblesDespD2 $?posiblesDespD2 1)
						;(bind $?despD2comen $?despD2comen ?tupla)
					)
					(if(> (nth$ ?posicionD2 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla)
						(bind $?posiblesDespD2 $?posiblesDespD2 2)
					)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (+ ?i ?sumadados))
				; (printout t "posicionD1D2: " ?posicionD1D2 crlf)
				(if(< ?posicionD1D2 24) then
					(if (= (nth$ ?posicionD1D2 $?tablero) -1) then 
						;(printout t "podemos comer siuuu con el dado1+2" crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
						(bind $?posiblesDespD1D2 $?posiblesDespD1D2 1)
						;(bind $?despD1D2comen $?despD1D2comen ?tupla)
					)
					(if(> (nth$ ?posicionD1D2 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
						(bind $?posiblesDespD1D2 $?posiblesDespD1D2 2)
					)
				)
			)
			(bind ?i (+ ?i 1))
		)	
	else
		(bind ?i 24)
		(while(< 1 ?i)
			; hay alguna ficha negra en la posicion i
			(if (< (nth$ ?i $?tablero) 0) then 
				; puedo mover la ficha i dado1 posiciones
				(bind ?posicionD1 (- ?i ?dado1))
				(if(> ?posicionD1 1) then
					(if (= (nth$ ?posicionD1 $?tablero) 1) then
						;(printout t "podemos comer siuuu con el dado1" crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
						(bind $?posiblesDespD1 $?posiblesDespD1 1)
						;(bind $?despD1comen $?despD1comen ?tupla)
					)
					(if(< (nth$ ?posicionD1 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
						(bind $?posiblesDespD1 $?posiblesDespD1 2)
					)	
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (- ?i ?dado2))
				(if(> ?posicionD2 1) then
					(if (= (nth$ ?posicionD2 $?tablero) 1) then
						;(printout t "podemos comer siuuu con el dado2" crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla)
						(bind $?posiblesDespD2 $?posiblesDespD2 1)
						;(bind $?despD2comen $?despD2comen ?tupla)
					)
					(if(< (nth$ ?posicionD2 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla 2)
					)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (- ?i ?sumadados))
				(if(> ?posicionD1D2 1) then
					(if (= (nth$ ?posicionD1D2 $?tablero) 1) then
						;(printout t "podemos comer siuuu con el dado1+2" crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
						(bind $?posiblesDespD1D2 $?posiblesDespD1D2 1)
						;(bind $?despD1D2comen $?despD1D2comen ?tupla)
					)
					(if(< (nth$ ?posicionD1D2 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
						(bind $?posiblesDespD1D2 $?posiblesDespD1D2 2)
					)
				)
			)
			(bind ?i (- ?i 1))
		)	
	)
	(return (create$ $?posiblesDespD1 0 $?posiblesDespD2 0 $?posiblesDespD1D2 0 ))
	
)

(deffunction actualizarTablero (?desd ?hast ?color ?vaComer $?tabler)
	(if (= ?color 1)then
		(bind ?contenido (nth$ ?desd $?tabler))
		(bind $?tabler (replace$ $?tabler ?desd ?desd (- ?contenido 1)))
		(bind ?contenido (nth$ ?hast $?tabler))
		(if (eq ?vaComer 1)then
			; si somos blanco y vamos a comer
			; entonces vamos a quitar la ficha negra que esta en la posicion 
			; ?hast y vamos a poner la ficha blanca en la posicion ?hast
			(bind $?tabler (replace$ $?tabler ?hast ?hast (+ ?contenido 2)))
		else
			(bind $?tabler (replace$ $?tabler ?hast ?hast (+ ?contenido 1)))
		)

	
	else
		(bind ?contenido (nth$ ?desd $?tabler))
		(bind $?tabler (replace$ $?tabler ?desd ?desd (+ ?contenido 1)))
		(bind ?contenido (nth$ ?hast $?tabler))
		(if (eq ?vaComer 1)then
			(bind $?tabler (replace$ $?tabler ?hast ?hast (- ?contenido 2)))
		else
			(bind $?tabler (replace$ $?tabler ?hast ?hast (- ?contenido 1)))
		)

	)
	(return $?tabler)
)

(deffunction posiblesDesplazamientosComidas (?color ?fichascomidas ?dado1 ?dado2 ?sumadados $?tablero)
	(bind $?posiblesDespD1 (create$))
	(bind $?posiblesDespD2 (create$))
	(bind $?posiblesDespD1D2 (create$))

	(if (eq ?color 1) then
		; puedo mover la ficha i dado1 posiciones		
		(bind ?posicionD1 (+ 0 ?dado1))
		(if (= (nth$ ?posicionD1 $?tablero) -1) then
			(bind ?tupla (create$ ?i ?posicionD1))
			(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
			(bind $?posiblesDespD1 $?posiblesDespD1 1)
		)
		(if(> (nth$ ?posicionD1 $?tablero) -1) then
			(bind ?tupla (create$ ?i ?posicionD1))
			(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
			(bind $?posiblesDespD1 $?posiblesDespD1 2)
		)
		

		; puedo mover la ficha i dado2 posiciones
		(bind ?posicionD2 (+ 0 ?dado2))
		(if (= (nth$ ?posicionD2 $?tablero) -1) then 
			(bind ?tupla (create$ ?i ?posicionD2))
			(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla)
			(bind $?posiblesDespD2 $?posiblesDespD2 1)
		)
		(if(> (nth$ ?posicionD2 $?tablero) -1) then
			(bind ?tupla (create$ ?i ?posicionD2))
			(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla)
			(bind $?posiblesDespD2 $?posiblesDespD2 2)
		)
		

		; puedo mover la ficha i dado1+dado2 posiciones
		(bind ?posicionD1D2 (+ 0 ?sumadados))
		(if (= (nth$ ?posicionD1D2 $?tablero) -1) then 
			(bind ?tupla (create$ ?i ?posicionD1D2))
			(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
			(bind $?posiblesDespD1D2 $?posiblesDespD1D2 1)
		)
		(if(> (nth$ ?posicionD1D2 $?tablero) -1) then
			(bind ?tupla (create$ ?i ?posicionD1D2))
			(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
			(bind $?posiblesDespD1D2 $?posiblesDespD1D2 2)
		)
		
		
	else
		; puedo mover la ficha i dado1 posiciones
		(bind ?posicionD1 (- 25 ?dado1))
			(if (= (nth$ ?posicionD1 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD1))
				(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
				(bind $?posiblesDespD1 $?posiblesDespD1 1)
			)
			(if(< (nth$ ?posicionD1 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD1))
				(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
				(bind $?posiblesDespD1 $?posiblesDespD1 2)
			)	

		; puedo mover la ficha i dado2 posiciones
		(bind ?posicionD2 (- 25 ?dado2))
			(if (= (nth$ ?posicionD2 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD2))
				(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla)
				(bind $?posiblesDespD2 $?posiblesDespD2 1)
			)
			(if(< (nth$ ?posicionD2 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD2))
				(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla 2)
			)
		

		; puedo mover la ficha i dado1+dado2 posiciones
		(bind ?posicionD1D2 (- 25 ?sumadados))
			(if (= (nth$ ?posicionD1D2 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD1D2))
				(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
				(bind $?posiblesDespD1D2 $?posiblesDespD1D2 1)
			)
			(if(< (nth$ ?posicionD1D2 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD1D2))
				(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
				(bind $?posiblesDespD1D2 $?posiblesDespD1D2 2)
			)		
	)
	(return (create$ $?posiblesDespD1 0 $?posiblesDespD2 0 $?posiblesDespD1D2 0 ))
)

(deffacts inicial
    (estado "INICIO")            
	(comidasJ1 0)				; fichas que tiene comidas el jugador 1 y tiene que sacar
	(comidasJ2 0)				; fichas que tiene comidas el jugador 2 y tiene que sacar   
	(desplazar 0)   
	(D1 0)
	(D2 0)
	(SD 0)
	(contadordado1 0)
	(contadordado2 0)
	(contadorsumadados 0)
	(fichasJugandoJugador1 24)
	(fichasJugandoJugador2 24)
)

(defrule INICIO
    ?e<-(estado "INICIO")
    =>
    (retract ?e)

    (printout t "Bienvenid@ a BackGammon" crlf)

    ; ponemos las fichas en el tablero
    (bind $?tablero (create$ 1 0 0 0 0 -5 0 -3 0 0 0 1 -5 0 0 0 1 0 1 0 0 0 0 -2))
    (imprimir-mapeo $?tablero)

	(assert (BackGammon (ID 0)(padre -1)(tablero $?tablero)(profundidad 0)))

	; JUGADOR 1
    ; iniciar CPU o Humano
    (printout t "Jugador 1: 1->cpu o 0->humano" crlf)
    (bind ?modo (read))

    ; iniciar blancas o negras
    (printout t "Ingrese el color de sus fichas: 1->blanco o 0->negro" crlf)
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
    (printout t "Jugador 2:1->cpu o 0->humano" crlf)
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
            (assert (turno 1))
    )

	
	(printout t "------------------------------------------------------" crlf)
	(printout t "------------------------------------------------------" crlf)
	(printout t "                    JUGANDO						   " crlf)
	(printout t "------------------------------------------------------" crlf)
	(printout t "------------------------------------------------------" crlf)

)

(defrule movimientoREGLA
	?m<- (movimiento 1)
	?d<- (desplazar 0)
	?cm1<- (comidasJ1 ?cmj1)			
	?cm2<- (comidasJ2 ?cmj2)   
	?cd1<- (contadordado1 ?contd1)
	?cd2<- (contadordado2 ?contd2)
	?cd1d2<- (contadorsumadados ?contd1d2)
	?m1<- (movimientosdado1 $?movimientosdado1)
	?m2<- (movimientosdado2 $?movimientosdado2)
	?m1m2<- (movimientosdado1dado2 $?movimientosdado1dado2)
	?nam<- (pcomer $?pcomer)
	?j<- (jugador (tipo ?tipo)(color ?color)(nombre ?nombre)(fichasJugando ?fichasJugando)(fichasCasa 0)(fichasUltimo ?fichasUltimo))
	?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))
	?t<- (turno ?turno)
	(test (= ?turno ?nombre))
	=>

	(bind ?movimiento (read))

	(bind ?contd1 (div ?contd1 3))
	(bind ?contd2 (div ?contd2 3))
	(bind ?contd1d2 (div ?contd1d2 3))
	;(printout t ?contd1 " " ?contd2 " " ?contd1d2 crlf)

	(if(<= ?movimiento  ?contd1) then 
		(retract ?m1m2)
		(printout t "elige el dado 1" crlf) 

		; hay que mirar si va a comer
		(bind ?vaComer (nth$ ?movimiento $?pcomer))
		(if (eq ?vaComer 1) then
			(printout t "Ha elegido comer" crlf)
			; hay que actualizar el numero de comidas para el otro contricante 			
			; miramos que jugador somos
			(if(eq ?turno 1) then
				(retract ?cm2)
				(assert (comidasJ2 (+ ?cmj2 1)))
			else
				(retract ?cm1)
				(assert (comidasJ1 (+ ?cmj1 1)))
			)

		)
		(bind ?desde (nth$ ?movimiento $?movimientosdado1))
		(bind ?hasta (nth$ (+ ?movimiento 1) $?movimientosdado1))

		(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color ?vaComer $?tablero))

		(imprimir-mapeo $?tableroNuevo)

		(retract ?m1)

		(printout t "Ahora elige un movimiento con el dado2" crlf)

		(bind ?movimiento (read))

		(while (or (> ?movimiento (+ ?contd1 ?contd2)) (< ?movimiento ?contd1))
			(printout t "elige un movimiento valido del dado2!" crlf)
			(bind ?movimiento (read))
		)

		; hay que mirar si va a comer
		(bind ?vaComer (nth$ ?movimiento $?pcomer))
		(if (eq ?vaComer 1) then
			(printout t "Ha elegido comer" crlf)
			; hay que actualizar el numero de comidas para el otro contricante 			
			; miramos que jugador somos
			(if(eq ?turno 1) then
				(retract ?cm2)
				(assert (comidasJ2 (+ ?cmj2 1)))
			else
				(retract ?cm1)
				(assert (comidasJ1 (+ ?cmj1 1)))
			)

		)
		(bind ?desde (nth$ (- ?movimiento ?contd1) $?movimientosdado2))
		(bind ?hasta (nth$ (+ (- ?movimiento ?contd1) 1) $?movimientosdado2))
		(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color ?vaComer $?tableroNuevo))

		(retract ?bg ?m2)
		(assert (BackGammon (ID ?id)(padre ?padre)(tablero ?tableroNuevo)(profundidad ?profundidad)))

		(imprimir-mapeo $?tableroNuevo)
		
	else
		(if(> ?movimiento (+ ?contd1 ?contd2)) then
			(printout t "elige el dado1+2" crlf)
			; ya no puede elegir ningun dado mas
			(retract ?m1 ?m2)
			; hay que mirar si va a comer
			(bind ?vaComer (nth$ ?movimiento $?pcomer))
			(if (eq ?vaComer 1) then
				(printout t "Ha elegido comer" crlf)
				; hay que actualizar el numero de comidas para el otro contricante 			
				; miramos que jugador somos
				(if(eq ?turno 1) then
					(retract ?cm2)
					(assert (comidasJ2 (+ ?cmj2 1)))
				else
					(retract ?cm1)
					(assert (comidasJ1 (+ ?cmj1 1)))
				)

			)
			(bind ?desde (nth$ (- ?movimiento ?contd2) $?movimientosdado1))
			(bind ?hasta (nth$ (+ (- ?movimiento ?contd2) 1) $?movimientosdado1))

			(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color ?vaComer $?tablero))

			(retract ?bg)
			?bg<- (assert (BackGammon (ID ?id)(padre ?padre)(tablero ?tableroNuevo)(profundidad ?profundidad)))

			(imprimir-mapeo $?tableroNuevo)
			(retract ?m1m2)
		else
			(retract ?m1m2)
			(printout t "elige el dado 2" crlf)
			; hay que mirar si va a comer
			(bind ?vaComer (nth$ ?movimiento $?pcomer))
			(if (eq ?vaComer 1) then
				(printout t "Ha elegido comer" crlf)
				; hay que actualizar el numero de comidas para el otro contricante 			
				; miramos que jugador somos
				(if(eq ?turno 1) then
					(retract ?cm2)
					(assert (comidasJ2 (+ ?cmj2 1)))
				else
					(retract ?cm1)
					(assert (comidasJ1 (+ ?cmj1 1)))
				)

			)
			(bind ?desde (nth$ (- ?movimiento ?contd1) $?movimientosdado2))
			(bind ?hasta (nth$ (+ (- ?movimiento ?contd1) 1) $?movimientosdado2))

			(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color ?vaComer $?tablero))

			(imprimir-mapeo $?tableroNuevo)

			(retract ?m2)

			(printout t "Ahora elige un movimiento con el dado1" crlf)

			(bind ?movimiento (read))

			(while (> ?movimiento ?contd1)
				(printout t "elige un movimiento valido del dado1!" crlf)
				(bind ?movimiento (read))
			)
			; hay que mirar si va a comer
			(bind ?vaComer (nth$ ?movimiento $?pcomer))
			(if (eq ?vaComer 1) then
				(printout t "Ha elegido comer" crlf)
				; hay que actualizar el numero de comidas para el otro contricante 			
				; miramos que jugador somos
				(if(eq ?turno 1) then
					(retract ?cm2)
					(assert (comidasJ2 (+ ?cmj2 1)))
				else
					(retract ?cm1)
					(assert (comidasJ1 (+ ?cmj1 1)))
				)

			)
			(bind ?desde (nth$ ?movimiento $?movimientosdado1))
			(bind ?hasta (nth$ (+ ?movimiento 1) $?movimientosdado1))
			(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color ?vaComer $?tableroNuevo))

			(retract ?bg ?m1)
			(assert (BackGammon (ID ?id)(padre ?padre)(tablero ?tableroNuevo)(profundidad ?profundidad)))

			(imprimir-mapeo $?tableroNuevo)
		)
	)


	(assert (desplazar 0))
	(assert (movimiento 0))
	(if (= ?turno 1) then
		(retract ?t)
		(assert (turno 2))
	else
		(retract ?t)
		(assert (turno 1))
	)
	

	(retract ?cd1 ?cd2 ?cd1d2) 
	
	(assert (D1 0))
	(assert (D2 0))
	(assert (SD 0))
	
	(assert (contadordado1 0))
	(assert (contadordado2 0))
	(assert (contadorsumadados 0))
)

(defrule desplazarREGLA
	?d<-(desplazar 1)
	?m1<- (movimientosdado1 $?movimientosdado1)
	?m2<- (movimientosdado2 $?movimientosdado2)
	?m1m2<- (movimientosdado1dado2 $?movimientosdado1dado2)
	?comJ1<- (comidasJ1 ?comiJ1)
	?comJ2<- (comidasJ2 ?comiJ2)
	?d1 <- (D1 ?dado1)
	?d2 <- (D2 ?dado2)
	?sumad1d2 <- (SD ?sumadados)
	?j<- (jugador (tipo ?tipo)(color ?color)(nombre ?nombre)(fichasJugando ?fichasJugando)(fichasCasa 0)(fichasUltimo ?fichasUltimo))
	?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))
	?t<- (turno ?turno)
	(test (eq ?turno ?nombre))
	=>
	;(printout t "entra en desplazar " crlf)
	(retract ?d ?m1 ?m2 ?m1m2)
	(if (eq ?color 1) then
		(bind ?i 1)
		(while(> 24 ?i)
			; hay alguna ficha blanca en la posicion i
			(if (> (nth$ ?i $?tablero) 0) then
				; puedo mover la ficha i dado1 posiciones		
				(bind ?posicionD1 (+ ?i ?dado1))
				(if(< ?posicionD1 24) then 
					(if (= (nth$ ?posicionD1 $?tablero) -1) then
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
						(bind $?movimientosdado1 $?movimientosdado1 1)
						;(bind $?D1comen $?D1comen ?tupla)
					)
					(if(> (nth$ ?posicionD1 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
						(bind $?movimientosdado1 $?movimientosdado1 2)
					)
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (+ ?i ?dado2))
				(if(< ?posicionD2 24) then
					(if (= (nth$ ?posicionD2 $?tablero) -1) then
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
						(bind $?movimientosdado2 $?movimientosdado2 1)	
						;(bind $?D2comen $?D2comen ?tupla)
					)
					(if(> (nth$ ?posicionD2 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
						(bind $?movimientosdado2 $?movimientosdado2 2)
					)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (+ ?i ?sumadados))
				(if(< ?posicionD1D2 24) then
					(if (= (nth$ ?posicionD1 $?tablero) -1) then
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 1)
						;(bind $?D1D2comen $?D1D2comen ?tupla)
					)
					(if(> (nth$ ?posicionD1D2 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 2)
					)
				)
			)
			(bind ?i (+ ?i 1))
		)
	else
		(bind ?i 24)
		(while(< 1 ?i)
			; hay alguna ficha negra en la posicion i
			(if (< (nth$ ?i $?tablero) 0) then 
				(bind ?posicionD1 (- ?i ?dado1))
				(if(> ?posicionD1 1) then
					(if (= (nth$ ?posicionD1 $?tablero) 1) then
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
						(bind $?movimientosdado1 $?movimientosdado1 1)
						;(bind $?D1comen $?D1comen ?tupla)
					)
					(if(< (nth$ ?posicionD1 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
						(bind $?movimientosdado1 $?movimientosdado1 2)
					)	
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (- ?i ?dado2))
				(if(> ?posicionD2 1) then
					(if (= (nth$ ?posicionD2 $?tablero) 1) then
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
						(bind $?movimientosdado2 $?movimientosdado2 1)
						;(bind $?D2comen $?D2comen ?tupla)
					)
					(if(< (nth$ ?posicionD2 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
						(bind $?movimientosdado2 $?movimientosdado2 2)
					)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (- ?i ?sumadados))
				(if(> ?posicionD1D2 1) then
					(if (= (nth$ ?posicionD1D2 $?tablero) 1) then
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 1)
						;(bind $?D1D2comen $?D1D2comen ?tupla)
					)
					(if(< (nth$ ?posicionD1D2 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 2)
					)
				)
			)
			(bind ?i (- ?i 1))
		)	
	)	
	(assert (movimientosdado1 $?movimientosdado1))
	(assert (movimientosdado2 $?movimientosdado2))
	(assert (movimientosdado1dado2 $?movimientosdado1dado2)) 
	(retract ?d)
	(assert (desplazar 0))
	(retract ?d1 ?d2 ?sumad1d2)
	(assert (movimiento 1))
)

(defrule desplazarComidasREGLA
	?d<-(desplazarComidas 1)
	?m1<- (movimientosdado1 $?movimientosdado1)
	?m2<- (movimientosdado2 $?movimientosdado2)
	?m1m2<- (movimientosdado1dado2 $?movimientosdado1dado2)
	?comJ1<- (comidasJ1 ?comiJ1)
	?comJ2<- (comidasJ2 ?comiJ2)
	?d1 <- (D1 ?dado1)
	?d2 <- (D2 ?dado2)
	?sumad1d2 <- (SD ?sumadados)
	?j<- (jugador (tipo ?tipo)(color ?color)(nombre ?nombre)(fichasJugando ?fichasJugando)(fichasCasa 0)(fichasUltimo ?fichasUltimo))
	?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))
	?t<- (turno ?turno)
	(test (eq ?turno ?nombre))
	=>
	(retract ?d ?m1 ?m2 ?m1m2)
	(if (eq ?color 1) then
		; puedo mover la ficha i dado1 posiciones		
		(bind ?posicionD1 (+ 0 ?dado1))
		(if(< ?posicionD1 24) then 
			(if (= (nth$ ?posicionD1 $?tablero) -1) then
				(bind ?tupla (create$ ?i ?posicionD1))
				(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
				(bind $?movimientosdado1 $?movimientosdado1 1)
			)
			(if(> (nth$ ?posicionD1 $?tablero) -1) then
				(bind ?tupla (create$ ?i ?posicionD1))
				(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
				(bind $?movimientosdado1 $?movimientosdado1 2)
			)
		)

		; puedo mover la ficha i dado2 posiciones
		(bind ?posicionD2 (+ 0 ?dado2))
		(if(< ?posicionD2 24) then
			(if (= (nth$ ?posicionD2 $?tablero) -1) then
				(bind ?tupla (create$ ?i ?posicionD2))
				(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
				(bind $?movimientosdado2 $?movimientosdado2 1)	
			)
			(if(> (nth$ ?posicionD2 $?tablero) -1) then
				(bind ?tupla (create$ ?i ?posicionD2))
				(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
				(bind $?movimientosdado2 $?movimientosdado2 2)
			)
		)

		; puedo mover la ficha i dado1+dado2 posiciones
		(bind ?posicionD1D2 (+ 0 ?sumadados))
		(if(< ?posicionD1D2 24) then
			(if (= (nth$ ?posicionD1 $?tablero) -1) then
				(bind ?tupla (create$ ?i ?posicionD1D2))
				(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
				(bind $?movimientosdado1dado2 $?movimientosdado1dado2 1)
			)
			(if(> (nth$ ?posicionD1D2 $?tablero) -1) then
				(bind ?tupla (create$ ?i ?posicionD1D2))
				(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
				(bind $?movimientosdado1dado2 $?movimientosdado1dado2 2)
			)
		)		
	else
		(bind ?posicionD1 (- 25 ?dado1))
		(if(> ?posicionD1 1) then
			(if (= (nth$ ?posicionD1 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD1))
				(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
				(bind $?movimientosdado1 $?movimientosdado1 1)
			)
			(if(< (nth$ ?posicionD1 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD1))
				(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
				(bind $?movimientosdado1 $?movimientosdado1 2)
			)	
		)

		; puedo mover la ficha i dado2 posiciones
		(bind ?posicionD2 (- 25 ?dado2))
		(if(> ?posicionD2 1) then
			(if (= (nth$ ?posicionD2 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD2))
				(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
				(bind $?movimientosdado2 $?movimientosdado2 1)
			)
			(if(< (nth$ ?posicionD2 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD2))
				(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
				(bind $?movimientosdado2 $?movimientosdado2 2)
			)
		)

		; puedo mover la ficha i dado1+dado2 posiciones
		(bind ?posicionD1D2 (- 25 ?sumadados))
		(if(> ?posicionD1D2 1) then
			(if (= (nth$ ?posicionD1D2 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD1D2))
				(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
				(bind $?movimientosdado1dado2 $?movimientosdado1dado2 1)
			)
			(if(< (nth$ ?posicionD1D2 $?tablero) 1) then
				(bind ?tupla (create$ ?i ?posicionD1D2))
				(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
				(bind $?movimientosdado1dado2 $?movimientosdado1dado2 2)
			)
		)

	)	
	(assert (movimientosdado1 $?movimientosdado1))
	(assert (movimientosdado2 $?movimientosdado2))
	(assert (movimientosdado1dado2 $?movimientosdado1dado2)) 
	(retract ?d)
	(assert (desplazar 0))
	(retract ?d1 ?d2 ?sumad1d2)
	(assert (movimiento 1))
)

(defrule jugador1
    ?t<-(turno 1)
	?d1<- (D1 0)
	?d2<- (D2 0)
	?d1d2<-(SD 0)
	?cd1<-(contadordado1 0)
	?cd2<-(contadordado2 0)
	?cd1d2<-(contadorsumadados 0)
	?j1<-(jugador (tipo ?tipoj1)(color ?colorj1)(nombre 1)(fichasJugando ?fichasJugandoj1)(fichasCasa ?fichasCasaj1)(fichasUltimo ?fichasUltimoj1))
	?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))
	?desplazar<-(desplazar 0)
	?numfichas<- (fichasJugandoJugador1 ?numfichasj1)
	=>
	(assert (movimientosdado1 (create$)))	
	(assert (movimientosdado2 (create$)))	
	(assert (movimientosdado1dado2 (create$)))	
	(assert (dado1puedenComer (create$)))
	(assert (dado2puedenComer (create$)))
	(assert (dado1dado2puedenComer (create$)))

	(bind $?podercomer (create$))

	(printout t "------------------------------------------------------" crlf)
	(printout t "TURNO DEL JUGADOR 1" crlf)
	(imprimir-mapeo $?tablero)

	(retract ?d1 ?d2 ?d1d2 ?desplazar ?cd1 ?cd2 ?cd1d2)

	(bind ?dados (tirarDados))
    (bind ?dado1 (nth$ 1 ?dados))
    (bind ?dado2 (nth$ 2 ?dados))
    (bind ?sumadados (+ ?dado1 ?dado2))
	
	(assert (D1 ?dado1))
	(assert (D2 ?dado2))
	(assert (SD ?sumadados))

	; regla para almacenar los posibles desplazamientos
	(assert (desplazar 1))

	(bind ?listas (posiblesDesplazamientos ?colorj1 ?fichasJugandoj1 ?dado1 ?dado2 ?sumadados $?tablero))

	;(printout t (implode$ ?listas) crlf)

	(bind ?l (implode$ ?listas))
	;(printout t ?l crlf)


	(printout t "------------------------------------------------------" crlf)
	(printout t "Opciones de movimiento: " crlf)
	(printout t "------------------------------------------------------" crlf)
	
	
	(printout t "Eliga una de las siguientes opciones: " crlf)



	; vamos a separar las listas : lista de dado1 , dado2 y dado1+dado2

	; dado1
	; cuantos elementos tiene la lista
	(bind ?dado1listabool 0)
	(bind ?dado1lista (create$))
	(bind ?i 1)
	(bind ?cont1 0)
	(while (= ?dado1listabool 0)
		(bind ?elemento (nth$ ?i ?listas))
		(if (= 0 ?elemento) then
			(bind ?dado1listabool 1)
		else
			(bind ?dado1lista ?dado1lista (nth$ ?i ?listas))
			(bind ?i (+ ?i 1))
			(bind ?cont1 (+ ?cont1 1))
		)
	)
	(printout t "Dado 1" crlf)
	;(printout t ?dado1lista crlf)
	(bind ?j 1)
	(bind ?a 1)
	(while (< ?j ?cont1)
		(bind ?tupla (create$))
		(bind ?elemento (nth$ ?j ?dado1lista))
		(bind ?siguienteElemento (nth$ (+ ?j 1) ?dado1lista))
		(bind ?secome (nth (+ ?j 2) ?dado1lista))
		;(printout t ?secome crlf)
		(if (eq ?secome 1) then
			(printout t " Opcion " ?a ") ["  ?elemento "  COME -> "  ?siguienteElemento " ]" crlf)
			(bind ?podercomer ?podercomer 1)
		else
			(bind ?tupla ?tupla ?elemento ?siguienteElemento)
			(printout t " Opcion " ?a ") [" (implode$ ?tupla) "]" crlf)
			(bind ?podercomer ?podercomer 0)
		)
		(bind ?j (+ ?j 3))
		(bind ?a (+ ?a 1))
	)
	(assert (contadordado1 ?cont1))
	;(printout t ?cont1 crlf)


	(bind ?i (+ ?i 1))
	(bind ?dado2listabool 0)
	(bind ?dado2lista (create$))
	(bind ?cont2 0)
	(while (= ?dado2listabool 0)
		(bind ?elemento (nth$ ?i ?listas))
		(if (= 0 ?elemento) then
			(bind ?dado2listabool 1)
		else
			(bind ?dado2lista ?dado2lista (nth$ ?i ?listas))
			(bind ?i (+ ?i 1))
			(bind ?cont2 (+ ?cont2 1))
		)
	)
	(printout t "Dado 2" crlf)
	;(printout t ?dado2lista crlf)
	(bind ?j 1)
	(while (< ?j ?cont2)
		(bind ?tupla (create$))
		(bind ?elemento (nth$ ?j ?dado2lista))
		(bind ?siguienteElemento (nth$ (+ ?j 1) ?dado2lista))
		(bind ?secome (nth (+ ?j 2) ?dado2lista))
		;(printout t ?secome crlf)
		(if (eq ?secome 1) then
			(printout t " Opcion " ?a ") ["  ?elemento " COME -> "  ?siguienteElemento " ]" crlf)
			(bind ?podercomer ?podercomer 1)
		else
			(bind ?tupla ?tupla ?elemento ?siguienteElemento)
			(printout t " Opcion " ?a ") [" (implode$ ?tupla) "]"crlf)
			(bind ?podercomer ?podercomer 0)
		)
		(bind ?j (+ ?j 3))
		(bind ?a (+ ?a 1))
	)
	(assert (contadordado2 ?cont2))
	;(printout t ?cont2 crlf)




	(bind ?i (+ ?i 1))
	(bind ?dado1d2listabool 0)
	(bind ?dado1d2lista (create$))
	(bind ?cont3 0)
	(while (= ?dado1d2listabool 0)
		(bind ?elemento (nth$ ?i ?listas))
		(if (= 0 ?elemento) then
			(bind ?dado1d2listabool 1)
		else
			(bind ?dado1d2lista ?dado1d2lista (nth$ ?i ?listas))
			(bind ?i (+ ?i 1))
			(bind ?cont3 (+ ?cont3 1))
		)
	)

	(printout t "Dado 1+2" crlf)
	;(printout t ?dado1d2lista crlf)
	(bind ?j 1)
	(while (< ?j ?cont3)
		(bind ?tupla (create$))
		(bind ?elemento (nth$ ?j ?dado1d2lista))
		(bind ?siguienteElemento (nth$ (+ ?j 1) ?dado1d2lista))
		(bind ?secome (nth (+ ?j 2) ?dado1d2lista))
		;(printout t ?secome crlf)
		(if (eq ?secome 1) then
			(printout t " Opcion " ?a ") ["  ?elemento "  COME -> "  ?siguienteElemento " ]"  crlf)
			(bind ?podercomer ?podercomer 1)
		else
			(bind ?tupla ?tupla ?elemento ?siguienteElemento)
			(printout t " Opcion " ?a ") ["  (implode$ ?tupla) "]" crlf)
			(bind ?podercomer ?podercomer 0)
		)
		(bind ?j (+ ?j 3))
		(bind ?a (+ ?a 1))
	)
	(assert (contadorsumadados ?cont3))
	;(printout t ?cont3 crlf)

	;(printout t  $?podercomer crlf)
	(assert (pcomer $?podercomer))

	(assert (movimiento 1))
	;(retract ?t)  
)

(defrule jugador2
    ?t<-(turno 2)
	?d1<- (D1 0)
	?d2<- (D2 0)
	?d1d2<-(SD 0)
	?cd1<-(contadordado1 0)
	?cd2<-(contadordado2 0)
	?cd1d2<-(contadorsumadados 0)
	;?j1<-(jugador (tipo ?tipoj1)(color ?colorj1)(nombre 1)(fichasJugando ?fichasJugandoj1)(fichasCasa ?fichasCasaj1)(fichasUltimo ?fichasUltimoj1))
    ?j2<- (jugador (tipo ?tipoj2)(color ?colorj2)(nombre 2)(fichasJugando ?fichasJugandoj2)(fichasCasa ?fichasCasaj2)(fichasUltimo ?fichasUltimoj2))
	?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))
	?desplazar<-(desplazar 0)
	?numfichas<- (fichasJugandoJugador2 ?numfichasj2)
	=>
	(assert (movimientosdado1 (create$)))	
	(assert (movimientosdado2 (create$)))	
	(assert (movimientosdado1dado2 (create$)))	
	(assert (dado1puedenComer (create$)))
	(assert (dado2puedenComer (create$)))
	(assert (dado1dado2puedenComer (create$)))
	;(retract ?j1)

	(printout t "------------------------------------------------------" crlf)
	(printout t "TURNO DEL JUGADOR 2" crlf)
	(imprimir-mapeo $?tablero)

	(retract ?d1 ?d2 ?d1d2 ?desplazar ?cd1 ?cd2 ?cd1d2)

	(bind ?dados (tirarDados))
    (bind ?dado1 (nth$ 1 ?dados))
    (bind ?dado2 (nth$ 2 ?dados))
    (bind ?sumadados (+ ?dado1 ?dado2))
	
	(assert (D1 ?dado1))
	(assert (D2 ?dado2))
	(assert (SD ?sumadados))

	; regla para almacenar los posibles desplazamientos
	(assert (desplazar 1))

	(bind ?listas (posiblesDesplazamientos ?colorj2 ?fichasJugandoj2 ?dado1 ?dado2 ?sumadados $?tablero))

	;(printout t (implode$ ?listas) crlf)

	(bind ?l (implode$ ?listas))


	(printout t "------------------------------------------------------" crlf)
	(printout t "Opciones de movimiento: " crlf)
	(printout t "------------------------------------------------------" crlf)
	
	
	(printout t "Eliga una de las siguientes opciones: " crlf)

	; vamos a separar las listas
	(bind ?dado1listabool 0)
	(bind ?dado1lista (create$))
	(bind ?i 1)
	(bind ?cont1 0)
	(while (= ?dado1listabool 0)
		(bind ?elemento (nth$ ?i ?listas))
		(if (= 0 ?elemento) then
			(bind ?dado1listabool 1)
		else
			(bind ?dado1lista ?dado1lista (nth$ ?i ?listas))
			(bind ?i (+ ?i 1))
			(bind ?cont1 (+ ?cont1 1))
		)
	)
	(printout t "Dado 1" crlf)
	(bind ?j 1)
	(bind ?a 1)
	(while (< ?j ?cont1)
		(bind ?tupla (create$))
		(bind ?elemento (nth$ ?j ?dado1lista))
		(bind ?siguienteElemento (nth$ (+ ?j 1) ?dado1lista))
		(if (or (= ?siguienteElemento -1) (= ?siguienteElemento 25)) then
			(printout t " Opcion " ?a ") ["  ?elemento " -> CASA]" crlf)

		else
			(bind ?tupla ?tupla ?elemento ?siguienteElemento)
			(printout t " Opcion " ?a ") [" (implode$ ?tupla) "]" crlf)
		)
		(bind ?j (+ ?j 2))
		(bind ?a (+ ?a 1))
	)
	(assert (contadordado1 ?cont1))



	(bind ?i (+ ?i 1))
	(bind ?dado2listabool 0)
	(bind ?dado2lista (create$))
	(bind ?cont2 0)
	(while (= ?dado2listabool 0)
		(bind ?elemento (nth$ ?i ?listas))
		(if (= 0 ?elemento) then
			(bind ?dado2listabool 1)
		else
			(bind ?dado2lista ?dado2lista (nth$ ?i ?listas))
			(bind ?i (+ ?i 1))
			(bind ?cont2 (+ ?cont2 1))
		)
	)

	(printout t "Dado 2" crlf)
	(bind ?j 1)
	(while (< ?j ?cont2)
		(bind ?tupla (create$))
		(bind ?elemento (nth$ ?j ?dado2lista))
		(bind ?siguienteElemento (nth$ (+ ?j 1) ?dado2lista))

		(if (or (= ?siguienteElemento -1) (= ?siguienteElemento 25)) then
			(printout t " Opcion " ?a ") ["  ?elemento " -> CASA]" crlf)
		else
			(bind ?tupla ?tupla ?elemento ?siguienteElemento)
			(printout t " Opcion " ?a ") [" (implode$ ?tupla) "]"crlf)
		)
		(bind ?j (+ ?j 2))
		(bind ?a (+ ?a 1))
	)
	(assert (contadordado2 ?cont2))





	(bind ?i (+ ?i 1))
	(bind ?dado1d2listabool 0)
	(bind ?dado1d2lista (create$))
	(bind ?cont3 0)
	(while (= ?dado1d2listabool 0)
		(bind ?elemento (nth$ ?i ?listas))
		(if (= 0 ?elemento) then
			(bind ?dado1d2listabool 1)
		else
			(bind ?dado1d2lista ?dado1d2lista (nth$ ?i ?listas))
			(bind ?i (+ ?i 1))
			(bind ?cont3 (+ ?cont3 1))
		)
	)

	(printout t "Dado 1+2" crlf)
	(bind ?j 1)
	(while (< ?j ?cont3)
		(bind ?tupla (create$))
		(bind ?elemento (nth$ ?j ?dado1d2lista))
		(bind ?siguienteElemento (nth$ (+ ?j 1) ?dado1d2lista))
		(if (or (= ?siguienteElemento -1) (= ?siguienteElemento 25)) then
			(printout t " Opcion " ?a ") ["  ?elemento " -> CASA]" crlf)
		else
			(bind ?tupla ?tupla ?elemento ?siguienteElemento)
			(printout t " Opcion " ?a ") ["  (implode$ ?tupla) "]" crlf)
		)
		(bind ?j (+ ?j 2))
		(bind ?a (+ ?a 1))
	)
	(assert (contadorsumadados ?cont3))


	(assert (movimiento 1))
	;(retract ?t)  
	

)


(defrule sacarComidasJ1
	?j<-(comidasJ1 ?c)
	(test (> ?c 0))
	(turno 1)
	=>
	(printout t "Sigues teniendo fichas comidas. Primero debes sacar estas antes de mover cualquier otra.")

	; vamos a tener 4 casos diferentes
	; 1) 2> ; elige 1 o 2 dado y sigue habiendo
	; 2) 2= ; elige 1 o 2 dado y no hay mas
	; 3) 1> ; elige 1+2 dado y sigue habiendo
	; 4) 1= ; elige cualquier tipo dado y no hay mas


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
