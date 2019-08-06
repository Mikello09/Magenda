//
//  FilterSelectedBuscarCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 26/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class FilterSelectedBuscarCell: UICollectionViewCell{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var deleteButton: FilterDeleteButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 10
        
    }
    
}
