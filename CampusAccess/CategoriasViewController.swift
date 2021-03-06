//
//  CategoriasViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 09/04/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import MapKit

class CategoriasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapaTec: MKMapView!
    @IBOutlet weak var categoryTableView: UITableView!
    
    let categorias = ["Edificios","Restaurantes","Cafeterías","Zonas Comunes","Deportes","Estacionamientos","Accesos","Otros"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 25.651022, longitude: -100.289712)
        annotation.title = "TEC"
        annotation.subtitle = "Tecnológico de Monterrey"
        mapaTec.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapaTec.setRegion(region, animated: true)
    }
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let celda = tableView.dequeueReusableCell(withIdentifier: "categoriaCell")!
        celda.textLabel?.text = categorias[indexPath.row]
        let letra = UIFont(name: "Arial Rounded MT Bold", size: 20)
        celda.textLabel?.font = letra
        return celda
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationControllerView = segue.destination as! UINavigationController
        let vistaLugares = navigationControllerView.topViewController as! LugaresTableViewController
        let indice = categoryTableView.indexPathForSelectedRow!
        vistaLugares.categoriaSeleccionada = categorias[indice.row]
    }
    
    @IBAction func btnRegresar(_ sender: Any) {
      dismiss(animated: true, completion: nil)
    }
}
