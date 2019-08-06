//
//  AnadirPruebaRouter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 27/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class AnadirPruebaRouter{
    
    func goToAnadirPrueba(navigationController: UINavigationController?, nHistoria: String, idPrueba: Int){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "anadirPruebaStoryBoard") as! AnadirPruebaViewController
        
        let presenter = AnadirPruebaPresenter()
        vc.presenter = presenter
        vc.nHistoria = nHistoria
        vc.idPrueba = idPrueba
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
