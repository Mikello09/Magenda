//
//  ViewController.swift
//  MedicalAgenda
//
//  Created by Juan Carlos Lopez Armendariz on 15/03/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import VACalendar
import RealmSwift
import NotificationCenter

struct PreFechas {
    var id: String
    var date: Date
    var tipo: String
    var dots: UIColor
}


class ViewController: BaseViewController, AuthProtocol {

    
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var heightToday: NSLayoutConstraint!
    @IBOutlet weak var headerView: Header!
    var calendarView: VACalendarView!
    var realm = try! Realm()
    var preFechas = [PreFechas]()
    var fromNotification: Bool = false
    var isAuthenticated: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView(origin: self)
        headerView.title.text = "Calendario"
        infoView.layer.borderColor = colorBase.cgColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCalendario()
        self.tabBarController?.tabBar.isHidden = false
        NotificationsManager.shared.clearBadge()
        if !isAuthenticated {
            performSegue(withIdentifier: "authPopUp", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "authPopUp"{
            let destinationVC:AuthenticationViewController = segue.destination as! AuthenticationViewController
            destinationVC.delegate = self
        }
        
    }
    
    func fbButtonPressed() {
        
        print("Share to fb")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(weekDaysView != nil && weekDaysView.frame != nil){
            let altura = weekDaysView.frame.maxY + 80 ?? 100
            
            if calendarView?.frame == .zero {
                calendarView.frame = CGRect(
                    x: 0,
                    y: altura,
                    width: view.frame.width,
                    height: view.frame.height - altura
                )
                calendarView.setup()
            }
        }
    }
    
    func setCalendario(){
        
        if(calendarView != nil){
            calendarView.removeFromSuperview()
        }
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal
        cargarFechas()
        view.addSubview(calendarView)
    }
    
    func cargarFechas(){
        realm = try! Realm()
        let pacientes = realm.objects(Paciente.self)
        var suplemento = [(Date(),[VADaySupplementary]())]
        preFechas = [PreFechas]()
        if(pacientes.count > 0){
            let intervencionesQuirurgicas = realm.objects(IntervencionQuirurgica.self)
            for iq in intervencionesQuirurgicas{
                if(iq.intervencionQuirurgica && iq.recordarIntervencion){
                    if(iq.fechaIntervencion != getDefaultDate()){//AZUL
                        preFechas.append(PreFechas(id: iq.id, date: iq.fechaIntervencion,tipo:"IN",dots: colorIQ))
                    }
                    if(!iq.intervenido){
                        if(iq.fechaListaEspera != getDefaultDate()){///ROJO
                            preFechas.append(PreFechas(id: iq.id,date: iq.fechaListaEspera,tipo: "IQ",dots: colorIQ))
                        }
                        if(iq.fechaPreanestesia != getDefaultDate()){//VERDE
                            preFechas.append(PreFechas(id: iq.id, date: iq.fechaPreanestesia,tipo: "PA",dots: colorIQ))
                        }
                    }
                }
            }
            let pruebas = realm.objects(Prueba.self)
            for prueba in pruebas{
                preFechas.append(PreFechas(id: prueba.id, date: prueba.fechaPrueba,tipo:"P", dots: colorPrueba))
            }
            let revisiones = realm.objects(Revisar.self)
            for revisar in revisiones{
                preFechas.append(PreFechas(id: revisar.id, date: revisar.fechaRevisar,tipo:"P2", dots: colorRevisar))
            }
            let siguientesCitas = realm.objects(SiguienteCita.self)
            for siguienteCita in siguientesCitas{
                preFechas.append(PreFechas(id: siguienteCita.id, date: siguienteCita.fechaSiguienteCita,tipo:"SC", dots: colorSiguienteCita))
            }
        }
        var preFechasEncontradas = [PreFechas]()
        var fechasPintadas = [PreFechas]()
        var contador1 = 0
        var contador2 = 0
        for fecha1 in preFechas{
            if(!fechasPintadas.contains(where: {$0.date == fecha1.date})){
                contador2 = 0
                var fechaIgual = false
                preFechasEncontradas.removeAll()
                for fecha2 in preFechas{
                    if(contador1 != contador2){
                        if(fecha1.date == fecha2.date){
                            fechaIgual = true
                            preFechasEncontradas.append(fecha2)
                            fechasPintadas.append(fecha2)
                        }
                    }
                    contador2 += 1
                }
                if(!fechaIgual){
                    suplemento.append((date: fecha1.date,dots: [VADaySupplementary.bottomDots([fecha1.dots])]))
                }else{
                    switch preFechasEncontradas.count{
                        case 1:
                            suplemento.append((date: fecha1.date,dots: [VADaySupplementary.bottomDots([fecha1.dots, preFechasEncontradas[0].dots])]))
                            break
                        case 2:
                            suplemento.append((date: fecha1.date,dots: [VADaySupplementary.bottomDots([fecha1.dots, preFechasEncontradas[0].dots, preFechasEncontradas[1].dots])]))
                            break
                        case 3:
                            suplemento.append((date: fecha1.date,dots: [VADaySupplementary.bottomDots([fecha1.dots, preFechasEncontradas[0].dots, preFechasEncontradas[1].dots, preFechasEncontradas[2].dots])]))
                            break
                        default:
                            suplemento.append((date: fecha1.date,dots: [VADaySupplementary.bottomDots([fecha1.dots])]))
                            break
                    }
                }
            }
            contador1 += 1
        }
        calendarView.setSupplementaries(suplemento as [(Date,[VADaySupplementary])])
        crearNotificaciones(dias: suplemento as [(Date,[VADaySupplementary])])
        let fech = formatterSave.string(from: Date()).toDateFormat
        if(preFechas.contains(where: {$0.date == fech})){
            //self.heightToday.constant = 80
            self.todayView.isHidden = false
        }else{
            //self.heightToday.constant = 0
            self.todayView.isHidden = true
        }
    }
    
    func crearNotificaciones(dias: [(Date, [VADaySupplementary])]){
        NotificationsManager.shared.cancelAllNotifications()
        for dia in dias{
            NotificationsManager.shared.generateNotification(fecha: dia.0)
        }
    }
    
    @IBAction func todayButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tareasStoryboard") as! TareasViewController
        vc.fechaSeleccionada = formatterSave.string(from: Date()).toDateFormat
        navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBOutlet weak var monthHeaderView: VAMonthHeaderView!{
        didSet {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            dateFormatter.locale = Locale(identifier: "es")
            
            let appereance = VAMonthHeaderViewAppearance(
                previousButtonImage: #imageLiteral(resourceName: "previous"),
                nextButtonImage: #imageLiteral(resourceName: "next"),
                dateFormatter: dateFormatter
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView!{
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
}

extension ViewController: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
    }
    
}

extension ViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .black
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
}

extension ViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .red
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
    func authenticated() {
        self.isAuthenticated = true
        if NotificationsManager.shared.fromNotifications{
            NotificationsManager.shared.fromNotifications = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tareasStoryboard") as! TareasViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: VACalendarViewDelegate {
    
    func selectedDates(_ dates: [Date]) {
        calendarView.startDate = dates.last ?? Date()
        if(dates.count > 0){
            for fechas in preFechas{
                if(dates[0] == fechas.date){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "tareasStoryboard") as! TareasViewController
                    vc.fechaSeleccionada = dates[0]
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
        }
    }
}

