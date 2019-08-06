//
//  RevisionesViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 01/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class RevisionesViewController: BaseViewController{
    
    @IBOutlet weak var recordarSwitch: UISwitch!
    @IBOutlet weak var notasText: UITextView!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var fechaBoton: UIButton!
    @IBOutlet weak var headerView: Header!
    var presenter: RevisionesPresenter!
    var nHistoria: String!
    var idRevision: Int!
    var fechaValor: String = ""
    @IBOutlet weak var guardarBoton: UIButton!
    
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
        super.viewDidLoad()
        
        paintNavigationBarWithOnlyBack(title: "")
        headerView.title.text = "Revision"
        
        let tapFecha = UITapGestureRecognizer(target: self, action: #selector(RevisionesViewController.tappedInDate))
        self.fechaLabel.isUserInteractionEnabled = true
        self.fechaLabel.addGestureRecognizer(tapFecha)
        
        guardarBoton.layer.cornerRadius = 3
        guardarBoton.layer.shadowColor = UIColor.gray.cgColor
        guardarBoton.layer.shadowOpacity = 0.8
        guardarBoton.layer.shadowOffset = CGSize(width: 3,height: 3)
        guardarBoton.layer.shadowRadius = 3
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(RevisionesViewController.dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RevisionesViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RevisionesViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if idRevision != -1 {
            llenarCampos()
        }
        
    }
    
    func llenarCampos(){
        let revision = presenter.getRevision(nHistoria: self.nHistoria, idRevision: self.idRevision)
        if revision.fechaRevisar != getDefaultDate(){
            fechaBoton.isHidden = true
            fechaLabel.isHidden = false
            fechaLabel.text = formatter.string(from: revision.fechaRevisar)
            fechaValor = formatterSave.string(from: revision.fechaRevisar)
        }
        notasText.text = revision.notasRevisar
        recordarSwitch.setOn(revision.recordarRevisar, animated: true)
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
    
    @objc
    func tappedInDate(){
        self.view.addSubview(calendarPopup)
    }
    
    @IBAction func fechaBotonClicked(_ sender: UIButton) {
        self.view.addSubview(calendarPopup)
    }
    
    @IBAction func guardarClicked(_ sender: UIButton) {
        if(notasText.text != ""){
            if self.idRevision != -1 {
                presenter.guardarRevision(revision: presenter.getRevision(nHistoria: self.nHistoria, idRevision: self.idRevision),
                                          fecha: fechaValor == "" ? "1990-09-09".toDateFormat : formatterSave.date(from: fechaValor)!,
                                          notas: notasText.text,
                                          recordar: recordarSwitch.isOn,
                                          nHistoria: self.nHistoria)
            }else{
                presenter.guardarRevision(revision: nil,
                                          fecha: fechaValor == "" ? "1990-09-09".toDateFormat : formatterSave.date(from: fechaValor)!,
                                          notas: notasText.text,
                                          recordar: recordarSwitch.isOn,
                                          nHistoria: self.nHistoria)
            }
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(mensaje: "Para poder guardar una revisión tienes que escribir algo en las notas")
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
