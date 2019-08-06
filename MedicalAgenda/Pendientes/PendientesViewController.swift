//
//  PendientesViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 29/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import RealmSwift



class PendientesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var noIconImage: UIImageView!
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var tabla: UITableView!
    let realm = try! Realm()
    var arrayPendientes = [Pendiente]()
    var presenter: PendientesPresenter!
    
    override func viewDidLoad() {
        //self.title = "Pendientes"
        navigationView(origin: self)
        headerView.title.text = "Pendientes"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter = PendientesPresenter()
        setUpView()
    }
    
    func setUpView(){
        arrayPendientes = presenter.getPendientesItems()
        if(arrayPendientes.count > 0){
            tabla.isHidden = false
            arrayPendientes = arrayPendientes.sorted(by: { $0.fecha < $1.fecha })
            noIconImage.isHidden = true
            tabla.reloadData()
        }else{
            noIconImage.isHidden = false
            tabla.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
        let animator = AnimationFactory.Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPendientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch arrayPendientes[indexPath.row].codigo{
        case CodigoTarea.ListaEspera:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesSimpleCell", for: indexPath) as! PendientesTableViewCellSimple
            cell.titulo.text = arrayPendientes[indexPath.row].titulo
            cell.color.backgroundColor = colorIQ
            cell.visto.setOn(false, animated: true)
            cell.visto.seleccion = indexPath.row
            cell.nHistoria.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
            cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
            cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
            if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
            return cell
        case CodigoTarea.Preanestesia:
            if(realm.objects(IntervencionQuirurgica.self).filter("id == %@", arrayPendientes[indexPath.row].numeroHistoria)[arrayPendientes[indexPath.row].idTarea].notasPreanestesia != ""){
                let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesCell", for: indexPath) as! PendientesTableViewCell
                cell.notas.text = realm.objects(IntervencionQuirurgica.self).filter("id == %@", arrayPendientes[indexPath.row].numeroHistoria)[arrayPendientes[indexPath.row].idTarea].notasPreanestesia
                cell.titulo.text = arrayPendientes[indexPath.row].titulo
                cell.subTitulo.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
                cell.color.backgroundColor = colorIQ
                cell.visto.setOn(false, animated: true)
                cell.visto.seleccion = indexPath.row
                cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
                cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
                if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesSimpleCell", for: indexPath) as! PendientesTableViewCellSimple
                cell.titulo.text = arrayPendientes[indexPath.row].titulo
                cell.color.backgroundColor = colorIQ
                cell.nHistoria.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
                cell.visto.setOn(false, animated: true)
                cell.visto.seleccion = indexPath.row
                cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
                cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
                if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
                return cell
            }
        case CodigoTarea.IQ:
            if(realm.objects(IntervencionQuirurgica.self).filter("id == %@", arrayPendientes[indexPath.row].numeroHistoria)[arrayPendientes[indexPath.row].idTarea].notasIntervencionQuirurgica != ""){
                let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesCell", for: indexPath) as! PendientesTableViewCell
                cell.notas.text = realm.objects(IntervencionQuirurgica.self).filter("id == %@", arrayPendientes[indexPath.row].numeroHistoria)[arrayPendientes[indexPath.row].idTarea].notasIntervencionQuirurgica
                cell.titulo.text = arrayPendientes[indexPath.row].titulo
                cell.subTitulo.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
                cell.color.backgroundColor = colorIQ
                cell.visto.setOn(false, animated: true)
                cell.visto.seleccion = indexPath.row
                cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
                cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
                if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesSimpleCell", for: indexPath) as! PendientesTableViewCellSimple
                cell.titulo.text = arrayPendientes[indexPath.row].titulo
                cell.color.backgroundColor = colorIQ
                cell.nHistoria.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
                cell.visto.setOn(false, animated: true)
                cell.visto.seleccion = indexPath.row
                cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
                cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
                if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
                return cell
            }
        case CodigoTarea.Prueba:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesSimpleCell", for: indexPath) as! PendientesTableViewCellSimple
            cell.titulo.text = arrayPendientes[indexPath.row].titulo
            cell.nHistoria.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
            cell.color.backgroundColor = colorPrueba
            cell.visto.setOn(false, animated: true)
            cell.visto.seleccion = indexPath.row
            cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
            cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
            if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
            return cell
        case CodigoTarea.Revisar:
            if(realm.objects(Revisar.self).filter("id == %@", arrayPendientes[indexPath.row].numeroHistoria)[arrayPendientes[indexPath.row].idTarea].notasRevisar != ""){
                let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesCell", for: indexPath) as! PendientesTableViewCell
                cell.notas.text = realm.objects(Revisar.self).filter("id == %@", arrayPendientes[indexPath.row].numeroHistoria)[arrayPendientes[indexPath.row].idTarea].notasRevisar
                cell.titulo.text = arrayPendientes[indexPath.row].titulo
                cell.subTitulo.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
                cell.color.backgroundColor = colorRevisar
                cell.visto.setOn(false, animated: true)
                cell.visto.seleccion = indexPath.row
                cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
                cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
                if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesSimpleCell", for: indexPath) as! PendientesTableViewCellSimple
                cell.titulo.text = arrayPendientes[indexPath.row].titulo
                cell.color.backgroundColor = colorRevisar
                cell.nHistoria.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
                cell.visto.setOn(false, animated: true)
                cell.visto.seleccion = indexPath.row
                cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
                cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
                if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
                return cell
            }
        case CodigoTarea.SiguienteCita:
            if(realm.objects(SiguienteCita.self).filter("id == %@", arrayPendientes[indexPath.row].numeroHistoria)[arrayPendientes[indexPath.row].idTarea].notasSiguienteCita != ""){
                let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesCell", for: indexPath) as! PendientesTableViewCell
                cell.notas.text = realm.objects(SiguienteCita.self).filter("id == %@", arrayPendientes[indexPath.row].numeroHistoria)[arrayPendientes[indexPath.row].idTarea].notasSiguienteCita
                cell.titulo.text = arrayPendientes[indexPath.row].titulo
                cell.subTitulo.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
                cell.color.backgroundColor = colorSiguienteCita
                cell.visto.setOn(false, animated: true)
                cell.visto.seleccion = indexPath.row
                cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
                cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
                if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pendientesSimpleCell", for: indexPath) as! PendientesTableViewCellSimple
                cell.titulo.text = arrayPendientes[indexPath.row].titulo
                cell.color.backgroundColor = colorSiguienteCita
                cell.nHistoria.text = "N.Historia: " + arrayPendientes[indexPath.row].numeroHistoria
                cell.visto.setOn(false, animated: true)
                cell.visto.seleccion = indexPath.row
                cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
                cell.fecha.text = formatter.string(from: arrayPendientes[indexPath.row].fecha)
                if(arrayPendientes[indexPath.row].fecha > Date()){cell.setCapa()}
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        InformacionPacienteRouter().goToInformacionPaciente(navigationController: navigationController,nHistoria: arrayPendientes[indexPath.row].numeroHistoria)
    }
    
    @objc
    func checkVisto(_ sender: VistoSwitchClass){
        
        if let seleccion = sender.seleccion{
            let numeroHistoria = arrayPendientes[seleccion].numeroHistoria
            let idTarea = arrayPendientes[seleccion].idTarea
            try! realm.write {
                switch arrayPendientes[seleccion].codigo{
                case CodigoTarea.ListaEspera:
                    let iq = realm.objects(IntervencionQuirurgica.self).filter("id == %@", numeroHistoria)[idTarea]
                    iq.vistoListaEspera = sender.isOn
                    break;
                case CodigoTarea.Preanestesia:
                    let iq = realm.objects(IntervencionQuirurgica.self).filter("id == %@", numeroHistoria)[idTarea]
                    iq.vistoPreanestesia = sender.isOn
                    break;
                case CodigoTarea.IQ:
                    let iq = realm.objects(IntervencionQuirurgica.self).filter("id == %@", numeroHistoria)[idTarea]
                    iq.vistoIQ = sender.isOn
                    break;
                case CodigoTarea.Prueba:
                    let prueba = realm.objects(Prueba.self).filter("id == %@", numeroHistoria)[idTarea]
                    prueba.pruebaVisto = sender.isOn
                    break;
                case CodigoTarea.Revisar:
                    let revisar = realm.objects(Revisar.self).filter("id == %@", numeroHistoria)[idTarea]
                    revisar.revisarVisto = sender.isOn
                    break;
                case CodigoTarea.SiguienteCita:
                    let siguienteCita = realm.objects(SiguienteCita.self).filter("id == %@", numeroHistoria)[idTarea]
                    siguienteCita.siguienteCitaVisto = sender.isOn
                    break;
                }
            }
        }
        setUpView()
    }
}



