;******************************************************************************************
;************************************ DEFINICIONES ***************************************
;******************************************************************************************

(deftemplate jugador
    (slot tipo (type SYMBOL))                   ; CPU o Humano
    (slot color (type SYMBOL))                  ; BLANCAS o NEGRAS
)

(deftemplate BackGammon
    (slot ID (type INTEGER))                    ; ID del nodo
    (slot padre (type INTEGER))                 ; ID del nodo padre
    (slot turno (type INTEGER))                 ; turno del jugador
    (multislot tablero (type INTEGER))          ; representa el tablero, donde se encuentran las fichas
    (slot profundidad (type INTEGER))           ; profundidad del nodo
)


(defglobal 
    ?*turno* = 1            ;num de turnos que lleva el jugador
    ?*tamano* = 24          ;tamnio del tablero
    ?*dado1* = 0
    ?*dado2* = 0            ;dado1 y dado2 son los dados que se tiran
    ?*ID* = 1               ;ID de cada nodo
    ?*padre* = 0            ;ID del padre de cada nodo
    ?*jugador* = 0          ;0->CPU 1->Humano
    ?*inicio* = 0           ;0->no se ha iniciado el juego 1->se ha iniciado el juego
    ?*agente* = "MINIMAX"   ;MINIMAX o ALFA-BETA

    ;informacion de la jugada optima
    ;?*tableroOPT* = ($create)
    ?*IDOPT* = 0
    ?*padreOPT* = 0
    ?*profundidadOPT* = 0
)

(deffacts inicio
    (estado "INICIO")
)

;******************************************************************************************
;************************************ FUNCIONES *******************************************
;******************************************************************************************

; hay que hacer una funcion por cada movimiento que se quiera hacer 
;(deffunction iniciarTablero
    ; crear una lista de 24 elementos, donde cada elemento representa un cuadrante del tablero
    ; cada elemento de la lista habra fichas blancas o negras. Las negras se representan con numeros negativos
    ; y las blancas con numeros positivos
;    (bind $?tablero (create$ 2 0 0 0 0 -5 0 -3 0 0 0 5 -5 0 0 0 3 0 5 0 0 0 0 -2))
;    (assert (tablero ?tablero)) 
;)

(deffunction tirarDados ()
    (printout t "Tirando dados..." crlf)
    (bind ?dado1 (random 1 6))
    (bind ?dado2 (random 1 6))
    
    (printout t "Dado 1: " ?dado1 crlf)
    (printout t "Dado 2: " ?dado2 crlf)
    (return (create$ ?dado1 ?dado2))
)

(deffunction dibujarTablero ()
    ; dibujar el tablero
    ; bucle de 1 a 12 del tablero
     
    ;(printout t  nth                                                         crlf)
    (printout t "  13  14  15  16  17  18   |   19  20  21  22  23  24    "crlf)
    (printout t "  -------------------------------------------------------" crlf)
    (printout t "     |   |   |   |   |     |      |   |   |   |   |    " crlf)
    (printout t "     |   |   |   |   |     |      |   |   |   |   |    " crlf)

    (printout t "     |   |   |   |   |     |      |   |   |   |   |    " crlf)
    (printout t "     |   |   |   |   |     |      |   |   |   |   |    " crlf)
    (printout t "  -----------------------------------------------------" crlf)
    (printout t "  12  11   10  9   8   7   |   6    5   4   3   2    1" crlf)

)

;******************************************************************************************
;************************************ REGLAS  *********************************************
;******************************************************************************************


; ************************ REGLAS PARA INICIAR EL JUEGO ***********************************

(defrule INICIO
    ?b<- (estado "INICIO")
    =>
    (retract ?b)
    (printout t "Bienvenid@ a BackGammon" crlf)

    ; llamamos a la funcion iniciar tablero
    (printout t "Tablero inicial:" crlf)
    (dibujarTablero)    ; funcion para dibujarlo

    ; ponemos las fichas en el tablero
    (bind $?tablero (create$ 2 0 0 0 0 -5 0 -3 0 0 0 5 -5 0 0 0 3 0 5 0 0 0 0 -2))

    ; iniciar CPU o Humano
    (printout t "Jugador 1: (CPU o HUMANO)" crlf)
    (bind ?modo (readline))

    ; iniciar blancas o negras
    (printout t "Ingrese el color de sus fichas: (BLANCAS o NEGRAS)" crlf)
    (bind ?color (readline))

    (if (eq ?modo "HUMANO")
        then
            (if (eq ?color "BLANCAS")
                then
                    (assert (jugador (tipo HUMANO)(color BLANCAS)))
                else
                    (assert (jugador (tipo HUMANO)(color NEGRAS)))
            )  
        else
            (if (eq ?color "BLANCAS")
                then
                    (assert (jugador (tipo CPU)(color BLANCAS)))
                else
                    (assert (jugador (tipo CPU)(color NEGRAS)))
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
            (assert (BackGammon (ID ?*ID*)(padre ?*padre*)(turno 1)(tablero $?tablero)(profundidad 0)))
        else
            (printout t "Jugador 2 empieza" crlf)
            (assert (BackGammon (ID ?*ID*)(padre ?*padre*)(turno 2)(tablero $?tablero)(profundidad 0)))
    )
     

    ; inicio del juego
    (assert (estado "JUGANDO"))
)


; ************************ REGLAS PARA JUGAR ***********************************

(defrule JUGANDO
    ?b<- (estado "JUGANDO")
    =>

    (retract ?b)

    ; comprobar si se quiere salir o no del juego
    (bind ?salir 0)
    
    (while (and (not (=(str-compare ?salir "c") 0)) (not (=(str-compare ?salir "s") 0)))
        (printout t "Para continuar: pulse 'c' " crlf)
        (printout t "Para salir: pulse 's' " crlf)
        (bind ?salir (read))
    )
    
    (if (=(str-compare ?salir "s") 0)
        then
            (assert (estado "FIN"))
        else
            (printout t "Turno del jugador " ?turno "de partida. "crlf)
                ; eleccion de la ficha a mover
                (if (= (mod ?turno 2) 0)
                    then
                        (printout t "Jugador 1" crlf)
                        (if (eq ?color "BLANCAS")
                            then
                                (printout t "Ingrese la ficha a mover: " crlf)
                                (bind ?ficha (read))
                                ; comprobar que haya fichas de ese colo en el tablero
                            else
                                (printout t "Ingrese la ficha a mover: " crlf)
                                (bind ?ficha (read))
                        )
                    else
                        (printout t "Jugador 2" crlf)
                        (if (eq ?color "BLANCAS")
                            then
                                (printout t "Ingrese la ficha a mover: " crlf)
                                (bind ?ficha (read))
                            else
                                (printout t "Ingrese la ficha a mover: " crlf)
                                (bind ?ficha (read))
                        )
                
                )

            ; eleccion de la posicion a mover
            (printout t "Ingrese la posicion a mover: " crlf)
            (bind ?posicion (read))


            ; no puede salir del tablero ni ir para atras
            (while (or (> ?posicion ?*tamano*)(< ?posicion (- ?posicion 1)))
                (printout t "Posicion invalida. Ingrese la posicion a mover: " crlf)
                (bind ?posicion (read))
            )
    )
)

