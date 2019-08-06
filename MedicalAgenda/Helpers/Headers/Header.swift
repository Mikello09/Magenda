//
//  Header.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 30/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import Foundation

class Header: UIView{
    
    @IBOutlet weak var title: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width + 50, height: self.frame.height)
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Header", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
