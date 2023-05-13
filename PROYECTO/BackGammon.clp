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
				(if(< ?posicionD1 24) then ; si nos salimos de la posicion 24, entramos en casa
					(if(> (nth$ ?posicionD1 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?posiblesDespD1 $?posiblesDespD1 ?tupla)
					)
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (+ ?i ?dado2))
				(if(< ?posicionD2 24) then
					(if(> (nth$ ?posicionD2 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?posiblesDespD2 $?posiblesDespD2 ?tupla)
					)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (+ ?i ?sumadados))
				; (printout t "posicionD1D2: " ?posicionD1D2 crlf)
				(if(< ?posicionD1D2 24) then
					(if(> (nth$ ?posicionD1D2 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?posiblesDespD1D2 $?posiblesDespD1D2 ?tupla)
					)
				)
			)
			(bind ?i (+ ?i 1))
		)


		(return (create$ $?posiblesDespD1 0 $?posiblesDespD2 0 $?posiblesDespD1D2 0 $?llegaCASA 0))
	
	else
		(bind ?posiblesDespD1 (create$))
		(bind ?posiblesDespD2 (create$))
		(bind ?posiblesDespD1D2 (create$))
		(bind ?llegaCASA (create$))
		(bind ?i 24)
		(while(< 1 ?i)
			; hay alguna ficha negra en la posicion i
			(if (< (nth$ ?i $?tablero) 0) then 
				; puedo mover la ficha i dado1 posiciones
				(bind ?posicionD1 (- ?i ?dado1))
				(if(> ?posicionD1 1) then
					(if(< (nth$ ?posicionD1 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind ?posiblesDespD1 ?posiblesDespD1 ?tupla)
					)	
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (- ?i ?dado2))
				
				(if(> ?posicionD2 1) then
					(if(< (nth$ ?posicionD2 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind ?posiblesDespD2 ?posiblesDespD2 ?tupla)
					)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (- ?i ?sumadados))
				(if(> ?posicionD1D2 1) then
					(if(< (nth$ ?posicionD1D2 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind ?posiblesDespD1D2 ?posiblesDespD1D2 ?tupla)
					)
				)
			)
			(bind ?i (- ?i 1))
		)		
		(return (create$ ?posiblesDespD1 0 ?posiblesDespD2 0 ?posiblesDespD1D2 0 ?llegaCASA 0))
	)
	
	
)

(deffunction actualizarTablero (?desd ?hast ?color $?tabler)
	(if (= ?color 1)then
		(bind ?contenido (nth$ ?desd $?tabler))
		(bind $?tabler (replace$ $?tabler ?desd ?desd (- ?contenido 1)))

		(bind ?contenido (nth$ ?hast $?tabler))
		(bind $?tabler (replace$ $?tabler ?hast ?hast (+ ?contenido 1)))

		(return $?tabler)
	
	else
		(bind ?contenido (nth$ ?desd $?tabler))
		(bind $?tabler (replace$ $?tabler ?desd ?desd (+ ?contenido 1)))


		(bind ?contenido (nth$ ?hast $?tabler))
		(bind $?tabler (replace$ $?tabler ?hast ?hast (- ?contenido 1)))

		(return $?tabler)
	)
	
)

(deffacts inicial
    (estado "INICIO")            
	(comidasJ1 0)				; fichas que tiene comidas el jugador 1 y tiene que sacar
	(comidasJ2 0)				; fichas que tiene comidas el jugador 2 y tiene que sacar   
	(desplazar 0)   
	(movimientosdado1 (create$))	; lista de movimientos posibles con el dado 1
	(movimientosdado2 (create$))	; lista de movimientos posibles con el dado 2
	(movimientosdado1dado2 (create$))	; lista de movimientos posibles con el dado 1 y 2
	(D1 0)
	(D2 0)
	(SD 0)
	(contadordado1 0)
	(contadordado2 0)
	(contadorsumadados 0)
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
	?cd1<- (contadordado1 ?contd1)
	?cd2<- (contadordado2 ?contd2)
	?cd1d2<- (contadorsumadados ?contd1d2)
	?m1<- (movimientosdado1 $?movimientosdado1)
	?m2<- (movimientosdado2 $?movimientosdado2)
	?m1m2<- (movimientosdado1dado2 $?movimientosdado1dado2)
	?j<- (jugador (tipo ?tipo)(color ?color)(nombre ?nombre)(fichasJugando ?fichasJugando)(fichasCasa 0)(fichasUltimo ?fichasUltimo))
	?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))
	=>

	(bind ?movimiento (read))

	(bind ?contd1 (div ?contd1 2))
	(bind ?contd2 (div ?contd2 2))
	(bind ?contd1d2 (div ?contd1d2 2))

	(if(<= ?movimiento  ?contd1) then 
		(retract ?m1m2)
		(printout t "elige el dado 1" crlf) 
		(bind ?desde (nth$ ?movimiento $?movimientosdado1))
		(bind ?hasta (nth$ (+ ?movimiento 1) $?movimientosdado1))

		(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color $?tablero))

		(retract ?bg)
		?bg<- (assert (BackGammon (ID ?id)(padre ?padre)(tablero ?tableroNuevo)(profundidad ?profundidad)))


		(imprimir-mapeo $?tableroNuevo)

		(retract ?m1)

		(printout t "Ahora elige un movimiento con el dado2" crlf)

		(bind ?movimiento (read))

		(while (or (> ?movimiento (+ ?contd1 ?contd2)) (< ?movimiento ?contd1))
			(printout t "elige un movimiento valido del dado2!" crlf)
			(bind ?movimiento (read))
		)

		(bind ?desde (nth$ (- ?movimiento ?contd1) $?movimientosdado2))
		(bind ?hasta (nth$ (+ (- ?movimiento ?contd1) 1) $?movimientosdado2))
		(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color $?tablero))

		(retract ?bg ?m2)
		(assert (BackGammon (ID ?id)(padre ?padre)(tablero ?tableroNuevo)(profundidad ?profundidad)))

		(imprimir-mapeo $?tableroNuevo)

	else
		(if(> ?movimiento (+ ?contd1 ?contd2)) then
			(printout t "elige el dado1+2" crlf)
			; ya no puede elegir ningun dado mas
			(retract ?m1 ?m2)

			(bind ?desde (nth$ (- ?movimiento ?contd2) $?movimientosdado1))
			(bind ?hasta (nth$ (+ (- ?movimiento ?contd2) 1) $?movimientosdado1))

			(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color $?tablero))

			(retract ?bg)
			?bg<- (assert (BackGammon (ID ?id)(padre ?padre)(tablero ?tableroNuevo)(profundidad ?profundidad)))

			(imprimir-mapeo $?tableroNuevo)
			(retract ?m1m2)
		else
			(retract ?m1m2)
			(printout t "elige el dado 2" crlf)
			
			(bind ?desde (nth$ (- ?movimiento ?contd1) $?movimientosdado2))
			(bind ?hasta (nth$ (+ (- ?movimiento ?contd1) 1) $?movimientosdado2))

			(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color $?tablero))

			(retract ?bg)
			?bg<- (assert (BackGammon (ID ?id)(padre ?padre)(tablero ?tableroNuevo)(profundidad ?profundidad)))


			(imprimir-mapeo $?tableroNuevo)

			(retract ?m2)

			(printout t "Ahora elige un movimiento con el dado1" crlf)

			(bind ?movimiento (read))

			(while (> ?movimiento ?contd1)
				(printout t "elige un movimiento valido del dado1!" crlf)
				(bind ?movimiento (read))
			)

			(bind ?desde (nth$ ?movimiento $?movimientosdado1))
			(bind ?hasta (nth$ (+ ?movimiento 1) $?movimientosdado1))
			(bind $?tableroNuevo (actualizarTablero ?desde ?hasta ?color $?tablero))

			(retract ?bg ?m1)
			(assert (BackGammon (ID ?id)(padre ?padre)(tablero ?tableroNuevo)(profundidad ?profundidad)))

			(imprimir-mapeo $?tableroNuevo)
		)
	)
)

(defrule desplazarREGLA
	?d<-(desplazar 1)
	?m1<- (movimientosdado1 $?movimientosdado1)
	?m2<- (movimientosdado2 $?movimientosdado2)
	?m1m2<- (movimientosdado1dado2 $?movimientosdado1dado2)
	?d1 <- (D1 ?dado1)
	?d2 <- (D2 ?dado2)
	?sumad1d2 <- (SD ?sumadados)
	?j<- (jugador (tipo ?tipo)(color ?color)(nombre ?nombre)(fichasJugando ?fichasJugando)(fichasCasa 0)(fichasUltimo ?fichasUltimo))
	?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))
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
					(if(> (nth$ ?posicionD1 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
					)
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (+ ?i ?dado2))
				(if(< ?posicionD2 24) then
					(if(> (nth$ ?posicionD2 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
					)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (+ ?i ?sumadados))
				(if(< ?posicionD1D2 24) then
					(if(> (nth$ ?posicionD1D2 $?tablero) -1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
					)
				)
			)
			(bind ?i (+ ?i 1))
		)
		(assert (movimientosdado1 $?movimientosdado1))
		(assert (movimientosdado2 $?movimientosdado2))
		(assert (movimientosdado1dado2 $?movimientosdado1dado2)) 
	else
		(bind ?i 24)
		(while(< 1 ?i)
			; hay alguna ficha negra en la posicion i
			(if (< (nth$ ?i $?tablero) 0) then 
				(bind ?posicionD1 (- ?i ?dado1))
				(if(> ?posicionD1 1) then
					(if(< (nth$ ?posicionD1 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1 " utilizando el dado1"crlf)
						(bind ?tupla (create$ ?i ?posicionD1))
						(bind $?movimientosdado1 $?movimientosdado1 ?tupla)
					)	
				)

				; puedo mover la ficha i dado2 posiciones
				(bind ?posicionD2 (- ?i ?dado2))
				(if(> ?posicionD2 1) then
					(if(< (nth$ ?posicionD2 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD2 " utilizando el dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD2))
						(bind $?movimientosdado2 $?movimientosdado2 ?tupla)
					)
				)

				; puedo mover la ficha i dado1+dado2 posiciones
				(bind ?posicionD1D2 (- ?i ?sumadados))
				(if(> ?posicionD1D2 1) then
					(if(< (nth$ ?posicionD1D2 $?tablero) 1) then
						;(printout t "La ficha de la posicion " ?i " puede moverse a la posicion " ?posicionD1D2 " utilizando el dado1+dado2"crlf)
						(bind ?tupla (create$ ?i ?posicionD1D2))
						(bind $?movimientosdado1dado2 $?movimientosdado1dado2 ?tupla)
					)
				)
			)
			(bind ?i (- ?i 1))
		)
		;(printout t "llego aqui" crlf)
		(assert (movimientosdado1 $?movimientosdado1))
		(assert (movimientosdado2 $?movimientosdado2))
		(assert (movimientosdado1dado2 $?movimientosdado1dado2)) 
	)
	(assert (desplazar 0))
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
    ?j2<- (jugador (tipo ?tipoj2)(color ?colorj2)(nombre 2)(fichasJugando ?fichasJugandoj2)(fichasCasa ?fichasCasaj2)(fichasUltimo ?fichasUltimoj2))
	?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))
	?desplazar<-(desplazar 0)
	=>

	(retract ?j2)

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



	; (bind ?casabool 0)
	; (bind ?casalista (create$))
	; (bind ?i (+ ?i 1))
	; (bind ?cont4 0)
	; (while (= ?casabool 0)
	; 	(bind ?elemento (nth$ ?i ?listas))
	; 	;(printout t "Elemento: " ?elemento crlf)
	; 	(if (= 0 ?elemento) then
	; 		(bind ?casabool 1)
	; 	else
	; 		(bind ?casalista ?casalista (nth$ ?i ?listas))
	; 		(bind ?i (+ ?i 1))
	; 		(bind ?cont4 (+ ?cont4 1))
	; 	)
	; )
	; (printout t "Mover a casa" crlf)
	; (printout t ?casalista crlf)
	; (bind ?j 1)
	; (while (<= ?j ?cont4)
	; 	(bind ?elemento (nth$ ?j ?casalista))
	; 	(printout t " Opcion " ?a " ["  ?elemento " -> CASA]" crlf)
	; 	(bind ?j (+ ?j 1))
	; 	(bind ?a (+ ?a 1))
	; )


	(assert (movimiento 1))
	(retract ?t)  
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

	
	(bind ?listas (posiblesDesplazamientos ?colorj2 ?fichasJugandoj2 ?dado1 ?dado2 ?sumadados $?tablero))
	
	(bind ?listaD1 (nth$ 1 ?listas))
	(bind ?listaD2 (nth$ 2 ?listas))
	(bind ?listaD3 (nth$ 3 ?listas))


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
