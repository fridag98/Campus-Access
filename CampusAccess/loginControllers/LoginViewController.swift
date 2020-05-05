//
//  LoginViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 05/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "logoPrueba")!
    }
 
}
