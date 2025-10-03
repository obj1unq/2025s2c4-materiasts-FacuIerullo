class Estudiante {
  const property materiasAprobadas = #{}
  const property carrerasCursando = #{}
  const property materiasInscripto = #{}

  method aprobarMateria(materia, nota){
    if(!self.estaAprobada(materia)){
        materiasAprobadas.add(new MateriasAprobadas(materia = materia, nota = nota))
    } else{
        self.error("la materia ya fue aprobada anteriormente")
    }
  }

  method inscribirMateria(materia){
    if(self.aptoParaInscribirse(materia) && materia.hayCupo()){
        materiasInscripto.add(materia)
        materia.inscribirEstudiante(self)
    } else if(self.aptoParaInscribirse(materia) && !materia.hayCupo()){
        materia.añadirEstudianteAListaDeEspera(self)
    }
    else{
        self.error("No es posible inscribirse a la materia")
    }
  }


  method promedio(){
    const notas = materiasAprobadas.map({materia => materia.nota()})
    return notas.average()
  }

  method estaAprobada(materia) {
    return materiasAprobadas.any({ma => ma.materia() == materia})
  }

  method coleccionDeMateriasDeCarrerasInscripto(){
    return carrerasCursando.flatMap({carrera => carrera.materias()})
  }

  method estaInscripto(materia) {
    return materiasInscripto.contains(materia)
  }

  method cumpleRequisitos(materia) {
    const materias = materiasAprobadas.map({ma => ma.materia()})
    return materia.requisitos().all({materia => materia == materias})
  }

  method aptoParaInscribirse(materia){
    return (self.coleccionDeMateriasDeCarrerasInscripto().contains(materia) && !self.estaAprobada(materia) && !self.estaInscripto(materia) && self.cumpleRequisitos(materia))
  }
}

class Carreras {
  const property materias = #{}
}

class MateriasAprobadas {
  const property materia 
  const property nota 
}

class Materias {
  const property requisitos = #{}
  const property cupo = 30 //para que no se queje el test mientras tanto
  const property inscriptos = #{}
  const property listaDeEspera = #{}

  method inscribirEstudiante(estudiante){
    inscriptos.add(estudiante)
  }

  method hayCupo() {
    return inscriptos.size() < cupo
  }
}