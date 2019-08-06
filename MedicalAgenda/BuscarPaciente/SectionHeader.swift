//
//  SectionHeader.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 30/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class SectionHeader: UITableViewHeaderFooterView{
    @IBOutlet weak var content: SectionContent!
    
}

class SectionContent: UIView{
    @IBOutlet weak var nHistoriaLabel: UILabel!
    @IBOutlet weak var goToPacienteView: UIView!
    
    
}
