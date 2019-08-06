//
//  IntervencionSlide.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 26/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

protocol IntervencionSlideProtocol {
    func vistoChanged(visto: Bool)
    func goToIntervencionDetail(intervencionId: Int)
}

class IntervencionSlide: UIView{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var intervencionLabel: UILabel!
    @IBOutlet weak var switchVisto: UISwitch!
    var intervencionId: Int = 0
    var delegate: IntervencionSlideProtocol!
    
    override func awakeFromNib() {
        //super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = CGSize(width: 3,height: 3)
        contentView.layer.shadowRadius = 10
    }
    
    @IBAction func goToIntervencionDetails(_ sender: UIButton) {
        delegate.goToIntervencionDetail(intervencionId: intervencionId)
    }
    
    @IBAction func switchClicked(_ sender: UISwitch) {
        delegate.vistoChanged(visto: sender.isOn)
    }
}
