
; ejercicio 1
(deffunction dentroDelRango (?a ?b)
    (bind ?c 1)
    (while(= ?c 1)
        (bind ?entrada (read))
        (if(< ?a ?entrada) then
            (if(> ?b ?entrada)then
                (bind ?c 0)
                (return ?entrada)
            else
                (printout t "Introduzca otro numero" crlf)
            )
        else
            (printout t "Introduzca otro numero" crlf)
        )
    )
)


; ejercicio 2
(deffunction mcd(?a ?b)
    (if(= ?a ?b) then
        (return ?a))
    (if(> ?a ?b) then
        (return (mcd(- ?a ?b) ?b)))
    (if(< ?a ?b) then
        (return (mcd ?a (- ?b ?a))))
)

; ejercicio 3
(deffunction mcm(?a ?b)
    (return (/ (* ?a ?b) (mcd ?a ?b)))
)

; ejercicio 4
(deffunction minimo($?num)
    (bind ?mini (nth$ 1 $?num))
    (bind ?minipos 1)
    (loop-for-count (?i 2 (length$ $?num))
        (if (> ?mini (nth$ ?i $?num)) then
            (bind ?mini (nth$ ?i $?num))
            (bind ?minipos ?i)
        )
    )
    (return ?minipos)
)

(deffunction ascendente($?num)
    (bind ?rango (length$ $?num))
    (bind $?listaordenada (create$))
    (loop-for-count(?i 1 ?rango)
        (bind ?minpos (minimo $?num))
        (bind $?listaordenada (create$ $?listaordenada (nth$ ?minpos $?num)))
        (bind $?num (delete$ $?num ?minpos ?minpos))
    )
    (return $?listaordenada)
)

; ejercicio 5
(deffunction ascendentePar($?num)
    (bind ?rango (length$ $?num))
    (bind $?listaordenada (create$))
    (loop-for-count(?i 1 ?rango)
        (bind ?minpos (minimo $?num))
        (if (= 0 (mod (nth$ ?minpos $?num) 2)) then
            (bind $?listaordenada (create$ $?listaordenada (nth$ ?minpos $?num)))
        )
        (bind $?num (delete$ $?num ?minpos ?minpos))
    )
    (return $?listaordenada)
)


; ejercicio 6
(deffunction diferencia(?a $?b)
	(bind $?resul 0)
	(progn$ (?elemento $?a)
		(bind $?aux (create$ ?elemento))

		(if (not(subsetp $?aux $?b)) then
			(bind $?resul (create$ $?resul $?aux))
		)
	)
	(return (rest$ $?resul))
)

; ejercicio 7
(deffunction concatenacion(?a $?b)
	(return (create$ $?a $?b))
)

; ejercicio 8
(deffunction cartesiano(?a $?b)
	(bind $?aux 0)
	(progn$ (?i $?a)
		(progn$ (?j $?b)
			(bind $?aux (create$ $?aux ?i ?j))
		)
	)
	(return (rest$ $?aux))
)

; ejercicio 9
(deffunction esPrimo(?a)
	(loop-for-count (?i 2 (- ?a 1)) do
		(if (=(mod ?a ?i) 0) then
			(return FALSE)
		)
	)
	(return TRUE)
)

(deffunction esCapicua(?a)
    (bind ?num ?a)
    (bind ?resto 0)
    (bind ?invertido 0)
    (while (> ?a 0)
        (bind ?resto (mod ?a 10))
        (bind ?invertido (+ (* ?invertido 10) ?resto))
        (bind ?a (div ?a 10))
    )
    (if (= ?num ?invertido) then
        (return 0)
    )
    (return 1)
)

(deffunction num_primos_y_capicua()
	(bind ?posibleNum 1)
	(bind $?listaNum (create$ 0))
    (bind ?entrada (read))
	(while (> ?entrada 0)
		(if (and (esPrimo ?posibleNum)  (esCapicua ?posibleNum) ) then
			(bind $?listaNum (create$ $?listaNum ?posibleNum))
			(bind ?entrada (- ?entrada 1))
		)
		(bind ?posibleNum (+ ?posibleNum 1))
	)
	(return (rest$ $?listaNum))
)

; ejercicio 10
(deffunction esMedio(?a)
    (bind ?sumainf 0)
    (loop-for-count(?i 1 (- ?a 1))
        (bind ?sumainf (+ ?sumainf ?i)) 
    )
    (bind ?sumasup 0)
    (bind ?sig (+ ?a 1))
    (while(> ?sumainf ?sumasup)
        (bind ?sumasup (+ ?sumasup ?sig))
        (if (= ?sumainf ?sumasup) then
            (return TRUE)
        )
        (bind ?sig (+ ?sig 1))
    )
    (return FALSE)
)
