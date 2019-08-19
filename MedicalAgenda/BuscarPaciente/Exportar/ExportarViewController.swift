//
//  ExportarViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez on 16/08/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class ExportarViewController: BaseViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createCsvFile(){
        let fileName = "Prueva.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        let csvText = "Date,Task,Time Started,Time Ended\nAAA,BBB,CCC"
        
        if let ruta = path{
            do {
                try csvText.write(to: ruta, atomically: true, encoding: String.Encoding.utf8)
                
                let vc = UIActivityViewController(activityItems: [ruta], applicationActivities: [])
                vc.excludedActivityTypes = [
                    UIActivityType.assignToContact,
                    UIActivityType.saveToCameraRoll,
                    UIActivityType.postToFlickr,
                    UIActivityType.postToVimeo,
                    UIActivityType.postToTencentWeibo,
                    UIActivityType.postToTwitter,
                    UIActivityType.postToFacebook,
                    UIActivityType.openInIBooks
                ]
                present(vc, animated: true, completion: nil)
            } catch {
                print("Failed to create file")
                print("\(error)")
            }
        }
    }
    @IBAction func export(_ sender: UIButton) {
        createCsvFile()
    }
    
}
