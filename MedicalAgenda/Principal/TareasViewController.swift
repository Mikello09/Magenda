//
//  TareasViewController.swift
//  MedicalAgenda
//
//  Created by Juan Carlos Lopez Armendariz on 15/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import RealmSwift

struct Seleccion {
    var nHistoria: String
    var color: UIColor
    var nombre: String
    var tipo: String
    var notas: String
    var visto: Bool
    var codigo: CodigoTarea
}

enum CodigoTarea: String{
    case ListaEspera = "LE"
    case Preanestesia = "PA"
    case IQ = "IQ"
    case Prueba = "P"
    case Revisar = "RE"
    case SiguienteCita = "SC"
}

class TareasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var emptyImage: UIImageView!
    var fechaSeleccionada: Date = Date()
    var seleccionArray = [Seleccion]()
    var realm = try! Realm()
    @IBOutlet weak var tabla: UITableView!
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E dd LLLL"
        formatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        formatter.locale = Locale(identifier: "es")
        return formatter
    }()
    
    
    private let formatterSave: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        formatter.locale = Locale(identifier: "es")
        return formatter
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        seleccionArray.removeAll()
        let listaDeEspera = realm.objects(IntervencionQuirurgica.self).filter("fechaListaEspera == %@", formatterSave.string(from: fechaSeleccionada).toDateFormat)
        let preanestesia = realm.objects(IntervencionQuirurgica.self).filter("#fechaPreanestesia == %@",formatterSave.string(from: fechaSeleccionada).toDateFormat)
        let intervencion = realm.objects(IntervencionQuirurgica.self).filter("#fechaIntervencion == %@",formatterSave.string(from: fechaSeleccionada).toDateFormat)
        let prueba = realm.objects(Prueba.self).filter("#fechaPrueba == %@", formatterSave.string(from: fechaSeleccionada).toDateFormat)
        let revisar = realm.objects(Revisar.self).filter("#fechaRevisar == %@", formatterSave.string(from: fechaSeleccionada).toDateFormat)
        let siguienteCita = realm.objects(SiguienteCita.self).filter("#fechaSiguienteCita == %@", formatterSave.string(from: fechaSeleccionada).toDateFormat)
        
        if(listaDeEspera.count > 0){
            for lista in listaDeEspera{
                let seleccion = Seleccion(
                    nHistoria: lista.id,
                    color: colorIQ,
                    nombre: "",
                    tipo: "Lista de espera",
                    notas: "" ,
                    visto: lista.vistoListaEspera,
                    codigo: CodigoTarea.ListaEspera)
                if lista.recordarIntervencion{seleccionArray.append(seleccion)}
            }
        }
        if(preanestesia.count > 0){
            for prea in preanestesia{
                let seleccion = Seleccion(
                    nHistoria: prea.id,
                    color: colorIQ,
                    nombre: "",
                    tipo: "Preanestesia",
                    notas: prea.notasPreanestesia,
                    visto: prea.vistoPreanestesia,
                    codigo: CodigoTarea.Preanestesia)
                if prea.recordarIntervencion{seleccionArray.append(seleccion)}
            }
        }
        if(intervencion.count > 0){
            for inter in intervencion{
                let seleccion = Seleccion(
                    nHistoria: inter.id,
                    color: colorIQ,
                    nombre: "",
                    tipo: "Intervención",
                    notas: inter.notasIntervencionQuirurgica,
                    visto: inter.vistoIQ,
                    codigo: CodigoTarea.IQ)
                if inter.recordarIntervencion{seleccionArray.append(seleccion)}
            }
        }
        if(prueba.count > 0){
            for pr in prueba {
                let seleccion = Seleccion(
                    nHistoria: pr.id,
                    color: colorPrueba,
                    nombre: "",
                    tipo: pr.tipoPrueba,
                    notas: "",
                    visto: pr.pruebaVisto,
                    codigo: CodigoTarea.Prueba)
                if pr.recordarPrueba{seleccionArray.append(seleccion)}
            }
        }
        if(revisar.count > 0){
            for rv in revisar{
                let seleccion = Seleccion(
                    nHistoria: rv.id,
                    color: colorRevisar,
                    nombre: "",
                    tipo: "Revisar",
                    notas: rv.notasRevisar,
                    visto: rv.revisarVisto,
                    codigo: CodigoTarea.Revisar)
                if rv.recordarRevisar{seleccionArray.append(seleccion)}
            }
        }
        if(siguienteCita.count > 0){
            for sg in siguienteCita{
                let seleccion = Seleccion(
                    nHistoria: sg.id,
                    color: colorSiguienteCita,
                    nombre: "",
                    tipo: "Siguiente cita",
                    notas: sg.notasSiguienteCita,
                    visto: sg.siguienteCitaVisto,
                    codigo: CodigoTarea.SiguienteCita)
                if sg.recordarSiguienteCita{seleccionArray.append(seleccion)}
            }
        }
        if(seleccionArray.count > 0){
            tabla.isHidden = false
            emptyImage.isHidden = true
            tabla.reloadData()
        } else {
            tabla.isHidden = true
            emptyImage.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        
        paintNavigationBarWithOnlyBack(title: formatter.string(from: fechaSeleccionada))
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
        let animator = AnimationFactory.Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seleccionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tareasCell", for: indexPath) as! TareasTableViewCell
        
        cell.color.backgroundColor = seleccionArray[indexPath.row].color
        cell.nombre.text = seleccionArray[indexPath.row].tipo
        cell.cita.text = "Número de historia: " + seleccionArray[indexPath.row].nHistoria
        if(seleccionArray[indexPath.row].notas != ""){
            cell.notasText.text = seleccionArray[indexPath.row].notas
            cell.notasText.isHidden = false
            cell.cellHeight.constant = 200
            //cell.topNotasMargin.constant = 10
            cell.bottomNotasMargin.constant = 10
        }
        cell.checkVisto.setOn(seleccionArray[indexPath.row].visto, animated: true)
        cell.checkVisto.seleccion = indexPath.row
        cell.checkVisto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       InformacionPacienteRouter().goToInformacionPaciente(navigationController: navigationController,nHistoria: seleccionArray[indexPath.row].nHistoria)
    }
    
    @objc
    func checkVisto(_ sender: VistoSwitchClass){
        if let seleccion = sender.seleccion{
            
            try! realm.write {
                switch seleccionArray[seleccion].codigo{
                case CodigoTarea.ListaEspera:
                    let intervencionQuirurgica = realm.objects(IntervencionQuirurgica.self).filter("id == %@", seleccionArray[seleccion].nHistoria)[0]
                    intervencionQuirurgica.vistoListaEspera = sender.isOn
                    break;
                case CodigoTarea.Preanestesia:
                    let intervencionQuirurgica = realm.objects(IntervencionQuirurgica.self).filter("id == %@", seleccionArray[seleccion].nHistoria)[0]
                    intervencionQuirurgica.vistoPreanestesia = sender.isOn
                    break;
                case CodigoTarea.IQ:
                    let intervencionQuirurgica = realm.objects(IntervencionQuirurgica.self).filter("id == %@", seleccionArray[seleccion].nHistoria)[0]
                    intervencionQuirurgica.vistoIQ = sender.isOn
                    break;
                case CodigoTarea.Prueba:
                    let prueba = realm.objects(Prueba.self).filter("id == %@", seleccionArray[seleccion].nHistoria)[0]
                    prueba.pruebaVisto = sender.isOn
                    break;
                case CodigoTarea.Revisar:
                    let revisar = realm.objects(Revisar.self).filter("id == %@", seleccionArray[seleccion].nHistoria)[0]
                    revisar.revisarVisto = sender.isOn
                    break;
                case CodigoTarea.SiguienteCita:
                    let siguienteCita = realm.objects(SiguienteCita.self).filter("id == %@", seleccionArray[seleccion].nHistoria)[0]
                    siguienteCita.siguienteCitaVisto = sender.isOn
                    break;
                }
            }
        }
    }

    
}
