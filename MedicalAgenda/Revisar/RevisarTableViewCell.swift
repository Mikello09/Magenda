//
//  RevisarTableViewCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 29/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class RevisarTableViewCell: UITableViewCell{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var visto: VistoSwitchClass!
    @IBOutlet weak var notas: UITextView!
    @IBOutlet weak var subtitulo: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var color: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOpacity = 0.8
        mainView.layer.shadowOffset = CGSize(width: 3,height: 3)
        mainView.layer.shadowRadius = 4
    }
    
}
