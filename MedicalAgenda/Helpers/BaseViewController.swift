//
//  BaseViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 07/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController{
    
    
    //DATE////////////////////////////////////
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E dd LLLL"
        formatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        formatter.locale = Locale(identifier: "es")
        return formatter
    }()
    
    let formatterSave: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        formatter.locale = Locale(identifier: "es")
        return formatter
    }()
    
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "es")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    func getDefaultDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.locale = Locale(identifier: "es")
        return dateFormatter.date(from:"1990-09-09")!
    }
    func getCloseDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.locale = Locale(identifier: "es")
        return dateFormatter.date(from:"1890-09-09")!
    }
    
    func toDateFormat(dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.locale = Locale(identifier: "es")
        return dateFormatter.date(from:dateString)!
    }
    //////////////////////////////////////////////////////////////////////
    
    func showAlert(mensaje: String){
        let alert = UIAlertController(title: "Cuidado!!", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension String{
    
    var toDateFormat: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.locale = Locale(identifier: "es") // set locale to reliable US_POSIX
        return dateFormatter.date(from:self)!
    }
    
    var presentationToDateFormat: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E dd LLLL"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.locale = Locale(identifier: "es") // set locale to reliable US_POSIX
        return dateFormatter.date(from:self)!
    }
    
}
