//
//  RevisarViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 29/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import RealmSwift



class RevisarViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var noIconImage: UIImageView!
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var tabla: UITableView!
    let realm = try! Realm()
    var revisarArray = [Revisar]()
    
    
    override func viewDidLoad() {
        navigationView(origin: self)
        headerView.title.text = "Revisar"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRevisarItems()
    }
    
    func getRevisarItems(){
        revisarArray.removeAll()
        for revisar in  realm.objects(Revisar.self){
            if(revisar.revisar && !revisar.revisarVisto){
                revisarArray.append(revisar)
            }
        }
        if(revisarArray.count > 0){
            tabla.isHidden = false
            noIconImage.isHidden = true
            tabla.reloadData()
        }else{
            tabla.isHidden = true
            noIconImage.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
        let animator = AnimationFactory.Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return revisarArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "revisarCell", for: indexPath) as! RevisarTableViewCell
        cell.titulo.text = revisarArray[indexPath.row].id
        cell.subtitulo.text = ""
        cell.color.backgroundColor = colorRevisar
        cell.visto.setOn(false, animated: true)
        cell.visto.seleccion = indexPath.row
        cell.visto.addTarget(self, action: #selector(checkVisto), for: .valueChanged)
        if(revisarArray[indexPath.row].notasRevisar != ""){
            cell.notas.isHidden = false
            cell.notas.text = revisarArray[indexPath.row].notasRevisar
            cell.cellHeight.constant = 200
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        InformacionPacienteRouter().goToInformacionPaciente(navigationController: navigationController, nHistoria: revisarArray[indexPath.row].id)
    }
    
    @objc
    func checkVisto(_ sender: VistoSwitchClass){
        if let seleccion = sender.seleccion{
            let revisar: Revisar
            revisar = realm.objects(Revisar.self).filter("id == %@", revisarArray[seleccion].id)[revisarArray[seleccion].idRevisar]
            try! realm.write {
                revisar.revisarVisto = sender.isOn
            }
        }
        getRevisarItems()
    }
    
}
