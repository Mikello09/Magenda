//
//  InformacionPacienteRouter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 12/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit


class InformacionPacienteRouter{
    
    func goToInformacionPaciente(navigationController: UINavigationController?, nHistoria: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "customCollectionViewControllerStoryBoard") as! CustomCollectionViewController
        let presenter = InformacionPacientePresenter()
        presenter.vc = vc
        vc.presenter = presenter
        vc.nHistoria = nHistoria
        navigationController?.pushViewController(vc, animated: true)
    }
}
