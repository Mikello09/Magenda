//
//  FormulariosVC.swift
//  MedicalAgenda
//
//  Created by Juan Carlos Lopez Armendariz on 15/03/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import RealmSwift



class PatologiasVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var separador: UIView!
    @IBOutlet weak var anadirBoton: UIButton!
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var patologiasTextView: UITextField!
    let realm = try! Realm()
    var arrayPatologia = [String]()
    var tipo: String = ""
    
    override func viewDidLoad() {
        
        switch tipo {
        case "patologia":
            paintNavigationBarWithOnlyBack(title: "Añadir patología")
            self.patologiasTextView.placeholder = "Patología"
            anadirBoton.backgroundColor = colorPatologia
            separador.backgroundColor = colorPatologia
            updatePatologias()
            break;
        case "pruebas":
            paintNavigationBarWithOnlyBack(title: "Añadir prueba")
            self.patologiasTextView.placeholder = "Prueba"
            anadirBoton.backgroundColor = colorPrueba
            separador.backgroundColor = colorPrueba
            updatePruebas()
            break;
        case "iq":
            paintNavigationBarWithOnlyBack(title: "Añadir tipo de IQ")
            self.patologiasTextView.placeholder = "Intervención quirúrgica"
            anadirBoton.backgroundColor = colorIQ
            separador.backgroundColor = colorIQ
            updateIQ()
            break;
        default:
            paintNavigationBarWithOnlyBack(title: "Añadir patología")
            self.patologiasTextView.placeholder = "Patología"
            anadirBoton.backgroundColor = colorPatologia
            separador.backgroundColor = colorPatologia
            updatePatologias()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func updatePatologias(){
        arrayPatologia.removeAll()
        for result in realm.objects(Patologias.self) {
            arrayPatologia.append(result.valor)
        }
        arrayPatologia.sort(by: <)
        tabla.reloadData()
    }
    
    func updatePruebas(){
        arrayPatologia.removeAll()
        for result in realm.objects(PruebasRealm.self) {
            arrayPatologia.append(result.valor)
        }
        arrayPatologia.sort(by: <)
        tabla.reloadData()
    }
    
    func updateIQ(){
        arrayPatologia.removeAll()
        for result in realm.objects(IQRealm.self) {
            arrayPatologia.append(result.valor)
        }
        arrayPatologia.sort(by: <)
        tabla.reloadData()
    }
    
    
    @IBAction func guardarClick(_ sender: Any) {
        
        if(patologiasTextView.text! != ""){
            switch tipo {
            case "patologia":
                let patologia = Patologias()
                patologia.valor = patologiasTextView.text!
                try! realm.write {
                    realm.add(patologia)
                }
                updatePatologias()
                break;
            case "pruebas":
                let prueba = PruebasRealm()
                prueba.valor = patologiasTextView.text!
                try! realm.write {
                    realm.add(prueba)
                }
                updatePruebas()
                break;
            case "iq":
                let iq = IQRealm()
                iq.valor = patologiasTextView.text!
                try! realm.write {
                    realm.add(iq)
                }
                updateIQ()
                break;
            default:
                let patologia = Patologias()
                patologia.valor = patologiasTextView.text!
                try! realm.write {
                    realm.add(patologia)
                }
                updatePatologias()
            }
            self.patologiasTextView.text = ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPatologia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patologiaCell", for: indexPath) as! PatologiaTableViewCell
        cell.title.text = arrayPatologia[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if(indexPath.row != 0){
            let deleteAction = UITableViewRowAction(style: .normal, title: "Borrar") { (rowAction, indexPath) in
                print("Deleted")
                switch self.tipo {
                case "patologia":
                    let patologia = self.realm.objects(Patologias.self).filter("valor == %@", self.arrayPatologia[indexPath.row])[0]
                    try! self.realm.write {
                        self.realm.delete(patologia)
                    }
                    self.updatePatologias()
                    break;
                case "pruebas":
                    let prueba = self.realm.objects(PruebasRealm.self).filter("valor == %@", self.arrayPatologia[indexPath.row])[0]
                    try! self.realm.write {
                        self.realm.delete(prueba)
                    }
                    self.updatePruebas()
                    break;
                case "iq":
                    let iq = self.realm.objects(IQRealm.self).filter("valor == %@", self.arrayPatologia[indexPath.row])[0]
                    try! self.realm.write {
                        self.realm.delete(iq)
                    }
                    self.updateIQ()
                    break;
                default:
                    let patologia = self.realm.objects(Patologias.self).filter("valor == %@", self.arrayPatologia[indexPath.row])[0]
                    try! self.realm.write {
                        self.realm.delete(patologia)
                    }
                    self.updatePatologias()
                }
            }
            deleteAction.backgroundColor = .red
            return [deleteAction]
        }
        return nil
    }
}
