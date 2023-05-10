
(deftemplate jugador
    (slot tipo (type SYMBOL) (allowed-symbols humano cpu)) 
    (slot color (type SYMBOL) (allowed-symbols negro blanco))
	(slot comidas (type INTEGER))
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


(deffacts inicial
    (estado "INICIO")                           
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
    (printout t "Jugador 1: (cpu o humano)" crlf)
    (bind ?modo (readline))

    ; iniciar blancas o negras
    (printout t "Ingrese el color de sus fichas: (blanco o negro)" crlf)
    (bind ?colorj1 (readline))
    (if (eq ?modo "humano")
        then
            (if (eq ?colorj1 "blanco")
                then
                    (assert (jugador (tipo humano)(color blanco)))
                else
                    (assert (jugador (tipo humano)(color negro)))
            )  
    else
            (if (eq ?colorj1 "blanco")
                then
                    (assert (jugador (tipo cpu)(color blanco)))
                else
                    (assert (jugador (tipo cpu)(color negro)))
            )
    )

	; JUGADOR 2
	; iniciar CPU o Humano
    (printout t "Jugador 2: (cpu o humano)" crlf)
    (bind ?modo (readline))
	; contrario que j1
    (if (eq ?modo "humano")
        then
            (if (eq ?colorj1 "blanco")
                then
                    (assert (jugador (tipo humano)(color negro)))
                else
                    (assert (jugador (tipo humano)(color blanco)))
            )  
    else
            (if (eq ?colorj1 "blanco")
                then
                    (assert (jugador (tipo cpu)(color negro)))
                else
                    (assert (jugador (tipo cpu)(color blanco)))
            )
    )
    
    ; tira dados Jugador 1
    (printout t "Jugador 1 tira dados..." crlf)
    (bind ?dados (tirarDados))
    (bind ?dado1J1 (nth$ 1 ?dados))
    (bind ?dado2J1 (nth$ 2 ?dados))
    (bind ?sumadadosJ1 (+ ?dado1J1 ?dado2J1))

    ; tira dados Jugador 2
    (printout t "Jugador 2 tira dados..." crlf)
    (bind ?dados (tirarDados))
    (bind ?dado1J2 (nth$ 1 ?dados))
    (bind ?dado2J2 (nth$ 2 ?dados))
    (bind ?sumadadosJ2 (+ ?dado1J2 ?dado2J2))
    
    (if (> ?sumadadosJ1 ?sumadadosJ2) 
        then
            (printout t "Jugador 1 empieza" crlf)
			(assert (turno 1))
        else
            (printout t "Jugador 2 empieza" crlf)
            (assert (turno 2))
    )


)

(defrule jugador1
    ?t<-(turno 1)
	?j1<-(jugador (tipo ?tipoj1)(color ?colorj1)(comidas ?comidasj1)(fichasJugando ?fichasJugandoj1)(fichasCasa ?fichasCasaj1)(fichasUltimo ?fichasUltimoj1))
    ?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))

	=>

	(bind ?dados (tirarDados))
    (bind ?dado1 (nth$ 1 ?dados))
    (bind ?dado2 (nth$ 2 ?dados))
    (bind ?sumadadosJ2 (+ ?dado1 ?dado2))

	(printout t "Puedes realizar 2 cosas:" crlf)
	(printout t "Usar la suma de los dados para una sola ficha, o por cada dado dos fichas." crlf)
	(printout t "Ingrese 1 para usar la suma de los dados para una sola ficha, o 2 para usar cada dado para dos fichas: " crlf)
	(bind ?opcion (read))

	(if (eq ?opcion 1) then
		(printout t "Ingrese la posicion de la ficha que quieres mover: " crlf)
		(bind ?ficha (read))

		;ELEGIR LA FICHA A MOVER
		; comprobar si la ficha elegida es del color del jugador
		(if (eq ?colorj1 "blanco") then
			(while (> (nth$ ?ficha $?tablero) 0); y mirar tambn si hay de su color 
				(printout t "No hay fichas de ese color en esa posicion. Ingrese la ficha a mover: " crlf)
				(bind ?ficha (read))
			)
		else
			; comprobar si la ficha elegida es del color del jugador
			(while (< (nth$ ?ficha $?tablero) 0)
					(printout t "No hay fichas de ese color en esa posicion. Ingrese la ficha a mover: " crlf)
					(bind ?ficha  (read))
			)

		)
	
		;MOVER LA FICHA

		(if (eq ?colorj1 "blanco") then
			(bind ?c 1)
			(while(= ?c 1)
				; si es blanco no puede ir para atras ( de la pos 8 a la 4)
				(if (< ?posicion (- ?posicion 1)) then
					(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
					(bind ?posicion (read))
				if (> 0 (nth$ ?posicion $?tablero)) then
					(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
					(bind ?posicion (read))
				else
					(bind ?c 0) )         
			)
		else
			(bind ?c 1)
			(while(= ?c 1)
				; si es negro no puede ir para atras ( de la pos 17 a la 23)
				(if (> ?posicion (- ?posicion 1))then
					(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
					(bind ?posicion (read))
				if (< 0 (nth$ ?posicion $?tablero)) then
					(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
					(bind ?posicion (read))
				else
					(bind ?c 0) )         
			)
		)
	)

    (retract ?t)
    (assert (turno 2))
	

)

(defrule jugador2
    ?t<-(turno 2)
	?j2<-(jugador (tipo ?tipoj2)(color ?colorj2)(comidas ?comidasj2)(fichasJugando ?fichasJugandoj2)(fichasCasa ?fichasCasaj2)(fichasUltimo ?fichasUltimoj2))
    ?bg<- (BackGammon (ID ?id)(padre ?padre)(tablero $?tablero)(profundidad ?profundidad))

    =>
 
	(bind ?dados (tirarDados))
    (bind ?dado1 (nth$ 1 ?dados))
    (bind ?dado2 (nth$ 2 ?dados))
    (bind ?sumadadosJ2 (+ ?dado1 ?dado2))

	(printout t "Puedes realizar 2 cosas:" crlf)
	(printout t "Usar la suma de los dados para una sola ficha, o por cada dado dos fichas." crlf)
	(printout t "Ingrese 1 para usar la suma de los dados para una sola ficha, o 2 para usar cada dado para dos fichas: " crlf)
	(bind ?opcion (readline))

	(if (eq ?opcion 1) then  
   
		; eleccion de la posicion a mover
		(printout t "Ingrese la posicion de la ficha que quieres mover: " crlf)
		(bind ?posicion (read))

		;ELEGIR FICHA A MOVER
		; comprobar si la ficha elegida es del color del jugador
		(if (eq ?colorj2 "blanco") then
			(while (> (nth$ ?ficha $?tablero) 0); y mirar tambn si hay de su color 
				(printout t "No hay fichas de ese color en esa posicion. Ingrese la ficha a mover: " crlf)
				(bind ?ficha (read))
			)
		else
			; comprobar si la ficha elegida es del color del jugador
			(while (< (nth$ ?ficha $?tablero) 0)
					(printout t "No hay fichas de ese color en esa posicion. Ingrese la ficha a mover: " crlf)
					(bind ?ficha (read))
			)

		)
		;MOVER LA FICHA
		(if (eq ?colorj2 "blanco") then
			(bind ?c 1)
			(while(= ?c 1)
				; si es blanco no puede ir para atras ( de la pos 8 a la 4)
				(if (< ?posicion (- ?posicion 1)) then
					(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
					(bind ?posicion (read))
				if (> 0 (nth$ ?posicion $?tablero)) then
					(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
					(bind ?posicion (read))
				else
					(bind ?c 0) )         
			)
		else
			(bind ?c 1)
			(while(= ?c 1)
				; si es negro no puede ir para atras ( de la pos 17 a la 23)
				(if (> ?posicion (- ?posicion 1))then
					(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
					(bind ?posicion (read))
				if (< 0 (nth$ ?posicion $?tablero)) then
					(printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
					(bind ?posicion (read))
				else
					(bind ?c 0) )         
			)
		)
	)

    (retract ?t)
    (assert (turno 1))
	

)

(defrule comidas
	?j<-(jugador (tipo ?tipoj)(color ?colorj)(comidas ?comidasj)(fichasJugando ?fichasJugandoj)(fichasCasa ?fichasCasaj)(fichasUltimo ?fichasUltimoj))
	(test (> ?comidasj 1))
	=>
	(printout t "Sigues teniendo fichas comidas. Primero debes sacar estas antes de mover cualquier otra.")
	(bind ?dados (tirarDados))
    (bind ?dado1J2 (nth$ 1 ?dados))
    (bind ?dado2J2 (nth$ 2 ?dados))
    (bind ?sumadadosJ2 (+ ?dado1J2 ?dado2J2))

	(printout t "Puedes realizar 2 cosas:" crlf)
	(printout t "Usar la suma de los dados para una sola ficha, o por cada dado dos fichas." crlf)


)
