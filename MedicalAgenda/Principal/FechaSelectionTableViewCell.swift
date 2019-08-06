//
//  FechaSelectionTableViewCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 22/4/19.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class FechaSelectionTableViewCell: UITableViewCell {
    /*@IBOutlet weak var color: UIView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var cita: UILabel!
    @IBOutlet weak var cellView: UIView!*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*self.cellView.layer.cornerRadius = 5
        self.cellView.layer.borderColor = UIColor.gray.cgColor
        self.cellView.layer.borderWidth = 1*/
        
        /*self.cellView.clipsToBounds = true
        self.cellView.layer.shadowPath =
            UIBezierPath(roundedRect: self.cellView.bounds,
                         cornerRadius: self.cellView.layer.cornerRadius).cgPath
        self.cellView.layer.shadowColor = UIColor.black.cgColor
        self.cellView.layer.shadowOpacity = 0.5
        self.cellView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.cellView.layer.shadowRadius = 1
        self.cellView.layer.masksToBounds = false*/
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
