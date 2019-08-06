//
//  PatologiaSlide.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 25/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class PatologiaSlide: UIView{
    @IBOutlet weak var patologiaLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = CGSize(width: 3,height: 3)
        contentView.layer.shadowRadius = 10
    }
    
}
