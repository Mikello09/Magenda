//
//  RevisionesPresenter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 01/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RevisionesPresenter{
    
    var realm = try! Realm()
    
    func getRevision(nHistoria: String, idRevision: Int) -> Revisar{
        let revisiones = realm.objects(Revisar.self).filter("id == %@", nHistoria)
        return revisiones[idRevision]
    }
    
    func guardarRevision(revision: Revisar?, fecha: Date, notas: String, recordar: Bool, nHistoria: String){
        try! realm.write {
            if let revisar = revision{
                revisar.fechaRevisar = fecha
                revisar.notasRevisar = notas
                revisar.recordarRevisar = recordar
                revisar.revisar = true
            }else{
                let rvs = Revisar()
                rvs.idRevisar = realm.objects(Revisar.self).filter("id = %@", nHistoria).count
                rvs.id = nHistoria
                rvs.fechaRevisar = fecha
                rvs.notasRevisar = notas
                rvs.recordarRevisar = recordar
                rvs.revisar = true
                realm.add(rvs)
            }
        }
    }
}
