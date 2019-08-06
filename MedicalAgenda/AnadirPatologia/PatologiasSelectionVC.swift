//
//  PatologiasSelectionVC.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 27/3/19.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import RealmSwift


protocol PatologiaSelected{
    func onPatologiaSelected(patologiaSeleccionada: String, tipo: String, numeroPrueba: Int?)
}

class PatologiasSelectionVC:UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource{
    
    var delegate: PatologiaSelected?
    let realm = try! Realm()
    var tipo: String = ""
    var numeroPrueba: Int? = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [String] = []
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        
        paintNavigationBarWithOnlyBack(title: "")
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(PatologiasSelectionVC.addItems))
        addButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = addButton
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        
        
    }
    
    func cargarDatos(){
        tableData.removeAll()
        switch tipo {
        case "patologia":
            for patologia in (Array(realm.objects(Patologias.self))){
                tableData.append(patologia.valor)
            }
            break;
        case "pruebas":
            for prueba in (Array(realm.objects(PruebasRealm.self))){
                tableData.append(prueba.valor)
            }
            break;
        case "iq":
            for iq in (Array(realm.objects(IQRealm.self))){
                tableData.append(iq.valor)
            }
            break;
        default:
            for patologia in (Array(realm.objects(Patologias.self))){
                tableData.append(patologia.valor)
            }
        }
        // Reload the table
        tableData.sort(by: <)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cargarDatos()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return tableData.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        let label = UILabel(frame: CGRect(x: 8, y: 3, width: view.frame.size.width, height: 20))
        label.textColor = .black
        switch tipo {
        case "patologia":
            returnedView.backgroundColor = colorPatologia
            label.text = "Seleccionar patologia"
            break;
        case "pruebas":
            returnedView.backgroundColor = colorPrueba
            label.text = "Seleccionar tipo prueba"
            break;
        case "iq":
            returnedView.backgroundColor = colorIQ
            label.text = "Seleccionar tipo de intervención quirúrgica"
        default:
            returnedView.backgroundColor = UIColor.black
        }
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tipo {
        case "patologia":
            return "Seleccionar patología"
        case "pruebas":
            return "Seleccionar tipo prueba"
        case "iq":
            return "Seleccionar tipo IQ"
        default:
            return "Seleccionar patología"
        }
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatologiaCell", for: indexPath) as! PatologiaSelectionCell
        if (resultSearchController.isActive) {
            cell.titulo?.text = filteredTableData[indexPath.row]
            return cell
        }
        else {
            cell.titulo?.text = tableData[indexPath.row]
            print(tableData[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (resultSearchController.isActive) {
            self.delegate?.onPatologiaSelected(patologiaSeleccionada: filteredTableData[indexPath.row], tipo: tipo, numeroPrueba: numeroPrueba)
        }
        else {
            self.delegate?.onPatologiaSelected(patologiaSeleccionada: tableData[indexPath.row], tipo: tipo, numeroPrueba: numeroPrueba)
        }
        resultSearchController.isActive = false
        navigationController?.popViewController(animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        
        self.tableView.reloadData()
    }
    
    @objc func addItems(){
        print("Añadir")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addItemsStoryboard") as! PatologiasVC
        vc.tipo = self.tipo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
