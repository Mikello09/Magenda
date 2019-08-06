//
//  SeleccionRouter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 13/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class SeleccionRouter{
    
    func goToSelection(navigationController: UINavigationController?, delegate: PatologiaSelected, tipo: String?, numeroPrueba: Int?){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "anadirItemsStoryboard") as! PatologiasSelectionVC
        vc.delegate = delegate
        vc.tipo = tipo ?? ""
        vc.numeroPrueba = numeroPrueba ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
