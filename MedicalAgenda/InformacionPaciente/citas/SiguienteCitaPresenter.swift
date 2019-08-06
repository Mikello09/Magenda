//
//  SiguienteCitaPresenter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 06/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SiguienteCitaPresenter{
    
    var realm = try! Realm()
    
    func getCita(nHistoria: String, idCita: Int) -> SiguienteCita{
        let citas = realm.objects(SiguienteCita.self).filter("id == %@", nHistoria)
        return citas[idCita]
    }
    
    func guardarCita(siguienteCita: SiguienteCita?, fecha: Date, notas: String, recordar: Bool, nHistoria: String){
        try! realm.write {
            if let cita = siguienteCita{
                cita.fechaSiguienteCita = fecha
                cita.notasSiguienteCita = notas
                cita.recordarSiguienteCita = recordar
                cita.siguienteCita = true
            }else{
                let cita = SiguienteCita()
                cita.idCita = realm.objects(SiguienteCita.self).filter("id = %@", nHistoria).count
                cita.id = nHistoria
                cita.fechaSiguienteCita = fecha
                cita.notasSiguienteCita = notas
                cita.recordarSiguienteCita = recordar
                cita.siguienteCita = true
                realm.add(cita)
            }
        }
    }
    
}
