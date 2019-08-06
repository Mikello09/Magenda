//
//  PendientesTableViewCellSimple.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 08/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class PendientesTableViewCellSimple: UITableViewCell{
    
    @IBOutlet weak var nHistoria: UILabel!
    @IBOutlet weak var visto: VistoSwitchClass!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var color: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var fecha: UILabel!
    var seleccion: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOpacity = 0.8
        mainView.layer.shadowOffset = CGSize(width: 3,height: 3)
        mainView.layer.shadowRadius = 4
    }
    
    func setCapa(){
        mainView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    }
    
}
