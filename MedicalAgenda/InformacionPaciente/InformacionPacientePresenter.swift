//
//  InformacionPacientePresenter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 12/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol InformacionPacienteProtocol{
    
}

enum SlideType: String {
    case patologia = "Patologia"
    case intervencion = "Intervencion"
    case prueba = "Prueba"
    case revision = "Revision"
    case cita = "Cita"
}

class InformacionPacientePresenter: IntervencionSlideProtocol, PruebasSlideProtocol, RevisionesProtocol, CitaSlideProtocol {
    
    
    var realm = try! Realm()
    var pacienteModel: PacienteModel = PacienteModel()
    var viewController: InformacionPacienteViewController!
    
    var vc: CustomCollectionViewController!
    
    
    
    func getPaciente() -> Paciente{
        return realm.objects(Paciente.self).filter("numeroHistoria == %@", pacienteModel.nHistoria)[0]
    }
    
    func setPacienteModel(nHistoria: String){
        pacienteModel = PacienteModel()
        
        let paciente = realm.objects(Paciente.self).filter("numeroHistoria == %@", nHistoria)
        let intervencionesQuirurgicas = realm.objects(IntervencionQuirurgica.self).filter("id == %@", nHistoria)
        let pruebas = realm.objects(Prueba.self).filter("id == %@", nHistoria)
        let revisiones = realm.objects(Revisar.self).filter("id == %@", nHistoria)
        let siguientesCitas = realm.objects(SiguienteCita.self).filter("id == %@", nHistoria)
        
        
        pacienteModel.nHistoria = paciente[0].numeroHistoria
        pacienteModel.nombre = paciente[0].nombre
        pacienteModel.patologias = paciente[0].patologia
        
        for iq in intervencionesQuirurgicas{
            var iqModel = IqModel()
            iqModel.idIQ = iq.idIQ
            iqModel.fechaIntervencion = iq.fechaIntervencion
            iqModel.tipoIntervencion = iq.tipoIntervencion
            iqModel.recordarIntervencion = iq.recordarIntervencion
            iqModel.notasIntervencion = iq.notasIntervencionQuirurgica
            iqModel.intervenido = iq.intervenido
            iqModel.fechaListaEspera = iq.fechaListaEspera
            iqModel.preanestesiaRealizada = iq.preanestesiaRealizada
            iqModel.fechaPreanestesia = iq.fechaPreanestesia
            iqModel.notasPreanestesia = iq.notasPreanestesia
            iqModel.vistoIq = iq.vistoIQ
            iqModel.vistoListaEspera = iq.vistoListaEspera
            iqModel.vistoPreanestesia = iq.vistoPreanestesia
            
            pacienteModel.iq.append(iqModel)
        }
        
        for pr in pruebas{
            var pruebaModel = PruebaModel()
            pruebaModel.tipoPrueba = pr.tipoPrueba
            pruebaModel.fechaPrueba = pr.fechaPrueba
            pruebaModel.recordarPrueba = pr.recordarPrueba
            pruebaModel.vistoPrueba = pr.pruebaVisto
            
            pacienteModel.prueba.append(pruebaModel)
        }
        
        for rv in revisiones{
            var revisionModel = RevisarModel()
            revisionModel.notasRevisar = rv.notasRevisar
            revisionModel.fechaRevisar = rv.fechaRevisar
            revisionModel.recordarRevisar = rv.recordarRevisar
            revisionModel.vistoRevisar = rv.revisarVisto
            
            pacienteModel.revisar.append(revisionModel)
        }
        
        for sc in siguientesCitas{
            var scModel = SiguienteCitaModel()
            scModel.notasSiguienteCita = sc.notasSiguienteCita
            scModel.fechaSiguienteCita = sc.fechaSiguienteCita
            scModel.recordarSiguienteCita = sc.recordarSiguienteCita
            scModel.vistoSiguienteCita = sc.siguienteCitaVisto
            
            pacienteModel.siguienteCita.append(scModel)
        }
    }
    
    func getSlides(type: SlideType) -> [UIView]{
        switch type {
        case .patologia:
            return getPatologiaSliders()
        case .intervencion:
            return getIntervencionSliders()
        case .prueba:
            return getPruebasSlider()
        case .revision:
            return getRevisionesSlider()
        case .cita:
            return getCitasSlider()
        }
    }
    
    //CITAS
    func getCitasSlider() -> [CitaSlide]{
        var citaSlideArray = [CitaSlide]()
        for (i,cita) in pacienteModel.siguienteCita.enumerated(){
            let citaSlide: CitaSlide = Bundle.main.loadNibNamed("CitaSlide", owner: viewController, options: nil)?.first as! CitaSlide
            citaSlide.citaLabel.text = cita.notasSiguienteCita
            citaSlide.delegate = self
            citaSlide.idCita = i
            citaSlideArray.append(citaSlide)
        }
        return citaSlideArray
    }
    
    func goToCita(idCita: Int) {
        viewController.goToCita(idCita: idCita)
    }
    
    //PRUEBAS
    func getPruebasSlider() -> [PruebasSlide]{
        var pruebasSlideArray = [PruebasSlide]()
        for (i,prueba) in pacienteModel.prueba.enumerated(){
            let pruebaSlide: PruebasSlide = Bundle.main.loadNibNamed("PruebasSlide", owner: viewController, options: nil)?.first as! PruebasSlide
            pruebaSlide.pruebaLabel.text = prueba.tipoPrueba
            pruebaSlide.delegate = self
            pruebaSlide.idPrueba = i
            pruebasSlideArray.append(pruebaSlide)
        }
        return pruebasSlideArray
    }
    
    func goToPruebaDetail(id: Int) {
        viewController.goToPrueba(idPrueba: id)
    }
    
    //REVISIONES
    func getRevisionesSlider() -> [RevisionSlide]{
        var revisionesSlideArray = [RevisionSlide]()
        for (i, revision) in pacienteModel.revisar.enumerated(){
            let revisionSlide: RevisionSlide = Bundle.main.loadNibNamed("RevisionSlide", owner: viewController, options: nil)?.first as! RevisionSlide
            revisionSlide.revisionLabel.text = revision.notasRevisar
            revisionSlide.delegate = self
            revisionSlide.idRevision = i
            revisionesSlideArray.append(revisionSlide)
        }
        return revisionesSlideArray
    }
    
    func goToRevision(idRevision: Int) {
        viewController.goToRevision(idRevision: idRevision)
    }
    
    /////INTERVENCION
    func getIntervencionSliders() -> [IntervencionSlide]{
        var intervencionSlideArray = [IntervencionSlide]()
        for intervencion in pacienteModel.iq{
            let intervencionSlide:IntervencionSlide = Bundle.main.loadNibNamed("IntervencionSlide", owner: viewController, options: nil)?.first as! IntervencionSlide
            intervencionSlide.intervencionLabel.text = intervencion.tipoIntervencion
            intervencionSlide.intervencionId = intervencion.idIQ
            intervencionSlide.delegate = self
            intervencionSlideArray.append(intervencionSlide)
        }
        return intervencionSlideArray
    }
    
    func vistoChanged(visto: Bool) {
        //dosomething
    }
    
    func goToIntervencionDetail(intervencionId: Int) {
        viewController.intervencionClicked(intervencionId: intervencionId)
    }
    
    /////PATOLOGIA
    func getPatologiaSliders() -> [PatologiaSlide]{
        let patologiaRealm = getPaciente().patologia
        var patologiaSlideArray = [PatologiaSlide]()
        if(patologiaRealm.contains("|")){
            for p in patologiaRealm.components(separatedBy: "|"){
                let patologiaSlide:PatologiaSlide = Bundle.main.loadNibNamed("PatologiaSlide", owner: viewController, options: nil)?.first as! PatologiaSlide
                patologiaSlide.patologiaLabel.text = p
                patologiaSlideArray.append(patologiaSlide)
            }
        }else{
            let patologiaSlide:PatologiaSlide = Bundle.main.loadNibNamed("PatologiaSlide", owner: viewController, options: nil)?.first as! PatologiaSlide
            patologiaSlide.patologiaLabel.text = patologiaRealm
            patologiaSlideArray.append(patologiaSlide)
        }
        return patologiaSlideArray
    }
    
    
    func setPatologia(patologia: String){
        let p = getPaciente()
        try! realm.write {
            if(p.patologia == ""){
                p.patologia = patologia
            }else{
                p.patologia = p.patologia + "|" + patologia
            }
            
        }
        pacienteModel.patologias = pacienteModel.patologias + "|" + patologia
    }
    
    func deletePatologia(row: Int){
        let p = getPaciente()
        try! realm.write {
            var patologias = ""
            for (i, patologia) in p.patologia.components(separatedBy: "|").enumerated(){
                if(i != row){
                    if(patologias == ""){
                        patologias = patologia
                    }else{
                        patologias = "\(patologias)|\(patologia)"
                    }
                }
            }
            p.patologia = patologias
        }
        pacienteModel.patologias = p.patologia
    }
    
    func deleteIQ(nHistoria: String, row: Int){
        try! realm.write {
            let iq = realm.objects(IntervencionQuirurgica.self).filter("id == %@", nHistoria)[row]
            self.realm.delete(iq)
        }
    }
    
    func deletePrueba(nHistoria: String, row: Int){
        try! realm.write {
            let prueba = realm.objects(Prueba.self).filter("id == %@", nHistoria)[row]
            self.realm.delete(prueba)
        }
    }
    
    
    func deleteRevisar(nHistoria: String, row: Int){
        try! realm.write {
            let revision = realm.objects(Revisar.self).filter("id == %@", nHistoria)[row]
            self.realm.delete(revision)
        }
    }
    
    func deleteCita(nHistoria: String, row: Int){
        try! realm.write {
            let cita = realm.objects(SiguienteCita.self).filter("id == %@", nHistoria)[row]
            self.realm.delete(cita)
        }
    }
    
    func setVistos(tipo: TipoInfo, visto: Bool, row: Int, nHistoria: String){
        switch tipo {
        case .patologia:
            break
        case .iq:
            try! realm.write {
                let iq = realm.objects(IntervencionQuirurgica.self).filter("id == %@", nHistoria)[row]
                iq.vistoIQ = visto
            }
            break
        case .prueba:
            try! realm.write {
                let prueba = realm.objects(Prueba.self).filter("id == %@", nHistoria)[row]
                prueba.pruebaVisto = visto
            }
            break
        case .revisar:
            try! realm.write {
                let revision = realm.objects(Revisar.self).filter("id == %@", nHistoria)[row]
                revision.revisarVisto = visto
            }
            break
        case .siguienteCita:
            try! realm.write {
                let cita = realm.objects(SiguienteCita.self).filter("id == %@", nHistoria)[row]
                cita.siguienteCitaVisto = visto
            }
            break
        }
    }
    
    func guardarPatologia(patologia: String){
        let paciente = realm.objects(Paciente.self).filter("<#T##predicate: NSPredicate##NSPredicate#>")
    }
    
    
}
