//
//  EventosTableViewController.swift
//  CampusAccess
//
//  Created by Rigoberto Valadez on 21/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

class CustomEventTableViewCell : UITableViewCell {
    @IBOutlet weak var lbNombreEvento: UILabel!
    @IBOutlet weak var lbDescripcion: UILabel!
}

class EventosTableViewController: UITableViewController {
    
    var listaEventos : [EventModel]!
    var alturaCelda = 132.00

    override func viewDidLoad() {
        super.viewDidLoad()
        listaEventos = DataLoader(arch: "Eventos", tipo: "evento").eventosData
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaEventos.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(alturaCelda)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventoCell", for: indexPath) as! CustomEventTableViewCell
        cell.lbNombreEvento.text = listaEventos[indexPath.row].name
        cell.lbDescripcion.text = listaEventos[indexPath.row].desc
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(listaEventos[indexPath.row].url)
    }
}
