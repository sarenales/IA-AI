; Duración media de todas las actividades superiores a 1 hora que una persona realiza durante la visita a una ciudad.

(deffacts persona
    (multislot nombrePersona)
    (multislot ciudadPersona)
)
(deffacts actividad
    (multislot monumento)
    (multislot ciudad)
    (multislot duracion (type INTEGER)(range ?var 0))
)


(deffacts personas 
    (persona (nombre Juan) (ciudad Paris)) 
    (persona (nombre Ana) (ciudad Edimburgo))
) 

(deffacts actividades 
    (actividad (nombre Torre_Eiffel) (ciudad Paris) (duracion 2)) 
    (actividad (nombre Castillo_de_Edimburgo) (ciudad Edimburgo) (duracion 5)) 
    (actividad (nombre Louvre) (ciudad Paris) (duracion 6)) 
    (actividad (nombre Montmartre) (ciudad Paris) (duracion 1))     
    (actividad (nombre Royal_Mile) (ciudad Edimburgo) (duracion 3))
) 

 
; unificamos y filtramos que la actividades que se elijan sean mayor a 1 
(defrule R1  
    (declare (salience 1))   
    (persona (nombre ?nombre) (ciudad ?ciudad))
    (actividad (monumento ?monumento)(ciudad ?ciudad) (duracion ?duracion&:(> ?duracion 1)))
=>
    (assert (registro (monumento ?monumento) (nombre ?nombre) (ciudad ?ciudad) (duracion ?duracion)))

)  

;comprueba la duracion
(defrule R2 
    (declare (salience 2))
    (not (registro))
=>
    (printout t "No hay actividades con duración superior a 1 hora." crlf)
    (halt)
)


; buscar los hechos creados en R1 y los agrupa por persona y ciudad
(defrule R3
    (declare (salience 3))
    (registro (nombre ?nombre) (ciudad ?ciudad) (duracion ?duracion))
    =>
    (assert (contador (monumento ?monumento)(nombre ?nombre) (ciudad ?ciudad) (total ?duracion) (cantidad 1)))
    (retract ?registro)
)


; busca los hechos resgitro y contador par cada persona y ciudad 
(defrule R4
    (declare (salience 5))
    (not (registro))
    (contador (monumento ?monumento)(nombre ?nombre) (ciudad ?ciudad) (total ?total) (cantidad ?cantidad))
    =>
    (bind ?media (/ ?total ?cantidad))
    (printout t "La duración media de las actividades superiores a 1 hora de la persona " ?nombre " en la ciudad " ?ciudad " es de " ?media " horas." crlf))


; comprueba q haya una duracion mayor a 1h y que ninguna persona 
(defrule R5
    (declare (salience 6))
    (not (registro))
    (not (contador))
    =>
    (printout t "No se ha encontrado ninguna actividad con duración superior a 1 hora." crlf))


; actualiza el contador 
(defrule R6
    (declare (salience 7))
    ?c <- (contador (monumento ?monumento)(nombre ?nombre) (ciudad ?ciudad) (total ?total) (cantidad ?cantidad))
    (registro (nombre ?nombre) (ciudad ?ciudad))
    =>
    (modify ?c (total (+ ?total ?registro:duracion)) (cantidad (+ ?cantidad 1)))
    (retract ?registro))