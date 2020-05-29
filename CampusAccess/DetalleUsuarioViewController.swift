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
    var user : UserModel!
    var document : DocumentSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSpinner()
        actionButton.layer.cornerRadius = 25.0
        updatePictureButton.layer.cornerRadius = 25.0
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
                guard let identificacionURL : String = dataDescription?["identificacionURL"] as? String else { return }

                let url = NSURL(string: identificacionURL)! as URL
                if let imageData: NSData = NSData(contentsOf: url) {
                    self.user.profilePictue = UIImage(data: imageData as Data)
                }
                
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
        let db = Firestore.firestore()
        
        showSpinner()
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
    }

    func showError(_ message:String){
        let alert = UIAlertController(title: "Campus Access", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
