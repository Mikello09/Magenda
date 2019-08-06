//
//  AnadirPruebaViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 27/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class AnadirPruebaViewController: BaseViewController, PatologiaSelected{
   
    
    
    var presenter: AnadirPruebaPresenter!
    
    var nHistoria: String!
    var idPrueba: Int!
    
    @IBOutlet weak var recordarSwitch: UISwitch!
    @IBOutlet weak var fechaBoton: UIButton!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var tipoPruebaBoton: UIButton!
    var fechaValor = ""
    @IBOutlet weak var headerView: Header!
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
        
        let tapFecha = UITapGestureRecognizer(target: self, action: #selector(AnadirPruebaViewController.tappedInDate))
        self.fechaLabel.isUserInteractionEnabled = true
        self.fechaLabel.addGestureRecognizer(tapFecha)
        
        
        guardarBoton.layer.cornerRadius = 3
        guardarBoton.layer.shadowColor = UIColor.gray.cgColor
        guardarBoton.layer.shadowOpacity = 0.8
        guardarBoton.layer.shadowOffset = CGSize(width: 3,height: 3)
        guardarBoton.layer.shadowRadius = 3
        
        paintNavigationBarWithOnlyBack(title: "")
        if(idPrueba != -1){
            llenarCampos()
        }else{
            headerView.title.text = "Nueva prueba"
        }
    }
    
    func llenarCampos(){
        let prueba = presenter.getPrueba(nHistoria: self.nHistoria, idPrueba: self.idPrueba)
        headerView.title.text = prueba.tipoPrueba
        tipoPruebaBoton.setTitle(prueba.tipoPrueba, for: .normal)
        if(prueba.fechaPrueba != getDefaultDate()){
            fechaBoton.isHidden = true
            fechaLabel.isHidden = false
            fechaLabel.text = formatter.string(from: prueba.fechaPrueba)
            recordarSwitch.setOn(prueba.recordarPrueba, animated: true)
            fechaValor = formatterSave.string(from: prueba.fechaPrueba)
        }
    }
    
    @IBAction func guardarClicked(_ sender: UIButton) {
        if(tipoPruebaBoton.title(for: .normal)! != "Ninguna"){
            presenter.guardarPrueba(prueba: idPrueba != -1 ? presenter.getPrueba(nHistoria: self.nHistoria, idPrueba: self.idPrueba) : nil,
                                    tipoPrueba: tipoPruebaBoton.title(for: .normal)! == "Ninguna" ? "" : tipoPruebaBoton.title(for: .normal)!,
                                    fechaPrueba: fechaValor == "" ? "1990-09-09".toDateFormat : formatterSave.date(from: fechaValor)!,
                                    recordar: recordarSwitch.isOn,
                                    visto: false,
                                    nHistoria: self.nHistoria)
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(mensaje: "Para poder guardar una prueba tienes que elgir un tipo de prueba")
        }
        
    }
    
    @IBAction func tipoPruebaClicked(_ sender: Any) {
        SeleccionRouter().goToSelection(navigationController: navigationController, delegate: self, tipo: "pruebas", numeroPrueba: nil)
    }
    
    @IBAction func fechaClicked(_ sender: UIButton) {
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
    
    @objc
    func tappedInDate(){
        self.view.addSubview(calendarPopup)
    }
    
    func onPatologiaSelected(patologiaSeleccionada: String, tipo: String, numeroPrueba: Int?) {
        tipoPruebaBoton.setTitle(patologiaSeleccionada, for: .normal)
    }
}
