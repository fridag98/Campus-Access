//
//  SigUpViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 05/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SigUpViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfContrasena: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "logoPrueba")!
        btnSignUp.layer.cornerRadius = 25.0
    }
    
    func isPasswordValid(_ password: String) -> Bool{
        //contraseña largo de minimo 8
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //regresar nil o un error message
    func validateFields() -> String? {
        //validar todo los campos llenos
        if (tfNombre.text == "" || tfApellido.text! == "" || tfCorreo.text! == "" || tfContrasena.text! == ""){
            return "Todos los datos deben ser llenados."
        }
        
        //validar si la contraseña es segura
        if(!isPasswordValid(tfContrasena.text!)){
            return "La contraseña debe de tener al menos 8 caracteres, 1 número y 1 caracter especial."
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        
        if(error != nil){
            showError(error!)
        } else{
            //crear usuario
            Auth.auth().createUser(withEmail: tfCorreo.text!, password: tfContrasena.text!) { (result, fail) in
                if fail != nil {
                    self.showError("No se pudo crear la cuenta")
                } else{
                    let db = Firestore.firestore()
                    db.collection("visitantes").addDocument(data: ["firstname":self.tfNombre.text!, "lastname":self.tfApellido.text!, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            print("No se guardaron los datos del usuario")
                        }
                    }
                    //ir a la pantalla necesaria
                    self.transitionToMenu()
                }
            }
        }
    }
    
    func showError(_ message:String){
        let alert = UIAlertController(title: "Campus Access", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
