//
//  LugaresTableViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 09/04/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class LugaresTableViewController: UITableViewController {
    
    var categoriaSeleccionada : String!
    var arrLugares = [Lugar]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Regresar", style: .plain, target: nil, action: nil)
        //cargar datos del json al arreglo
        arrLugares = DataLoader(arch:categoriaSeleccionada).lugaresData
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLugares.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lugarCell", for: indexPath)
        cell.textLabel?.text = arrLugares[indexPath.row].nombre
        let letra = UIFont(name: "Arial Rounded MT Bold", size: 20)
        cell.textLabel?.font = letra
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapaLugar = segue.destination as! DetallesLugarViewController
       let indice = tableView.indexPathForSelectedRow!
        mapaLugar.lugar = arrLugares[indice.row]
    }
    
    @IBAction func btRegresar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
