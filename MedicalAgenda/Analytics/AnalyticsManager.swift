//
//  AnalyticsManager.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 05/08/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class AnalyticsManager{
    
    
    static var shared = AnalyticsManager()
    
    private init(){}
    
    func saveData(page: String){
        
        let url = URL(string: "https:8080-dot-8275646-dot-devshell.appspot.com/?authuser=0")
        
    }
    
}
