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
    @IBOutlet weak var tfIdentificacion: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lbError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "logoPrueba")!
        lbError.alpha = 0
        btnSignUp.layer.cornerRadius = 25.0
    }
    
    func isPasswordValid(_ password: String) -> Bool{
        //largo de 8
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //si no hay error regresar nil else un error message
    func validateFields() -> String? {
        //validar todo los campos llenos
        if (tfNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfApellido.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfCorreo.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfContrasena.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            
            return "Llenar todos los datos"
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
            let correo = tfCorreo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let contrasena = tfContrasena.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //crear usuario
            Auth.auth().createUser(withEmail: correo, password: contrasena) { (result, fail) in
                if fail != nil {
                    self.showError("No se pudo crear la cuenta")
                } else{
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":self.tfNombre.text!, "lastname":self.tfApellido.text!, "uid": result!.user.uid]) { (error) in
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
