//
//  NavigationBarUtil.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 30/05/2019.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func navigationView(withLogo: Bool = true, origin: UIViewController? = nil){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if(withLogo){addLogoButton(origin: origin)}
    }
    
    func paintNavigationBarWithOnlyBack(title: String){
        navigationView(withLogo: false)
        navigationTitle(title: title)
        addBackItem()
        let view = UIView(frame: UIApplication.shared.statusBarFrame)
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
    }
    
    func navigationTitle(title: String){
        let font = UIFont.boldSystemFont(ofSize: 16)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor : UIColor.black]
        self.navigationItem.title = title
    }
    
    func addBackItem(){
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "icon_back")?.withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        button.addTarget(self, action: #selector(UIViewController.navBackButton(_:)), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        
        let currWidth = barButton.customView?.widthAnchor.constraint(equalToConstant: 28)
        currWidth?.isActive = true
        let currHeight = barButton.customView?.heightAnchor.constraint(equalToConstant: 28)
        currHeight?.isActive = true
        
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func addLogoButton(origin: UIViewController?){
        let button: LogoBoton = LogoBoton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "app_logo")?.withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        if let from = origin{
            button.origin = from
        }
        button.addTarget(self, action: #selector(UIViewController.logo_clicked(_:)), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        
        let currWidth = barButton.customView?.widthAnchor.constraint(equalToConstant: 42)
        currWidth?.isActive = true
        let currHeight = barButton.customView?.heightAnchor.constraint(equalToConstant: 42)
        currHeight?.isActive = true
        
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @IBAction func navBackButton(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logo_clicked(_ sender: LogoBoton){
        let vc = sender.origin.storyboard!.instantiateViewController(withIdentifier: "configurationViewController")
        sender.origin.present(vc, animated: true, completion: nil)
    }
    
}

class LogoBoton: UIButton{
    var origin: UIViewController!
}
