//
//  LoginViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 05/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfContrasena: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lbError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "logoPrueba")!
        lbError.alpha = 0
        btnLogin.layer.cornerRadius = 25.0

    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if(tfCorreo.text! != "" && tfContrasena.text! != ""){
            signIn()
        } else {
            showError("Llenar todos los datos")
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: tfCorreo.text!, password: tfContrasena.text!) { (result, error) in
            if error != nil {
                self.showError("Contraseña o correo incorrecto")
            } else {
                self.transitionToMenu()
            }
        }
    }
    
    func showError(_ message:String){
        lbError.text = message
        lbError.alpha = 1
    }
    
    func transitionToMenu(){
        let visitorsMenu = storyboard?.instantiateViewController(withIdentifier: "visitorsMenu") as? HomeVisitantViewController
        view.window?.rootViewController = visitorsMenu
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func btnInicio(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
}
