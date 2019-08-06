//
//  CustomCollectionCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 20/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

protocol CustomCollectionProtocol{
    func anadir(tipo: TipoInfo)
    func rowClicked(tipo: TipoInfo, row: Int)
    func eliminar(tipo: TipoInfo, row: Int)
    func visto(tipo: TipoInfo, row: Int, visto: Bool)
}

class CustomCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var anadirButton: UIButton!
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var emptyImage: UIImageView!
    var data: InfoPaciente!{
        didSet{
            title.text = data.tipo.rawValue
            if(data.informacion.count == 0){
                self.tabla.isHidden = true
                self.emptyImage.isHidden = false
            } else{
                self.tabla.isHidden = false
                self.emptyImage.isHidden = true
                self.tabla.reloadData()
            }
        }
    }
    var delegate: CustomCollectionProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tabla.delegate = self
        tabla.dataSource = self
        
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 3,height: 3)
        view.layer.shadowRadius = 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.informacion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCollectionCell", for: indexPath) as! CustomCollectionTableViewCell
        cell.title.text = self.data.informacion[indexPath.row].titulo
        if let date = self.data.informacion[indexPath.row].fecha{
            if(date == getDefaultDate()){
                cell.fecha.text = ""
            } else {
                cell.fecha.text = formatter.string(from: date)
            }
        } else{
            cell.fecha.text = ""
        }
        cell.vistoView.isHidden = !self.data.informacion[indexPath.row].visto
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.rowClicked(tipo: self.data.tipo, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            self.data.informacion.remove(at: indexPath.row)
            self.tabla.reloadData()
            self.delegate.eliminar(tipo: self.data.tipo, row: indexPath.row)
        }
        deleteAction.image = UIImage(named: "icon_delete")
        deleteAction.backgroundColor = .red
        
        let vistoAction = UIContextualAction(style: .normal, title: nil) {action, view, complete in
            self.data.informacion[indexPath.row].visto = !self.data.informacion[indexPath.row].visto
            self.tabla.reloadData()
            self.delegate.visto(tipo: self.data.tipo, row: indexPath.row, visto: self.data.informacion[indexPath.row].visto)
        }
        vistoAction.image = UIImage(named: "visible")
        vistoAction.backgroundColor = verde
        if(self.data.tipo == .patologia){
            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            return UISwipeActionsConfiguration(actions: [vistoAction, deleteAction])
        }
    }
    
    @IBAction func anadirButtonClicked(_ sender: UIButton) {
        self.delegate.anadir(tipo: self.data.tipo)
    }
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E dd LLLL"
        formatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        formatter.locale = Locale(identifier: "es")
        return formatter
    }()
    
    func getDefaultDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.locale = Locale(identifier: "es")
        return dateFormatter.date(from:"1990-09-09")!
    }
}
