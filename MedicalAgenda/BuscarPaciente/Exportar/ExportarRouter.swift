//
//  ExportarRouter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez on 16/08/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit


class ExportarRouter{
    
    func goToExportar(fromViewController: UIViewController){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "exportarStoryBoard") as! ExportarViewController
        fromViewController.present(vc, animated: true, completion: nil)
    }
    
}
