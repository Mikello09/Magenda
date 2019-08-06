//
//  RevisionesRouter.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 01/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class RevisionesRouter{
    
    func goToRevisiones(navigationController: UINavigationController?, nHistoria: String, idRevision: Int){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "revisionesStoryboard") as! RevisionesViewController
        
        let presenter = RevisionesPresenter()
        vc.presenter = presenter
        vc.nHistoria = nHistoria
        vc.idRevision = idRevision
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
