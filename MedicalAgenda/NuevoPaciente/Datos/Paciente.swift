//
//  DataManager.swift
//  MedicalAgenda
//
//  Created by Juan Carlos Lopez Armendariz on 15/03/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import RealmSwift

class Paciente: Object{
    
   ///DATOS GENERALES
    @objc dynamic var numeroHistoria = ""
    @objc dynamic var nombre = ""
    @objc dynamic var patologia = ""

}

class IntervencionQuirurgica: Object{
    @objc dynamic var id = ""
    @objc dynamic var idIQ = 0
    
    @objc dynamic var intervencionQuirurgica = false
    @objc dynamic var tipoIntervencion = ""
    
    @objc dynamic var vistoIQ = false
    @objc dynamic var fechaIntervencion = "1990-09-09".toDateFormat
    @objc dynamic var recordarIntervencion = false
    @objc dynamic var notasIntervencionQuirurgica = ""
    @objc dynamic var intervenido = true
    
    @objc dynamic var fechaListaEspera = "1990-09-09".toDateFormat
    @objc dynamic var vistoListaEspera = false
    
    @objc dynamic var preanestesiaRealizada = false
    @objc dynamic var fechaPreanestesia = "1990-09-09".toDateFormat
    @objc dynamic var notasPreanestesia = ""
    @objc dynamic var vistoPreanestesia = false
    
    @objc dynamic var anatomiaPatologica = ""
    @objc dynamic var complicaciones = ""
    @objc dynamic var notasDetalles = ""
}

class Prueba: Object{
    @objc dynamic var id = ""
    @objc dynamic var idPrueba = 0
    
    @objc dynamic var tipoPrueba = ""
    @objc dynamic var fechaPrueba = "1990-09-09".toDateFormat
    @objc dynamic var recordarPrueba = false
    @objc dynamic var pruebaVisto = false
    
}

class Revisar: Object{
    @objc dynamic var id = ""
    @objc dynamic var idRevisar = 0
    
    @objc dynamic var revisar = false
    @objc dynamic var notasRevisar = ""
    @objc dynamic var recordarRevisar = false
    @objc dynamic var fechaRevisar = "1990-09-09".toDateFormat
    @objc dynamic var revisarVisto = false
    
}

class SiguienteCita: Object{
    @objc dynamic var id = ""
    @objc dynamic var idCita = 0
    
    @objc dynamic var siguienteCita = false
    @objc dynamic var fechaSiguienteCita = "1990-09-09".toDateFormat
    @objc dynamic var recordarSiguienteCita = false
    @objc dynamic var notasSiguienteCita = ""
    @objc dynamic var siguienteCitaVisto = false
    
}

struct PacienteModel{
    var nHistoria: String = ""
    var nombre: String = ""
    var patologias: String = ""
    var iq: [IqModel] = [IqModel]()
    var prueba: [PruebaModel] = [PruebaModel]()
    var revisar: [RevisarModel] = [RevisarModel]()
    var siguienteCita: [SiguienteCitaModel] = [SiguienteCitaModel]()
}

struct IqModel{
    var idIQ = 0
    var tipoIntervencion = ""
    var vistoIq = false
    var fechaIntervencion = "1990-09-09".toDateFormat
    var recordarIntervencion = false
    var notasIntervencion = ""
    var intervenido = true
    var fechaListaEspera = "1990-09-09".toDateFormat
    var vistoListaEspera = false
    var preanestesiaRealizada = false
    var fechaPreanestesia = "1990-09-09".toDateFormat
    var notasPreanestesia = ""
    var vistoPreanestesia = false
    var anatomiaPatologica = ""
    var complicaciones = ""
    var notasDetalles = ""
}

struct PruebaModel{
    var idPrueba = 0
    var tipoPrueba = ""
    var fechaPrueba = "1990-09-09".toDateFormat
    var recordarPrueba = false
    var vistoPrueba = false
}

struct RevisarModel{
    var idRevisar = 0
    var notasRevisar = ""
    var recordarRevisar = false
    var fechaRevisar = "1990-09-09".toDateFormat
    var vistoRevisar = false
}

struct SiguienteCitaModel{
    var idCita = 0
    var fechaSiguienteCita = "1990-09-09".toDateFormat
    var recordarSiguienteCita = false
    var notasSiguienteCita = ""
    var vistoSiguienteCita = false
}
