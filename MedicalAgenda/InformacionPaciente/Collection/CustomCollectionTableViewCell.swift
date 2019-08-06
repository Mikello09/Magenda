//
//  CustomCollectionTableViewCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 21/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionTableViewCell: UITableViewCell{
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var vistoImage: UIImageView!
    @IBOutlet weak var vistoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 3,height: 3)
        view.layer.shadowRadius = 4
    }
    
}
