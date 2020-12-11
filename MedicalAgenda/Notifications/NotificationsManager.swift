//
//  NotificationsManager.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 23/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit



class NotificationsManager{
    
    let notificationCenter = UNUserNotificationCenter.current()
    var savedNotifications = [Double]()
    var fromNotifications: Bool = false
    static let shared = NotificationsManager()
    
    private init(){}
    
    func isNotificationAvailbale() {
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                //Notifications NO available
            } else {
                //Notifications available
            }
        }
    }
    
    func generateNotification(fecha: Date){
        
        let preferences = UserDefaults.standard
        let notiTypeKey = "notificationsActive"
        if preferences.object(forKey: notiTypeKey) == nil {
            createNotification(fecha: fecha)
        } else {
            if(preferences.bool(forKey: notiTypeKey)){
                createNotification(fecha: fecha)
            }
        }
    }
    
    func createNotification(fecha: Date){
        let content = UNMutableNotificationContent()
        content.title = "Revisa MAgenda"
        content.body = "Hoy tienes tareas pendientes. ¡Manos a la obra!"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        let td = calculateSavedTime(fecha: fecha)
        let interval = td.timeIntervalSinceNow
        if(interval > 0 && manageSavedNotifications(savedNotifications: savedNotifications, interval: interval)){//no es una fecha del pasado
            savedNotifications.append(interval)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let identifier = interval.description//todas las notificaciones de cada dia mismo identificador
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    func manageSavedNotifications(savedNotifications: [Double], interval: Double) -> Bool{
        for notification in savedNotifications{
            if (notification < (interval + 100) && notification > (interval - 100)){return false}
        }
        return true
    }
    
    func cancelAllNotifications(){
        notificationCenter.removeAllPendingNotificationRequests()
        savedNotifications.removeAll()
    }
    
    func clearBadge(){
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func calculateSavedTime(fecha: Date) -> Date{
        let preferences = UserDefaults.standard
        let timeTypeKey = "notiTime"
        if preferences.object(forKey: timeTypeKey) == nil {
            return Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: fecha) ?? Date()
        } else {
            let timeValue = preferences.string(forKey: timeTypeKey) ?? ""
            let hour: Int = Int(timeValue.components(separatedBy: ":")[0]) ?? 0
            let minute: Int = Int(timeValue.components(separatedBy: ":")[1]) ?? 0
            return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: fecha) ?? Date()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
            NotificationsManager.shared.fromNotifications = true
            completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        NotificationsManager.shared.fromNotifications = true
        completionHandler([.sound, .alert])
    }
}
