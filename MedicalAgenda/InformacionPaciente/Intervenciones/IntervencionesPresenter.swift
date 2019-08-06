//
//  IntervencionesPresenter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 19/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class IntervencionesPresenter{
    
    
    var nHistoria: String = ""
    var realm = try! Realm()
    
    func setIntervencion(
        tipoIQ: String,
        fechaIntervencion: Date,
        recordarIntervencion: Bool,
        notasIntervencion: String,
        intervenido: Bool,
        fechaListaEspera: Date,
        preanestesiaRealizada: Bool,
        fechaPreanestesia: Date,
        notasPreanestesia: String,
        intervencionQuirurgica: IntervencionQuirurgica = IntervencionQuirurgica(),
        isNew:Bool = true){
        
        try! realm.write {
            intervencionQuirurgica.id = nHistoria
            intervencionQuirurgica.idIQ = realm.objects(IntervencionQuirurgica.self).filter("id = %@", nHistoria).count
            intervencionQuirurgica.tipoIntervencion = tipoIQ
            intervencionQuirurgica.intervencionQuirurgica = true
            intervencionQuirurgica.vistoIQ = false
            intervencionQuirurgica.fechaIntervencion = fechaIntervencion
            intervencionQuirurgica.recordarIntervencion = recordarIntervencion
            intervencionQuirurgica.notasIntervencionQuirurgica = notasIntervencion
            intervencionQuirurgica.intervenido = intervenido
            intervencionQuirurgica.fechaListaEspera = fechaListaEspera
            intervencionQuirurgica.vistoListaEspera = false
            intervencionQuirurgica.preanestesiaRealizada = preanestesiaRealizada
            intervencionQuirurgica.fechaPreanestesia = fechaPreanestesia
            intervencionQuirurgica.notasPreanestesia = notasPreanestesia
            intervencionQuirurgica.vistoPreanestesia = false
            if(isNew){realm.add(intervencionQuirurgica)}
        }
    }
    
    func setIntervencionDetalles(intervencion: IntervencionQuirurgica, anatomiaPatologica: String, complicaciones: String, notas: String){
        try! realm.write {
            intervencion.anatomiaPatologica = anatomiaPatologica
            intervencion.complicaciones = complicaciones
            intervencion.notasDetalles = notas
        }
    }
    
    func getIQModel(idIQ: Int) -> IqModel{
        let intervencionesQuirurgicas = realm.objects(IntervencionQuirurgica.self).filter("id == %@ AND idIQ == %d", nHistoria, idIQ)[0]
        var iqModel = IqModel()
        iqModel.fechaIntervencion = intervencionesQuirurgicas.fechaIntervencion
        iqModel.tipoIntervencion = intervencionesQuirurgicas.tipoIntervencion
        iqModel.recordarIntervencion = intervencionesQuirurgicas.recordarIntervencion
        iqModel.notasIntervencion = intervencionesQuirurgicas.notasIntervencionQuirurgica
        iqModel.intervenido = intervencionesQuirurgicas.intervenido
        iqModel.fechaListaEspera = intervencionesQuirurgicas.fechaListaEspera
        iqModel.preanestesiaRealizada = intervencionesQuirurgicas.preanestesiaRealizada
        iqModel.fechaPreanestesia = intervencionesQuirurgicas.fechaPreanestesia
        iqModel.notasPreanestesia = intervencionesQuirurgicas.notasPreanestesia
        iqModel.vistoIq = intervencionesQuirurgicas.vistoIQ
        iqModel.vistoListaEspera = intervencionesQuirurgicas.vistoListaEspera
        iqModel.vistoPreanestesia = intervencionesQuirurgicas.vistoPreanestesia
        iqModel.anatomiaPatologica = intervencionesQuirurgicas.anatomiaPatologica
        iqModel.complicaciones = intervencionesQuirurgicas.complicaciones
        iqModel.notasDetalles = intervencionesQuirurgicas.notasDetalles
        return iqModel
    }
    
    func getIntervencionQuirurgica(idIQ: Int) -> IntervencionQuirurgica{
        return realm.objects(IntervencionQuirurgica.self).filter("id == %@ AND idIQ == %@", nHistoria, idIQ)[0]
    }
}
