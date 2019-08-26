//
//  ResultadosMainCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 27/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit



class ResultadosMainCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var subTableHeight: NSLayoutConstraint!
    @IBOutlet weak var patologiaLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    @IBOutlet weak var verPaciente: UIButton!
    @IBOutlet weak var tablaSub: UITableView!

    var nHistoria: String!
    var subCellData = [BusquedaCeldasSub]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tablaSub.delegate = self
        tablaSub.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultadosSubCell", for: indexPath) as! ResultadosSubCell
        cell.item.text = subCellData[indexPath.row].item
        cell.fecha.text = subCellData[indexPath.row].fecha
        switch subCellData[indexPath.row].tipo {
        case "IQ":
            cell.color.backgroundColor = colorIQ
        case "Prueba":
            cell.color.backgroundColor = colorPrueba
        case "Preanestesia":
            cell.color.backgroundColor = colorIQ
        case "ListaEspera":
            cell.color.backgroundColor = colorIQ
        case "Revisar":
            cell.color.backgroundColor = colorRevisar
        case "SiguienteCita":
            cell.color.backgroundColor = colorSiguienteCita
        default:
            cell.color.backgroundColor = UIColor.black
        }
        return cell
    }
    
    func setSubCellData(data: [BusquedaCeldasSub]){
        self.subCellData = data
        subTableHeight.constant = 0
        for subCelda in data{
            subTableHeight.constant += 100
        }
    }
    
    
}
