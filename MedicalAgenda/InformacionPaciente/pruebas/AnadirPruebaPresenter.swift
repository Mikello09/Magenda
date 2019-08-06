//
//  AnadirPruebaPresenter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 27/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AnadirPruebaPresenter{
    
    var realm = try! Realm()
    
    func getPrueba(nHistoria: String, idPrueba: Int) -> Prueba{
        let pruebas = realm.objects(Prueba.self).filter("id == %@", nHistoria)
        return pruebas[idPrueba]
    }
    
    func guardarPrueba(prueba: Prueba?, tipoPrueba: String, fechaPrueba: Date, recordar: Bool, visto: Bool, nHistoria: String){
        try! realm.write {
            if let pruebaUpdate = prueba{
                pruebaUpdate.tipoPrueba = tipoPrueba
                pruebaUpdate.fechaPrueba = fechaPrueba
                pruebaUpdate.recordarPrueba = recordar
                pruebaUpdate.pruebaVisto = visto
            }else{
                let pruebaNueva = Prueba()
                pruebaNueva.idPrueba = realm.objects(Prueba.self).filter("id = %@", nHistoria).count
                pruebaNueva.id = nHistoria
                pruebaNueva.tipoPrueba = tipoPrueba
                pruebaNueva.fechaPrueba = fechaPrueba
                pruebaNueva.recordarPrueba = recordar
                pruebaNueva.pruebaVisto = false
                realm.add(pruebaNueva)
            }
        }
    }
    
    
}
