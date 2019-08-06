//
//  IntervencionDetalleViewController.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 20/06/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import Foundation
import UIKit


class IntervencionDetalleViewController: BaseViewController{
    
    @IBOutlet weak var tabSelector: UISegmentedControl!
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var containerView: UIView!
    
    var nHistoria: String = ""
    var idIntervencion: Int = 0
    
    
    private lazy var generalViewControler: AnadirIntervencionViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "anadirIntervencionStoryboard") as! AnadirIntervencionViewController
        let intervencionPresenter = IntervencionesPresenter()
        intervencionPresenter.nHistoria = self.nHistoria
        vc.presenter = intervencionPresenter
        vc.idIntervencion = self.idIntervencion
        self.add(asChildViewController: vc)
        return vc
    
    }()
    
    private lazy var detalleViewController: DetalleTabViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "detalleTabViewController") as! DetalleTabViewController
        let intervencionPresenter = IntervencionesPresenter()
        intervencionPresenter.nHistoria = self.nHistoria
        viewController.presenter = intervencionPresenter
        viewController.idIQ = self.idIntervencion
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintNavigationBarWithOnlyBack(title: "")
        headerView.title.text = "Intervención"
        
        add(asChildViewController: generalViewControler)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        //viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        if tabSelector.selectedSegmentIndex == 0 {
            remove(asChildViewController: detalleViewController)
            add(asChildViewController: generalViewControler)
        } else {
            remove(asChildViewController: generalViewControler)
            add(asChildViewController: detalleViewController)
        }
    }
    
    @IBAction func tabSelectorValueChanged(_ sender: UISegmentedControl) {
        updateView()
        
    }
    
}
