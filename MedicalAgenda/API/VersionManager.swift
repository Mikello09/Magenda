//
//  VersionManager.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez on 16/08/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class VersionManager{
    
    static var shared = VersionManager()
    let url = "https://magenda.appspot.com/version"
    
    private init(){}
    
    func getVersion(){
        
        Alamofire.request(url,
                          method: .get)
            .validate()
            .responseJSON { response in
                if response.error == nil {
                    if let versionFirebase = Double(response.result.value as! String), let versionApp = Double(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String){
                        if(versionFirebase > versionApp){
                            print("ACTUALIZATE!!!")
                        } else {
                            print("VERSION CORRECTA")
                        }
                    }
                } else{
                    print("ERROR en servicio: " + response.error.debugDescription)
                }
        }
    }
}
