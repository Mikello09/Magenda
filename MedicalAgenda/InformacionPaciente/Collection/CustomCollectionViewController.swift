//
//  CustomCollectionViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 20/07/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

struct InfoPaciente{
    var tipo: TipoInfo
    var informacion: [Informacion]
}

struct Informacion{
    var titulo: String
    var visto: Bool
    var fecha: Date?
}

enum TipoInfo: String {
    case patologia = "Patologia"
    case iq = "Intervención"
    case prueba = "Pruebas"
    case revisar = "Revisar"
    case siguienteCita = "Citas"
}

class CustomCollectionViewController: BaseViewController{
    
    @IBOutlet weak var headerView: HeaderWithDetail!
    @IBOutlet weak var nombreLabel: UILabel!
    var items: [InfoPaciente] = [InfoPaciente]()
    var presenter: InformacionPacientePresenter!
    var nHistoria: String!
    
    var tablaPatologias: UITableView!
    var tablaIQ: UITableView!
    var tablaPruebas: UITableView!
    var tablaRevisar: UITableView!
    var tablaCita: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintNavigationBarWithOnlyBack(title: "")
        headerView.title.text = "Paciente"
        headerView.detail.text = self.nHistoria
        self.collection.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paintCells()
        nombreLabel.text = presenter?.pacienteModel.nombre
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collection.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        self.collection.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func paintCells(){
        items.removeAll()
        
        presenter?.setPacienteModel(nHistoria: self.nHistoria)
        //nombreLabel.text = presenter?.pacienteModel.nombre
        
        //PATOLOGIA
        var informacion: [Informacion] = [Informacion]()
        for patologia in presenter.pacienteModel.patologias.components(separatedBy: "|"){
            informacion.append(Informacion(titulo: patologia, visto: false, fecha: nil))
        }
        items.append(InfoPaciente(tipo: .patologia, informacion: informacion))
        
        ///INTERVENCION
        informacion = [Informacion]()
        for intervencion in presenter.pacienteModel.iq{
            informacion.append(Informacion(titulo: intervencion.tipoIntervencion, visto: intervencion.vistoIq, fecha: intervencion.fechaIntervencion))
        }
        items.append(InfoPaciente(tipo: .iq, informacion: informacion))
        
        //PRUEBAS
        informacion = [Informacion]()
        for prueba in presenter.pacienteModel.prueba{
            informacion.append(Informacion(titulo: prueba.tipoPrueba, visto: prueba.vistoPrueba, fecha: prueba.fechaPrueba))
        }
        items.append(InfoPaciente(tipo: .prueba, informacion: informacion))
        
        //REVISAR
        informacion = [Informacion]()
        for revision in presenter.pacienteModel.revisar{
            informacion.append(Informacion(titulo: revision.notasRevisar, visto: revision.vistoRevisar, fecha: revision.fechaRevisar))
        }
        items.append(InfoPaciente(tipo: .revisar, informacion: informacion))
        
        //SIGUIENTE CITA
        informacion = [Informacion]()
        for cita in presenter.pacienteModel.siguienteCita{
            informacion.append(Informacion(titulo: cita.notasSiguienteCita, visto: cita.vistoSiguienteCita, fecha: cita.fechaSiguienteCita))
        }
        items.append(InfoPaciente(tipo: .siguienteCita, informacion: informacion))
        
        if let _ = self.tablaPatologias{
            self.tablaPatologias.reloadData()
        }
        if let _ = self.tablaIQ{
            self.tablaIQ.reloadData()
        }
        if let _ = self.tablaPruebas{
            self.tablaPruebas.reloadData()
        }
        if let _ = self.tablaRevisar{
            self.tablaRevisar.reloadData()
        }
        if let _ = self.tablaCita{
            self.tablaCita.reloadData()
        }
    }
  
}

extension CustomCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath as IndexPath) as! CustomCollectionCell
        cell.delegate = self
        cell.data = items[indexPath.row]
        switch items[indexPath.row].tipo {
        case .patologia:
            self.tablaPatologias = cell.tabla
            cell.title.textColor = colorPatologia
            cell.anadirButton.setBackgroundImage(UIImage(named: "add_patologia"), for: .normal)
            break
        case .iq:
            self.tablaIQ = cell.tabla
            cell.title.textColor = colorIQ
            cell.anadirButton.setBackgroundImage(UIImage(named: "add_iq"), for: .normal)
            break
        case .prueba:
            self.tablaPruebas = cell.tabla
            cell.title.textColor = colorPrueba
            cell.anadirButton.setBackgroundImage(UIImage(named: "add_prueba"), for: .normal)
            break
        case .revisar:
            self.tablaRevisar = cell.tabla
            cell.title.textColor = colorRevisar
            cell.anadirButton.setBackgroundImage(UIImage(named: "add_revisar"), for: .normal)
            break
        case .siguienteCita:
            self.tablaCita = cell.tabla
            cell.title.textColor = colorSiguienteCita
            cell.anadirButton.setBackgroundImage(UIImage(named: "add_cita"), for: .normal)
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 300)
    }
    
}

extension CustomCollectionViewController: CustomCollectionProtocol{
    func visto(tipo: TipoInfo, row: Int, visto: Bool) {
        presenter.setVistos(tipo: tipo, visto: visto, row: row, nHistoria: self.nHistoria)
    }
    
    func eliminar(tipo: TipoInfo, row: Int) {
        switch tipo {
        case .patologia:
            presenter.deletePatologia(row: row)
            paintCells()
            break
        case .iq:
            presenter.deleteIQ(nHistoria: self.nHistoria, row: row)
            paintCells()
            break
        case .prueba:
            presenter.deletePrueba(nHistoria: self.nHistoria, row: row)
            paintCells()
            break
        case .revisar:
            presenter.deleteRevisar(nHistoria: self.nHistoria, row: row)
            paintCells()
            break
        case .siguienteCita:
            presenter.deleteCita(nHistoria: self.nHistoria, row: row)
            paintCells()
            break
        }
        //self.collection.reloadData()
        return
    }
    
    func rowClicked(tipo: TipoInfo, row: Int) {
        switch tipo {
        case .patologia:
            break
        case .iq:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "detalleIntervencionStoryboard") as! IntervencionDetalleViewController
            vc.nHistoria = self.nHistoria
            vc.idIntervencion = row
            navigationController?.pushViewController(vc, animated: true)
            break
        case .prueba:
            AnadirPruebaRouter().goToAnadirPrueba(navigationController: navigationController, nHistoria: self.nHistoria, idPrueba: row)
            break
        case .revisar:
            RevisionesRouter().goToRevisiones(navigationController: navigationController, nHistoria: self.nHistoria, idRevision: row)
            break
        case .siguienteCita:
            SiguienteCitaRouter().goToSiguienteCita(navigationController: navigationController, nHistoria: self.nHistoria, idCita: row)
            break
        }
    }
    
    func anadir(tipo: TipoInfo) {
        switch tipo {
        case .patologia:
            SeleccionRouter().goToSelection(navigationController: navigationController, delegate: self, tipo: "patologia", numeroPrueba: nil)
            break
        case .iq:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "anadirIntervencionStoryboard") as! AnadirIntervencionViewController
            let intervencionPresenter = IntervencionesPresenter()
            intervencionPresenter.nHistoria = self.nHistoria
            vc.presenter = intervencionPresenter
            navigationController?.pushViewController(vc, animated: true)
            break
        case .prueba:
            AnadirPruebaRouter().goToAnadirPrueba(navigationController: navigationController, nHistoria: self.nHistoria, idPrueba: -1)
            break
        case .revisar:
            RevisionesRouter().goToRevisiones(navigationController: navigationController, nHistoria: self.nHistoria, idRevision: -1)
            break
        case .siguienteCita:
            SiguienteCitaRouter().goToSiguienteCita(navigationController: navigationController, nHistoria: self.nHistoria, idCita: -1)
            break
        }
    }
}

extension CustomCollectionViewController: PatologiaSelected{
    func onPatologiaSelected(patologiaSeleccionada: String, tipo: String, numeroPrueba: Int?) {
        presenter?.setPatologia(patologia: patologiaSeleccionada)
        if let _ = self.tablaPatologias{
            self.tablaPatologias.reloadData()
        }
    }
}
