//
//  ConfigurationViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 31/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class ConfigurationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
   
    
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var tabla: UITableView!
    let rowArrays:[[String]] = [["",""],[""]]
    var timeValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.title.text = "Configuración"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }
    
    func setUpView(){
        let preferences = UserDefaults.standard
        let timeTypeKey = "notiTime"
        if preferences.object(forKey: timeTypeKey) == nil {
            timeValue = "08:00"
        } else {
            timeValue = preferences.string(forKey: timeTypeKey)!
        }
    }
    
    @IBAction func cancelarClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowArrays[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
        returnedView.backgroundColor = grisClaro
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "configurationSwitchCell", for: indexPath) as! ConfigurationSwitchCell
                cell.title.text = "Notificaciones activas"
                
                let preferences = UserDefaults.standard
                let notiTypeKey = "notificationsActive"
                if preferences.object(forKey: notiTypeKey) != nil {
                    if(!preferences.bool(forKey: notiTypeKey)){
                        cell.activeSwitch.setOn(false, animated: true)
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "configurationTimeCell", for: indexPath) as! ConfigurationTimeCell
                cell.delegate = self
                cell.timeText.text = timeValue
                return cell
            }
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "configurationNormalCell", for: indexPath) as! ConfigurationNormalCell
            cell.title.text = "Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ConfigurationViewController: TimeCellProtocol{
    func editingClicked(timeField: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        let datePickerView:TimeCellDatePicker = TimeCellDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        if let date = dateFormatter.date(from: timeField.text!) {
            datePickerView.date = date
        }
        
        datePickerView.timeText = timeField
        timeField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ConfigurationViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = colorBase
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ConfigurationViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        timeField.inputAccessoryView = toolBar
    }
    
    @objc
    func datePickerValueChanged(sender:TimeCellDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        sender.timeText.text = dateFormatter.string(from: sender.date)
        let preferences = UserDefaults.standard
        let timeTypeKey = "notiTime"
        preferences.set(dateFormatter.string(from: sender.date), forKey: timeTypeKey)
        preferences.synchronize()
    }
    
    @objc
    func donePicker(){
        self.view.endEditing(true)
    }
    
}
