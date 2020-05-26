//
//  DetalleUsuarioViewController.swift
//  CampusAccess
//
//  Created by Iñaki Janeiro Olague on 23/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import Firebase

class DetalleUsuarioViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var updatePictureButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    var imgIdentificacion : UIImage!

    let user : UserModel = UserModel()
    
    var document : DocumentSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showSpinner()
        // Do any additional setup after loading the view.
        actionButton.layer.cornerRadius = 25.0
        updatePictureButton.layer.cornerRadius = 25.0
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
                self.document = querySnapshot!.documents.first
                let dataDescription = self.document?.data()
                guard let firstName = dataDescription?["firstname"] else { return }
                guard let lastName = dataDescription?["lastname"] else { return }
                // TODO: - Esto puede tener inconsistencias si se hace login en multiples celulares, super edge case que no creo que tenga impacto para el alcance del proyecto, pero bueno tomarlo en cuenta por si acaso
                // TODO: Agregarlo al documento de usuario en firebase
                guard let identificacionURL : String = dataDescription?["identificacionURL"] as? String else { return }

                let isVisitor = UserModel.isUserVisitor(fromEmail: self.user.email)
                print(identificacionURL)
                let url = NSURL(string: identificacionURL)! as URL
                print(url)
                if let imageData: NSData = NSData(contentsOf: url) {
                    self.user.profilePictue = UIImage(data: imageData as Data)
                }
               
                
                self.user.firstName = firstName as? String
                self.user.lastName = lastName as? String
                self.user.isVisitor = isVisitor
                
                self.tfName.text = self.user.firstName
                self.tfLastName.text = self.user.lastName
                self.tfEmail.text = self.user.email
                self.profilePicture.image = self.user.profilePictue
                
                if !self.user.isVisitor {
                    self.tfName.isEnabled = false
                    self.tfLastName.isEnabled = false
                    self.updatePictureButton.isHidden = true
                    self.actionButton.isHidden = true
                }
               
                self.removeSpinner()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editIden" {
            let identificacionView = segue.destination as! IdentificacionViewController
            identificacionView.btnEditHidden = false
        }
    }
    
    @IBAction func unwindIdentificacionToEdit(unwindSegue : UIStoryboardSegue){
        if imgIdentificacion != nil {
            profilePicture.image = imgIdentificacion
        }
        
    }

    @IBAction func guardarInfo(_ sender: UIButton) {
        
        let tfNameIsEmpty = (tfName.text ?? "").isEmpty
        let tfLastNameIsEmpty = (tfLastName.text ?? "").isEmpty
        
        if tfNameIsEmpty || tfLastNameIsEmpty {
            showError("No puede haber campos vacios")
            return
        }
        
        showSpinner()
        let db = Firestore.firestore()
        
        if (imgIdentificacion != nil) {
            guard let imageData = imgIdentificacion.jpegData(compressionQuality: 0.4) else {
                return
            }
                    
            let storageRef = Storage.storage().reference(forURL: "gs://campusaccess-863ef.appspot.com")
            let storageIdenRef = storageRef.child("identificacion").child(user.uid)
                               
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageIdenRef.putData(imageData, metadata: metadata, completion: {(storageMetadata,error) in
                if error != nil{
                    print("error en subir la foto")
                    return
                }
                
                storageIdenRef.downloadURL(completion: {(url, error) in
                    var identificacionURL : String?
                    if let metaImageUrl = url?.absoluteString {
                        //print(metaImageUrl)
                        identificacionURL = metaImageUrl
                    }
                    let collection = UserModel.getCollection(fromEmail: self.user.email)
                    db.collection(collection).document(self.document!.documentID).updateData([
                        "firstname" : self.tfName.text!,
                        "lastname" : self.tfLastName.text!,
                        "identificacionURL": identificacionURL!
                    ]) { (error) in
                        if (error != nil){
                            print("error al actualizar datos")
                        }
                        self.removeSpinner()
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }
        else {
            let collection = UserModel.getCollection(fromEmail: self.user.email)
            db.collection(collection).document(self.document!.documentID).updateData([
                "firstname" : self.tfName.text!,
                "lastname" : self.tfLastName.text!,
            ]) { (error) in
                if (error != nil){
                    print("error al actualizar datos")
                }
                self.removeSpinner()
                self.navigationController?.popViewController(animated: true)
            }
        }
//        if user.isVisitor {
//            let ref = Firestore.firestore().collection("visitantes").document(self.document!.documentID).updateData([
//                "firstname" : self.user.firstName
//                "lastName" : self.u
//            ]) { (Error?) in
//
//            }
//
//            dbObject = ref.child("visitantes/")
//        }
        
    
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func showError(_ message:String){
        let alert = UIAlertController(title: "Campus Access", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
