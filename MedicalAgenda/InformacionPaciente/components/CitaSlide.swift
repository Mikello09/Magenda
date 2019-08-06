//
//  CitaSlide.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 02/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

protocol CitaSlideProtocol{
    func goToCita(idCita: Int)
}

class CitaSlide: UIView{
    
    @IBOutlet weak var citaLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    var idCita: Int!
    var delegate: CitaSlideProtocol!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = CGSize(width: 3,height: 3)
        contentView.layer.shadowRadius = 10
    }
    
    @IBAction func goToCita(_ sender: UIButton) {
        delegate.goToCita(idCita: self.idCita)
    }
}
