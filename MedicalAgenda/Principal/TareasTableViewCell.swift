//
//  TareasTableViewCell.swift
//  MedicalAgenda
//
//  Created by Juan Carlos Lopez Armendariz on 15/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class TareasTableViewCell: UITableViewCell{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var color: UIView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var cita: UILabel!
    @IBOutlet weak var checkVisto: VistoSwitchClass!
    @IBOutlet weak var notasText: UITextView!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var topNotasMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomNotasMargin: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOpacity = 0.8
        mainView.layer.shadowOffset = CGSize(width: 3,height: 3)
        mainView.layer.shadowRadius = 4
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
