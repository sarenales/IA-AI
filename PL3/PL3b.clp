;ejercicio 1
(defrule regla-sumar1
	(declare (salience 10))
	?a <- (elemento ?x)
=>
	(assert (elemento (+ 1 ?x))))

(defrule regla-parar
	(declare (salience 20))
	(elemento ?x)
	(test (> ?x 9))
=>
	(halt))

(deffacts hechos-iniciales
	(elemento 1))



;ejercicio2
(defrule regla-sumar-elementos
	(declare (salience 10))
	(elemento ?x)
	(elemento ?y)
=>
	(assert (elemento (+ ?x ?y)))
	(printout t (+ ?x ?y) crlf))
	
(defrule regla-parar
	(declare (salience 20))
	(elemento ?x)
	(test (> ?x 9))
=>
	(halt))

(deffacts hechos-iniciales
	(elemento 1))


;ejercicio4
(defrule R1 
	(declare (salience 15)) 
	?a <- (numero ?x ?u) 
	?b <- (numero ?y ?v) 
	(test (> ?u ?v)) 
=> 
	(assert (numero (+ ?x ?y) (+ ?u 1))) 
	(retract ?b)) 

 
(defrule R2 
	(declare (salience 5)) 
	?b <-(total ?x) 
	(test (> ?x 0)) 
=> 
	(assert (numero 0 1))) 

 
(defrule R3 
	(declare (salience 5)) 
	?b <-(total ?x) 
	(test (> ?x 1)) 
=> 
	(assert (numero 1 2))) 

 
(defrule R4 
	(declare (salience 20)) 
	(total ?a) 
	(numero ?x ?a) 
=> 
	(printout t "OK:" ?x crlf) 
	(halt)) 

(defrule R5 
	(declare (salience 1)) 
=> 	
	(printout t "ERROR" crlf)) 

; ejercicio5
(deffacts personas 
	(persona (nombre Juan) (ciudad Paris)) 
	(persona (nombre Ana) (ciudad Edimburgo))
) 

 

(deffacts actividades 

(actividad (nombre Torre_Eiffel) (ciudad Paris) (duracion 2)) 

(actividad (nombre Castillo_de_Edimburgo) (ciudad Edimburgo) (duracion 5)) 

(actividad (nombre Louvre) (ciudad Paris) (duracion 6)) 

(actividad (nombre Montmartre) (ciudad Paris) (duracion 1)) 

(actividad (nombre Royal_Mile) (ciudad Edimburgo) (duracion 3))) 

 

(defrule R1  

    (declare (salience 15))   

    ?q<-(actividad (ciudad ?c) (duracion ?t))  

    ?o <-(numero ?actividad ?tiempo ?n ?c) 

=>  

    (retract ?o ?q) 

    (assert (numero (+ ?actividad 1) (+ ?tiempo ?t) ?n ?c)) 

) 

 

;Regla inicial guardar horas totales y numero actividades 

(defrule R2 

    (declare (salience 5)) 

    ?q<-(persona (nombre ?n) (ciudad ?c)) 

=>  

    (retract ?q) 

    (assert (numero 0 0 ?n ?c))) 

 
 

;Regla final divide horas/numero actividades y devuelve el resultado 

(defrule R3 

    (declare (salience 1)) 

    (not(actividad))  

    ?o <-(numero ?actividad ?tiempo ?n ?c) 

=>  

    (retract ?o) 

    (printout t "La duración media de las actividades de " ?n " fue " (/ ?tiempo ?actividad) crlf) 

) 
