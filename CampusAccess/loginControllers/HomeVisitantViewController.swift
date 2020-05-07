//
//  HomeVisitantViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 05/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class HomeVisitantViewController: UIViewController {

    @IBOutlet weak var btnLogOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogOut.layer.cornerRadius = 25.0
    }
    
    
    @IBAction func btnLogout(_ sender: UIButton) {
        let menu = storyboard?.instantiateViewController(withIdentifier: "homeView") as? ViewController
          view.window?.rootViewController = menu
          view.window?.makeKeyAndVisible()
    }
    

}
