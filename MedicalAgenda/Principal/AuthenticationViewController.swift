//
//  AuthenticationViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 07/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication


class AuthenticationViewController: BaseViewController{
    
    @IBOutlet weak var fingerButton: UIButton!
    @IBOutlet weak var fingerView: UIView!
    @IBOutlet weak var codeView: UIView!
    private var isFirstLaunch: Bool = true
    
    override func viewDidLoad() {
        if #available(iOS 8.0, macOS 10.12.1, *) {
        } else {
            fingerButton.isEnabled = false
        }
        setShadow(toView: fingerView)
        setShadow(toView: codeView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(isFirstLaunch){
            readPreferences()
        }
    }
    
    func readPreferences(){
        isFirstLaunch = false
        let preferences = UserDefaults.standard
        let authTypeKey = "authType"
        if preferences.object(forKey: authTypeKey) == nil {
            //  No hay authType
        } else {
            let authType = preferences.string(forKey: authTypeKey)
            if(authType == "finger"){
                listenForBiometric()
            } else {
                performSegue(withIdentifier: "codePop", sender: nil)
            }
        }
    }
    
    func savePreferences(authType: String){
        let preferences = UserDefaults.standard
        let authTypeKey = "authType"
        preferences.set(authType, forKey: authTypeKey)
        preferences.synchronize()
    }
    
    func setShadow(toView: UIView){
        toView.layer.cornerRadius = 10
        toView.layer.shadowColor = UIColor.gray.cgColor
        toView.layer.shadowOpacity = 0.8
        toView.layer.shadowOffset = CGSize(width: 3,height: 3)
        toView.layer.shadowRadius = 10
    }
    
    @IBAction func authenticateClicked(_ sender: UIButton) {
        savePreferences(authType: "finger")
        listenForBiometric()
    }
    
    @IBAction func codeClicked(_ sender: UIButton) {
        savePreferences(authType: "code")
        performSegue(withIdentifier: "codePop", sender: nil)
    }
    
    func listenForBiometric(){
        print("hello there!.. You have clicked the touch ID")
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Auténticate para entrar en tu agenda!!"
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            self.performSegue(withIdentifier: "goToPrincipal", sender: nil)
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                
            }
        } else {
            // Fallback on earlier versions
        
        }
    }
    
    @IBAction func refrescarContrasenaClicked(_ sender: UIButton) {
        let preferences = UserDefaults.standard
        let authTypeKey = "authType"
        preferences.set(nil, forKey: authTypeKey)
        let passCodeKey = "passCode"
        preferences.set(nil, forKey: passCodeKey)
        preferences.synchronize()
    }
}

