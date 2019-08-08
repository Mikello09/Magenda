//
//  PassCodeViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 09/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

enum ModoPassCode{
    case nuevo
    case veterano
}




class PassCodeViewController: BaseViewController{
   
    @IBOutlet weak var uno: UILabel!
    @IBOutlet weak var dos: UILabel!
    @IBOutlet weak var tres: UILabel!
    @IBOutlet weak var cuatro: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var hiddenText: UITextField!
    var mode: ModoPassCode = .nuevo
    
    override func viewDidLoad() {
        hiddenText.becomeFirstResponder()
        readPreferences()
    }
    
    func readPreferences(){
        let preferences = UserDefaults.standard
        let passCodeKey = "passCode"
        if preferences.object(forKey: passCodeKey) == nil {
            mode = .nuevo
            infoLabel.text = "Introduce los 4 dígitos que van a formar parte de tu contraseña"
        } else {
            mode = .veterano
            infoLabel.text = "Intróduce tu contraseña"
        }
    }
    
    func savePreferences(passCode: String){
        let preferences = UserDefaults.standard
        let passCodeKey = "passCode"
        preferences.set(passCode, forKey: passCodeKey)
        preferences.synchronize()
    }
    
    @IBAction func cancelarClicked(_ sender: UIButton) {
        hiddenText.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func whereToGo(contraseña: String){
        switch mode{
        case .nuevo:
            savePreferences(passCode: contraseña)
            uno.text = "-"
            dos.text = "-"
            tres.text = "-"
            cuatro.text = "-"
            hiddenText.text = ""
            infoLabel.text = "Intróduce tu contraseña"
            mode = .veterano
        case .veterano:
            let preferences = UserDefaults.standard
            let passCodeKey = "passCode"
            if (preferences.string(forKey: passCodeKey) == contraseña){
                hiddenText.endEditing(true)
                self.performSegue(withIdentifier: "goToPrincipalFromCode", sender: nil)
            }else{
                uno.text = "-"
                dos.text = "-"
                tres.text = "-"
                cuatro.text = "-"
                hiddenText.text = ""
                infoLabel.text = "Intróduce tu contraseña"
            }
        }
    }
    
    @IBAction func editingHasChanged(_ sender: UITextField) {
        var passCode = sender.text ?? ""
        switch sender.text?.count {
        case 0:
            uno.text = "-"
            dos.text = "-"
            tres.text = "-"
            cuatro.text = "-"
        case 1:
            uno.text = "*"
            dos.text = "-"
            tres.text = "-"
            cuatro.text = "-"
        case 2:
            uno.text = "*"
            dos.text = "*"
            tres.text = "-"
            cuatro.text = "-"
        case 3:
            uno.text = "*"
            dos.text = "*"
            tres.text = "*"
            cuatro.text = "-"
        case 4:
            uno.text = "*"
            dos.text = "*"
            tres.text = "*"
            cuatro.text = "*"
            whereToGo(contraseña: sender.text!)
        default:
            uno.text = "-"
            dos.text = "-"
            tres.text = "-"
            cuatro.text = "-"
        }
    }
    
    
}
