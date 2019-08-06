//
//  BuscarPacienteTableViewCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 23/4/19.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class BuscarPacienteTableViewCell: UITableViewCell{
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var numeroHistoria: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
