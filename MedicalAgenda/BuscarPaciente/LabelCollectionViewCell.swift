//
//  LabelCollectionViewCell.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 23/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

class LabelCellView: UITableViewCell{
    
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var mainView: UIView!
    var isViewSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(self.viewClicked))
        mainView.isUserInteractionEnabled = true
        mainView.addGestureRecognizer(viewTap)
        
        noSelectedStyle()
    }
    
    @objc
    func viewClicked(){
        if(isViewSelected){noSelectedState()}else{selectedState()}
    }
    
    func noSelectedStyle(){
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOpacity = 0.8
        mainView.layer.shadowOffset = CGSize(width: 3,height: 3)
        mainView.layer.shadowRadius = 4
        mainView.backgroundColor = colorNoSelected
        mainView.layer.borderWidth = 0
        mainView.layer.borderColor = nil
    }
    
    func selectStyle(){
        mainView.layer.shadowOpacity = 0
        mainView.backgroundColor = nil
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = UIColor.white.cgColor
    }
    
    func selectedState(){
        isViewSelected = true
        selectStyle()
    }
    
    func noSelectedState(){
        isViewSelected = false
        noSelectedStyle()
    }
}
