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
