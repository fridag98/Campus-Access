//
//  DetallesLugarViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 10/04/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import MapKit

class DetallesLugarViewController: UIViewController {

    var lugar : Lugares!
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var lbDescripcion: UILabel!
    @IBOutlet weak var btNavegar: UIButton!
    @IBOutlet weak var mapaLugar: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbNombre.text = lugar.nombre
        lbDescripcion.text = lugar.description
    }


}
