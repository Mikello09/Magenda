//
//  RevisionSlide.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 01/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

protocol RevisionesProtocol {
    func goToRevision(idRevision: Int)
}

class RevisionSlide: UIView{
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var revisionLabel: UILabel!
    var idRevision: Int!
    var delegate: RevisionesProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = CGSize(width: 3,height: 3)
        contentView.layer.shadowRadius = 10
    
    }
    
    @IBAction func revisionClicked(_ sender: UIButton) {
        delegate.goToRevision(idRevision: self.idRevision)
    }
    
}
