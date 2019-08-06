//
//  FechaCollectionViewCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 23/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class FechaCellView: UIView{
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var calendarIcon: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOpacity = 0.8
        mainView.layer.shadowOffset = CGSize(width: 3,height: 3)
        mainView.layer.shadowRadius = 4
        mainView.backgroundColor = colorNoSelected
        mainView.layer.borderWidth = 0
        mainView.layer.borderColor = nil
    }
}
