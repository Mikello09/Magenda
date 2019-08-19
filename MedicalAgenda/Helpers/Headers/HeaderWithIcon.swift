//
//  HeaderWithIcon.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez on 16/08/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class HeaderWithIcon: UIView{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIButton!
    var baseViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HeaderWithIcon", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @IBAction func iconClicked(_ sender: UIButton) {
        ExportarRouter().goToExportar(fromViewController: self.baseViewController)
    }
    
}
