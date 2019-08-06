//
//  AnadirIntervencionViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 19/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class AnadirIntervencionViewController: BaseViewController, UITextViewDelegate, PatologiaSelected{
    
    
    
    @IBOutlet weak var headerView: Header!
    var presenter: IntervencionesPresenter?
    @IBOutlet weak var tipoIqButton: UIButton!
    @IBOutlet weak var fechaIqButton: UIButton!
    @IBOutlet weak var fechaIqLabel: UILabel!
    @IBOutlet weak var recordarIqSwitch: UISwitch!
    @IBOutlet weak var notasIqTextView: UITextView!
    @IBOutlet weak var intervenidoSwitch: UISwitch!
    @IBOutlet weak var fechaListaEsperaButton: UIButton!
    @IBOutlet weak var fechaListaEsperaLabel: UILabel!
    @IBOutlet weak var fechaListaEsperaView: UIView!
    @IBOutlet weak var preanestesiaRealizadaSwitch: UISwitch!
    @IBOutlet weak var preanestesiaRealizadaView: UIView!
    @IBOutlet weak var fechaPreanestesiaButton: UIButton!
    @IBOutlet weak var fechaPreanestesiaLabel: UILabel!
    @IBOutlet weak var fechaPreanestesiaView: UIView!
    @IBOutlet weak var preanestesiaNotasTextView: UITextView!
    @IBOutlet weak var notasPreanestesiaView: UIView!
    @IBOutlet weak var guardarBoton: UIButton!
    
    private var keyboardCanChangeView: Bool = true
    var valorFechaIntervencion = ""
    var valorFehcaListaEspera = ""
    var valorFechaPreanestesia = ""
    
    var idIntervencion: Int?
    
    
    private lazy var calendarPopupListaEspera: CalendarPopUpView = {
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
            self?.setDate(date,self?.calendarPopupListaEspera, (self?.fechaListaEsperaLabel)!, (self?.fechaListaEsperaButton)!)
        }
        
        return calendar
    }()
    
    private lazy var calendarPopupIntervencion: CalendarPopUpView = {
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
            self?.setDate(date,self?.calendarPopupIntervencion, (self?.fechaIqLabel)!, (self?.fechaIqButton)!)
        }
        
        return calendar
    }()
    
    private lazy var calendarPopupPreanestesia: CalendarPopUpView = {
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
            self?.setDate(date,self?.calendarPopupPreanestesia, (self?.fechaPreanestesiaLabel)!, (self?.fechaPreanestesiaButton)!)
        }
        
        return calendar
    }()
    
    override func viewDidLoad() {
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(AnadirIntervencionViewController.dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AnadirIntervencionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AnadirIntervencionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        guardarBoton.layer.cornerRadius = 3
        guardarBoton.layer.shadowColor = UIColor.gray.cgColor
        guardarBoton.layer.shadowOpacity = 0.8
        guardarBoton.layer.shadowOffset = CGSize(width: 3,height: 3)
        guardarBoton.layer.shadowRadius = 3
        
        let tapFechaIntervencion = UITapGestureRecognizer(target: self, action: #selector(AnadirIntervencionViewController.popIntervencionCalendar))
        self.fechaIqLabel.isUserInteractionEnabled = true
        self.fechaIqLabel.addGestureRecognizer(tapFechaIntervencion)
        
        let tapFechaListaEspera = UITapGestureRecognizer(target: self, action: #selector(AnadirIntervencionViewController.popListaEsperaCalendar))
        self.fechaListaEsperaLabel.isUserInteractionEnabled = true
        self.fechaListaEsperaLabel.addGestureRecognizer(tapFechaListaEspera)
        
        let tapFechaPreanestesia = UITapGestureRecognizer(target: self, action: #selector(AnadirIntervencionViewController.popPreanestesiaCalendar))
        self.fechaPreanestesiaLabel.isUserInteractionEnabled = true
        self.fechaPreanestesiaLabel.addGestureRecognizer(tapFechaPreanestesia)
        
        if let idIntervencion = idIntervencion{
            llenarCampos(idIntervencion:idIntervencion)
        }else{
            paintNavigationBarWithOnlyBack(title: "")
            headerView.title.text = "Intervención"
        }
    }
    
    @IBAction func tipoIqButtonClicked(_ sender: UIButton) {
        SeleccionRouter().goToSelection(navigationController: navigationController, delegate: self, tipo: "iq", numeroPrueba: nil)
    }
    @IBAction func fechaIqButtonClicked(_ sender: UIButton) {
        view.addSubview(calendarPopupIntervencion)
    }
    @IBAction func intervenidoSwitchClicked(_ sender: UISwitch) {
        changeIntervenidoView(isOn: sender.isOn)
    }
    @IBAction func fechaListaEsperaButtonClicked(_ sender: UIButton) {
        view.addSubview(calendarPopupListaEspera)
    }
    @IBAction func preanestesiaRealizadaSwitchClicked(_ sender: UISwitch) {
    }
    @IBAction func fechaPreanestesiaButtonClicked(_ sender: UIButton) {
        view.addSubview(calendarPopupPreanestesia)
    }
    @IBAction func guardarButtonClicked(_ sender: UIButton) {
        if(tipoIqButton.title(for: .normal)! != "Ninguna"){
            var intervencionQuirurgica: IntervencionQuirurgica
            if let idIQ = idIntervencion{
                intervencionQuirurgica = (presenter?.getIntervencionQuirurgica(idIQ: idIQ))!
            }else{
                intervencionQuirurgica = IntervencionQuirurgica()
            }
            let isNew = idIntervencion == nil ? true : false
            presenter?.setIntervencion(
                tipoIQ: tipoIqButton.title(for: .normal) ?? "",
                fechaIntervencion: valorFechaIntervencion == "" ? "1990-09-09".toDateFormat : valorFechaIntervencion.toDateFormat,
                recordarIntervencion: recordarIqSwitch.isOn,
                notasIntervencion: notasIqTextView.text,
                intervenido: intervenidoSwitch.isOn,
                fechaListaEspera: valorFehcaListaEspera == "" ? "1990-09-09".toDateFormat : valorFehcaListaEspera.toDateFormat,
                preanestesiaRealizada: preanestesiaRealizadaSwitch.isOn,
                fechaPreanestesia: valorFechaPreanestesia == "" ? "1990-09-09".toDateFormat : valorFechaPreanestesia.toDateFormat,
                notasPreanestesia: preanestesiaNotasTextView.text,
                intervencionQuirurgica: intervencionQuirurgica,
                isNew: isNew)
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(mensaje: "Para poder guardar una intervención tienes que elegir un tipo de intervención")
        }
    }
    func changeIntervenidoView(isOn: Bool){
        self.fechaListaEsperaView.isHidden = isOn
        self.preanestesiaRealizadaView.isHidden = isOn
        self.notasPreanestesiaView.isHidden = isOn
        self.fechaPreanestesiaView.isHidden = isOn
    }
    func onPatologiaSelected(patologiaSeleccionada: String, tipo: String, numeroPrueba: Int?) {
        tipoIqButton.setTitle(patologiaSeleccionada, for: .normal)
    }
    
    //LLENAR
    func llenarCampos(idIntervencion:Int){
        headerView.isHidden = true
        if let iq = presenter?.getIQModel(idIQ: idIntervencion){
            tipoIqButton.setTitle(iq.tipoIntervencion, for: .normal)
            if(iq.fechaIntervencion != getDefaultDate()){
                fechaIqButton.isHidden = true
                valorFechaIntervencion = formatterSave.string(from: iq.fechaIntervencion)
                fechaIqLabel.text = formatter.string(from: iq.fechaIntervencion)
            }
            recordarIqSwitch.isOn = iq.recordarIntervencion
            notasIqTextView.text = iq.notasIntervencion
            intervenidoSwitch.isOn = iq.intervenido
            changeIntervenidoView(isOn: iq.intervenido)
            if(iq.fechaListaEspera != getDefaultDate()){
                fechaListaEsperaButton.isHidden = true
                valorFehcaListaEspera = formatterSave.string(from: iq.fechaListaEspera)
                fechaListaEsperaLabel.text = formatter.string(from: iq.fechaListaEspera)
            }
            preanestesiaRealizadaSwitch.isOn = iq.preanestesiaRealizada
            if(iq.fechaPreanestesia != getDefaultDate()){
                fechaPreanestesiaButton.isHidden = true
                valorFechaPreanestesia = formatterSave.string(from: iq.fechaPreanestesia)
                fechaPreanestesiaLabel.text = formatter.string(from: iq.fechaPreanestesia)
            }
            preanestesiaNotasTextView.text = iq.notasPreanestesia
        }
    }
    
    
    ///CALENDAR POPUP
    @objc
    func popIntervencionCalendar(sender:UITapGestureRecognizer){
        print("intervencion pop")
        self.view.addSubview(calendarPopupIntervencion)
    }
    @objc
    func popPreanestesiaCalendar(sender:UITapGestureRecognizer){
        print("preanestesia pop")
        self.view.addSubview(calendarPopupPreanestesia)
    }
    @objc
    func popListaEsperaCalendar(sender:UITapGestureRecognizer){
        print("listaEspera pop")
        self.view.addSubview(calendarPopupListaEspera)
    }
    func setDate(_ date: Date, _ calendario: CalendarPopUpView?, _ label: UILabel, _ boton: UIButton){
        calendario!.removeFromSuperview()
        var valor = ""
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                valor = formatterSave.string(from: date)
                label.isHidden = false
                label.text = formatter.string(from: date)
                boton.isHidden = true
            }else{
                valor = ""
                label.isHidden = true
                label.text = ""
                boton.isHidden = false
            }
            switch calendario{
                case calendarPopupIntervencion:
                    valorFechaIntervencion = valor
                    break;
                case calendarPopupPreanestesia:
                    valorFechaPreanestesia = valor
                    break;
                case calendarPopupListaEspera:
                    valorFehcaListaEspera = valor
                    break;
                default:
                    print("error")
                    break;
            }
        }
    }
    
    
    ///KEYBOARD
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        keyboardCanChangeView = true
    }
    
}
