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
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeSpinner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "logoPrueba")!
        btnLogin.layer.cornerRadius = 25.0
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.showSpinner()
        if(tfCorreo.text! != "" && tfContrasena.text! != ""){
            signIn()
        } else {
            self.removeSpinner()
            showError("Todos los datos deben llenarse")
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: tfCorreo.text!, password: tfContrasena.text!) { (result, error) in
            if error != nil {
                self.removeSpinner()
                self.showError("Contraseña o correo incorrecto")
            } else { //ir a la vista según el tipo
                self.performSegue(withIdentifier: "toHomeViewControllerFromLogIn", sender: self)
            }
        }
    }
    
    func showError(_ message:String){
        let alert = UIAlertController(title: "Campus Access", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
        
    @IBAction func btnInicio(_ sender: Any) {
       // dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
}
