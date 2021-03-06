//
//  CredencialViewController.swift
//  CampusAccess
//
//  Created by Rigoberto Valadez on 26/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import Firebase

class CredencialViewController: UIViewController {
    
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbMatricula: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    
    var user : UserModel!
    var document : DocumentSnapshot?
    var imgURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbUserName.text = "\(user.firstName!) \(user.lastName!)"
        lbMatricula.text = user.email
        imgQR.image = generateQRCode(from: imgURL)
    }
    
    @IBAction func regresar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
