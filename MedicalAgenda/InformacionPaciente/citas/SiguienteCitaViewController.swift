//
//  SiguienteCitaViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 06/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class SiguienteCitaViewController: BaseViewController{
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var fechaBoton: UIButton!
    @IBOutlet weak var notasText: UITextView!
    @IBOutlet weak var recordarSwitch: UISwitch!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var guardarBoton: UIButton!
    
    var presenter: SiguienteCitaPresenter!
    var nHistoria: String!
    var idCita: Int!
    var fechaValor: String = ""
    
    private lazy var calendarPopup: CalendarPopUpView = {
        let frame = CGRect(
            x: 15,
            y: view.frame.height/2 - 150,
            width: view.frame.width - 30,
            height: 365
        )
        let calendar = CalendarPopUpView(frame: frame)
        calendar.backgroundColor = .clear
        calendar.layer.shadowColor = UIColor.black.cgColor
        calendar.layer.shadowOpacity = 0.4
        calendar.layer.shadowOffset = .zero
        calendar.layer.shadowRadius = 5
        calendar.didSelectDay = { [weak self] date in
            self?.setDate(date)
        }
        
        return calendar
    }()
    
    override func viewDidLoad() {
        paintNavigationBarWithOnlyBack(title: "")
        headerView.title.text = "Cita"
        
        let tapFecha = UITapGestureRecognizer(target: self, action: #selector(SiguienteCitaViewController.tappedInDate))
        self.fechaLabel.isUserInteractionEnabled = true
        self.fechaLabel.addGestureRecognizer(tapFecha)
        
        guardarBoton.layer.cornerRadius = 3
        guardarBoton.layer.shadowColor = UIColor.gray.cgColor
        guardarBoton.layer.shadowOpacity = 0.8
        guardarBoton.layer.shadowOffset = CGSize(width: 3,height: 3)
        guardarBoton.layer.shadowRadius = 3
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(SiguienteCitaViewController.dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SiguienteCitaViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SiguienteCitaViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if(self.idCita != -1){
            llenarCampos()
        }
    }
    
    func llenarCampos(){
        let cita = presenter.getCita(nHistoria: self.nHistoria, idCita: self.idCita)
        if cita.fechaSiguienteCita != getDefaultDate(){
            fechaBoton.isHidden = true
            fechaLabel.isHidden = false
            fechaLabel.text = formatter.string(from: cita.fechaSiguienteCita)
            fechaValor = formatterSave.string(from: cita.fechaSiguienteCita)
        }
        notasText.text = cita.notasSiguienteCita
        recordarSwitch.setOn(cita.recordarSiguienteCita, animated: true)
    }
    
    @objc
    func tappedInDate(){
        self.view.addSubview(calendarPopup)
    }
    
    func setDate(_ date: Date){
        calendarPopup.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                fechaValor = formatterSave.string(from: date)
                fechaLabel.isHidden = false
                fechaBoton.isHidden = true
                fechaLabel.text = formatter.string(from: date)
            }else{
                fechaValor = ""
                fechaLabel.isHidden = true
                fechaLabel.text = ""
                fechaBoton.isHidden = false
            }
        }
    }
    
    @IBAction func fechaBotonClicked(_ sender: UIButton) {
        self.view.addSubview(calendarPopup)
    }
    
    @IBAction func guardarClicked(_ sender: UIButton) {
        if(fechaValor != ""){
            if self.idCita != -1 {
                presenter.guardarCita(siguienteCita: presenter.getCita(nHistoria: self.nHistoria, idCita: self.idCita),
                                      fecha: fechaValor == "" ? "1990-09-09".toDateFormat : formatterSave.date(from: fechaValor)!,
                                      notas: notasText.text,
                                      recordar: recordarSwitch.isOn,
                                      nHistoria: self.nHistoria)
            }else{
                presenter.guardarCita(siguienteCita: nil,
                                      fecha: fechaValor == "" ? "1990-09-09".toDateFormat : formatterSave.date(from: fechaValor)!,
                                      notas: notasText.text,
                                      recordar: recordarSwitch.isOn,
                                      nHistoria: self.nHistoria)
            }
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(mensaje: "Para poder guardar una cita tienes que elegir una fecha")
        }
        
    }
    
    ///KEYBOARD
    @objc
    func dismissKeyboard(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        /*guard let userInfo = notification.userInfo else {return}
         guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
         let keyboardFrame = keyboardSize.cgRectValue
         self.view.frame.origin.y -= keyboardFrame.height*/
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //self.view.frame.origin.y = 0
    }
}

