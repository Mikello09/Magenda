//
//  ResultadosSubCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 27/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class ResultadosSubCell: UITableViewCell{
    
    @IBOutlet weak var color: UIView!
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOpacity = 0.8
        mainView.layer.shadowOffset = CGSize(width: 3,height: 3)
        mainView.layer.shadowRadius = 4
    
        
    }
    
    
}
