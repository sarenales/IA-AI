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
