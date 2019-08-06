//
//  InformacionPacienteViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 12/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit

class InformacionPacienteViewController: BaseViewController, PatologiaSelected, UIScrollViewDelegate{
    
    var presenter: InformacionPacientePresenter!
    @IBOutlet weak var headerView: HeaderWithDetail!
    var nHistoria: String = ""
    
    
    @IBOutlet weak var nHistoriaLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    
    //INTERVENCIONES
    @IBOutlet weak var intervencionScrollView: UIScrollView!
    @IBOutlet weak var intervencionPageControll: UIPageControl!
    @IBOutlet weak var intervencionesView: UIView!
    @IBOutlet weak var intervencionSubView: UIView!
    
    ///PATOLOGIAS
    @IBOutlet weak var patologiaScrollView: UIScrollView!
    @IBOutlet weak var patologiasView: UIView!
    @IBOutlet weak var patologiaPageControl: UIPageControl!
    @IBOutlet weak var patologiaSubview: UIView!
    
    //PRUEBAS
    @IBOutlet weak var pruebasView: UIView!
    @IBOutlet weak var pruebasScrollView: UIScrollView!
    @IBOutlet weak var pruebasPageControl: UIPageControl!
    @IBOutlet weak var pruebaSubView: UIView!
    
    //REVISIONES
    @IBOutlet weak var revisionesView: UIView!
    @IBOutlet weak var revisionScrollView: UIScrollView!
    @IBOutlet weak var revisionPageControl: UIPageControl!
    @IBOutlet weak var revisionSubView: UIView!
    
    //CITAS
    @IBOutlet weak var citasView: UIView!
    @IBOutlet weak var citasScrollView: UIScrollView!
    @IBOutlet weak var citasPageControl: UIPageControl!
    @IBOutlet weak var citasSubView: UIView!
    
    
    override func viewDidLoad() {
        paintNavigationBarWithOnlyBack(title: "")
        headerView.title.text = "Paciente"
        headerView.detail.text = self.nHistoria
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.setPacienteModel(nHistoria: self.nHistoria)
        nombreLabel.text = presenter?.pacienteModel.nombre
        setUpViews()
    }
    
    func setUpViews(){
        //PATOLOGIA
        patologiasView.backgroundColor = colorGeneral
        patologiaSubview.backgroundColor = colorGeneral
        patologiaScrollView.delegate = self
        setupSlideScrollView(type: .patologia)
        patologiaPageControl.numberOfPages = (presenter?.getSlides(type: .patologia).count)!
        patologiaPageControl.currentPage = 0
        self.view.bringSubview(toFront: patologiaPageControl)
        //INTERVENCION
        intervencionesView.backgroundColor = colorIQ
        intervencionSubView.backgroundColor = colorIQ
        intervencionScrollView.delegate = self
        setupSlideScrollView(type: .intervencion)
        intervencionPageControll.numberOfPages = (presenter?.getSlides(type: .intervencion).count)!
        intervencionPageControll.currentPage = 0
        self.view.bringSubview(toFront: intervencionPageControll)
        //PRUEBAS
        pruebasView.backgroundColor = .white
        pruebaSubView.backgroundColor = .white
        pruebasScrollView.delegate = self
        setupSlideScrollView(type: .prueba)
        pruebasPageControl.numberOfPages = (presenter?.getSlides(type: .prueba).count)!
        pruebasPageControl.currentPage = 0
        self.view.bringSubview(toFront: pruebasPageControl)
        //REVISIONES
        revisionesView.backgroundColor = colorRevisar
        revisionSubView.backgroundColor = colorRevisar
        revisionScrollView.delegate = self
        setupSlideScrollView(type: .revision)
        revisionPageControl.numberOfPages = (presenter?.getSlides(type: .revision).count)!
        revisionPageControl.currentPage = 0
        self.view.bringSubview(toFront: revisionPageControl)
        //CITAS
        citasView.backgroundColor = colorSiguienteCita
        citasSubView.backgroundColor = colorSiguienteCita
        citasScrollView.delegate = self
        setupSlideScrollView(type: .cita)
        citasPageControl.numberOfPages = (presenter?.getSlides(type: .cita).count)!
        citasPageControl.currentPage = 0
        self.view.bringSubview(toFront: citasPageControl)
    }
    
    @IBAction func anadirIntervencionButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "anadirIntervencionStoryboard") as! AnadirIntervencionViewController
        let intervencionPresenter = IntervencionesPresenter()
        intervencionPresenter.nHistoria = self.nHistoria
        vc.presenter = intervencionPresenter
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func anadirPruebasClicked(_ sender: UIButton) {
        AnadirPruebaRouter().goToAnadirPrueba(navigationController: navigationController, nHistoria: self.nHistoria, idPrueba: -1)
    }
    
    func goToPrueba(idPrueba: Int){
        AnadirPruebaRouter().goToAnadirPrueba(navigationController: navigationController, nHistoria: self.nHistoria, idPrueba: idPrueba)
    }
    
    @IBAction func anadirCitaClicked(_ sender: UIButton) {
        SiguienteCitaRouter().goToSiguienteCita(navigationController: navigationController, nHistoria: self.nHistoria, idCita: -1)
    }
    
    func goToCita(idCita: Int){
        SiguienteCitaRouter().goToSiguienteCita(navigationController: navigationController, nHistoria: self.nHistoria, idCita: idCita)
    }
    
    func goToRevision(idRevision: Int){
        RevisionesRouter().goToRevisiones(navigationController: navigationController, nHistoria: self.nHistoria, idRevision: idRevision)
    }
    @IBAction func anadirRevisionClicked(_ sender: UIButton) {
        RevisionesRouter().goToRevisiones(navigationController: navigationController, nHistoria: self.nHistoria, idRevision: -1)
    }
    
    //SCROLLVIEW
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == patologiaScrollView{
            let pageIndex = round(scrollView.contentOffset.x/250)
            patologiaPageControl.currentPage = Int(pageIndex)
        }
        if scrollView == intervencionScrollView{
            let pageIndex = round(scrollView.contentOffset.x/250)
            intervencionPageControll.currentPage = Int(pageIndex)
        }
        if scrollView == pruebasScrollView{
            let pageIndex = round(scrollView.contentOffset.x/250)
            pruebasPageControl.currentPage = Int(pageIndex)
        }
    }
    
    ////PATOLOGIA
    @IBAction func anadirPatologiaClicked(_ sender: UIButton) {
        SeleccionRouter().goToSelection(navigationController: navigationController, delegate: self, tipo: "patologia", numeroPrueba: nil)
    }
    
    func onPatologiaSelected(patologiaSeleccionada: String, tipo: String, numeroPrueba: Int?) {
        presenter?.setPatologia(patologia: patologiaSeleccionada)
    }
    
    func intervencionClicked(intervencionId: Int){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleIntervencionStoryboard") as! IntervencionDetalleViewController
        vc.nHistoria = self.nHistoria
        vc.idIntervencion = intervencionId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupSlideScrollView(type: SlideType) {
        
        var slides = (presenter?.getSlides(type: type))!
        var anchura: CGFloat = 0.0
        var espacio: CGFloat = 0.0
        var margen: CGFloat = 0.0
        switch type {
        case .patologia:
            deleteSubviews(scroll: patologiaScrollView)
            anchura = patologiaScrollView.frame.width
            espacio = (patologiaScrollView.frame.width)*0.66
            margen = CGFloat(espacio/4)
            patologiaScrollView.contentSize = CGSize(width: anchura * CGFloat(slides.count), height: 100)
            patologiaScrollView.isPagingEnabled = true
        case .intervencion:
            deleteSubviews(scroll: intervencionScrollView)
            anchura = intervencionScrollView.frame.width
            espacio = (intervencionScrollView.frame.width)*0.66
            margen = CGFloat(espacio/4)
            intervencionScrollView.contentSize = CGSize(width: anchura * CGFloat(slides.count), height: 100)
            intervencionScrollView.isPagingEnabled = true
        case .prueba:
            deleteSubviews(scroll: pruebasScrollView)
            anchura = pruebasScrollView.frame.width
            espacio = (pruebasScrollView.frame.width)*0.90
            margen = CGFloat(espacio/20)
            pruebasScrollView.contentSize = CGSize(width: anchura * CGFloat(slides.count), height: 200)
            pruebasScrollView.isPagingEnabled = true
        case .revision:
            deleteSubviews(scroll: revisionScrollView)
            anchura = revisionScrollView.frame.width
            espacio = (revisionScrollView.frame.width)*0.66
            margen = CGFloat(espacio/4)
            revisionScrollView.contentSize = CGSize(width: anchura * CGFloat(slides.count), height: 100)
            revisionScrollView.isPagingEnabled = true
        case .cita:
            deleteSubviews(scroll: citasScrollView)
            anchura = citasScrollView.frame.width
            espacio = (citasScrollView.frame.width)*0.66
            margen = CGFloat(espacio/4)
            citasScrollView.contentSize = CGSize(width: anchura * CGFloat(slides.count), height: 100)
            citasScrollView.isPagingEnabled = true
        }
        for i in 0 ..< slides.count {
            switch type{
                case .patologia:
                    if(i == 0){
                        slides[i].frame = CGRect(x: margen, y: 0, width: espacio, height: 100)
                    }else{
                        let xValue = CGFloat((espacio/4)*(CGFloat(i + 1))) + espacio * CGFloat(i) + margen*CGFloat(i)
                        slides[i].frame = CGRect(x: xValue , y: 0, width: espacio, height: 100)
                    }
                    patologiaScrollView.addSubview(slides[i])
                case .intervencion:
                    if(i == 0){
                        slides[i].frame = CGRect(x: margen, y: 0, width: espacio, height: 200)
                    }else{
                        let xValue = CGFloat((espacio/4)*(CGFloat(i + 1))) + espacio * CGFloat(i) + margen*CGFloat(i)
                        slides[i].frame = CGRect(x: xValue , y: 0, width: espacio, height: 200)
                    }
                    intervencionScrollView.addSubview(slides[i])
                case .prueba:
                    if(i == 0){
                        slides[i].frame = CGRect(x: margen, y: 0, width: espacio, height: 150)
                    }else{
                        let xValue = CGFloat((espacio/20)*(CGFloat(i + 1))) + espacio * CGFloat(i) + margen*CGFloat(i)
                        slides[i].frame = CGRect(x: xValue , y: 0, width: espacio, height: 150)
                    }
                    pruebasScrollView.addSubview(slides[i])
                case .revision:
                    if(i == 0){
                        slides[i].frame = CGRect(x: margen, y: 0, width: espacio, height: 200)
                    }else{
                        let xValue = CGFloat((espacio/4)*(CGFloat(i + 1))) + espacio * CGFloat(i) + margen*CGFloat(i)
                        slides[i].frame = CGRect(x: xValue , y: 0, width: espacio, height: 200)
                    }
                    revisionScrollView.addSubview(slides[i])
                case .cita:
                    if(i == 0){
                        slides[i].frame = CGRect(x: margen, y: 0, width: espacio, height: 200)
                    }else{
                        let xValue = CGFloat((espacio/4)*(CGFloat(i + 1))) + espacio * CGFloat(i) + margen*CGFloat(i)
                        slides[i].frame = CGRect(x: xValue , y: 0, width: espacio, height: 200)
                    }
                    citasScrollView.addSubview(slides[i])
            }
            
        }
    }
    
    func deleteSubviews(scroll: UIScrollView){
        let subViews = scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
    }
}
