//
//  PruebasSlide.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 27/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

protocol PruebasSlideProtocol{
    func goToPruebaDetail(id: Int)
}

class PruebasSlide: UIView{
    @IBOutlet weak var pruebaLabel: UILabel!
    var delegate: PruebasSlideProtocol!
    var idPrueba: Int!
    @IBOutlet weak var contentView: UIView!
    
    override func awakeFromNib() {
        //super.awakeFromNib()
        
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = colorPrueba.cgColor
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowColor = colorPrueba.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 3,height: 3)
        contentView.layer.shadowRadius = 5
        
    }
    
    @IBAction func pruebaClicked(_ sender: UIButton) {
        delegate.goToPruebaDetail(id: self.idPrueba)
    }
    
}
