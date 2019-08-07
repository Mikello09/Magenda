//
//  FilterViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 24/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import RealmSwift


protocol FilterProtocol{
    func exitFilter()
    func filterSelected(selectedFilters: [FilterSelected] )
}

struct Filter {
    var tipo = ""
    var value = ""
    var selected: Bool = false
}

struct FilterSelected {
    var tipo = ""
    var value = ""
    var section: Int = 0
    var row: Int = 0
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    let realm = try! Realm()
    
    @IBOutlet weak var continuarView: UIView!
    @IBOutlet weak var noHayFiltersText: UILabel!
    @IBOutlet weak var filtersTable: UITableView!
    @IBOutlet weak var selectedCollection: UICollectionView!
    @IBOutlet weak var closeFilter: UIView!
    var delegate: FilterProtocol?
    var editArray = [Filter]()
    var pruebasArray = [Filter]()
    var iqArray = [Filter]()
    var patologiaArray = [Filter]()
    var allFiltersData = [[Filter]]()
    let headerTitles = ["General", "Patologías","Tipo intervención quirúrgica","Tipo prueba"]
    var filterSelectedArray = [FilterSelected]()
    var filtrosPrecargados = [FilterSelected]()
    
    ///variables a borrar en un futuro
    var nameValue: String = ""
    var nHistoriaValue: String = ""
    var isDeleting: Bool = false
    
    
    override func viewDidLoad() {
        //TAP GESTURES
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(self.closeFilterClicked))
        closeFilter.isUserInteractionEnabled = true
        closeFilter.addGestureRecognizer(viewTap)
        
        let continuarViewTap = UITapGestureRecognizer(target: self, action: #selector(self.continuarClicked))
        continuarView.isUserInteractionEnabled = true
        continuarView.addGestureRecognizer(continuarViewTap)
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(FilterViewController.dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapView)
        
        bindView()
    }
    
    @objc
    func dismissKeyboard(sender:UITapGestureRecognizer) {
        print("Dismiss keyboard")
        view.endEditing(true)
    }
    
    func bindView(){
        //General
        var indexNHistoria = -1
        var indexName = -1
        for (i,filter) in filtrosPrecargados.enumerated(){
            if(filter.tipo == "nHistoria"){indexNHistoria = i}
            if(filter.tipo == "nombre"){indexName = i}
        }
        editArray = [
            Filter(tipo: "nHistoria", value: indexNHistoria == -1 ? "" : filtrosPrecargados[indexNHistoria].value, selected: false),
            Filter(tipo: "nombre", value: indexName == -1 ? "" : filtrosPrecargados[indexName].value, selected: false),
            Filter(tipo: "intervenidoSi", value: "Intervenido SI", selected: filtrosPrecargados.contains(where: {$0.tipo == "intervenidoSi"})),
            Filter(tipo: "intervenidoNo", value: "Intervenido NO", selected: filtrosPrecargados.contains(where: {$0.tipo == "intervenidoNo"}))]
        
        //Pruebas
        let resultsPruebas = realm.objects(PruebasRealm.self)
        for result in resultsPruebas {
            if(result.valor != "Ninguna"){
                if(filtrosPrecargados.contains(where: {$0.value == result.valor})){
                    pruebasArray.append(Filter(tipo: "prueba", value: result.valor, selected: true))
                }else{
                    pruebasArray.append(Filter(tipo: "prueba", value: result.valor, selected: false))
                }
            }
        }
        
        //iq
        let resultsIQ = realm.objects(IQRealm.self)
        for result in resultsIQ {
            if(result.valor != "Ninguna"){
                if(filtrosPrecargados.contains(where: {$0.value == result.valor})){
                    iqArray.append(Filter(tipo: "iq", value: result.valor, selected: true))
                }else{
                    iqArray.append(Filter(tipo: "iq", value: result.valor, selected: false))
                }
            }
        }
        
        //patologia
        let resultsPatologias = realm.objects(Patologias.self)
        for result in resultsPatologias {
            if(result.valor != "Ninguna"){
                if(filtrosPrecargados.contains(where: {$0.value == result.valor})){
                    patologiaArray.append(Filter(tipo: "patologia", value: result.valor, selected: true))
                }else{
                    patologiaArray.append(Filter(tipo: "patologia", value: result.valor, selected: false))
                }
            }
        }
        allFiltersData.append(editArray)
        allFiltersData.append(patologiaArray)
        allFiltersData.append(iqArray)
        allFiltersData.append(pruebasArray)
        
        filterSelectedArray = filtrosPrecargados
        if(filterSelectedArray.count > 0){
            noHayFiltersText.isHidden = true
            selectedCollection.isHidden = false
            selectedCollection.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        switch section {
        case 0:
            returnedView.backgroundColor = colorGeneral
        case 1:
            returnedView.backgroundColor = colorPatologia
        case 2:
            returnedView.backgroundColor = colorIQ
        case 3:
            returnedView.backgroundColor = colorPrueba
        default:
            returnedView.backgroundColor = UIColor.black
        }
        
        let label = UILabel(frame: CGRect(x: 8, y: 3, width: view.frame.size.width, height: 20))
        label.text = self.headerTitles[section]
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFiltersData[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allFiltersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "filterEditCell", for: indexPath) as! FilterEditCell
                cell.value.placeholder = "nHistoria"
                cell.value.addTarget(self, action: #selector(nHistoriaEditingStarted), for: UIControlEvents.allEditingEvents)
                cell.value.text = allFiltersData[indexPath.section][indexPath.row].value
                return cell
            }else if(indexPath.row == 1){
                let cell = tableView.dequeueReusableCell(withIdentifier: "filterEditCell", for: indexPath) as! FilterEditCell
                cell.value.placeholder = "Nombre"
                cell.value.addTarget(self, action: #selector(nNombreEditingStarted), for: UIControlEvents.allEditingEvents)
                cell.value.text = allFiltersData[indexPath.section][indexPath.row].value
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "filterValueCell", for: indexPath) as! FilterValueCell
                cell.value.text = allFiltersData[indexPath.section][indexPath.row].value
                cell.cellSelected.isChecked = allFiltersData[indexPath.section][indexPath.row].selected
                
                cell.cellSelected.tipo = allFiltersData[indexPath.section][indexPath.row].tipo
                cell.cellSelected.value = allFiltersData[indexPath.section][indexPath.row].value
                cell.cellSelected.row = indexPath.row
                cell.cellSelected.section = indexPath.section
                cell.cellSelected.addTarget(self, action: #selector(filterSelected), for: .valueChanged)
                
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "filterValueCell", for: indexPath) as! FilterValueCell
            cell.value.text = allFiltersData[indexPath.section][indexPath.row].value
            cell.cellSelected.isChecked = allFiltersData[indexPath.section][indexPath.row].selected
            
            cell.cellSelected.tipo = allFiltersData[indexPath.section][indexPath.row].tipo
            cell.cellSelected.value = allFiltersData[indexPath.section][indexPath.row].value
            cell.cellSelected.row = indexPath.row
            cell.cellSelected.section = indexPath.section
            cell.cellSelected.addTarget(self, action: #selector(filterSelected), for: .valueChanged)
    
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterSelectedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterSelectedCell", for: indexPath) as! FilterSelectedCell
        cell.title.text = filterSelectedArray[indexPath.row].value
        switch filterSelectedArray[indexPath.row].tipo {
        case "nHistoria":
            cell.mainView.backgroundColor = colorGeneral
        case "nombre":
            cell.mainView.backgroundColor = colorGeneral
        case "prueba":
            cell.mainView.backgroundColor = colorPrueba
        case "iq":
            cell.mainView.backgroundColor = colorIQ
        case "patologia":
            cell.mainView.backgroundColor = colorPatologia
        case "intervenidoSi":
            cell.mainView.backgroundColor = colorGeneral
        case "intervenidoNo":
            cell.mainView.backgroundColor = colorGeneral
        default:
            cell.mainView.backgroundColor = UIColor.black
        }
        
        cell.deleteButton.tipo = filterSelectedArray[indexPath.row].tipo
        cell.deleteButton.value = filterSelectedArray[indexPath.row].value
        cell.deleteButton.row = filterSelectedArray[indexPath.row].row
        cell.deleteButton.selectedRow = indexPath.row
        cell.deleteButton.section = filterSelectedArray[indexPath.row].section
        cell.deleteButton.addTarget(self, action: #selector(deleteFilter), for: .touchUpInside)
        
        
        return cell
    }
    
    @objc
    func filterSelected(sender: Checkbox){
        if(sender.isChecked){
            allFiltersData[sender.section][sender.row].selected = true
            print("Selected " + sender.tipo + sender.value)
            filterSelectedArray.append(FilterSelected(
                tipo: sender.tipo,
                value: sender.value,
                section: sender.section,
                row: sender.row))
            selectedCollection.reloadData()
            noHayFiltersText.isHidden = true
            selectedCollection.isHidden = false
        }else{
            allFiltersData[sender.section][sender.row].selected = false
            var cont = 0
            for selections in filterSelectedArray{
                if(selections.value == sender.value){
                    filterSelectedArray.remove(at: cont)
                    selectedCollection.reloadData()
                    if(filterSelectedArray.count == 0){
                        noHayFiltersText.isHidden = false
                        selectedCollection.isHidden = true
                    }
                    return
                }
                cont += 1
            }
        }
    }
    
    @objc
    func deleteFilter(sender: FilterDeleteButton){
        filterSelectedArray.remove(at: sender.selectedRow!)
        if(filterSelectedArray.count == 0){
            noHayFiltersText.isHidden = false
            selectedCollection.isHidden = true
        }
        if(sender.tipo == "nHistoria"){
            isDeleting = true
            allFiltersData[0][0].value = ""
        }else if(sender.tipo == "nombre"){
            isDeleting = true
            allFiltersData[0][1].value = ""
        }else{
            allFiltersData[sender.section!][sender.row!].selected = false   
        }
        filtersTable.reloadData()
        selectedCollection.reloadData()
    }
    
    @objc
    func continuarClicked(){
        for (i,filter) in filterSelectedArray.enumerated(){
            if(filter.tipo == "nHistoria"){
                filterSelectedArray[i].value = nHistoriaValue
            }
            if(filter.tipo == "nombre"){
                filterSelectedArray[i].value = nameValue
            }
        }
        delegate?.filterSelected(selectedFilters: filterSelectedArray)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func closeFilterClicked(){
        delegate?.exitFilter()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func nNombreEditingStarted(sender: UITextField){
        nameValue = sender.text!
        if(!isDeleting){
            if(sender.text != ""){
                allFiltersData[0][1].value = sender.text!
                if(filterSelectedArray.count > 0){
                    if(!filterSelectedArray.contains(where: {$0.tipo == "nombre"})){
                        filterSelectedArray.append(FilterSelected(tipo: "nombre", value: "nombre", section: 0, row: 1))
                        selectedCollection.reloadData()
                        noHayFiltersText.isHidden = true
                        selectedCollection.isHidden = false
                    }
                }else{
                    filterSelectedArray.append(FilterSelected(tipo: "nombre", value:"nombre", section: 0, row: 1))
                    selectedCollection.reloadData()
                    noHayFiltersText.isHidden = true
                    selectedCollection.isHidden = false
                }
            }else{
                allFiltersData[0][1].value = ""
                if(filterSelectedArray.count > 0){
                    var cont = 0
                    for selections in filterSelectedArray{
                        if(selections.tipo == "nombre"){
                            filterSelectedArray.remove(at: cont)
                            selectedCollection.reloadData()
                            if(filterSelectedArray.count == 0){
                                noHayFiltersText.isHidden = false
                                selectedCollection.isHidden = true
                            }
                            return
                        }
                        cont += 1
                    }
                }
            }
        }else{
            isDeleting = false
            sender.text = ""
        }
    }
    
    @objc
    func nHistoriaEditingStarted(sender: UITextField){
        nHistoriaValue = sender.text!
        print("nHistoria text: " + sender.text!)
        if(!isDeleting){
            if(sender.text != ""){
                allFiltersData[0][0].value = sender.text!
                if(filterSelectedArray.count > 0){
                    if(!filterSelectedArray.contains(where: {$0.tipo == "nHistoria"})){
                        filterSelectedArray.append(FilterSelected(tipo: "nHistoria", value: "nHistoria", section: 0, row: 0))
                        selectedCollection.reloadData()
                        noHayFiltersText.isHidden = true
                        selectedCollection.isHidden = false
                    }
                }else{
                    filterSelectedArray.append(FilterSelected(tipo: "nHistoria", value: "nHistoria", section: 0, row: 0))
                    selectedCollection.reloadData()
                    noHayFiltersText.isHidden = true
                    selectedCollection.isHidden = false
                }
            }else{
                allFiltersData[0][0].value = ""
                if(filterSelectedArray.count > 0){
                    var cont = 0
                    for selections in filterSelectedArray{
                        if(selections.tipo == "nHistoria"){
                            filterSelectedArray.remove(at: cont)
                            selectedCollection.reloadData()
                            if(filterSelectedArray.count == 0){
                                noHayFiltersText.isHidden = false
                                selectedCollection.isHidden = true
                            }
                            return
                        }
                        cont += 1
                    }
                }
            }
        }else{
            isDeleting = false
            sender.text = ""
        }
        
    }
}
