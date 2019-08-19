//
//  AnalyticsManager.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 05/08/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AnalyticsManager{
    
    
    static var shared = AnalyticsManager()
    
    private init(){}
    
    func getData() {
        guard let url = URL(string: "https://magenda.appspot.com") else {
            print("ERROR en URL")
            return
        }
        Alamofire.request(url,
                          method: .put)
            .validate()
            .responseJSON { response in
                print("RESPONSE: \(response)")
                //                guard response.result.isSuccess else {
                //                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                //
                //                    return
                //                }
                
                //                guard let value = response.result.value as? [String: Any],
                //                    let rows = value["rows"] as? [[String: Any]] else {
                //                        print("Malformed data received from fetchAllRooms service")
                //
                //                        return
                //                }
        }
    }
    
    
    
}
