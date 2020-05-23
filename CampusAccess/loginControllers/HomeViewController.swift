//
//  HomeStudentsViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 05/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {

    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var profileSettingsButton: UIButton!
    @IBOutlet weak var accessButton: UIButton!
    @IBOutlet weak var digitalServicesButton: UIButton!
    @IBOutlet weak var expresoTecButton: UIButton!
    
    let user : UserModel = UserModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogOut.layer.cornerRadius = 25.0
        self.navigationController?.navigationBar.isHidden = true
        
       // let user : UserModel = UserModel()
        
        if let usr = Auth.auth().currentUser {
            user.uid = usr.uid
            user.email = usr.email
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let db = Firestore.firestore()
        let collection = UserModel.getCollection(fromEmail: user.email)
        
        let docRef = db.collection(collection).whereField("uid", isEqualTo: user.uid ?? "")
        docRef.getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error!)
                return
            }
            else if querySnapshot!.documents.count != 1 {
                print("WARNING: Hay data inconsistente, mas de un documento con el mismo user-UID en la base de datos")
            }
            else {
                let document = querySnapshot!.documents.first
                let dataDescription = document?.data()
                guard let firstName = dataDescription?["firstname"] else { return }
                guard let lastName = dataDescription?["lastname"] else { return }
                // TODO: - Esto puede tener inconsistencias si se hace login en multiples celulares, super edge case que no creo que tenga impacto para el alcance del proyecto, pero bueno tomarlo en cuenta por si acaso
                // TODO: Agregarlo al documento de usuario en firebase
                guard let identificacionURL = dataDescription?["identificacionURL"] else { return }
                let isVisitor = UserModel.isUserVisitor(fromEmail: self.user.email)
                
                self.user.firstName = firstName as? String
                self.user.lastName = lastName as? String
                self.user.isVisitor = isVisitor
                
                //print(user)
                if self.user.isVisitor {
                    self.accessButton.titleLabel?.lineBreakMode = .byWordWrapping;
                    self.accessButton.setTitle("ACCESO\nAL\nCAMPUS", for: .normal)
                    self.accessButton.titleLabel?.textAlignment = .center
                    self.digitalServicesButton.isHidden = true
                    self.expresoTecButton.isHidden = true
                }
                self.profileSettingsButton.setTitle(self.user.firstName.uppercased(), for: .normal)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueVisitas" {
            let navigationControllerView = segue.destination as! UINavigationController
            let vistaRegistro = navigationControllerView.topViewController as! ListaVisitasViewController
            vistaRegistro.user = self.user
        }
    }
    
    @IBAction func buttonAcceso(_ sender: UIButton) {
        if user.isVisitor {
            self.performSegue(withIdentifier: "segueVisitas", sender: nil)
        }
        else {
            print("segue del alumno")
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
            /*
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let IntroVC = storyboard.instantiateViewController(withIdentifier: "IntroVC") as! introVC
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               appDelegate.window?.rootViewController = IntroVC
             */

           }
           catch let error as NSError {
               print(error.localizedDescription)
           }
    }

    // TODO: - Change this to go to root navigation controller and auth.signOut
    @IBAction func btnLogout(_ sender: UIButton) {
        logOut()
    }
    
    @IBAction func openAutoservicios(_ sender: UIButton) {
        guard let url = URL(string: "https://apps.powerapps.com/play/68d78026-73d2-462a-8508-987a11fb1074?tenantId=c65a3ea6-0f7c-400b-8934-5a6dc1705645") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func openExpresoTec(_ sender: UIButton) {
        guard let url = URL(string: "https://apps.powerapps.com/play/c69d30b8-398b-451e-8423-865c73116d6e?tenantId=c65a3ea6-0f7c-400b-8934-5a6dc1705645") else { return }
        UIApplication.shared.open(url)
    }
    
    
}
