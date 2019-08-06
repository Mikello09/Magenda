//
//  PendientesPresenter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 07/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


struct Pendiente {
    var numeroHistoria: String
    var fecha: Date
    var codigo: CodigoTarea
    var titulo: String
    var idTarea: Int
}

class PendientesPresenter{
    
    var arrayPendientes: [Pendiente] = [Pendiente]()
    let realm = try! Realm()
    
    func getPendientesItems() -> [Pendiente]{
        arrayPendientes.removeAll()
        for iq in realm.objects(IntervencionQuirurgica.self){
            if(iq.recordarIntervencion && iq.fechaIntervencion != getDefaultDate() && !iq.vistoIQ){
                arrayPendientes.append(Pendiente(numeroHistoria: iq.id, fecha: iq.fechaIntervencion, codigo: CodigoTarea.IQ, titulo: iq.tipoIntervencion, idTarea: iq.idIQ))
            }
            if(iq.recordarIntervencion && iq.fechaPreanestesia != getDefaultDate() && !iq.vistoPreanestesia){
                arrayPendientes.append(Pendiente(numeroHistoria: iq.id, fecha: iq.fechaPreanestesia, codigo: CodigoTarea.Preanestesia, titulo: "Preanestesia",idTarea: iq.idIQ))
            }
            if(iq.recordarIntervencion && iq.fechaListaEspera != getDefaultDate() && !iq.vistoListaEspera){
                arrayPendientes.append(Pendiente(numeroHistoria: iq.id, fecha: iq.fechaListaEspera, codigo: CodigoTarea.ListaEspera, titulo: "Lista de espera",idTarea: iq.idIQ))
            }
        }
        for prueba in realm.objects(Prueba.self){
            if(prueba.recordarPrueba && prueba.fechaPrueba != getDefaultDate() && !prueba.pruebaVisto){
                arrayPendientes.append(Pendiente(numeroHistoria: prueba.id, fecha: prueba.fechaPrueba, codigo: CodigoTarea.Prueba, titulo: prueba.tipoPrueba, idTarea: prueba.idPrueba))
            }
        }
        for revisar in realm.objects(Revisar.self){
            if(revisar.recordarRevisar && revisar.fechaRevisar != getDefaultDate() && !revisar.revisarVisto){
                arrayPendientes.append(Pendiente(numeroHistoria: revisar.id, fecha: revisar.fechaRevisar, codigo: CodigoTarea.Revisar,titulo: "Revisar", idTarea: revisar.idRevisar))
            }
        }
        for siguienteCita in realm.objects(SiguienteCita.self){
            if(siguienteCita.recordarSiguienteCita && siguienteCita.fechaSiguienteCita != getDefaultDate() && !siguienteCita.siguienteCitaVisto){
                arrayPendientes.append(Pendiente(numeroHistoria: siguienteCita.id, fecha: siguienteCita.fechaSiguienteCita, codigo: CodigoTarea.SiguienteCita, titulo: "Cita", idTarea: siguienteCita.idCita))
            }
        }
        return arrayPendientes
       
    }
    
    
    func getDefaultDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.locale = Locale(identifier: "es")
        return dateFormatter.date(from:"1990-09-09")!
    }
    
}
