//
//  SiguienteCitaRouter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 06/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class SiguienteCitaRouter{
    
    func goToSiguienteCita(navigationController: UINavigationController?, nHistoria: String, idCita: Int){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "siguienteCitaStoryBoard") as! SiguienteCitaViewController
        let presenter = SiguienteCitaPresenter()
        vc.presenter = presenter
        vc.nHistoria = nHistoria
        vc.idCita = idCita
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
