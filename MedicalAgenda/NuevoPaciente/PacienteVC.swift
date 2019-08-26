//
//  PacienteVC.swift
//  MedicalAgenda
//
//  Created by Juan Carlos Lopez Armendariz on 22/03/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import RAGTextField
import RealmSwift

struct Pruebas {
    var tipo: String
    var fecha: Date
    var recordar: Bool
}


class PacienteVC: BaseViewController, PatologiaSelected, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var headerView: Header!
    var editaje: Bool = false
    var numeroHistoriaEditaje: String = ""
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var patologia: SeleccionarItemBotonClass!
    var patologiaObject: Patologias = Patologias()
    let realm = try! Realm()
    var pruebasArray = [Pruebas]()
    var pruebaEnModificacion: Int = 0
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    
    ///INFORMACION GENERAL
    @IBOutlet weak var nHistoriaTextField: RAGTextField!
    @IBOutlet weak var nombreTextField: RAGTextField!
    
    @IBOutlet weak var informacionTituloView: UIView!
    
    
    ////INTERVENCIONES QUIRURGICAS
    @IBOutlet weak var intervencionesView: UIStackView!
    @IBOutlet weak var intervencionSwitch: UISwitch!
    @IBOutlet weak var checkView: UIView!
    var fechaListaEsperaView: UIView = UIView()
    var fechaListaEsperaTitutlo: UILabel = UILabel()
    var fechaListaEsperaText: UILabel = UILabel()
    var calendarIconListaEspera: UIButton = UIButton()
    var listaEsperaFechaValue: String = ""
    var fechaPreanestesiaView: UIView = UIView()
    var fechaPreanestesiaTitulo: UILabel = UILabel()
    var fechaPreanestesiaText: UILabel = UILabel()
    var calendarIconPreanestesia: UIButton = UIButton()
    var preanestesiaFechaValue: String = ""
    var fechaIntervencionView: UIView = UIView()
    var fechaIntervencionTitulo: UILabel = UILabel()
    var fechaIntervencionText: UILabel = UILabel()
    var calendarIconIntervencion: UIButton = UIButton()
    var intervencionFechaValue: String = ""
    var operadoView: UIView = UIView()
    var operadoTitulo: UILabel = UILabel()
    var operadoSwitch: UISwitch = UISwitch()
    var tipoIntervencionView: UIView = UIView()
    var tipoIntervencionTitulo: UILabel = UILabel()
    var tipoIntervencionButton: SeleccionarItemBotonClass = SeleccionarItemBotonClass()
    var tipoIntervencionImagen: UIImageView = UIImageView()
    var tipoIntervencionSeparadorBottom: UIView = UIView()
    var fechaIntervencionSeparador: UIView = UIView()
    var notasIntervencionView: UIView = UIView()
    var notasIntervencionTitulo: UILabel = UILabel()
    var notasIntervencionTexto: UITextView = UITextView()
    var notasIntervencionSeparador: UIView = UIView()
    var recordarIntervencionView: UIView = UIView()
    var recordarIntervencionTitulo: UILabel = UILabel()
    var recordarIntervencionSwitch: UISwitch = UISwitch()
    var recordarIntervencionSeparador: UIView = UIView()
    var listaDeEsperaSeparador: UIView = UIView()
    var preanestesiaTitulo: UILabel = UILabel()
    var preanestesiaRealizada: UISwitch = UISwitch()
    var preanestesiaRealizadaTitulo: UILabel = UILabel()
    var preanestesiaRealizadaView: UIView = UIView()
    var preanestesiaRealizadaSeparador: UIView = UIView()
    var preanestesiaNotasView: UIView = UIView()
    var preanestesiaNotasTitulo: UILabel = UILabel()
    var preanestesiaNotasText: UITextView = UITextView()
    var preanestesiaFechaSeparador: UIView = UIView()
    var preanestesiaFechaView: UIView = UIView()
    var tachadoFechaPreanestesia: UIView = UIView()
    
    
    @IBOutlet weak var iqCheckedView: UIView!
    /////AÑADIR PRUEBAS
    @IBOutlet weak var pruebasTabla: UITableView!
    @IBOutlet weak var pruebasAltura: NSLayoutConstraint!
    
    @IBOutlet weak var pruebasMainView: UIView!
    
    @IBOutlet weak var pruebasTituloView: UIView!
    
    @IBOutlet weak var anadirPruebasView: UIStackView!
    @IBOutlet weak var anadirBotonView: UIView!
    var prueba1View: UIView = UIView()
    var eliminarPrueba1: UIButton = UIButton()
    var prueba1Fecha: UILabel = UILabel()
    var prueba1EditText: RAGTextField = RAGTextField()
    var calendarIconPrueba1: UIButton = UIButton()
    var prueba1FechaValue: String = ""
    var prueba2View: UIView = UIView()
    var eliminarPrueba2: UIButton = UIButton()
    var prueba2Fecha: UILabel = UILabel()
    var prueba2EditText: RAGTextField = RAGTextField()
    var calendarIconPrueba2: UIButton = UIButton()
    var prueba2FechaValue: String = ""
    
    
    ///REVISAR
    @IBOutlet weak var revisarView: UIStackView!
    @IBOutlet weak var revisarSwitch: UISwitch!
    var notasRevisarTitulo: UILabel = UILabel()
    var notasRevisarSeparador: UIView = UIView()
    var notasRevisarView: UIView = UIView()
    var notasRecordarView: UIView = UIView()
    var notasRevisar: UITextView = UITextView()
    var recordarRevisarTitulo: UILabel = UILabel()
    var recordarRevisar: UISwitch = UISwitch()
    var calendarioRevisar: UIButton = UIButton()
    var fechaRevisar: UILabel = UILabel()
    var fechaRevisarValue: String = ""
    
    @IBOutlet weak var revisarMainView: UIView!
    
    
    ///SIGUIENTE CITA
    var siguienteFechaValue = ""
    @IBOutlet weak var siguienteCitaView: UIStackView!
    var siguienteCitaNotasView: UIView = UIView()
    var siguienteCitaNotasTitulo: UILabel = UILabel()
    var siguienteCitaNotasText: UITextView = UITextView()
    var siguienteCitaNotasSeparador: UIView = UIView()
    var siguienteCitaRecordarView: UIView = UIView()
    var siguienteCitaRecordarTitulo: UILabel = UILabel()
    var siguienteCitaRecordarSwitch: UISwitch = UISwitch()
    var siguienteCitaRecordarCalendario: UIButton = UIButton()
    var siguienteCitaRecordarFecha: UILabel = UILabel()
    
    @IBOutlet weak var siguienteCitaSwitch: UISwitch!
    @IBOutlet weak var siguienteCietaMainView: UIView!
    private var keyboardCanChangeView: Bool = true
    
    
    
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
            self?.setSelectedDateListaEspera(date)
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
            self?.setSelectedDatePreanestesia(date)
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
            self?.setSelectedDateIntervencion(date)
        }
        
        return calendar
    }()
    
    private lazy var calendarPopupPrueba: CalendarPopUpView = {
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
            self?.setSelectedDatePrueba(date)
        }
        return calendar
    }()
    
    private lazy var calendarPopupRevisar: CalendarPopUpView = {
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
            self?.setSelectedDateRevisar(date: date)
        }
        return calendar
    }()
    
    private lazy var calendarPopupSiguienteCita: CalendarPopUpView = {
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
            self?.setSelectedDateSiguienteCita(date)
        }
        
        return calendar
    }()
    
    
    
    
    override func viewDidLoad() {
        navigationView(origin: self)
        headerView.title.text = "Añadir"
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(PacienteVC.dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapView)
        
        let tapSiguienteCita = UITapGestureRecognizer(target: self, action: #selector(PacienteVC.siguienteCitaClicked))
        //self.siguienteFechaText.isUserInteractionEnabled = true
        //self.siguienteFechaText.addGestureRecognizer(tapSiguienteCita)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PacienteVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PacienteVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        patologia.setTitle(Array(realm.objects(Patologias.self))[0].valor, for: UIControlState.normal)
        patologia.tipo = "patologia"
        patologia.addTarget(self, action: #selector(PacienteVC.goToSelection), for: .touchUpInside)
        createIntervencionesViews()
        createRevisarView()
        createSiguienteCitaView()
        
        if(self.editaje){
            //self.title = "Editar"
            bindView()
        }else{
            //self.title = "Añadir"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        eliminarPrueba1.isHidden = true
        eliminarPrueba2.isHidden = true
    }
    
    func bindView(){
        
    }
    
    @objc
    func dismissKeyboard(sender:UITapGestureRecognizer) {
        print("Dismiss keyboard")
        view.endEditing(true)
        eliminarPrueba1.isHidden = true
        eliminarPrueba2.isHidden = true
    }
    
    func onPatologiaSelected(patologiaSeleccionada: String, tipo: String, numeroPrueba: Int?) {
        switch tipo {
        case "patologia":
            patologia.setTitle(patologiaSeleccionada, for: UIControlState.normal)
            break;
        case "pruebas":
            pruebasArray[numeroPrueba!].tipo = patologiaSeleccionada
            pruebasTabla.reloadData()
            break;
        case "iq":
            tipoIntervencionButton.setTitle(patologiaSeleccionada, for: UIControlState.normal)
            break;
        default:
            patologia.setTitle(patologiaSeleccionada, for: UIControlState.normal)
        }
    }
    
    @IBAction func onItervencionChanged(_ sender: UISwitch) {
        showIntervencionView(intervencion: sender.isOn)
    }
    
    func showIntervencionView(intervencion: Bool){
        if(intervencion){
            self.intervencionesView.addArrangedSubview(operadoView)
            self.intervencionesView.addArrangedSubview(tipoIntervencionView)
            self.intervencionesView.addArrangedSubview(fechaIntervencionView)
            self.intervencionesView.addArrangedSubview(recordarIntervencionView)
            self.intervencionesView.addArrangedSubview(notasIntervencionView)
            mainHeight.constant = mainHeight.constant + 325
            intervenidoChecked()
        }else{
            if(!operadoSwitch.isOn){
                self.intervencionesView.removeArrangedSubview(fechaListaEsperaView)
                fechaListaEsperaView.removeFromSuperview()
                self.intervencionesView.removeArrangedSubview(fechaPreanestesiaView)
                fechaPreanestesiaView.removeFromSuperview()
                mainHeight.constant = mainHeight.constant - 300
            }
            self.intervencionesView.removeArrangedSubview(operadoView)
            operadoView.removeFromSuperview()
            self.intervencionesView.removeArrangedSubview(tipoIntervencionView)
            tipoIntervencionView.removeFromSuperview()
            self.intervencionesView.removeArrangedSubview(fechaIntervencionView)
            fechaIntervencionView.removeFromSuperview()
            self.intervencionesView.removeArrangedSubview(notasIntervencionView)
            notasIntervencionView.removeFromSuperview()
            self.intervencionesView.removeArrangedSubview(recordarIntervencionView)
            recordarIntervencionView.removeFromSuperview()
            operadoSwitch.setOn(false, animated: false)
            mainHeight.constant = mainHeight.constant - 325
        }
    }
    
    func createIntervencionesViews(){
        
        informacionTituloView.clipsToBounds = true
        informacionTituloView.layer.cornerRadius = 10
        informacionTituloView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        iqCheckedView.clipsToBounds = true
        iqCheckedView.layer.cornerRadius = 10
        iqCheckedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        /////Intervenido
        operadoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        operadoView.widthAnchor.constraint(equalToConstant: self.intervencionesView.frame.width)
        operadoView.backgroundColor = UIColor.white
        
        operadoTitulo.translatesAutoresizingMaskIntoConstraints = false
        operadoTitulo.text = "Intervenido"
        operadoTitulo.textColor = UIColor.black
        operadoTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        operadoView.addSubview(operadoTitulo)
        operadoTitulo.leftAnchor.constraint(equalTo: operadoView.leftAnchor, constant: 16).isActive = true
        operadoTitulo.topAnchor.constraint(equalTo: operadoView.topAnchor).isActive = true
        operadoTitulo.bottomAnchor.constraint(equalTo: operadoView.bottomAnchor).isActive = true
        
        operadoSwitch.translatesAutoresizingMaskIntoConstraints = false
        operadoSwitch.setOn(false, animated: false)
        operadoSwitch.addTarget(self, action: #selector(intervenidoChec), for: .valueChanged)
        operadoView.addSubview(operadoSwitch)
        operadoSwitch.rightAnchor.constraint(equalTo: operadoView.rightAnchor, constant: -8).isActive = true
        operadoSwitch.topAnchor.constraint(equalTo: operadoView.topAnchor, constant: 10).isActive = true
        operadoSwitch.bottomAnchor.constraint(equalTo: operadoView.bottomAnchor).isActive = true
        
        ///TipoIntervencion
        tipoIntervencionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tipoIntervencionView.widthAnchor.constraint(equalToConstant: self.intervencionesView.frame.width)
        tipoIntervencionView.backgroundColor = UIColor.white
        
        tipoIntervencionTitulo.translatesAutoresizingMaskIntoConstraints = false
        tipoIntervencionTitulo.text = "Tipo IQ"
        tipoIntervencionTitulo.textColor = UIColor.black
        tipoIntervencionTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        tipoIntervencionView.addSubview(tipoIntervencionTitulo)
        tipoIntervencionTitulo.leftAnchor.constraint(equalTo: tipoIntervencionView.leftAnchor, constant: 16).isActive = true
        tipoIntervencionTitulo.centerYAnchor.constraint(equalTo: tipoIntervencionView.centerYAnchor).isActive = true
        
        tipoIntervencionButton.translatesAutoresizingMaskIntoConstraints = false
        tipoIntervencionButton.setTitle("Escoge tipo IQ", for: .normal)
        tipoIntervencionButton.setTitleColor(UIColor.black, for: .normal)
        tipoIntervencionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        tipoIntervencionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        tipoIntervencionView.addSubview(tipoIntervencionButton)
        tipoIntervencionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tipoIntervencionButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tipoIntervencionButton.rightAnchor.constraint(equalTo: tipoIntervencionView.rightAnchor).isActive = true
        tipoIntervencionButton.centerYAnchor.constraint(equalTo: tipoIntervencionView.centerYAnchor).isActive = true
        tipoIntervencionButton.tipo = "iq"
        tipoIntervencionButton.addTarget(self, action: #selector(PacienteVC.goToSelection), for: .touchUpInside)
        
        tipoIntervencionImagen.translatesAutoresizingMaskIntoConstraints = false
        tipoIntervencionImagen.image = UIImage(named: "icons8-forward-48.png")
        tipoIntervencionView.addSubview(tipoIntervencionImagen)
        tipoIntervencionImagen.widthAnchor.constraint(equalToConstant: 24).isActive = true
        tipoIntervencionImagen.heightAnchor.constraint(equalToConstant: 24).isActive = true
        tipoIntervencionImagen.rightAnchor.constraint(equalTo: tipoIntervencionView.rightAnchor, constant: -8).isActive = true
        tipoIntervencionImagen.centerYAnchor.constraint(equalTo: tipoIntervencionView.centerYAnchor).isActive = true
        
        tipoIntervencionSeparadorBottom.translatesAutoresizingMaskIntoConstraints = false
        tipoIntervencionSeparadorBottom.backgroundColor = UIColor.lightGray
        tipoIntervencionView.addSubview(tipoIntervencionSeparadorBottom)
        tipoIntervencionSeparadorBottom.leftAnchor.constraint(equalTo: tipoIntervencionView.leftAnchor, constant: 8).isActive = true
        tipoIntervencionSeparadorBottom.rightAnchor.constraint(equalTo: tipoIntervencionView.rightAnchor, constant: -8).isActive = true
        tipoIntervencionSeparadorBottom.bottomAnchor.constraint(equalTo: tipoIntervencionView.bottomAnchor).isActive = true
        tipoIntervencionSeparadorBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        /////FECHA INTERVENCION
        fechaIntervencionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fechaIntervencionView.widthAnchor.constraint(equalToConstant: self.intervencionesView.frame.width)
        fechaIntervencionView.backgroundColor = UIColor.white
        
        fechaIntervencionTitulo.translatesAutoresizingMaskIntoConstraints = false
        fechaIntervencionTitulo.text = "Fecha intervención"
        fechaIntervencionTitulo.textColor = UIColor.black
        fechaIntervencionTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        fechaIntervencionView.addSubview(fechaIntervencionTitulo)
        fechaIntervencionTitulo.leftAnchor.constraint(equalTo: fechaIntervencionView.leftAnchor, constant: 16).isActive = true
        fechaIntervencionTitulo.topAnchor.constraint(equalTo: fechaIntervencionView.topAnchor).isActive = true
        fechaIntervencionTitulo.bottomAnchor.constraint(equalTo: fechaIntervencionView.bottomAnchor).isActive = true
        
        fechaIntervencionText.translatesAutoresizingMaskIntoConstraints = false
        fechaIntervencionText.text = ""
        fechaIntervencionText.textColor = UIColor.blue
        fechaIntervencionText.isHidden = true
        fechaIntervencionText.font = UIFont.systemFont(ofSize: 16)
        fechaIntervencionView.addSubview(fechaIntervencionText)
        fechaIntervencionText.rightAnchor.constraint(equalTo: fechaIntervencionView.rightAnchor, constant: -8).isActive = true
        fechaIntervencionText.topAnchor.constraint(equalTo: fechaIntervencionView.topAnchor).isActive = true
        fechaIntervencionText.bottomAnchor.constraint(equalTo: fechaIntervencionView.bottomAnchor).isActive = true
        
        calendarIconIntervencion.translatesAutoresizingMaskIntoConstraints = false
        calendarIconIntervencion.setImage(UIImage(named: "calendar_icon"), for: UIControlState.normal)
        fechaIntervencionView.addSubview(calendarIconIntervencion)
        calendarIconIntervencion.widthAnchor.constraint(equalToConstant: 36).isActive = true
        calendarIconIntervencion.heightAnchor.constraint(equalToConstant: 36).isActive = true
        calendarIconIntervencion.centerYAnchor.constraint(equalTo: fechaIntervencionView.centerYAnchor).isActive = true
        calendarIconIntervencion.rightAnchor.constraint(equalTo: fechaIntervencionView.rightAnchor, constant: -8).isActive = true
        calendarIconIntervencion.addTarget(self, action: #selector(PacienteVC.tapIntervencion), for: UIControlEvents.touchUpInside)
        
        let tapIntervencion = UITapGestureRecognizer(target: self, action: #selector(PacienteVC.tapIntervencion))
        fechaIntervencionText.isUserInteractionEnabled = true
        fechaIntervencionText.addGestureRecognizer(tapIntervencion)
        
        fechaIntervencionSeparador.translatesAutoresizingMaskIntoConstraints = false
        fechaIntervencionSeparador.backgroundColor = UIColor.lightGray
        fechaIntervencionView.addSubview(fechaIntervencionSeparador)
        fechaIntervencionSeparador.leftAnchor.constraint(equalTo: fechaIntervencionView.leftAnchor, constant: 8).isActive = true
        fechaIntervencionSeparador.rightAnchor.constraint(equalTo: fechaIntervencionView.rightAnchor, constant: -8).isActive = true
        fechaIntervencionSeparador.bottomAnchor.constraint(equalTo: fechaIntervencionView.bottomAnchor).isActive = true
        fechaIntervencionSeparador.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //RECORDAR INTERVENCION
        recordarIntervencionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        recordarIntervencionView.widthAnchor.constraint(equalToConstant: self.intervencionesView.frame.width).isActive = true
        recordarIntervencionView.backgroundColor = UIColor.white
        
        recordarIntervencionTitulo.translatesAutoresizingMaskIntoConstraints = false
        recordarIntervencionTitulo.textColor = UIColor.black
        recordarIntervencionTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        recordarIntervencionTitulo.text = "Recordar"
        recordarIntervencionView.addSubview(recordarIntervencionTitulo)
        recordarIntervencionTitulo.leftAnchor.constraint(equalTo: recordarIntervencionView.leftAnchor, constant: 16).isActive = true
        recordarIntervencionTitulo.centerYAnchor.constraint(equalTo: recordarIntervencionView.centerYAnchor).isActive = true
        
        recordarIntervencionSwitch.translatesAutoresizingMaskIntoConstraints = false
        recordarIntervencionSwitch.setOn(true, animated: false)
        recordarIntervencionView.addSubview(recordarIntervencionSwitch)
        recordarIntervencionSwitch.rightAnchor.constraint(equalTo: recordarIntervencionView.rightAnchor, constant: -8).isActive = true
        recordarIntervencionSwitch.centerYAnchor.constraint(equalTo: recordarIntervencionView.centerYAnchor).isActive = true
        
        recordarIntervencionSeparador.translatesAutoresizingMaskIntoConstraints = false
        recordarIntervencionSeparador.backgroundColor = UIColor.lightGray
        recordarIntervencionView.addSubview(recordarIntervencionSeparador)
        recordarIntervencionSeparador.leftAnchor.constraint(equalTo: recordarIntervencionView.leftAnchor, constant: 8).isActive = true
        recordarIntervencionSeparador.rightAnchor.constraint(equalTo: recordarIntervencionView.rightAnchor, constant: -8).isActive = true
        recordarIntervencionSeparador.bottomAnchor.constraint(equalTo: recordarIntervencionView.bottomAnchor).isActive = true
        recordarIntervencionSeparador.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        ////NOTAS INTERVENCION
        notasIntervencionView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        notasIntervencionView.widthAnchor.constraint(equalToConstant: self.intervencionesView.frame.width)
        notasIntervencionView.backgroundColor = UIColor.white
        
        notasIntervencionTitulo.translatesAutoresizingMaskIntoConstraints = false
        notasIntervencionTitulo.text = "Notas IQ"
        notasIntervencionTitulo.textColor = UIColor.black
        notasIntervencionTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        notasIntervencionView.addSubview(notasIntervencionTitulo)
        notasIntervencionTitulo.leftAnchor.constraint(equalTo: notasIntervencionView.leftAnchor, constant: 16).isActive = true
        notasIntervencionTitulo.topAnchor.constraint(equalTo: notasIntervencionView.topAnchor, constant: 5).isActive = true
        
        notasIntervencionTexto.translatesAutoresizingMaskIntoConstraints = false
        notasIntervencionTexto.textColor = UIColor.black
        notasIntervencionTexto.font = UIFont.systemFont(ofSize: 16)
        notasIntervencionTexto.backgroundColor = UIColor.groupTableViewBackground
        notasIntervencionView.addSubview(notasIntervencionTexto)
        notasIntervencionTexto.leftAnchor.constraint(equalTo: notasIntervencionView.leftAnchor, constant: 16).isActive = true
        notasIntervencionTexto.rightAnchor.constraint(equalTo: notasIntervencionView.rightAnchor, constant: -8).isActive = true
        notasIntervencionTexto.topAnchor.constraint(equalTo: notasIntervencionView.topAnchor, constant: 30).isActive = true
        notasIntervencionTexto.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        notasIntervencionSeparador.translatesAutoresizingMaskIntoConstraints = false
        notasIntervencionSeparador.backgroundColor = UIColor.lightGray
        notasIntervencionView.addSubview(notasIntervencionSeparador)
        notasIntervencionSeparador.leftAnchor.constraint(equalTo: notasIntervencionView.leftAnchor, constant: 8).isActive = true
        notasIntervencionSeparador.rightAnchor.constraint(equalTo: notasIntervencionView.rightAnchor, constant: -8).isActive = true
        notasIntervencionSeparador.bottomAnchor.constraint(equalTo: notasIntervencionView.bottomAnchor).isActive = true
        notasIntervencionSeparador.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        /////LISTA DE ESPERA
        fechaListaEsperaView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fechaListaEsperaView.widthAnchor.constraint(equalToConstant: self.intervencionesView.frame.width)
        fechaListaEsperaView.backgroundColor = UIColor.white
        
        fechaListaEsperaTitutlo.translatesAutoresizingMaskIntoConstraints = false
        fechaListaEsperaTitutlo.text = "Lista de espera"
        fechaListaEsperaTitutlo.textColor = UIColor.black
        fechaListaEsperaTitutlo.font = UIFont.boldSystemFont(ofSize: 16)
        fechaListaEsperaView.addSubview(fechaListaEsperaTitutlo)
        fechaListaEsperaTitutlo.leftAnchor.constraint(equalTo: fechaListaEsperaView.leftAnchor, constant: 24).isActive = true
        fechaListaEsperaTitutlo.topAnchor.constraint(equalTo: fechaListaEsperaView.topAnchor).isActive = true
        fechaListaEsperaTitutlo.bottomAnchor.constraint(equalTo: fechaListaEsperaView.bottomAnchor).isActive = true
        
        fechaListaEsperaText.translatesAutoresizingMaskIntoConstraints = false
        fechaListaEsperaText.text = ""
        fechaListaEsperaText.textColor = UIColor.blue
        fechaListaEsperaText.isHidden = true
        fechaListaEsperaText.font = UIFont.systemFont(ofSize: 16)
        fechaListaEsperaView.addSubview(fechaListaEsperaText)
        fechaListaEsperaText.rightAnchor.constraint(equalTo: fechaListaEsperaView.rightAnchor, constant: -8).isActive = true
        fechaListaEsperaText.topAnchor.constraint(equalTo: fechaListaEsperaView.topAnchor).isActive = true
        fechaListaEsperaText.bottomAnchor.constraint(equalTo: fechaListaEsperaView.bottomAnchor).isActive = true
        
        calendarIconListaEspera.translatesAutoresizingMaskIntoConstraints = false
        calendarIconListaEspera.setImage(UIImage(named: "calendar_icon"), for: UIControlState.normal)
        fechaListaEsperaView.addSubview(calendarIconListaEspera)
        calendarIconListaEspera.widthAnchor.constraint(equalToConstant: 36).isActive = true
        calendarIconListaEspera.heightAnchor.constraint(equalToConstant: 36).isActive = true
        calendarIconListaEspera.centerYAnchor.constraint(equalTo: fechaListaEsperaView.centerYAnchor).isActive = true
        calendarIconListaEspera.rightAnchor.constraint(equalTo: fechaListaEsperaView.rightAnchor, constant: -8).isActive = true
        calendarIconListaEspera.addTarget(self, action: #selector(PacienteVC.tapListaEspera), for: UIControlEvents.touchUpInside)
        
        let tapListaEspera = UITapGestureRecognizer(target: self, action: #selector(PacienteVC.tapListaEspera))
        fechaListaEsperaText.isUserInteractionEnabled = true
        fechaListaEsperaText.addGestureRecognizer(tapListaEspera)
        
        listaDeEsperaSeparador.translatesAutoresizingMaskIntoConstraints = false
        listaDeEsperaSeparador.backgroundColor = UIColor.lightGray
        fechaListaEsperaView.addSubview(listaDeEsperaSeparador)
        listaDeEsperaSeparador.leftAnchor.constraint(equalTo: fechaListaEsperaView.leftAnchor, constant: 8).isActive = true
        listaDeEsperaSeparador.rightAnchor.constraint(equalTo: fechaListaEsperaView.rightAnchor, constant: -8).isActive = true
        listaDeEsperaSeparador.bottomAnchor.constraint(equalTo: fechaListaEsperaView.bottomAnchor).isActive = true
        listaDeEsperaSeparador.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
        
        
        /////PREANESTESIA
        fechaPreanestesiaView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        fechaPreanestesiaView.widthAnchor.constraint(equalToConstant: self.intervencionesView.frame.width)
        fechaPreanestesiaView.clipsToBounds = true
        fechaPreanestesiaView.layer.cornerRadius = 10
        fechaPreanestesiaView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        fechaPreanestesiaView.backgroundColor = UIColor.white
        
        preanestesiaTitulo.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaTitulo.text = "Preanestesia"
        preanestesiaTitulo.textColor = UIColor.black
        preanestesiaTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        fechaPreanestesiaView.addSubview(preanestesiaTitulo)
        preanestesiaTitulo.leftAnchor.constraint(equalTo: fechaPreanestesiaView.leftAnchor, constant: 24).isActive = true
        preanestesiaTitulo.topAnchor.constraint(equalTo: fechaPreanestesiaView.topAnchor, constant: 5).isActive = true
        
        preanestesiaRealizadaView.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaRealizadaView.backgroundColor = UIColor.white
        preanestesiaRealizadaView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fechaPreanestesiaView.addSubview(preanestesiaRealizadaView)
        preanestesiaRealizadaView.topAnchor.constraint(equalTo: fechaPreanestesiaView.topAnchor, constant: 30).isActive = true
        preanestesiaRealizadaView.widthAnchor.constraint(equalToConstant: fechaPreanestesiaView.frame.width).isActive = true
        preanestesiaRealizadaView.leftAnchor.constraint(equalTo: fechaPreanestesiaView.leftAnchor).isActive = true
        preanestesiaRealizadaView.rightAnchor.constraint(equalTo: fechaPreanestesiaView.rightAnchor).isActive = true
        
        preanestesiaRealizadaTitulo.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaRealizadaTitulo.text = "Preanestesia realizada"
        preanestesiaRealizadaTitulo.textColor = UIColor.black
        preanestesiaRealizadaTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        preanestesiaRealizadaView.addSubview(preanestesiaRealizadaTitulo)
        preanestesiaRealizadaTitulo.leftAnchor.constraint(equalTo: preanestesiaRealizadaView.leftAnchor, constant: 32).isActive = true
        preanestesiaRealizadaTitulo.centerYAnchor.constraint(equalTo: preanestesiaRealizadaView.centerYAnchor).isActive = true
        
        preanestesiaRealizada.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaRealizada.setOn(false, animated: false)
        preanestesiaRealizada.addTarget(self, action: #selector(preanestesiaRealizadaClicked), for: .valueChanged)
        preanestesiaRealizadaView.addSubview(preanestesiaRealizada)
        preanestesiaRealizada.rightAnchor.constraint(equalTo: preanestesiaRealizadaView.rightAnchor, constant: -8).isActive = true
        preanestesiaRealizada.topAnchor.constraint(equalTo: preanestesiaRealizadaView.topAnchor, constant: 10).isActive = true
        preanestesiaRealizada.bottomAnchor.constraint(equalTo: preanestesiaRealizadaView.bottomAnchor).isActive = true
        
        preanestesiaRealizadaSeparador.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaRealizadaSeparador.backgroundColor = UIColor.lightGray
        preanestesiaRealizadaView.addSubview(preanestesiaRealizadaSeparador)
        preanestesiaRealizadaSeparador.leftAnchor.constraint(equalTo: preanestesiaRealizadaView.leftAnchor, constant: 8).isActive = true
        preanestesiaRealizadaSeparador.rightAnchor.constraint(equalTo: preanestesiaRealizadaView.rightAnchor, constant: -8).isActive = true
        preanestesiaRealizadaSeparador.bottomAnchor.constraint(equalTo: preanestesiaRealizadaView.bottomAnchor).isActive = true
        preanestesiaRealizadaSeparador.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        preanestesiaFechaView.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaFechaView.backgroundColor = UIColor.white
        preanestesiaFechaView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fechaPreanestesiaView.addSubview(preanestesiaFechaView)
        preanestesiaFechaView.topAnchor.constraint(equalTo: fechaPreanestesiaView.topAnchor, constant: 80).isActive = true
        preanestesiaFechaView.widthAnchor.constraint(equalToConstant: fechaPreanestesiaView.frame.width).isActive = true
        preanestesiaFechaView.leftAnchor.constraint(equalTo: fechaPreanestesiaView.leftAnchor).isActive = true
        preanestesiaFechaView.rightAnchor.constraint(equalTo: fechaPreanestesiaView.rightAnchor).isActive = true
        
        fechaPreanestesiaTitulo.translatesAutoresizingMaskIntoConstraints = false
        fechaPreanestesiaTitulo.textColor = UIColor.black
        fechaPreanestesiaTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        fechaPreanestesiaTitulo.text = "Fecha"
        preanestesiaFechaView.addSubview(fechaPreanestesiaTitulo)
        fechaPreanestesiaTitulo.leftAnchor.constraint(equalTo: preanestesiaFechaView.leftAnchor, constant: 32).isActive = true
        fechaPreanestesiaTitulo.centerYAnchor.constraint(equalTo: preanestesiaFechaView.centerYAnchor).isActive = true
        
        fechaPreanestesiaText.translatesAutoresizingMaskIntoConstraints = false
        fechaPreanestesiaText.text = ""
        fechaPreanestesiaText.textColor = UIColor.blue
        fechaPreanestesiaText.isHidden = true
        fechaPreanestesiaText.font = UIFont.systemFont(ofSize: 16)
        preanestesiaFechaView.addSubview(fechaPreanestesiaText)
        fechaPreanestesiaText.rightAnchor.constraint(equalTo: preanestesiaFechaView.rightAnchor, constant: -8).isActive = true
        fechaPreanestesiaText.topAnchor.constraint(equalTo: preanestesiaFechaView.topAnchor).isActive = true
        fechaPreanestesiaText.bottomAnchor.constraint(equalTo: preanestesiaFechaView.bottomAnchor).isActive = true
        
        calendarIconPreanestesia.translatesAutoresizingMaskIntoConstraints = false
        calendarIconPreanestesia.setImage(UIImage(named: "calendar_icon"), for: UIControlState.normal)
        preanestesiaFechaView.addSubview(calendarIconPreanestesia)
        calendarIconPreanestesia.widthAnchor.constraint(equalToConstant: 36).isActive = true
        calendarIconPreanestesia.heightAnchor.constraint(equalToConstant: 36).isActive = true
        calendarIconPreanestesia.centerYAnchor.constraint(equalTo: preanestesiaFechaView.centerYAnchor).isActive = true
        calendarIconPreanestesia.rightAnchor.constraint(equalTo: preanestesiaFechaView.rightAnchor, constant: -8).isActive = true
        calendarIconPreanestesia.addTarget(self, action: #selector(PacienteVC.tapPreanestesia), for: UIControlEvents.touchUpInside)
        
        let tapPreanestesia = UITapGestureRecognizer(target: self, action: #selector(PacienteVC.tapPreanestesia))
        fechaPreanestesiaText.isUserInteractionEnabled = true
        fechaPreanestesiaText.addGestureRecognizer(tapPreanestesia)
        
        tachadoFechaPreanestesia.translatesAutoresizingMaskIntoConstraints = false
        tachadoFechaPreanestesia.backgroundColor = UIColor.lightGray
        tachadoFechaPreanestesia.isHidden = true
        preanestesiaFechaView.addSubview(tachadoFechaPreanestesia)
        tachadoFechaPreanestesia.leftAnchor.constraint(equalTo: preanestesiaFechaView.leftAnchor, constant: 24).isActive = true
        tachadoFechaPreanestesia.rightAnchor.constraint(equalTo: preanestesiaFechaView.rightAnchor, constant: -8).isActive = true
        tachadoFechaPreanestesia.centerYAnchor.constraint(equalTo: preanestesiaFechaView.centerYAnchor).isActive = true
        tachadoFechaPreanestesia.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        preanestesiaFechaSeparador.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaFechaSeparador.backgroundColor = UIColor.lightGray
        preanestesiaFechaView.addSubview(preanestesiaFechaSeparador)
        preanestesiaFechaSeparador.leftAnchor.constraint(equalTo: preanestesiaFechaView.leftAnchor, constant: 8).isActive = true
        preanestesiaFechaSeparador.rightAnchor.constraint(equalTo: preanestesiaFechaView.rightAnchor, constant: -8).isActive = true
        preanestesiaFechaSeparador.bottomAnchor.constraint(equalTo: preanestesiaFechaView.bottomAnchor).isActive = true
        preanestesiaFechaSeparador.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        preanestesiaNotasView.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaNotasView.backgroundColor = UIColor.white
        preanestesiaNotasView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        fechaPreanestesiaView.addSubview(preanestesiaNotasView)
        preanestesiaNotasView.topAnchor.constraint(equalTo: fechaPreanestesiaView.topAnchor, constant: 130).isActive = true
        preanestesiaNotasView.widthAnchor.constraint(equalToConstant: fechaPreanestesiaView.frame.width).isActive = true
        preanestesiaNotasView.leftAnchor.constraint(equalTo: fechaPreanestesiaView.leftAnchor).isActive = true
        preanestesiaNotasView.rightAnchor.constraint(equalTo: fechaPreanestesiaView.rightAnchor).isActive = true
        
        preanestesiaNotasTitulo.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaNotasTitulo.textColor = UIColor.black
        preanestesiaNotasTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        preanestesiaNotasTitulo.text = "Notas"
        preanestesiaNotasView.addSubview(preanestesiaNotasTitulo)
        preanestesiaNotasTitulo.leftAnchor.constraint(equalTo: preanestesiaNotasView.leftAnchor, constant: 32).isActive = true
        preanestesiaNotasTitulo.topAnchor.constraint(equalTo: preanestesiaNotasView.topAnchor, constant: 8).isActive = true
        
        preanestesiaNotasText.translatesAutoresizingMaskIntoConstraints = false
        preanestesiaNotasText.textColor = UIColor.black
        preanestesiaNotasText.font = UIFont.systemFont(ofSize: 16)
        preanestesiaNotasText.backgroundColor = UIColor.groupTableViewBackground
        preanestesiaNotasView.addSubview(preanestesiaNotasText)
        preanestesiaNotasText.leftAnchor.constraint(equalTo: preanestesiaNotasView.leftAnchor, constant: 32).isActive = true
        preanestesiaNotasText.rightAnchor.constraint(equalTo: preanestesiaNotasView.rightAnchor, constant: -8).isActive = true
        preanestesiaNotasText.topAnchor.constraint(equalTo: preanestesiaNotasView.topAnchor, constant: 30).isActive = true
        preanestesiaNotasText.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    func createRevisarView(){
        
        pruebasTituloView.clipsToBounds = true
        pruebasTituloView.layer.cornerRadius = 10
        pruebasTituloView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        revisarMainView.clipsToBounds = true
        revisarMainView.layer.cornerRadius = 10
        revisarMainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        notasRevisarView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        notasRevisarView.widthAnchor.constraint(equalToConstant: self.revisarView.frame.width)
        notasRevisarView.backgroundColor = UIColor.white
        
        notasRevisarTitulo.translatesAutoresizingMaskIntoConstraints = false
        notasRevisarTitulo.text = "Notas"
        notasRevisarTitulo.textColor = UIColor.black
        notasRevisarTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        notasRevisarView.addSubview(notasRevisarTitulo)
        notasRevisarTitulo.leftAnchor.constraint(equalTo: notasRevisarView.leftAnchor, constant: 16).isActive = true
        notasRevisarTitulo.topAnchor.constraint(equalTo: notasRevisarView.topAnchor, constant: 8).isActive = true
        
        notasRevisar.translatesAutoresizingMaskIntoConstraints = false
        notasRevisar.textColor = UIColor.black
        notasRevisar.font = UIFont.systemFont(ofSize: 16)
        notasRevisar.backgroundColor = UIColor.groupTableViewBackground
        notasRevisarView.addSubview(notasRevisar)
        notasRevisar.leftAnchor.constraint(equalTo: notasRevisarView.leftAnchor, constant: 16).isActive = true
        notasRevisar.rightAnchor.constraint(equalTo: notasRevisarView.rightAnchor, constant: -8).isActive = true
        notasRevisar.topAnchor.constraint(equalTo: notasRevisarView.topAnchor, constant: 30).isActive = true
        notasRevisar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        notasRevisarSeparador.translatesAutoresizingMaskIntoConstraints = false
        notasRevisarSeparador.backgroundColor = UIColor.lightGray
        notasRevisarView.addSubview(notasRevisarSeparador)
        notasRevisarSeparador.leftAnchor.constraint(equalTo: notasRevisarView.leftAnchor, constant: 8).isActive = true
        notasRevisarSeparador.rightAnchor.constraint(equalTo: notasRevisarView.rightAnchor, constant: -8).isActive = true
        notasRevisarSeparador.bottomAnchor.constraint(equalTo: notasRevisarView.bottomAnchor).isActive = true
        notasRevisarSeparador.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        notasRecordarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        notasRecordarView.widthAnchor.constraint(equalToConstant: self.revisarView.frame.width)
        notasRecordarView.clipsToBounds = true
        notasRecordarView.layer.cornerRadius = 10
        notasRecordarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        notasRecordarView.backgroundColor = UIColor.white
        
        
        recordarRevisarTitulo.translatesAutoresizingMaskIntoConstraints = false
        recordarRevisarTitulo.text = "Recordar"
        recordarRevisarTitulo.textColor = UIColor.black
        recordarRevisarTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        notasRecordarView.addSubview(recordarRevisarTitulo)
        recordarRevisarTitulo.leftAnchor.constraint(equalTo: notasRecordarView.leftAnchor, constant: 16).isActive = true
        recordarRevisarTitulo.centerYAnchor.constraint(equalTo: notasRecordarView.centerYAnchor).isActive = true
        
        recordarRevisar.translatesAutoresizingMaskIntoConstraints = false
        recordarRevisar.setOn(false, animated: false)
        recordarRevisar.addTarget(self, action: #selector(recordarRevisarCheck), for: .valueChanged)
        notasRecordarView.addSubview(recordarRevisar)
        recordarRevisar.leftAnchor.constraint(equalTo: recordarRevisarTitulo.rightAnchor, constant: 3).isActive = true
        recordarRevisar.centerYAnchor.constraint(equalTo: notasRecordarView.centerYAnchor).isActive = true
        
        fechaRevisar.translatesAutoresizingMaskIntoConstraints = false
        fechaRevisar.text = ""
        fechaRevisar.textColor = UIColor.blue
        fechaRevisar.isHidden = true
        fechaRevisar.font = UIFont.systemFont(ofSize: 16)
        notasRecordarView.addSubview(fechaRevisar)
        fechaRevisar.rightAnchor.constraint(equalTo: notasRecordarView.rightAnchor, constant: -8).isActive = true
        fechaRevisar.centerYAnchor.constraint(equalTo: notasRecordarView.centerYAnchor).isActive = true

        
        calendarioRevisar.translatesAutoresizingMaskIntoConstraints = false
        calendarioRevisar.setImage(UIImage(named: "calendar_icon"), for: UIControlState.normal)
        calendarioRevisar.isHidden = true
        notasRecordarView.addSubview(calendarioRevisar)
        calendarioRevisar.widthAnchor.constraint(equalToConstant: 36).isActive = true
        calendarioRevisar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        calendarioRevisar.centerYAnchor.constraint(equalTo: notasRecordarView.centerYAnchor).isActive = true
        calendarioRevisar.rightAnchor.constraint(equalTo: notasRecordarView.rightAnchor, constant: -8).isActive = true
        
        calendarioRevisar.addTarget(self, action: #selector(PacienteVC.tapRevisarFecha), for: UIControlEvents.touchUpInside)
        
        let tapPreanestesia = UITapGestureRecognizer(target: self, action: #selector(PacienteVC.tapRevisarFecha))
        fechaRevisar.isUserInteractionEnabled = true
        fechaRevisar.addGestureRecognizer(tapPreanestesia)
        
    }
    
    func createSiguienteCitaView(){
        
        siguienteCietaMainView.clipsToBounds = true
        siguienteCietaMainView.layer.cornerRadius = 10
        siguienteCietaMainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        siguienteCitaNotasView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        siguienteCitaNotasView.widthAnchor.constraint(equalToConstant: self.siguienteCitaView.frame.width)
        siguienteCitaNotasView.backgroundColor = UIColor.white
        
        siguienteCitaNotasTitulo.translatesAutoresizingMaskIntoConstraints = false
        siguienteCitaNotasTitulo.text = "Notas"
        siguienteCitaNotasTitulo.textColor = UIColor.black
        siguienteCitaNotasTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        siguienteCitaNotasView.addSubview(siguienteCitaNotasTitulo)
        siguienteCitaNotasTitulo.leftAnchor.constraint(equalTo: siguienteCitaNotasView.leftAnchor, constant: 16).isActive = true
        siguienteCitaNotasTitulo.topAnchor.constraint(equalTo: siguienteCitaNotasView.topAnchor, constant: 8).isActive = true
        
        siguienteCitaNotasText.translatesAutoresizingMaskIntoConstraints = false
        siguienteCitaNotasText.textColor = UIColor.black
        siguienteCitaNotasText.font = UIFont.systemFont(ofSize: 16)
        siguienteCitaNotasText.backgroundColor = UIColor.groupTableViewBackground
        siguienteCitaNotasView.addSubview(siguienteCitaNotasText)
        siguienteCitaNotasText.leftAnchor.constraint(equalTo: siguienteCitaNotasView.leftAnchor, constant: 16).isActive = true
        siguienteCitaNotasText.rightAnchor.constraint(equalTo: siguienteCitaNotasView.rightAnchor, constant: -8).isActive = true
        siguienteCitaNotasText.topAnchor.constraint(equalTo: siguienteCitaNotasView.topAnchor, constant: 30).isActive = true
        siguienteCitaNotasText.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        siguienteCitaNotasSeparador.translatesAutoresizingMaskIntoConstraints = false
        siguienteCitaNotasSeparador.backgroundColor = UIColor.lightGray
        siguienteCitaNotasView.addSubview(siguienteCitaNotasSeparador)
        siguienteCitaNotasSeparador.leftAnchor.constraint(equalTo: siguienteCitaNotasView.leftAnchor, constant: 8).isActive = true
        siguienteCitaNotasSeparador.rightAnchor.constraint(equalTo: siguienteCitaNotasView.rightAnchor, constant: -8).isActive = true
        siguienteCitaNotasSeparador.bottomAnchor.constraint(equalTo: siguienteCitaNotasView.bottomAnchor).isActive = true
        siguienteCitaNotasSeparador.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        siguienteCitaRecordarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        siguienteCitaRecordarView.widthAnchor.constraint(equalToConstant: self.revisarView.frame.width)
        siguienteCitaRecordarView.clipsToBounds = true
        siguienteCitaRecordarView.layer.cornerRadius = 10
        siguienteCitaRecordarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        siguienteCitaRecordarView.backgroundColor = UIColor.white
        
        siguienteCitaRecordarTitulo.translatesAutoresizingMaskIntoConstraints = false
        siguienteCitaRecordarTitulo.text = "Recordar"
        siguienteCitaRecordarTitulo.textColor = UIColor.black
        siguienteCitaRecordarTitulo.font = UIFont.boldSystemFont(ofSize: 16)
        siguienteCitaRecordarView.addSubview(siguienteCitaRecordarTitulo)
        siguienteCitaRecordarTitulo.leftAnchor.constraint(equalTo: siguienteCitaRecordarView.leftAnchor, constant: 16).isActive = true
        siguienteCitaRecordarTitulo.centerYAnchor.constraint(equalTo: siguienteCitaRecordarView.centerYAnchor).isActive = true
        
        siguienteCitaRecordarSwitch.translatesAutoresizingMaskIntoConstraints = false
        siguienteCitaRecordarSwitch.setOn(false, animated: false)
        siguienteCitaRecordarSwitch.addTarget(self, action: #selector(siguienteCitaRecordarCheck), for: .valueChanged)
        siguienteCitaRecordarView.addSubview(siguienteCitaRecordarSwitch)
        siguienteCitaRecordarSwitch.leftAnchor.constraint(equalTo: siguienteCitaRecordarTitulo.rightAnchor, constant: 3).isActive = true
        siguienteCitaRecordarSwitch.centerYAnchor.constraint(equalTo: siguienteCitaRecordarView.centerYAnchor).isActive = true
        
        siguienteCitaRecordarFecha.translatesAutoresizingMaskIntoConstraints = false
        siguienteCitaRecordarFecha.text = ""
        siguienteCitaRecordarFecha.textColor = UIColor.blue
        siguienteCitaRecordarFecha.isHidden = true
        siguienteCitaRecordarFecha.font = UIFont.systemFont(ofSize: 16)
        siguienteCitaRecordarView.addSubview(siguienteCitaRecordarFecha)
        siguienteCitaRecordarFecha.rightAnchor.constraint(equalTo: siguienteCitaRecordarView.rightAnchor, constant: -8).isActive = true
        siguienteCitaRecordarFecha.centerYAnchor.constraint(equalTo: siguienteCitaRecordarView.centerYAnchor).isActive = true
        
        
        siguienteCitaRecordarCalendario.translatesAutoresizingMaskIntoConstraints = false
        siguienteCitaRecordarCalendario.setImage(UIImage(named: "calendar_icon"), for: UIControlState.normal)
        siguienteCitaRecordarCalendario.isHidden = true
        siguienteCitaRecordarView.addSubview(siguienteCitaRecordarCalendario)
        siguienteCitaRecordarCalendario.widthAnchor.constraint(equalToConstant: 36).isActive = true
        siguienteCitaRecordarCalendario.heightAnchor.constraint(equalToConstant: 36).isActive = true
        siguienteCitaRecordarCalendario.centerYAnchor.constraint(equalTo: siguienteCitaRecordarView.centerYAnchor).isActive = true
        siguienteCitaRecordarCalendario.rightAnchor.constraint(equalTo: siguienteCitaRecordarView.rightAnchor, constant: -8).isActive = true
        
        siguienteCitaRecordarCalendario.addTarget(self, action: #selector(PacienteVC.tapSiguienteCitaFecha), for: UIControlEvents.touchUpInside)
        
        let tapPreanestesia = UITapGestureRecognizer(target: self, action: #selector(PacienteVC.tapSiguienteCitaFecha))
        siguienteCitaRecordarFecha.isUserInteractionEnabled = true
        siguienteCitaRecordarFecha.addGestureRecognizer(tapPreanestesia)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pruebasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pruebasCell", for: indexPath) as! PruebasTableViewCell
        cell.escogePrueba.setTitle(pruebasArray[indexPath.row].tipo == "" ? "Escoge prueba" : pruebasArray[indexPath.row].tipo, for: .normal)
        cell.escogePrueba.tipo = "pruebas"
        cell.escogePrueba.numeroPrueba = indexPath.row
        cell.escogePrueba.addTarget(self, action: #selector(PacienteVC.goToSelection), for: .touchUpInside)
        cell.calendario.isHidden = pruebasArray[indexPath.row].fecha == getDefaultDate() ? false : true
        cell.fechaText.isHidden = pruebasArray[indexPath.row].fecha == getDefaultDate() ? true : false
        cell.fechaText.setTitle(cell.fechaText.isHidden == true ? "" : formatter.string(from: pruebasArray[indexPath.row].fecha), for: .normal)
        cell.recordar.isOn = pruebasArray[indexPath.row].recordar
        cell.calendario.numeroPrueba = indexPath.row
        cell.calendario.addTarget(self, action: #selector(PacienteVC.tapPruebaCalendario), for: .touchUpInside)
        cell.fechaText.numeroPrueba = indexPath.row
        cell.fechaText.addTarget(self, action: #selector(PacienteVC.tapPruebaCalendario), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Borrar") { (rowAction, indexPath) in
            print("Deleted")
            self.pruebasArray.remove(at: indexPath.row)
            self.pruebasTabla.reloadData()
            self.pruebasAltura.constant = self.pruebasAltura.constant - 100
            self.mainHeight.constant = self.mainHeight.constant - 100
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
    
    @objc func goToSelection(_ sender: SeleccionarItemBotonClass){
        SeleccionRouter().goToSelection(navigationController: navigationController, delegate: self, tipo: sender.tipo,numeroPrueba: sender.numeroPrueba)
    }
    
    @objc func preanestesiaRealizadaClicked(){
        if(preanestesiaRealizada.isOn){
            tachadoFechaPreanestesia.isHidden = false
        }else{
            tachadoFechaPreanestesia.isHidden = true
        }
    }
    @objc func intervenidoChec(){
        intervenidoChecked()
    }
    
    func intervenidoChecked(){
        if(operadoSwitch.isOn){
            self.intervencionesView.removeArrangedSubview(fechaListaEsperaView)
            fechaListaEsperaView.removeFromSuperview()
            self.intervencionesView.removeArrangedSubview(fechaPreanestesiaView)
            fechaPreanestesiaView.removeFromSuperview()
            mainHeight.constant = mainHeight.constant - 300
        }else{
            self.intervencionesView.addArrangedSubview(fechaListaEsperaView)
            self.intervencionesView.addArrangedSubview(fechaPreanestesiaView)
            mainHeight.constant = mainHeight.constant + 300
        }
    }
    
    @objc func recordarRevisarCheck(){
        if(recordarRevisar.isOn){
            calendarioRevisar.isHidden = false
        }else{
            calendarioRevisar.isHidden = true
            fechaRevisar.isHidden = true
        }
    }
    
    @objc func siguienteCitaRecordarCheck(){
        if(siguienteCitaRecordarSwitch.isOn){
            siguienteCitaRecordarCalendario.isHidden = false
        }else{
            siguienteCitaRecordarCalendario.isHidden = true
            siguienteCitaRecordarFecha.isHidden = true
        }
    }
    
    @IBAction func nombreEditingBegin(_ sender: RAGTextField) {
        keyboardCanChangeView = false
    }
    @IBAction func nombreEditingEnd(_ sender: RAGTextField) {
        keyboardCanChangeView = true
    }
    @IBAction func nHistoriaEditingEnd(_ sender: RAGTextField) {
        keyboardCanChangeView = true
    }
    @IBAction func nHistoriaEditingBegin(_ sender: RAGTextField) {
        keyboardCanChangeView = false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if(keyboardCanChangeView){
            guard let userInfo = notification.userInfo else {return}
            guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyboardFrame = keyboardSize.cgRectValue
            mainScroll.contentOffset.y += keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if(keyboardCanChangeView){
            guard let userInfo = notification.userInfo else {return}
            guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyboardFrame = keyboardSize.cgRectValue
            mainScroll.contentOffset.y -= keyboardFrame.height
        }
    }
    @IBAction func onRevisarChecked(_ sender: UISwitch) {
        revisarChecked(checked: sender.isOn)
    }
    
    func revisarChecked(checked: Bool){
        if(checked){
            self.revisarView.addArrangedSubview(notasRevisarView)
            self.revisarView.addArrangedSubview(notasRecordarView)
            mainHeight.constant = mainHeight.constant + 170
        }else{
            self.revisarView.removeArrangedSubview(notasRevisarView)
            notasRevisarView.removeFromSuperview()
            self.revisarView.removeArrangedSubview(notasRecordarView)
            notasRecordarView.removeFromSuperview()
            mainHeight.constant = mainHeight.constant - 170
        }
    }
    
    @objc
    func tapSiguienteCitaFecha(sender: UITapGestureRecognizer){
        print("Siguiente cita")
        view.addSubview(calendarPopupSiguienteCita)
    }
    
    @objc
    func tapRevisarFecha(sender: UITapGestureRecognizer){
        print("Revisar")
        view.addSubview(calendarPopupRevisar)
    }
    
    @objc
    func tapListaEspera(sender:UITapGestureRecognizer) {
        print("Lista de espera")
        view.addSubview(calendarPopupListaEspera)
    }
    
    @objc
    func tapPreanestesia(sender:UITapGestureRecognizer) {
        print("Preanestesia")
        view.addSubview(calendarPopupPreanestesia)
    }
    
    @objc
    func tapIntervencion(sender:UITapGestureRecognizer) {
        print("Intervencion")
        view.addSubview(calendarPopupIntervencion)
    }
    
    @objc
    func siguienteCitaClicked(sender:UITapGestureRecognizer) {
        print("Siguiente cita")
        //view.addSubview(calendarPopupSiguienteCita)
    }
    
    private func setSelectedDateListaEspera(_ date: Date) {
        calendarPopupListaEspera.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                setListaEspera(date: date,delete: false)
            }else{
                setListaEspera(date: date,delete: true)
            }
        }
    }
    
    func setListaEspera(date: Date, delete: Bool){
        if(!delete){
            listaEsperaFechaValue = formatterSave.string(from: date)
            calendarIconListaEspera.isHidden = true
            fechaListaEsperaText.isHidden = false
            fechaListaEsperaText.text = formatter.string(from: date)
        }else{
            listaEsperaFechaValue = ""
            calendarIconListaEspera.isHidden = false
            fechaListaEsperaText.isHidden = true
            fechaListaEsperaText.text = ""
        }
    }
    
    private func setSelectedDatePreanestesia(_ date: Date) {
        calendarPopupPreanestesia.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                setPreanestesia(date: date, delete: false)
            }else{
                setPreanestesia(date: date, delete: true)
            }
        }
    }
    
    func setPreanestesia(date: Date, delete: Bool){
        if(!delete){
            preanestesiaFechaValue = formatterSave.string(from: date)
            calendarIconPreanestesia.isHidden = true
            fechaPreanestesiaText.isHidden = false
            fechaPreanestesiaText.text = formatter.string(from: date)
        }else{
            preanestesiaFechaValue = ""
            calendarIconPreanestesia.isHidden = false
            fechaPreanestesiaText.isHidden = true
            fechaPreanestesiaText.text = ""
        }
        
    }
    
    private func setSelectedDateIntervencion(_ date: Date) {
        calendarPopupIntervencion.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                setIntervencion(date: date, delete: false)
            }else{
                setIntervencion(date: date, delete: true)
            }
        }
    }
    
    func setIntervencion(date: Date, delete: Bool){
        if(!delete){
            intervencionFechaValue = formatterSave.string(from: date)
            calendarIconIntervencion.isHidden = true
            fechaIntervencionText.isHidden = false
            fechaIntervencionText.text = formatter.string(from: date)
        }else{
            intervencionFechaValue = ""
            calendarIconIntervencion.isHidden = false
            fechaIntervencionText.isHidden = true
            fechaIntervencionText.text = ""
        }
    }
    
    func setSelectedDateRevisar(date: Date){
        calendarPopupRevisar.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                setRevisar(date: date, delete: false)
            }else{
                setRevisar(date: date, delete: true)
            }
        }
    }
    
    func setRevisar(date: Date, delete: Bool){
        if(!delete){
            fechaRevisarValue = formatterSave.string(from: date)
            calendarioRevisar.isHidden = true
            fechaRevisar.isHidden = false
            fechaRevisar.text = formatter.string(from: date)
        }else{
            fechaRevisarValue = ""
            calendarioRevisar.isHidden = false
            fechaRevisar.isHidden = true
            fechaRevisar.text = ""
        }
    }
    
    
    
    @objc
    func tapPruebaCalendario(_ sender: PruebaCalendarioBotonClass) {
        print("Prueba")
        pruebaEnModificacion = sender.numeroPrueba!
        view.addSubview(calendarPopupPrueba)
    }
    
    private func setSelectedDatePrueba(_ date: Date) {
        calendarPopupPrueba.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                setDatePrueba(date: date, delete: false)
            }else{
                setDatePrueba(date: date, delete: true)
            }
        }
    }
    
    func setDatePrueba(date: Date, delete: Bool){
        if(!delete){
            pruebasArray[pruebaEnModificacion].fecha = date
        }else{
            pruebasArray[pruebaEnModificacion].fecha = getDefaultDate()
        }
        pruebasTabla.reloadData()
    }
    
    private func setSelectedDateSiguienteCita(_ date: Date) {
        calendarPopupSiguienteCita.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                setSiguienteCita(date: date, delete: false)
            }else{
                setSiguienteCita(date: date, delete: true)
            }
        }
    }
    
    func setSiguienteCita(date: Date, delete: Bool){
        if(!delete){
            siguienteFechaValue = formatterSave.string(from: date)
            siguienteCitaRecordarFecha.isHidden = false
            siguienteCitaRecordarCalendario.isHidden = true
            siguienteCitaRecordarFecha.text = formatter.string(from: date)
        }else{
            siguienteFechaValue = ""
            siguienteCitaRecordarFecha.isHidden = true
            siguienteCitaRecordarCalendario.isHidden = false
            siguienteCitaRecordarFecha.text = ""
        }
        
    }
    @IBAction func onSiguienteCitaClicked(_ sender: UISwitch) {
        siguienteCitaChecked(checked: sender.isOn)
    }
    
    func siguienteCitaChecked(checked: Bool){
        if(checked){
            self.siguienteCitaView.addArrangedSubview(siguienteCitaNotasView)
            self.siguienteCitaView.addArrangedSubview(siguienteCitaRecordarView)
            mainHeight.constant = mainHeight.constant + 170
        }else{
            self.siguienteCitaView.removeArrangedSubview(siguienteCitaNotasView)
            siguienteCitaNotasView.removeFromSuperview()
            self.siguienteCitaView.removeArrangedSubview(siguienteCitaRecordarView)
            siguienteCitaRecordarView.removeFromSuperview()
            mainHeight.constant = mainHeight.constant - 170
        }
    }
    
    @IBAction func anadirPruebasClick(_ sender: UIButton) {
        print("Añadir prueba")
        pruebasAltura.constant = pruebasAltura.constant + 100
        pruebasArray.append(Pruebas(tipo: "",fecha: getDefaultDate(),recordar: true))
        pruebasTabla.reloadData()
        mainHeight.constant = mainHeight.constant + 100
    }
    
    func cleanForm(){
        
        //INFORMACION GENERAL
        nHistoriaTextField.text = ""
        nombreTextField.text = ""
        patologia.setTitle("Ninguna", for: .normal)
        ///IQ
        intervencionSwitch.setOn(false, animated: true)
        tipoIntervencionButton.setTitle("Ninguna", for: .normal)
        fechaIntervencionText.text = ""
        fechaIntervencionText.isHidden = true
        calendarIconIntervencion.isHidden = false
        recordarIntervencionSwitch.setOn(true, animated: true)
        notasIntervencionTexto.text = ""
        fechaListaEsperaText.text = ""
        fechaListaEsperaText.isHidden = true
        calendarIconListaEspera.isHidden = false
        preanestesiaRealizada.setOn(false, animated: true)
        fechaPreanestesiaText.text = ""
        fechaPreanestesiaText.isHidden = true
        calendarIconPreanestesia.isHidden = false
        preanestesiaNotasText.text = ""
        ///PRUEBAS
        pruebasArray.removeAll()
        pruebasTabla.reloadData()
        ///REVISAR
        revisarSwitch.setOn(false,animated: true)
        notasRevisar.text = ""
        recordarRevisar.setOn(false, animated: true)
        fechaRevisar.text = ""
        fechaRevisar.isHidden = true
        calendarioRevisar.isHidden = false
        recordarRevisarCheck()
        ///SIGUIENTE CITA
        siguienteCitaSwitch.setOn(false, animated: true)
        siguienteCitaNotasText.text = ""
        siguienteCitaRecordarFecha.text = ""
        siguienteCitaRecordarFecha.isHidden = true
        siguienteCitaRecordarCalendario.isHidden = false
        siguienteCitaRecordarCheck()
        
        if(!operadoSwitch.isOn){
            self.intervencionesView.removeArrangedSubview(fechaListaEsperaView)
            fechaListaEsperaView.removeFromSuperview()
            self.intervencionesView.removeArrangedSubview(fechaPreanestesiaView)
            fechaPreanestesiaView.removeFromSuperview()
        }
        
        self.intervencionesView.removeArrangedSubview(operadoView)
        operadoView.removeFromSuperview()
        self.intervencionesView.removeArrangedSubview(tipoIntervencionView)
        tipoIntervencionView.removeFromSuperview()
        self.intervencionesView.removeArrangedSubview(fechaIntervencionView)
        fechaIntervencionView.removeFromSuperview()
        self.intervencionesView.removeArrangedSubview(notasIntervencionView)
        notasIntervencionView.removeFromSuperview()
        self.intervencionesView.removeArrangedSubview(recordarIntervencionView)
        recordarIntervencionView.removeFromSuperview()
        
        self.revisarView.removeArrangedSubview(notasRevisarView)
        notasRevisarView.removeFromSuperview()
        self.revisarView.removeArrangedSubview(notasRecordarView)
        notasRecordarView.removeFromSuperview()
        
        self.siguienteCitaView.removeArrangedSubview(siguienteCitaNotasView)
        siguienteCitaNotasView.removeFromSuperview()
        self.siguienteCitaView.removeArrangedSubview(siguienteCitaRecordarView)
        siguienteCitaRecordarView.removeFromSuperview()
        
        operadoSwitch.isOn = true
        //mainScroll.setContentOffset(.zero, animated: true)
        
        self.pruebasAltura.constant = 50
        self.mainHeight.constant = 600
        
    }
    
    @IBAction func guardarPaciente(_ sender: UIButton) {
        
        if(nHistoriaTextField.text != ""){
            if isNewNHistoria(nHistoria: nHistoriaTextField.text!){
                let paciente: Paciente = Paciente()
                let intervencionQuirurgica: IntervencionQuirurgica = IntervencionQuirurgica()
                let revisar: Revisar = Revisar()
                let siguienteCita: SiguienteCita = SiguienteCita()
                try! realm.write {
                    ///INFORMACION GENERAL
                    paciente.numeroHistoria = nHistoriaTextField.text!
                    paciente.nombre = nombreTextField.text!
                    paciente.patologia = patologia.title(for: UIControlState.normal)!
                    realm.add(paciente)
                    
                    ///IQ
                    if(intervencionSwitch.isOn){
                        intervencionQuirurgica.id = nHistoriaTextField.text!
                        intervencionQuirurgica.idIQ = 0
                        intervencionQuirurgica.intervencionQuirurgica = intervencionSwitch.isOn
                        intervencionQuirurgica.tipoIntervencion = tipoIntervencionButton.title(for: UIControlState.normal)!
                        intervencionQuirurgica.fechaIntervencion = fechaIntervencionText.text?.description == "" ? "1990-09-09".toDateFormat : intervencionFechaValue.toDateFormat
                        intervencionQuirurgica.recordarIntervencion = recordarIntervencionSwitch.isOn
                        intervencionQuirurgica.notasIntervencionQuirurgica = notasIntervencionTexto.text.description
                        intervencionQuirurgica.intervenido = operadoSwitch.isOn
                        intervencionQuirurgica.fechaListaEspera = fechaListaEsperaText.text?.description == "" ? "1990-09-09".toDateFormat : listaEsperaFechaValue.toDateFormat
                        intervencionQuirurgica.preanestesiaRealizada = preanestesiaRealizada.isOn
                        intervencionQuirurgica.fechaPreanestesia = fechaPreanestesiaText.text?.description == "" ? "1990-09-09".toDateFormat : preanestesiaFechaValue.toDateFormat
                        intervencionQuirurgica.notasPreanestesia = preanestesiaNotasText.text.description
                        realm.add(intervencionQuirurgica)
                    }
                    
                    //PRUEBAS
                    for (i,prueba) in pruebasArray.enumerated(){
                        let pruebaRealm: Prueba = Prueba()
                        pruebaRealm.idPrueba = i
                        pruebaRealm.id = nHistoriaTextField.text!
                        pruebaRealm.tipoPrueba = prueba.tipo
                        pruebaRealm.recordarPrueba = prueba.recordar
                        if(prueba.recordar){pruebaRealm.fechaPrueba = formatterSave.string(from: prueba.fecha).toDateFormat}else{pruebaRealm.fechaPrueba = "1990-09-09".toDateFormat}
                        realm.add(pruebaRealm)
                    }
                    
                    //REVISAR
                    if(revisarSwitch.isOn){
                        revisar.idRevisar = 0
                        revisar.id = nHistoriaTextField.text!
                        revisar.revisar = revisarSwitch.isOn
                        revisar.notasRevisar = notasRevisar.text.description
                        revisar.recordarRevisar = recordarRevisar.isOn
                        revisar.fechaRevisar = fechaRevisarValue.description == "" ? "1990-09-09".toDateFormat : fechaRevisarValue.toDateFormat
                        realm.add(revisar)
                    }
                    
                    //SIGUIENTE CITA
                    if(siguienteCitaSwitch.isOn){
                        siguienteCita.idCita = 0
                        siguienteCita.id = nHistoriaTextField.text!
                        siguienteCita.siguienteCita = siguienteCitaSwitch.isOn
                        siguienteCita.notasSiguienteCita = siguienteCitaNotasText.text
                        siguienteCita.recordarSiguienteCita = siguienteCitaRecordarSwitch.isOn
                        siguienteCita.fechaSiguienteCita = siguienteCitaRecordarFecha.text?.description == "" ? "1990-09-09".toDateFormat : siguienteFechaValue.toDateFormat
                        realm.add(siguienteCita)
                    }
                    
                    cleanForm()
                    print("guardado")
                    self.tabBarController?.selectedIndex = 0
                }
            }
            
        } else {
            showAlert(mensaje: "Para poder guardar un nuevo paciente tienes que asignarle un ID")
        }
    }
    
    func isNewNHistoria(nHistoria: String) -> Bool{
        let pacientes = realm.objects(Paciente.self)
        for paciente in pacientes{
            if paciente.numeroHistoria == nHistoria {
                showAlert(mensaje: "Este ID ya ha sido utilizado")
                return false
            }
        }
        return true
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
