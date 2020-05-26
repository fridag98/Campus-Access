//
//  IdentificacionViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 10/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit


class IdentificacionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var identificacion : UIImage!
    var btnEditHidden = true
    
    @IBOutlet weak var photoPlaceholder: UIButton!
    @IBOutlet weak var photoSVG: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        identificacion = nil
        if(btnEditHidden) {
            btnEdit.isHidden = true
            btnEdit.isEnabled = false
        } else {
            btnSignUp.isHidden = true
            btnSignUp.isEnabled = false
        }
    }

    //el textfield tienen un botton invisible, la cámara tienen un tap
    @IBAction func subirFoto(_ sender: Any) {
        let picker = UIImagePickerController()
         picker.delegate = self
         picker.sourceType = .photoLibrary
         present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let foto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        identificacion = foto
        photoPlaceholder.setImage(foto, for: .normal)
        photoSVG.isHidden = true
        dismiss(animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if (sender as! UIButton) == btnSignUp {
            let vistaSiguiente = segue.destination as! SigUpViewController
            vistaSiguiente.imgIdentificacion = identificacion
        }
        else if (sender as! UIButton) == btnEdit {
            let vistaSiguiente = segue.destination as! DetalleUsuarioViewController
            vistaSiguiente.imgIdentificacion = identificacion
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identificacion == nil {
                let alerta = UIAlertController(title: "Error", message: "Selecciona una imagen como identificación", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alerta, animated: true, completion: nil)
                return false
        }
        return true
    }

}
