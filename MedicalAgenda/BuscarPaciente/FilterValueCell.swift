//
//  FilterValueCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 25/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class FilterValueCell: UITableViewCell{
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var cellSelected: Checkbox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpCheckBox()
        
    }
    
    func setUpCheckBox(){
        cellSelected.checkedBorderColor = colorBase
        cellSelected.uncheckedBorderColor = .lightGray
        cellSelected.borderStyle = .circle
        cellSelected.checkmarkStyle = .circle
        cellSelected.checkmarkColor = colorBase
        cellSelected.useHapticFeedback = true
        cellSelected.increasedTouchRadius = 5 // Default
    }
}
