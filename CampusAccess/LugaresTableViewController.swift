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
        //cambiar nombre del botón de navegación a "Regresar"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Regresar", style: .plain, target: nil, action: nil)
        //cargar datos del json al arreglo. Lo hace la clase DataLoader que se creó
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
