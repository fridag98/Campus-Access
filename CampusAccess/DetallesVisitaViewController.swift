//
//  DetallesVisitaViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 21/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class DetallesVisitaViewController: UIViewController {

    
    @IBOutlet weak var lbUsuario: UILabel!
    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var lbHora: UILabel!
    @IBOutlet weak var lbMotivo: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    
    var visita: VisitModel!
    var nombreUsuario : String!

    //display visit's information on specific format
    override func viewDidLoad() {
        super.viewDidLoad()
        lbUsuario.text = nombreUsuario

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        lbFecha.text = formatter.string(from: visita.date)

        //show qr when date equals to current date
        if lbFecha.text != formatter.string(from: Date()) {
            imgQR.isHidden = true
        }
        
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        lbHora.text = formatter.string(from: visita.date)
        
        lbMotivo.text = visita.motive
        
        let infoQR = "\(nombreUsuario!)\n\(lbFecha.text!)\n\(lbHora.text!)\n\(visita.motive!)"
        
        imgQR.image = generateQRCode(from: infoQR)
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
