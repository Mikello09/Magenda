//
//  ConfigurationTimeCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 01/08/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

protocol TimeCellProtocol{
    func editingClicked(timeField: UITextField)
}

class ConfigurationTimeCell: UITableViewCell{
    
    @IBOutlet weak var timeText: UITextField!
    var delegate: TimeCellProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func timeClicked(_ sender: UITextField) {
        delegate.editingClicked(timeField: self.timeText)
    }
    
}

class TimeCellDatePicker: UIDatePicker{
    var timeText: UITextField!
}
