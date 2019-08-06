//
//  PruebasTableViewCell.swift
//  MedicalAgenda
//
//  Created by Juan Carlos Lopez Armendariz on 16/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class PruebasTableViewCell: UITableViewCell{
    
    @IBOutlet weak var fechaText: PruebaCalendarioBotonClass!
    @IBOutlet weak var escogePrueba: SeleccionarItemBotonClass!
    @IBOutlet weak var recordar: UISwitch!
    @IBOutlet weak var calendario: PruebaCalendarioBotonClass!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
