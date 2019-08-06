//
//  DetalleTabViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 21/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit


class DetalleTabViewController: BaseViewController, UITextViewDelegate{
    @IBOutlet weak var anatomiaPatologicaText: UITextView!
    @IBOutlet weak var complicacionesText: UITextView!
    @IBOutlet weak var notasText: UITextView!
    @IBOutlet weak var guardarBoton: UIButton!
    
    var presenter: IntervencionesPresenter!
    var idIQ: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(DetalleTabViewController.dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapView)
        
        guardarBoton.layer.cornerRadius = 3
        guardarBoton.layer.shadowColor = UIColor.gray.cgColor
        guardarBoton.layer.shadowOpacity = 0.8
        guardarBoton.layer.shadowOffset = CGSize(width: 3,height: 3)
        guardarBoton.layer.shadowRadius = 3
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetalleTabViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetalleTabViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        llenarView()
    }
    
    func llenarView(){
        if let id = idIQ{
            anatomiaPatologicaText.text = presenter.getIQModel(idIQ: id).anatomiaPatologica
            complicacionesText.text = presenter.getIQModel(idIQ: id).complicaciones
            notasText.text = presenter.getIQModel(idIQ: id).notasDetalles
        }
    }
    
    @IBAction func guardar(_ sender: UIButton) {
        presenter.setIntervencionDetalles(
            intervencion: presenter.getIntervencionQuirurgica(idIQ: self.idIQ),
            anatomiaPatologica: anatomiaPatologicaText.text,
            complicaciones: complicacionesText.text,
            notas: notasText.text)
        navigationController?.popViewController(animated: true)
    }
    
    
    //KEYBOARD
    @objc
    func dismissKeyboard(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        self.view.frame.origin.y -= keyboardFrame.height
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.frame.origin.y = 0
    }
}
