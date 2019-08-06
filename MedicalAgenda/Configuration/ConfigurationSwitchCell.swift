//
//  ConfigurationSwitchCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 31/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class ConfigurationSwitchCell: UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        let preferences = UserDefaults.standard
        let authTypeKey = "notificationsActive"
        preferences.set(sender.isOn, forKey: authTypeKey)
        preferences.synchronize()
    }
}
