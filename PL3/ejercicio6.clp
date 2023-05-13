(deftemplate elemento 
    (slot valor (type INTEGER))
) 
(defrule R1 
    (declare (salience 40)) 
    (elemento (valor ?x))   
    (not (inicial ?))   
    (test (>= ?x 0)) 
=> 
    (assert (inicial ?x)))  
(defrule R2     
    (declare (salience 20)) 
    (elemento (valor ?x)) 
    (not (elemento (valor 2))) 
    (not (borrando)) 
    (test (> ?x 2)) 
=> 
    (assert (elemento (valor (- ?x 1))))) 
(defrule R3 
    (declare (salience 15)) 
    ?a <- (elemento (valor ?x)) 
    ?b <- (elemento (valor ?y)) 
    (test (> ?x ?y)) 
=> 
    (assert (borrando)) 
    (assert (elemento (valor (* ?x ?y)))) 
    (retract ?a) 
    (retract ?b)
) 
(defrule R4 
    (declare (salience 30)) 
    ?a <- (elemento (valor 0)) 
=> 
    (retract ?a) 
    (assert (elemento (valor 1)))
)  
(defrule R5 
    (declare (salience 10)) 
    (inicial ?x) 
    (elemento (valor ?y)) 
    (test (>= ?y 0)) 
=> 
    (printout t "OK:" "(" ?x "," ?y ")" crlf) 
    (halt)
)  
(defrule R6     
    (declare (salience 1)) 
=> 
    (printout t "ERROR" crlf)
) 

 