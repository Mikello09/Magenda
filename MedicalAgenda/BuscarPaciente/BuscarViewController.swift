//
//  BuscarViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 23/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import RealmSwift

struct BusquedaCeldasSub{
    var tipo: String
    var item: String
    var fecha: String
}

struct BusquedaCeldasMain{
    var nHistoria: String
    var patologia: String
    var tipo: String
    var subCeldas: [BusquedaCeldasSub]
}

class BuscarViewController: BaseViewController, FilterProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var headerView: HeaderWithIcon!
    @IBOutlet weak var calendarHastaLabel: UILabel!
    @IBOutlet weak var calendarHastaButton: UIButton!
    @IBOutlet weak var calendarDesdeLabel: UILabel!
    @IBOutlet weak var calendarDesdeButton: UIButton!
    @IBOutlet weak var calendarDiaLabel: UILabel!
    @IBOutlet weak var calendarDiaButton: UIButton!
    @IBOutlet weak var noPacientesLabel: UILabel!
    @IBOutlet weak var filtrarPorCollection: UICollectionView!
    @IBOutlet weak var filtrarPorLabel: UILabel!
    @IBOutlet weak var filtrarView: UIView!
    @IBOutlet weak var fechaView: UIView!
    @IBOutlet weak var filtrosView: UIView!
    var arrayBusquedas = [BusquedaCeldasMain]()
    var selectedFiltersArray = [FilterSelected]()
    @IBOutlet weak var resultadosTabla: UITableView!
    var diaDate = ""
    var desdeDate = ""
    var hastaDate = ""
    let realm = try! Realm()
    
    
    private lazy var calendarPopupDia: CalendarPopUpView = {
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
            self?.setSelectedDateDia(date: date)
        }
        
        return calendar
    }()
    
    private lazy var calendarPopupDesde: CalendarPopUpView = {
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
            self?.setSelectedDateDesde(date: date)
        }
        
        return calendar
    }()
    
    private lazy var calendarPopupHasta: CalendarPopUpView = {
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
            self?.setSelectedDateHasta(date: date)
        }
        
        return calendar
    }()
    
    override func viewDidLoad() {
        
        navigationView(origin: self)
        headerView.title.text = "Buscar"
        headerView.baseViewController = self
        
        bindView()
    }
    
    func bindView(){
        filtrosView.layer.shadowColor = UIColor.gray.cgColor
        filtrosView.layer.shadowOpacity = 0.8
        filtrosView.layer.shadowOffset = CGSize(width: 3,height: 3)
        filtrosView.layer.shadowRadius = 4
        
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(self.filtrarViewClicked))
        filtrarPorLabel.isUserInteractionEnabled = true
        filtrarPorLabel.addGestureRecognizer(viewTap)
        
        let diaTap = UITapGestureRecognizer(target: self, action: #selector(self.showDiaCalendar))
        calendarDiaLabel.isUserInteractionEnabled = true
        calendarDiaLabel.addGestureRecognizer(diaTap)
        
        let desdeTap = UITapGestureRecognizer(target: self, action: #selector(self.showDesdeCalendar))
        calendarDesdeLabel.isUserInteractionEnabled = true
        calendarDesdeLabel.addGestureRecognizer(desdeTap)
        
        let hastaTap = UITapGestureRecognizer(target: self, action: #selector(self.showHastaCalendar))
        calendarHastaLabel.isUserInteractionEnabled = true
        calendarHastaLabel.addGestureRecognizer(hastaTap)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        aplicarFiltros()
    }

    
    @objc
    func filtrarViewClicked(){
        performSegue(withIdentifier: "filterPopUp", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filterVC = segue.destination as! FilterViewController
        if(selectedFiltersArray.count > 0){
            selectedFiltersArray.remove(at: selectedFiltersArray.count - 1)
        }
        filterVC.filtrosPrecargados = selectedFiltersArray
        filterVC.delegate = self
    }
    
    func aplicarFiltros(){
        arrayBusquedas.removeAll()
        var pacientesFiltrados = [Paciente]()
        var pacientesAEliminar = [Int]()
        let pacientes = realm.objects(Paciente.self)
        let iq = realm.objects(IntervencionQuirurgica.self)
        let pruebas = realm.objects(Prueba.self)
        let revisar = realm.objects(Revisar.self)
        let siguienteCita = realm.objects(SiguienteCita.self)
        pacientesFiltrados = Array(pacientes)
        if(selectedFiltersArray.count > 0){
                for filtro in selectedFiltersArray{
                    pacientesAEliminar.removeAll()
                    switch filtro.tipo {
                        case "nHistoria":
                            if(pacientesFiltrados.contains(where: {$0.numeroHistoria.lowercased().contains(filtro.value.lowercased())})){
                                for (i,pacienteFiltrado) in pacientesFiltrados.enumerated(){
                                    if(!pacienteFiltrado.numeroHistoria.lowercased().contains(filtro.value.lowercased())){
                                        pacientesAEliminar.append(i)
                                    }
                                }
                                if(pacientesAEliminar.count > 0){
                                    for item in pacientesAEliminar.reversed() {
                                        pacientesFiltrados.remove(at: item)
                                    }
                                }
                            }else{
                                pacientesFiltrados.removeAll()
                            }
                            break;
                        case "nombre":
                            if(pacientesFiltrados.contains(where: {$0.nombre.lowercased().contains(filtro.value.lowercased())})){
                                for (i,pacienteFiltrado) in pacientesFiltrados.enumerated(){
                                    if(!pacienteFiltrado.nombre.lowercased().contains(filtro.value.lowercased())){
                                        pacientesAEliminar.append(i)
                                    }
                                }
                                if(pacientesAEliminar.count > 0){
                                    for item in pacientesAEliminar.reversed() {
                                        pacientesFiltrados.remove(at: item)
                                    }
                                }
                            }else{
                                pacientesFiltrados.removeAll()
                            }
                            break;
                        case "prueba":
                                for (i,pacienteFiltrado) in pacientesFiltrados.enumerated(){
                                    if(!pruebas.filter("id == %@", pacienteFiltrado.numeroHistoria).contains(where: {$0.tipoPrueba == filtro.value})){
                                        pacientesAEliminar.append(i)
                                    }
                                }
                                if(pacientesAEliminar.count > 0){
                                    for item in pacientesAEliminar.reversed() {
                                        pacientesFiltrados.remove(at: item)
                                    }
                                }
                            break;
                        case "intervenidoSi":
                            for(i,pacienteFiltrado) in pacientesFiltrados.enumerated(){
                                if(!iq.filter("id == %@", pacienteFiltrado.numeroHistoria).contains(where: {$0.intervenido == true})){
                                    pacientesAEliminar.append(i)
                                }
                            }
                            if(pacientesAEliminar.count > 0){
                                for item in pacientesAEliminar.reversed() {
                                    pacientesFiltrados.remove(at: item)
                                }
                            }
                            break;
                        case "intervenidoNo":
                            for(i,pacienteFiltrado) in pacientesFiltrados.enumerated(){
                                if(!iq.filter("id == %@", pacienteFiltrado.numeroHistoria).contains(where: {$0.intervenido == false})){
                                    pacientesAEliminar.append(i)
                                }
                            }
                            if(pacientesAEliminar.count > 0){
                                for item in pacientesAEliminar.reversed() {
                                    pacientesFiltrados.remove(at: item)
                                }
                            }
                        case "iq":
                                for (i,pacienteFiltrado) in pacientesFiltrados.enumerated(){
                                    if(!iq.filter("id == %@", pacienteFiltrado.numeroHistoria).contains(where: {$0.tipoIntervencion == filtro.value})){
                                        pacientesAEliminar.append(i)
                                    }
                                }
                                if(pacientesAEliminar.count > 0){
                                    for item in pacientesAEliminar.reversed() {
                                        pacientesFiltrados.remove(at: item)
                                    }
                                }
                            break;
                        case "patologia":
                            if(pacientesFiltrados.contains(where: {$0.patologia == filtro.value})){
                                for (i,pacienteFiltrado) in pacientesFiltrados.enumerated(){
                                    if(pacienteFiltrado.patologia != filtro.value){
                                        pacientesAEliminar.append(i)
                                    }
                                }
                                if(pacientesAEliminar.count > 0){
                                    for item in pacientesAEliminar.reversed() {
                                        pacientesFiltrados.remove(at: item)
                                    }
                                }
                            }else{
                                pacientesFiltrados.removeAll()
                            }
                            break;
                        default:
                            break;
                    }
            }
            
        }
        if(pacientesFiltrados.count > 0){
            if(calendarDiaLabel.text != "" || (calendarDesdeLabel.text != "" && calendarHastaLabel.text != "")){
                aplicarFiltrosFechas(pacientesFiltrados: pacientesFiltrados)
            }else{
                resultadosTabla.isHidden = false
                noPacientesLabel.isHidden = true
                for paciente in pacientesFiltrados {
                    arrayBusquedas.append(BusquedaCeldasMain(nHistoria: paciente.numeroHistoria,
                                                             patologia: paciente.patologia.replacingOccurrences(of: "|", with: ", "),
                                                             tipo: "",
                                                             subCeldas: getSubCeldas(paciente: paciente)))
                }
                resultadosTabla.reloadData()
            }
            
        }else{
            resultadosTabla.isHidden = true
            noPacientesLabel.isHidden = false
        }
    }
    
    func getSubCeldas(paciente: Paciente) -> [BusquedaCeldasSub]{
        var celdasSub = [BusquedaCeldasSub]()
        let intervencionesQuirurgicas = realm.objects(IntervencionQuirurgica.self).filter("id = %@", paciente.numeroHistoria)
        let pruebas = realm.objects(Prueba.self).filter("id = %@", paciente.numeroHistoria)
        let revisiones = realm.objects(Revisar.self).filter("id = %@", paciente.numeroHistoria)
        let siguientesCitas = realm.objects(SiguienteCita.self).filter("id = %@", paciente.numeroHistoria)
        for iq in intervencionesQuirurgicas{
            if(iq.fechaIntervencion != getDefaultDate()){
                celdasSub.append(BusquedaCeldasSub(tipo: "IQ", item: iq.tipoIntervencion, fecha: formatter.string(from: iq.fechaIntervencion)))
            }
            if(iq.fechaPreanestesia != getDefaultDate()){
                celdasSub.append(BusquedaCeldasSub(tipo: "Preanestesia", item: "Preanestesia", fecha: formatter.string(from: iq.fechaPreanestesia)))
            }
            if(iq.fechaListaEspera != getDefaultDate()){
                celdasSub.append(BusquedaCeldasSub(tipo: "ListaEspera", item: "Lista de espera", fecha: formatter.string(from: iq.fechaListaEspera)))
            }
        }
        for prueba in pruebas{
            if(prueba.fechaPrueba != getDefaultDate()){
                celdasSub.append(BusquedaCeldasSub(tipo: "Prueba", item: prueba.tipoPrueba, fecha: formatter.string(from: prueba.fechaPrueba)))
            }
        }
        for revisar in revisiones{
            if(revisar.fechaRevisar != getDefaultDate()){
                celdasSub.append(BusquedaCeldasSub(tipo: "Revisar", item: "Revisar", fecha: formatter.string(from: revisar.fechaRevisar)))
            }
        }
        for siguienteCita in siguientesCitas{
            if(siguienteCita.fechaSiguienteCita != getDefaultDate()){
                celdasSub.append(BusquedaCeldasSub(tipo: "SiguienteCita", item: "Siguiente cita", fecha: formatter.string(from: siguienteCita.fechaSiguienteCita)))
            }
        }
        return celdasSub
    }
    
    func aplicarFiltrosFechas(pacientesFiltrados: [Paciente]){
        var pacientesFiltradosPorFecha = [Paciente]()
        
        if(calendarDiaLabel.text != ""){
            for paciente in pacientesFiltrados{
                let intervencionesQuirurgicas = realm.objects(IntervencionQuirurgica.self).filter("id = %@", paciente.numeroHistoria)
                let pruebas = realm.objects(Prueba.self).filter("id = %@", paciente.numeroHistoria)
                let revisiones = realm.objects(Revisar.self).filter("id = %@", paciente.numeroHistoria)
                let siguientesCitas = realm.objects(SiguienteCita.self).filter("id = %@", paciente.numeroHistoria)
                var encontrado = false
                for iq in intervencionesQuirurgicas{
                    if(formatterSave.string(from:iq.fechaIntervencion) == diaDate ||
                        formatterSave.string(from:iq.fechaListaEspera) == diaDate ||
                        formatterSave.string(from:iq.fechaPreanestesia) == diaDate
                        ){
                        encontrado = true
                    }
                }
                for pr in pruebas{
                    if(formatterSave.string(from:pr.fechaPrueba) == diaDate){
                        encontrado = true
                    }
                }
                for rv in revisiones{
                    if(formatterSave.string(from:rv.fechaRevisar) == diaDate){
                        encontrado = true
                    }
                }
                for sc in siguientesCitas{
                    if(formatterSave.string(from:sc.fechaSiguienteCita) == diaDate){
                        encontrado = true
                    }
                }
                if(encontrado){pacientesFiltradosPorFecha.append(paciente)}
            }
        }else{
            for paciente in pacientesFiltrados{
                let intervencionesQuirurgicas = realm.objects(IntervencionQuirurgica.self).filter("id = %@", paciente.numeroHistoria)
                let pruebas = realm.objects(Prueba.self).filter("id = %@", paciente.numeroHistoria)
                let revisiones = realm.objects(Revisar.self).filter("id = %@", paciente.numeroHistoria)
                let siguientesCitas = realm.objects(SiguienteCita.self).filter("id = %@", paciente.numeroHistoria)
                var encontrado = false
                for iq in intervencionesQuirurgicas{
                    if((iq.fechaIntervencion >= toDateFormat(dateString: desdeDate) && iq.fechaIntervencion <= toDateFormat(dateString: hastaDate) ) ||
                        (iq.fechaListaEspera >= toDateFormat(dateString: desdeDate) && iq.fechaListaEspera <= toDateFormat(dateString: hastaDate)) ||
                        (iq.fechaPreanestesia >= toDateFormat(dateString: desdeDate) && iq.fechaPreanestesia <= toDateFormat(dateString: hastaDate))){
                        encontrado = true
                    }
                }
                for pr in pruebas{
                    if((pr.fechaPrueba >= toDateFormat(dateString: desdeDate) && pr.fechaPrueba <= toDateFormat(dateString: hastaDate))){
                        encontrado = true
                    }
                }
                for rv in revisiones{
                    if((rv.fechaRevisar >= toDateFormat(dateString: desdeDate) && rv.fechaRevisar <= toDateFormat(dateString: hastaDate))){
                        encontrado = true
                    }
                }
                for sc in siguientesCitas{
                    if((sc.fechaSiguienteCita >= toDateFormat(dateString: desdeDate) && sc.fechaSiguienteCita <= toDateFormat(dateString: hastaDate))){
                        encontrado = true
                    }
                }
                if(encontrado){pacientesFiltradosPorFecha.append(paciente)}
            }
        }
        if(pacientesFiltradosPorFecha.count > 0){
            resultadosTabla.isHidden = false
            noPacientesLabel.isHidden = true
            for paciente in pacientesFiltradosPorFecha {
                arrayBusquedas.append(BusquedaCeldasMain(nHistoria: paciente.numeroHistoria,
                                                         patologia: paciente.patologia,
                                                         tipo: "",
                                                         subCeldas: getSubCeldas(paciente: paciente)))
            }
            resultadosTabla.reloadData()
        }else{
            resultadosTabla.isHidden = true
            noPacientesLabel.isHidden = false
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedFiltersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterSelectedCell", for: indexPath) as! FilterSelectedBuscarCell
        if(selectedFiltersArray[indexPath.row].tipo == "AÑ"){
            cell.mainView.backgroundColor = UIColor.lightGray
            cell.title.text = "+"
            cell.title.textColor = UIColor.black
            cell.title.font = UIFont.boldSystemFont(ofSize: 22)
            let viewTap = UITapGestureRecognizer(target: self, action: #selector(self.filtrarViewClicked))
            cell.mainView.isUserInteractionEnabled = true
            cell.mainView.addGestureRecognizer(viewTap)
        }else{
            cell.title.font = UIFont.boldSystemFont(ofSize: 14)
            cell.title.text = selectedFiltersArray[indexPath.row].value
            cell.deleteButton.isHidden = true
            switch selectedFiltersArray[indexPath.row].tipo {
            case "nHistoria":
                cell.mainView.backgroundColor = colorGeneral
            case "nombre":
                cell.mainView.backgroundColor = colorGeneral
            case "prueba":
                cell.mainView.backgroundColor = colorPrueba
            case "iq":
                cell.mainView.backgroundColor = colorIQ
            case "patologia":
                cell.mainView.backgroundColor = colorPatologia
            case "intervenidoSi":
                cell.mainView.backgroundColor = colorGeneral
            case "intervenidoNo":
                cell.mainView.backgroundColor = colorGeneral
            default:
                cell.mainView.backgroundColor = UIColor.black
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(selectedFiltersArray[indexPath.row].tipo == "AÑ"){
            return CGSize(width: 40, height: 40)
        }else{
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: 30.0)
            let boundingBox = selectedFiltersArray[indexPath.row].value.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
            return CGSize(width: boundingBox.width + 30, height: 40.0)
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /*if section < arrayBusquedas.count {
            return arrayBusquedas[section].nHistoria
        }*/
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70))
        returnedView.backgroundColor = colorBase
        
        let imagen = UIImageView(frame: CGRect(x: 8, y: 10, width: 20, height: 20))
        imagen.image = UIImage(named: "report_card-2.png")
        returnedView.addSubview(imagen)
        
        let pacienteView = UIView(frame: CGRect(x: view.frame.size.width - 72, y: 10, width: 48, height: 48))
        pacienteView.layer.cornerRadius = 24
        pacienteView.backgroundColor = .white
        let pacienteImage = UIImageView(frame: CGRect(x: 14, y: 14, width: 20, height: 20))
        pacienteImage.image = UIImage(named: "user_male-2")
        pacienteView.addSubview(pacienteImage)
        pacienteImage.centerYAnchor.constraint(equalTo: pacienteView.centerYAnchor).isActive = true
        pacienteImage.centerXAnchor.constraint(equalTo: pacienteView.centerXAnchor).isActive = true
        returnedView.addSubview(pacienteView)
        pacienteView.centerYAnchor.constraint(equalTo: returnedView.centerYAnchor).isActive = true
        pacienteView.trailingAnchor.constraint(equalTo: returnedView.trailingAnchor).isActive = true
        
        let pacienteTap = BuscadorPacienteGesture(target: self, action: #selector(self.goToPaciente))
        pacienteTap.nHistoria = self.arrayBusquedas[section].nHistoria
        pacienteView.isUserInteractionEnabled = true
        pacienteView.addGestureRecognizer(pacienteTap)
        
        let label = UILabel(frame: CGRect(x: 36, y: 10, width: view.frame.size.width, height: 20))
        label.text = self.arrayBusquedas[section].nHistoria
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayBusquedas.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
        let animator = AnimationFactory.Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultadosMainCell", for: indexPath) as! ResultadosMainCell
        cell.backgroundColor = UIColor.black
        var altura = 50.0
        for _ in arrayBusquedas[indexPath.section].subCeldas{
            altura = altura + 100.0
        }
        cell.nHistoria = arrayBusquedas[indexPath.section].nHistoria
        cell.patologiaLabel.text = arrayBusquedas[indexPath.section].patologia
        tableView.rowHeight = CGFloat(altura)
        cell.mainHeight.constant = CGFloat(altura)
        cell.setSubCellData(data: arrayBusquedas[indexPath.section].subCeldas)
        cell.tablaSub.reloadData()
        return cell
    }
    
    func showCalendar(calendario: Int){
        switch calendario {
        case 0:
            view.addSubview(calendarPopupDia)
            break;
        case 1:
            view.addSubview(calendarPopupDesde)
            break;
        case 2:
            view.addSubview(calendarPopupHasta)
            break;
        default:
            break;
        }
    }
    
    @objc
    private func showDiaCalendar(){
        showCalendar(calendario: 0)
    }
    
    @objc
    private func showDesdeCalendar(){
        showCalendar(calendario: 1)
    }
    
    @objc
    private func showHastaCalendar(){
        showCalendar(calendario: 2)
    }
    
    @IBAction func onCalendarDiaClicked(_ sender: UIButton) {
        showDiaCalendar()
    }
    @IBAction func onCalendarDesdeClicked(_ sender: UIButton) {
        showDesdeCalendar()
    }
    @IBAction func onCalendarHastaClicked(_ sender: UIButton) {
        showHastaCalendar()
    }
    
    private func setSelectedDateDia(date: Date){
        calendarPopupDia.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                calendarDiaButton.isHidden = true
                calendarDiaLabel.isHidden = false
                calendarDiaLabel.text = formatter.string(from: date)
                diaDate = formatterSave.string(from: date)
            }else{
                calendarDiaButton.isHidden = false
                calendarDiaLabel.isHidden = true
            }
            configureFechasFiltros(calendario: 0)
        }
    }
    
    private func setSelectedDateDesde(date: Date){
        calendarPopupDesde.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                calendarDesdeButton.isHidden = true
                calendarDesdeLabel.isHidden = false
                calendarDesdeLabel.text = formatter.string(from: date)
                desdeDate = formatterSave.string(from: date)
            }else{
                calendarDesdeButton.isHidden = false
                calendarDesdeLabel.isHidden = true
            }
            configureFechasFiltros(calendario: 1)
        }
    }
    
    private func setSelectedDateHasta(date: Date){
        calendarPopupHasta.removeFromSuperview()
        if(date != getCloseDate()){
            if(date != getDefaultDate()){
                calendarHastaButton.isHidden = true
                calendarHastaLabel.isHidden = false
                calendarHastaLabel.text = formatter.string(from: date)
                hastaDate = formatterSave.string(from: date)
            }else{
                calendarHastaButton.isHidden = false
                calendarHastaLabel.isHidden = true
            }
            configureFechasFiltros(calendario: 2)
        }
    }
    
    func configureFechasFiltros(calendario: Int){
        switch calendario {
            case 0:
                calendarDesdeLabel.isHidden = true
                calendarDesdeLabel.text = ""
                calendarDesdeButton.isHidden = false
                calendarHastaLabel.isHidden = true
                calendarHastaLabel.text = ""
                calendarHastaButton.isHidden = false
                break;
            case 1:
                calendarDiaLabel.isHidden = true
                calendarDiaLabel.text = ""
                calendarDiaButton.isHidden = false
                if(calendarHastaLabel.text != ""){
                    if(calendarDesdeLabel.text!.presentationToDateFormat >= calendarHastaLabel.text!.presentationToDateFormat){
                        calendarDesdeLabel.isHidden = true
                        calendarDesdeLabel.text = ""
                        calendarDesdeButton.isHidden = false
                    }
                }
                break;
            case 2:
                calendarDiaLabel.isHidden = true
                calendarDiaLabel.text = ""
                calendarDiaButton.isHidden = false
                if(calendarDesdeLabel.text != ""){
                    if(calendarHastaLabel.text!.presentationToDateFormat <= calendarDesdeLabel.text!.presentationToDateFormat){
                        calendarHastaLabel.isHidden = true
                        calendarHastaLabel.text = ""
                        calendarHastaButton.isHidden = false
                    }
                }
                break;
            default:
                break;
        }
        aplicarFiltros()
    }
    
    
    ///FILTER PROTOCOL
    func exitFilter() {
        //todo
        print("exit")
    }
    
    func filterSelected(selectedFilters: [FilterSelected]) {
        if(selectedFilters.count > 0){
            self.selectedFiltersArray = selectedFilters
            self.selectedFiltersArray.append(FilterSelected(tipo: "AÑ", value: "", section: 0, row: 0))
            filtrarPorLabel.isHidden = true
            filtrarPorCollection.isHidden = false
            filtrarPorCollection.reloadData()
        }else{
            self.selectedFiltersArray.removeAll()
            filtrarPorLabel.isHidden = false
            filtrarPorCollection.isHidden = true
        }
        aplicarFiltros()
        
    }
    
    @objc
    func goToPaciente(sender: BuscadorPacienteGesture) {
        InformacionPacienteRouter().goToInformacionPaciente(navigationController: navigationController, nHistoria: sender.nHistoria)
    }
    
    @IBAction func refrescarClicked(_ sender: UIButton) {
        
        self.selectedFiltersArray.removeAll()
        filtrarPorLabel.isHidden = false
        filtrarPorCollection.isHidden = true
        calendarDiaButton.isHidden = false
        calendarDiaLabel.isHidden = true
        configureFechasFiltros(calendario: 0)
        calendarDiaLabel.text = ""
        calendarDesdeLabel.text = ""
        calendarHastaLabel.text = ""
        aplicarFiltros()
    }
}

class BuscadorPacienteGesture: UITapGestureRecognizer{
    var nHistoria: String!
}
